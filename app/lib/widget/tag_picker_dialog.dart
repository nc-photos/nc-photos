import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc/list_tag.dart';
import 'package:nc_photos/bloc/search_suggestion.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/dialog_scaffold.dart';
import 'package:np_async/np_async.dart';
import 'package:np_string/np_string.dart';

class TagPickerDialog extends StatefulWidget {
  const TagPickerDialog({super.key, required this.account});

  @override
  createState() => _TagPickerDialogState();

  final Account account;
}

class _TagPickerDialogState extends State<TagPickerDialog> {
  @override
  initState() {
    super.initState();
    _initBloc();
  }

  @override
  build(BuildContext context) {
    return DialogScaffold(
      body: BlocListener<ListTagBloc, ListTagBlocState>(
        bloc: _bloc,
        listener: _onStateChange,
        child: Builder(builder: _buildContent),
      ),
    );
  }

  void _initBloc() {
    _reqQuery();
  }

  Widget _buildContent(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 24),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ..._selected.map((i) => _buildItem(context, i)),
            _buildCreateShareItem(context),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _onOkPressed,
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, Tag tag) {
    return SimpleDialogOption(
      child: ListTile(
        title: Text(tag.displayName),
        // pass through the tap event
        trailing: IgnorePointer(
          child: Checkbox(value: true, onChanged: (_) {}),
        ),
      ),
      onPressed: () => _onItemPressed(tag),
    );
  }

  Widget _buildCreateShareItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TypeAheadField<Tag>(
        controller: _searchController,
        suggestionsCallback: _onSearch,
        itemBuilder:
            (_, suggestion) => ListTile(title: Text(suggestion.displayName)),
        onSelected: _onSearchSuggestionSelected,
        hideOnEmpty: true,
        hideOnLoading: true,
        autoFlipDirection: true,
        builder:
            (context, controller, focusNode) => TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: L10n.global().addTagInputHint,
              ),
            ),
      ),
    );
  }

  void _onStateChange(BuildContext context, ListTagBlocState state) {
    if (state is ListTagBlocSuccess) {
      _transformSuggestionItems(state.items);
    } else if (state is ListTagBlocFailure) {
      SnackBarManager().showSnackBarForException(state.exception);
    }
  }

  void _onItemPressed(Tag tag) {
    setState(() {
      _selected.remove(tag);
    });
    _updateSuggestionList();
  }

  void _onOkPressed() {
    if (_selected.isEmpty) {
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().tagPickerNoTagSelectedNotification),
          duration: k.snackBarDurationNormal,
        ),
      );
      return;
    }
    Navigator.of(context).pop(_selected);
  }

  Future<List<Tag>> _onSearch(String pattern) async {
    _suggestionBloc.add(SearchSuggestionBlocSearchEvent(pattern.toCi()));
    await Future.delayed(const Duration(milliseconds: 250));
    await wait(() => _suggestionBloc.state is! SearchSuggestionBlocLoading);
    if (_suggestionBloc.state is SearchSuggestionBlocSuccess) {
      return _suggestionBloc.state.results;
    } else {
      return [];
    }
  }

  Future<void> _onSearchSuggestionSelected(Tag tag) async {
    _searchController.clear();
    setState(() {
      _selected.add(tag);
    });
    _updateSuggestionList();
  }

  void _updateSuggestionList() {
    if (_bloc.state is ListTagBlocSuccess) {
      _transformSuggestionItems(_bloc.state.items);
    }
  }

  void _transformSuggestionItems(List<Tag> tags) {
    // remove selected items
    final candidates = tags.where((t) => !_selected.contains(t)).toList();
    _suggestionBloc.add(SearchSuggestionBlocUpdateItemsEvent<Tag>(candidates));
  }

  void _reqQuery() {
    _bloc.add(ListTagBlocQuery(widget.account));
  }

  late final _bloc = ListTagBloc.of(widget.account);
  final _suggestionBloc = SearchSuggestionBloc<Tag>(
    itemToKeywords: (item) => [item.displayName.toCi()],
  );

  final _selected = <Tag>[];
  final _searchController = TextEditingController();
}
