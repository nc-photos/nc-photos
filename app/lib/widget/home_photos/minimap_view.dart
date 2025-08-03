part of '../home_photos2.dart';

@npLog
class _MinimapView extends StatelessWidget {
  const _MinimapView();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.minimapItems != current.minimapItems ||
          previous.minimapYRatio != current.minimapYRatio ||
          previous.viewHeight != current.viewHeight ||
          previous.viewOverlayPadding != current.viewOverlayPadding,
      builder: (context, state) {
        if (state.minimapItems == null) {
          return const SizedBox.shrink();
        }
        double? prevItemY;
        Date? prevDate;
        return IgnorePointer(
          child: Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 128,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ...state.minimapItems!.expand3((e, prev, next) {
                    final contentHeight =
                        state.viewHeight! - state.viewOverlayPadding!;
                    var top = e.logicalY < contentHeight
                        ? 0.0
                        : (e.logicalY - contentHeight) * state.minimapYRatio;
                    top +=
                        AppDimension.of(context).timelineDraggableThumbSize / 2;
                    try {
                      if (prevDate == null) {
                        prevDate = e.date;
                        return [null];
                      }
                      if (prevDate!.year != e.date.year) {
                        if (prevItemY != null && top < prevItemY! + _minDateY) {
                          // prevent overlap
                          top = prevItemY! + _minDateY;
                        }
                        prevItemY = top;
                        final text =
                            "${DateFormat.y().format(prevDate!.toLocalDateTime())} —";
                        return [
                          Positioned(
                            right: 8,
                            top: top,
                            child: Text(
                              text,
                              style: TextStyle(
                                fontSize: 12,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 4
                                  ..color =
                                      Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: top,
                            child: Text(
                              text,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ];
                      } else {
                        return [null];
                      }
                    } finally {
                      prevDate = e.date;
                    }
                  }).whereNotNull(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static const _minDateY = 13;
}

class _MinimapBackground extends StatelessWidget {
  const _MinimapBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topRight,
        child: SizedBox(
          width: 128,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.center,
                colors: Theme.of(context)
                    .colorScheme
                    .surface
                    .let((c) => [c.withOpacity(0), c.withOpacity(.6)]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MinimapPadding extends StatelessWidget {
  const _MinimapPadding({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight,
        bottom: AppDimension.of(context).homeBottomAppBarHeight,
      ),
      child: child,
    );
  }

  final Widget child;
}

class _MinimapItem {
  const _MinimapItem({
    required this.date,
    required this.logicalY,
    required this.logicalHeight,
  });

  final Date date;
  final double logicalY;
  final double logicalHeight;
}
