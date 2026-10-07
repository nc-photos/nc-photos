part of 'swipe_select_guide.dart';

class _SwipeSelectAnimation extends StatefulWidget {
  const _SwipeSelectAnimation();

  @override
  State<_SwipeSelectAnimation> createState() => _SwipeSelectAnimationState();
}

class _SwipeSelectAnimationState extends State<_SwipeSelectAnimation>
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
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 60),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
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
        width: _cellSize * _columnCount,
        height: _cellSize * _rowCount,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final moveProgress = Curves.linear.transform(
              ((_controller.value - _growEnd) / (_moveEnd - _growEnd)).clamp(
                0.0,
                1.0,
              ),
            );

            final isSelected = List<bool>.generate(
              _itemCount,
              (index) =>
                  _controller.value >= _growEnd &&
                  moveProgress >= index * _selectionStep,
            );

            final circleCenter = Offset.lerp(_start, _end, moveProgress)!;
            final circleRadius =
                _circleRadius * _circleScale.value * _circleOpacity.value;

            return Stack(
              children: [
                Positioned.fill(child: _buildGrid(context, isSelected)),
                Positioned(
                  left: circleCenter.dx - circleRadius,
                  top: circleCenter.dy - circleRadius,
                  child: IgnorePointer(
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<bool> isSelected) {
    return Column(
      children: List.generate(_rowCount, (row) {
        return Expanded(
          child: Row(
            children: List.generate(_columnCount, (col) {
              final index = row * _columnCount + col;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(_itemPadding),
                  child: Selectable(
                    isSelected: isSelected[index],
                    iconSize: 32,
                    childBorderRadius: BorderRadius.circular(24),
                    child: Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .25),
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
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  late final AnimationController _controller;
  late final Animation<double> _circleOpacity;
  late final Animation<double> _circleScale;
  Timer? _timer;

  static const _columnCount = 2;
  static const _rowCount = 3;
  static const _itemCount = _columnCount * _rowCount;
  static const _itemSize = 80.0;
  static const _itemPadding = 2.0;
  static const _cellSize = _itemSize + _itemPadding * 2;
  static const _circleRadius = 16.0;

  static const _start = Offset(_cellSize / 2, _cellSize / 2);
  static const _end = Offset(
    _cellSize * (_columnCount - .5),
    _cellSize * (_rowCount - .5),
  );

  static const _selectionStep = 1 / (_itemCount - 1);

  // animation time
  static const _growEnd = .25;
  static const _moveEnd = .65;

  static const _duration = Duration(milliseconds: 2800);
}
