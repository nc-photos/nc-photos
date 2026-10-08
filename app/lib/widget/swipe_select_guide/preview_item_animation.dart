part of 'swipe_select_guide.dart';

class _PreviewItemAnimation extends StatefulWidget {
  const _PreviewItemAnimation();

  @override
  State<_PreviewItemAnimation> createState() => _PreviewItemAnimationState();
}

class _PreviewItemAnimationState extends State<_PreviewItemAnimation>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _timer = Timer(const Duration(seconds: 3), () {
            _controller.value = 0;
            _controller.forward();
          });
        }
      });
    _timer = Timer(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
    _circleOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 25),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 40),
    ]).animate(_controller);
    _circleScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: .3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 25,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 75),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: SizedBox(
        width: _width,
        height: _height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final expandProgress = Curves.easeInOutCubic.transform(
              ((_controller.value - _expandStart) / (_expandEnd - _expandStart))
                  .clamp(0.0, 1.0),
            );
            final expandScale = 1 + (_height / _cellSize - 1) * expandProgress;
            final circleRadius = _circleRadius * _circleScale.value;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // The rest of the grid fades out as the previewed item takes
                // over the whole area
                Positioned.fill(
                  child: Opacity(
                    opacity: 1 - expandProgress,
                    child: _buildGrid(context),
                  ),
                ),
                // The third item scales and translates to fill the parent
                Positioned(
                  left: 0,
                  top: _cellSize,
                  width: _cellSize,
                  height: _cellSize,
                  child: Transform.translate(
                    offset: _openTranslation * expandProgress,
                    child: Transform.scale(
                      scale: expandScale,
                      child: _buildItem(context, _openItemIndex),
                    ),
                  ),
                ),
                // Touch circle mimicking a long press
                Positioned(
                  left: _viewerCenter.dx - circleRadius,
                  top: _viewerCenter.dy - circleRadius,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: _circleOpacity.value,
                      child: Container(
                        width: circleRadius * 2,
                        height: circleRadius * 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Column(
      children: List.generate(_rowCount, (row) {
        return Expanded(
          child: Row(
            children: List.generate(_columnCount, (col) {
              final index = row * _columnCount + col;
              // The previewed item is rendered as an overlay instead
              return Expanded(
                child: index == _openItemIndex
                    ? const SizedBox()
                    : _buildItem(context, index),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(_itemPadding),
      child: Selectable(
        isSelected: [0, 1, 5].contains(index),
        iconSize: 32,
        childBorderRadius: BorderRadius.circular(24),
        child: Container(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .25),
          child: Center(
            child: Icon(
              key: Key("item$index"),
              const [
                Icons.wb_twilight,
                Icons.local_florist,
                Icons.sailing,
                Icons.bedtime,
                Icons.android,
                Icons.location_city,
              ][index],
              size: 36,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  late final AnimationController _controller;
  late final Animation<double> _circleOpacity;
  late final Animation<double> _circleScale;
  Timer? _timer;

  static const _columnCount = 2;
  static const _rowCount = 3;
  static const _itemSize = 80.0;
  static const _itemPadding = 2.0;
  static const _cellSize = _itemSize + _itemPadding * 2;
  static const _circleRadius = 16.0;

  static const _width = _cellSize * _columnCount;
  static const _height = _cellSize * _rowCount;

  static const _openItemIndex = 2;
  static const _viewerCenter = Offset(_cellSize * .5, _cellSize * 1.5);
  static const _openTranslation = Offset(_cellSize * .5, 0);

  // animation time
  static const _expandStart = .45;
  static const _expandEnd = .85;

  static const _duration = Duration(milliseconds: 2800);
}
