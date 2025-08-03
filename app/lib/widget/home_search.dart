import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc/search.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/download_handler.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/entity/search.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/language_util.dart' as language_util;
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/share_handler.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme/dimension.dart';
import 'package:nc_photos/throttler.dart';
import 'package:nc_photos/widget/builder/photo_list_item_builder.dart';
import 'package:nc_photos/widget/collection_viewer/collection_viewer.dart';
import 'package:nc_photos/widget/handler/add_selection_to_collection_handler.dart';
import 'package:nc_photos/widget/handler/remove_selection_handler.dart';
import 'package:nc_photos/widget/home_search_suggestion.dart';
import 'package:nc_photos/widget/navigation_bar_blur_filter.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/photo_list_item.dart';
import 'package:nc_photos/widget/photo_list_util.dart' as photo_list_util;
import 'package:nc_photos/widget/search_landing.dart';
import 'package:nc_photos/widget/selectable_item_stream_list_mixin.dart';
import 'package:nc_photos/widget/selection_app_bar.dart';
import 'package:np_async/np_async.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';

part 'home_search.g.dart';

class HomeSearch extends StatefulWidget {
  const HomeSearch({
    super.key,
    required this.account,
  });

  @override
  createState() => _HomeSearchState();

  final Account account;
}

@npLog
class _HomeSearchState extends State<HomeSearch>
    with
        SelectableItemStreamListMixin<HomeSearch>,
        RouteAware,
        PageVisibilityMixin {
  @override
  initState() {
    super.initState();
    _initBloc();
  }

  @override
  dispose() {
    _inputFocus.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return BlocListener<SearchBloc, SearchBlocState>(
      bloc: _bloc,
      listener: (context, state) => _onStateChange(context, state),
      child: BlocBuilder<SearchBloc, SearchBlocState>(
        bloc: _bloc,
        builder: (context, state) => _buildContent(context, state),
      ),
    );
  }

  @override
  onItemTap(SelectableItem item, int index) {
    item.as<PhotoListFileItem>()?.run((fileItem) {
      Navigator.of(context).pushNamed(
        CollectionViewer.routeName,
        arguments: CollectionViewerArguments(
          _backingFiles,
          fileItem.fileIndex,
          null,
        ),
      );
    });
  }

  void _initBloc() {
    if (_bloc.state is! SearchBlocInit) {
      // process the current state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _onStateChange(context, _bloc.state);
          });
        }
      });
    }
  }

  Widget _buildContent(BuildContext context, SearchBlocState state) {
    return WillPopScope(
      onWillPop: _onBackButtonPressed,
      child: Focus(
        focusNode: _stealFocus,
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              buildItemStreamListOuter(
                context,
                child: Stack(
                  children: [
                    CustomScrollView(
                      physics: _isSearchMode
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      slivers: [
                        _buildAppBar(context, state),
                        if (_isShowLanding(state))
                          SliverToBoxAdapter(
                            child: SearchLanding(
                              onFavoritePressed: _onLandingFavoritePressed,
                              onVideoPressed: _onLandingVideoPressed,
                            ),
                          )
                        else if (state is SearchBlocSuccess &&
                            !_buildItemQueue.isProcessing &&
                            itemStreamListItems.isEmpty)
                          SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Text(L10n.global().listNoResultsText),
                              ),
                            ),
                          )
                        else
                          buildItemStreamList(
                            maxCrossAxisExtent: _thumbSize,
                          ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height:
                                AppDimension.of(context).homeBottomAppBarHeight,
                          ),
                        ),
                      ],
                    ),
                    AnimatedVisibility(
                      opacity: _isSearchMode ? 1 : 0,
                      duration: k.animationDurationShort,
                      child: SafeArea(
                        left: false,
                        right: false,
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.only(top: kToolbarHeight),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_isSearchMode) {
                                    setState(() {
                                      _setSearchMode(false);
                                    });
                                  }
                                },
                                child: Container(color: Colors.black54),
                              ),
                              _buildSearchPane(context, state),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state is SearchBlocLoading ||
                        _buildItemQueue.isProcessing)
                      const LinearProgressIndicator(),
                    NavigationBarBlurFilter(
                      height: AppDimension.of(context).homeBottomAppBarHeight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, SearchBlocState state) {
    if (isSelectionMode) {
      return _buildSelectionAppBar(context);
    } else {
      return _buildNormalAppBar(context, state);
    }
  }

  Widget _buildSelectionAppBar(BuildContext conetxt) {
    return SelectionAppBar(
      count: selectedListItems.length,
      onClosePressed: () {
        setState(() {
          clearSelectedItems();
        });
      },
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          tooltip: L10n.global().shareTooltip,
          onPressed: () => _onSelectionSharePressed(context),
        ),
        IconButton(
          icon: const Icon(Icons.add_outlined),
          tooltip: L10n.global().addItemToCollectionTooltip,
          onPressed: () => _onSelectionAddToAlbumPressed(context),
        ),
        PopupMenuButton<_SelectionMenuOption>(
          tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _SelectionMenuOption.download,
              child: Text(L10n.global().downloadTooltip),
            ),
            PopupMenuItem(
              value: _SelectionMenuOption.archive,
              child: Text(L10n.global().archiveTooltip),
            ),
            PopupMenuItem(
              value: _SelectionMenuOption.delete,
              child: Text(L10n.global().deleteTooltip),
            ),
          ],
          onSelected: (option) => _onSelectionMenuSelected(context, option),
        ),
      ],
    );
  }

  Widget _buildNormalAppBar(BuildContext context, SearchBlocState state) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      snap: true,
      title: Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus && !_isSearchMode) {
            setState(() {
              _setSearchMode(true);
            });
          }
        },
        child: TextFormField(
          focusNode: _inputFocus,
          controller: _inputController,
          decoration: InputDecoration(
            hintText: L10n.global().searchTooltip,
          ),
          onFieldSubmitted: (_) {
            _onSearchPressed();
          },
          onSaved: (value) {
            _formValue?.input = value ?? "";
          },
          onChanged: (value) {
            _searchSuggestionThrottler.trigger(
              maxResponceTime: const Duration(milliseconds: 500),
              maxPendingCount: 8,
              data: value,
            );
          },
        ),
      ),
      actions: [
        IconButton(
          onPressed: _onSearchPressed,
          tooltip: L10n.global().searchTooltip,
          icon: const Icon(Icons.search_outlined),
        ),
      ],
      bottom: _isShowLanding(state)
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: SizedBox(
                height: 40,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: _FilterBubbleList(
                    filters: state.criteria.filters,
                    onEditPressed: () => _onEditFilterPressed(state),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSearchPane(BuildContext context, SearchBlocState state) {
    return Align(
      alignment: Alignment.topCenter,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: SingleChildScrollView(
          child: HomeSearchSuggestion(
            account: widget.account,
            controller: _searchSuggestionController,
          ),
        ),
      ),
    );
  }

  void _onStateChange(BuildContext context, SearchBlocState state) {
    if (state is SearchBlocInit) {
      itemStreamListItems = [];
    } else if (state is SearchBlocSuccess || state is SearchBlocLoading) {
      _transformItems(state.items);
    } else if (state is SearchBlocFailure) {
      _transformItems(state.items);
      if (isPageVisible()) {
        SnackBarManager().showSnackBarForException(state.exception);
      }
    } else if (state is SearchBlocInconsistent) {
      _reqQuery(_activeInput, _activeFilters);
    }
  }

  Future<bool> _onBackButtonPressed() async {
    if (_isSearchMode) {
      setState(() {
        _setSearchMode(false);
      });
      return false;
    } else if (_bloc.state is! SearchBlocInit) {
      // back to landing
      _reqResetLanding();
      setState(() {
        _activeInput = "";
        _activeFilters = [];
        _inputController.text = "";
        _searchSuggestionController.search("");
      });
      return false;
    } else {
      return true;
    }
  }

  void _onSearchPressed() {
    if (_formKey.currentState?.validate() == true) {
      _formValue = _FormValue();
      _formKey.currentState!.save();
      _activeInput = _formValue!.input;

      setState(() {
        _setSearchMode(false);
      });
      _reqQuery(_activeInput, _activeFilters);
    }
  }

  void _onLandingFavoritePressed() {
    _activeFilters = [
      const SearchFavoriteFilter(true),
    ];
    _reqQuery(_activeInput, _activeFilters);
  }

  void _onLandingVideoPressed() {
    _activeFilters = [
      const SearchFileTypeFilter(SearchFileType.video),
    ];
    _reqQuery(_activeInput, _activeFilters);
  }

  Future<void> _onEditFilterPressed(SearchBlocState state) async {
    final result = await showDialog<List<SearchFilter>>(
      context: context,
      builder: (context) => _FilterEditDialog(searchState: state),
    );
    if (result == null) {
      return;
    }
    _activeFilters = result;

    _reqQuery(_activeInput, _activeFilters);
  }

  void _onSelectionMenuSelected(
      BuildContext context, _SelectionMenuOption option) {
    switch (option) {
      case _SelectionMenuOption.archive:
        _onSelectionArchivePressed(context);
        break;
      case _SelectionMenuOption.delete:
        _onSelectionDeletePressed(context);
        break;
      case _SelectionMenuOption.download:
        _onSelectionDownloadPressed();
        break;
      default:
        _log.shout("[_onSelectionMenuSelected] Unknown option: $option");
        break;
    }
  }

  void _onSelectionSharePressed(BuildContext context) {
    final c = KiwiContainer().resolve<DiContainer>();
    final selected = selectedListItems
        .whereType<PhotoListFileItem>()
        .map((e) => e.file)
        .toList();
    ShareHandler(
      c,
      context: context,
      clearSelection: () {
        setState(() {
          clearSelectedItems();
        });
      },
    ).shareFiles(widget.account, selected);
  }

  Future<void> _onSelectionAddToAlbumPressed(BuildContext context) {
    return const AddSelectionToCollectionHandler()(
      context: context,
      selection: selectedListItems
          .whereType<PhotoListFileItem>()
          .map((e) => e.file)
          .toList(),
      clearSelection: () {
        if (mounted) {
          setState(() {
            clearSelectedItems();
          });
        }
      },
    );
  }

  void _onSelectionDownloadPressed() {
    final c = KiwiContainer().resolve<DiContainer>();
    final selected = selectedListItems
        .whereType<PhotoListFileItem>()
        .map((e) => e.file)
        .toList();
    DownloadHandler(c).downloadFiles(widget.account, selected);
    setState(() {
      clearSelectedItems();
    });
  }

  Future<void> _onSelectionArchivePressed(BuildContext context) async {
    final selectedFiles = selectedListItems
        .whereType<PhotoListFileItem>()
        .map((e) => e.file)
        .toList();
    setState(() {
      clearSelectedItems();
    });
    await context.read<AccountController>().filesController.updateProperty(
      selectedFiles,
      isArchived: const OrNull(true),
      errorBuilder: (fileIds) {
        if (mounted) {
          SnackBarManager().showSnackBar(SnackBar(
            content: Text(L10n.global()
                .archiveSelectedFailureNotification(fileIds.length)),
            duration: k.snackBarDurationNormal,
          ));
        }
        return null;
      },
    );
  }

  Future<void> _onSelectionDeletePressed(BuildContext context) async {
    final selectedFiles = selectedListItems
        .whereType<PhotoListFileItem>()
        .map((e) => e.file)
        .toList();
    setState(() {
      clearSelectedItems();
    });
    await RemoveSelectionHandler(
      filesController: context.read<AccountController>().filesController,
    )(
      account: widget.account,
      selection: selectedFiles,
      isMoveToTrash: true,
    );
  }

  void _transformItems(List<FileDescriptor> files) {
    _buildItemQueue.addJob(
      PhotoListItemBuilderArguments(
        widget.account,
        files,
        sorter: photoListFileDateTimeSorter,
        grouper: PhotoListFileDateGrouper(isMonthOnly: _thumbZoomLevel < 0),
        shouldShowFavoriteBadge: true,
        locale: language_util.getSelectedLocale() ??
            PlatformDispatcher.instance.locale,
      ),
      buildPhotoListItem,
      (result) {
        if (mounted) {
          setState(() {
            _backingFiles = result.backingFiles;
            itemStreamListItems = result.listItems;
          });
        }
      },
    );
  }

  void _reqQuery(String input, List<SearchFilter> filters) {
    _bloc.add(SearchBlocQuery(widget.account, SearchCriteria(input, filters)));
  }

  void _reqResetLanding() {
    _bloc.add(SearchBlocResetLanding(widget.account));
  }

  void _setSearchMode(bool value) {
    _isSearchMode = value;
    if (value) {
      _inputFocus.requestFocus();
    } else {
      _inputController.text = _activeInput;
      _searchSuggestionController.search(_activeInput);
      _stealFocus.requestFocus();
    }
  }

  bool _isShowLanding(SearchBlocState state) => state is SearchBlocInit;

  late final _bloc = SearchBloc(KiwiContainer().resolve<DiContainer>());

  final _formKey = GlobalKey<FormState>();
  _FormValue? _formValue;
  final _inputController = TextEditingController();
  final _inputFocus = FocusNode();
  // used to steal focus from input field
  final _stealFocus = FocusNode();
  var _isSearchMode = false;

  var _activeInput = "";
  var _activeFilters = <SearchFilter>[];

  final _searchSuggestionController = HomeSearchSuggestionController();
  late final _searchSuggestionThrottler = Throttler<String>(
    onTriggered: (data) {
      _searchSuggestionController.search(data.last);
    },
  );

  final _buildItemQueue =
      ComputeQueue<PhotoListItemBuilderArguments, PhotoListItemBuilderResult>();

  late final _thumbZoomLevel = Pref().getHomePhotosZoomLevelOr(0);
  late final _thumbSize =
      photo_list_util.getThumbSize(_thumbZoomLevel).toDouble();

  var _backingFiles = <FileDescriptor>[];
}

