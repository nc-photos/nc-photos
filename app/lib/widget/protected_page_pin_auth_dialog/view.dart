part of 'protected_page_pin_auth_dialog.dart';

class _DialogBody extends StatelessWidget {
  const _DialogBody();

  @override
  Widget build(BuildContext context) {
    final backspace = _BackspaceButton(
      onTap: () {
        context.addEvent(const _PopDigit());
      },
    );
    return SizedBox(
      width: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 64,
            child: Align(
              alignment: Alignment(0, -0.5),
              child: _ObsecuredInputView(),
            ),
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children:
                    [1, 2, 3]
                        .map(
                          (e) => _DigitButton(
                            child: Text(e.toString()),
                            onTap: () {
                              context.addEvent(_PushDigit(e));
                            },
                          ),
                        )
                        .toList(),
              ),
              TableRow(
                children:
                    [4, 5, 6]
                        .map(
                          (e) => _DigitButton(
                            child: Text(e.toString()),
                            onTap: () {
                              context.addEvent(_PushDigit(e));
                            },
                          ),
                        )
                        .toList(),
              ),
              TableRow(
                children:
                    [7, 8, 9]
                        .map(
                          (e) => _DigitButton(
                            child: Text(e.toString()),
                            onTap: () {
                              context.addEvent(_PushDigit(e));
                            },
                          ),
                        )
                        .toList(),
              ),
              TableRow(
                children: [
                  if (context.bloc.pin == null)
                    backspace
                  else
                    const SizedBox.shrink(),
                  _DigitButton(
                    child: const Text("0"),
                    onTap: () {
                      context.addEvent(const _PushDigit(0));
                    },
                  ),
                  if (context.bloc.pin == null)
                    _ConfirmButton(
                      onTap: () {
                        context.addEvent(const _SetupConfirmPin());
                      },
                    )
                  else
                    backspace,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ObsecuredInputView extends StatefulWidget {
  const _ObsecuredInputView();

  @override
  State<StatefulWidget> createState() => _ObsecuredInputViewState();
}

class _ObsecuredInputViewState extends State<_ObsecuredInputView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return _BlocListenerT(
      selector: (state) => state.isPinError,
      listener: (context, isPinError) {
        if (isPinError.value == true) {
          _controller.forward(from: 0);
        }
      },
      child: SlideTransition(
        position: _controller.drive(
          Animatable<Offset>.fromCallback(
            (t) => Offset(tremblingTransform(3, t) * .05, 0),
          ),
        ),
        child: AnimatedList(
          key: context.bloc.listKey,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          initialItemCount: context.state.obsecuredInput.length,
          itemBuilder:
              (context, index, animation) => ScaleTransition(
                scale: animation.drive(CurveTween(curve: Curves.elasticOut)),
                child: _ObsecuredDigitDisplay(
                  randomInt: context.state.obsecuredInput[index],
                ),
              ),
        ),
      ),
    );
  }

  late final _controller = AnimationController(vsync: this)
    ..duration = k.animationDurationLong;
}

class _ObsecuredDigitDisplay extends StatelessWidget {
  _ObsecuredDigitDisplay({required int randomInt})
    : text = String.fromCharCode(0x1f600 + (randomInt % 0x30));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  final String text;
}

class _DigitButton extends StatelessWidget {
  const _DigitButton({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              height: 56,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headlineMedium!,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  final Widget child;
  final VoidCallback? onTap;
}

class _BackspaceButton extends StatelessWidget {
  const _BackspaceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.obsecuredInput.isEmpty,
      builder:
          (context, isEmpty) => Padding(
            padding: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: isEmpty ? null : onTap,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    height: 56,
                    child: Icon(
                      Icons.backspace_outlined,
                      color: isEmpty ? Theme.of(context).disabledColor : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  final VoidCallback onTap;
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.obsecuredInput.length >= 4,
      builder:
          (context, isInputValid) => Padding(
            padding: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: isInputValid ? onTap : null,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    height: 56,
                    child: Text(
                      L10n.global().confirmButtonLabel,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color:
                            !isInputValid
                                ? Theme.of(context).disabledColor
                                : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  final VoidCallback onTap;
}

class _RemoveItem extends StatelessWidget {
  const _RemoveItem({required this.animation, required this.value});

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation.drive(CurveTween(curve: Curves.linear)),
      child: _ObsecuredDigitDisplay(randomInt: value),
    );
  }

  final Animation<double> animation;
  final int value;
}
