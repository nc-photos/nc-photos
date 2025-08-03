import 'dart:async';

import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/collections_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/util.dart';
import 'package:nc_photos/entity/sharee.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/exception_util.dart' as exception_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/suggester.dart';
import 'package:nc_photos/toast.dart';
import 'package:nc_photos/widget/app_intermediate_circular_progress_indicator.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'share_collection_dialog.g.dart';
part 'share_collection_dialog/bloc.dart';
part 'share_collection_dialog/state_event.dart';

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;

/// Dialog to share a new collection to other user on the same server
///
/// Return the created collection, or null if user cancelled
class ShareCollectionDialog extends StatelessWidget {
  const ShareCollectionDialog({
    super.key,
    required this.account,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _Bloc(
        container: KiwiContainer().resolve<DiContainer>(),
        account: account,
        collectionsController:
            context.read<AccountController>().collectionsController,
        collection: collection,
      ),
      child: const _WrappedShareCollectionDialog(),
    );
  }

  final Account account;
  final Collection collection;
}

class _WrappedShareCollectionDialog extends StatefulWidget {
  const _WrappedShareCollectionDialog();

  @override
  State<StatefulWidget> createState() => _WrappedShareCollectionDialogState();
}

class _WrappedShareCollectionDialogState
    extends State<_WrappedShareCollectionDialog> {
  @override
  void initState() {
    super.initState();
    _bloc.add(const _LoadSharee());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<_Bloc, _State>(
          listenWhen: (previous, current) => previous.error != current.error,
          listener: (context, state) {
            if (state.error != null) {
              if (state.error!.error is CollectionPartialShareException) {
                final e = state.error!.error as CollectionPartialShareException;
                AppToast.showToast(
                  context,
                  msg: L10n.global()
                      .shareAlbumSuccessWithErrorNotification(e.shareeName),
                  duration: k.snackBarDurationNormal,
                );
              } else if (state.error!.error
                  is CollectionPartialUnshareException) {
                final e =
                    state.error!.error as CollectionPartialUnshareException;
                AppToast.showToast(
                  context,
                  msg: L10n.global()
                      .unshareAlbumSuccessWithErrorNotification(e.shareeName),
                  duration: k.snackBarDurationNormal,
                );
              } else {
                AppToast.showToast(
                  context,
                  msg: exception_util.toUserString(state.error!.error),
                  duration: k.snackBarDurationNormal,
                );
              }
            }
          },
        ),
      ],
      child: _BlocBuilder(
        buildWhen: (previous, current) =>
            previous.collection != current.collection ||
            previous.processingShares != current.processingShares,
        builder: (context, state) {
          final shares = {
            ...state.collection.shares,
            ...state.processingShares,
          }.sortedBy((e) => e.username);
          return SimpleDialog(
            title: Text(L10n.global().shareAlbumDialogTitle),
            children: [
              ...shares.map((s) => _ShareView(
                    share: s,
                    isProcessing: state.processingShares.contains(s),
                    onPressed: () {
                      _bloc.add(_Unshare(s));
                    },
                  )),
              const _ShareeInputView(),
            ],
          );
        },
      ),
    );
  }

  late final _bloc = context.read<_Bloc>();
}

class _ShareeInputView extends StatefulWidget {
  const _ShareeInputView();

  @override
  State<StatefulWidget> createState() => _ShareeInputViewState();
}

class _ShareeInputViewState extends State<_ShareeInputView> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<_Bloc, _State>(
          listenWhen: (previous, current) =>
              previous.shareeSuggester != current.shareeSuggester,
          listener: (context, state) {
            // search again
            if (_lastPattern != null) {
              _onSearch(_lastPattern!);
            }
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: TypeAheadField<Sharee>(
          controller: _textController,
          suggestionsCallback: _onSearch,
          itemBuilder: (context, suggestion) => ListTile(
            title: Text(suggestion.label),
            subtitle: Text(suggestion.shareWith.toString()),
          ),
          onSelected: _onSuggestionSelected,
          hideOnEmpty: true,
          hideOnLoading: true,
          autoFlipDirection: true,
          builder: (context, controller, focusNode) => TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: L10n.global().addUserInputHint,
            ),
          ),
        ),
      ),
    );
  }

  List<Sharee> _onSearch(String pattern) {
    _lastPattern = pattern;
    final suggester = _bloc.state.shareeSuggester;
    return suggester?.search(pattern.toCi()) ?? [];
  }

  void _onSuggestionSelected(Sharee sharee) {
    _textController.clear();
    _bloc.add(_Share(sharee));
  }

  late final _bloc = context.read<_Bloc>();
  final _textController = TextEditingController();

  String? _lastPattern;
}

class _ShareView extends StatelessWidget {
  const _ShareView({
    required this.share,
    required this.isProcessing,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Widget trailing;
    if (isProcessing) {
      trailing = const Padding(
        padding: EdgeInsetsDirectional.only(end: 12),
        child: SizedBox(
          width: 24,
          height: 24,
          child: AppIntermediateCircularProgressIndicator(),
        ),
      );
    } else {
      trailing = Checkbox(
        value: true,
        onChanged: (_) {},
      );
    }
    return SimpleDialogOption(
      onPressed: isProcessing ? null : onPressed,
      child: ListTile(
        title: Text(share.username),
        subtitle: Text(share.userId.toString()),
        // pass through the tap event
        trailing: IgnorePointer(
          child: trailing,
        ),
      ),
    );
  }

  final CollectionShare share;
  final bool isProcessing;
  final VoidCallback? onPressed;
}