class _FormValue {
  String input = "";
}

extension on SearchFileType {
  String toUserString() {
    switch (this) {
      case SearchFileType.image:
        return L10n.global().searchFilterTypeOptionImageLabel;

      case SearchFileType.video:
        return L10n.global().searchFilterTypeOptionVideoLabel;
    }
  }
}

class _FilterBubbleList extends StatelessWidget {
  const _FilterBubbleList({
    required this.filters,
    this.onEditPressed,
  });

  @override
  build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  ...filters
                      .map((f) => _buildBubble(context, _toUserString(f))),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: onEditPressed,
            child: Text(L10n.global().searchFilterButtonLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        elevation: 1,
        pressElevation: 1,
        showCheckmark: false,
        visualDensity: VisualDensity.compact,
        selected: true,
        label: Text(label),
        onSelected: (_) {},
      ),
    );
  }

  String _toUserString(SearchFilter filter) {
    if (filter is SearchFileTypeFilter) {
      switch (filter.type) {
        case SearchFileType.image:
          return L10n.global().searchFilterBubbleTypeImageText;

        case SearchFileType.video:
          return L10n.global().searchFilterBubbleTypeVideoText;
      }
    } else if (filter is SearchFavoriteFilter) {
      return filter.value
          ? L10n.global().searchFilterBubbleFavoriteTrueText
          : L10n.global().searchFilterBubbleFavoriteFalseText;
    }
    throw ArgumentError.value(filter, "filter");
  }

  final List<SearchFilter> filters;
  final VoidCallback? onEditPressed;
}

