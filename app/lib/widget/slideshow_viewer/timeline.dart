part of '../slideshow_viewer.dart';

class _Timeline extends StatefulWidget {
  const _Timeline();

  @override
  State<StatefulWidget> createState() => _TimelineState();

  static const width = 96.0;
}

class _TimelineState extends State<_Timeline> {
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT(
          selector: (state) => state.page,
          listener: (context, page) {
            if (_lastInteraction == null ||
                clock.now().difference(_lastInteraction!) >
                    const Duration(seconds: 10)) {
              _controller.animateTo(
                page * _Timeline.width,
                duration: k.animationDurationShort,
                curve: Curves.easeOut,
              );
            }
          },
        ),
      ],
      child: Container(
        width: _Timeline.width,
        color: Colors.black.withValues(alpha: .65),
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            _lastInteraction = clock.now();
            return false;
          },
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false, overscroll: false),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              controller: _controller,
              itemCount: context.bloc.pageCount,
              itemBuilder:
                  (context, i) => _BlocSelector<int>(
                    selector: (state) => state.page,
                    builder:
                        (context, page) => _TimelineItem(
                          index: i,
                          file: context.bloc.getFileByPageIndex(i),
                          isSelected: i == page,
                        ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  late final _controller = ScrollController();
  DateTime? _lastInteraction;
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.index,
    required this.file,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color:
              isSelected
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Colors.transparent,
          child:
              file != null
                  ? PhotoListImage(
                    account: context.bloc.account,
                    previewUrl: NetworkRectThumbnail.imageUrlForFile(
                      context.bloc.account,
                      file!,
                    ),
                    mime: file!.fdMime,
                  )
                  : AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        L10n.global().fileNotFound,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
        ),
        if (!isSelected)
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  context.addEvent(_RequestPage(index));
                },
              ),
            ),
          ),
      ],
    );
  }

  final int index;
  final FileDescriptor? file;
  final bool isSelected;
}