class _FilterEditDialog extends StatefulWidget {
  const _FilterEditDialog({
    required this.searchState,
  });

  @override
  createState() => _FilterEditDialogState();

  final SearchBlocState searchState;
}

class _FilterEditDialogState extends State<_FilterEditDialog> {
  @override
  build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Text(L10n.global().searchFilterDialogTitle),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _FilterDropdown<SearchFileType>(
                label: L10n.global().searchFilterTypeLabel,
                items: SearchFileType.values,
                itemStringifier: (item) => item.toUserString(),
                initialValue: widget.searchState.criteria.filters
                    .whereType<SearchFileTypeFilter>()
                    .firstOrNull
                    ?.type,
                onSaved: (value) {
                  if (value != null) {
                    _formValue?.filters.add(SearchFileTypeFilter(value));
                  }
                },
              ),
              const SizedBox(height: 8),
              _FilterDropdown<bool>(
                label: L10n.global().searchFilterFavoriteLabel,
                items: const [true, false],
                itemStringifier: (item) => item
                    ? L10n.global().searchFilterOptionTrueLabel
                    : L10n.global().searchFilterOptionFalseLabel,
                initialValue: widget.searchState.criteria.filters
                    .whereType<SearchFavoriteFilter>()
                    .firstOrNull
                    ?.value,
                onSaved: (value) {
                  if (value != null) {
                    _formValue?.filters.add(SearchFavoriteFilter(value));
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _onApplyPressed,
            child: Text(L10n.global().applyButtonLabel),
          ),
        ],
      ),
    );
  }

  void _onApplyPressed() {
    if (_formKey.currentState?.validate() == true) {
      _formValue = _FilterEditFormValue();
      _formKey.currentState!.save();
      Navigator.of(context).pop(_formValue!.filters);
    }
  }

  final _formKey = GlobalKey<FormState>();
  _FilterEditFormValue? _formValue;
}

class _FilterEditFormValue {
  final filters = <SearchFilter>[];
}

class _FilterDropdown<T> extends StatefulWidget {
  const _FilterDropdown({
    required this.label,
    required this.items,
    required this.itemStringifier,
    this.initialValue,
    this.onValueChanged,
    this.onSaved,
  });

  @override
  createState() => _FilterDropdownState<T>();

  final String label;
  final List<T> items;
  final String Function(T item) itemStringifier;
  final T? initialValue;
  final ValueChanged<T?>? onValueChanged;
  final FormFieldSetter<T>? onSaved;
}

class _FilterDropdownState<T> extends State<_FilterDropdown<T>> {
  @override
  initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: DropdownButtonFormField<T>(
            value: _value,
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(L10n.global().searchFilterOptionAnyLabel),
              ),
              ...widget.items.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(widget.itemStringifier(e)),
                  )),
            ],
            onChanged: (value) {
              setState(() {
                _value = value;
              });
              widget.onValueChanged?.call(_value);
            },
            onSaved: widget.onSaved,
          ),
        ),
      ],
    );
  }

  T? _value;
}

enum _SelectionMenuOption {
  archive,
  delete,
  download,
}
