part of 'protected_page_password_auth_dialog.dart';

class _DialogBody extends StatelessWidget {
  const _DialogBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _PasswordInput(),
        _BlocSelector(
          selector: (state) => state.isAuthorized,
          builder: (context, isAuthorized) {
            if (isAuthorized.value == false) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: _ErrorNotice(L10n.global().appLockUnlockWrongPassword),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}

class _PasswordInput extends StatefulWidget {
  const _PasswordInput();

  @override
  State<StatefulWidget> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      obscureText: !_isVisible,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: L10n.global().passwordInputHint,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          icon:
              _isVisible
                  ? const Icon(Icons.visibility_outlined)
                  : const Icon(Icons.visibility_off_outlined),
        ),
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          context.addEvent(_Submit(value));
        }
      },
    );
  }

  var _isVisible = false;
}

class _ErrorNotice extends StatefulWidget {
  const _ErrorNotice(this.text);

  @override
  State<StatefulWidget> createState() => _ErrorNoticeState();

  final String text;
}

class _ErrorNoticeState extends State<_ErrorNotice>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _BlocListenerT(
      selector: (state) => state.isAuthorized,
      listener: (context, isAuthorized) {
        if (isAuthorized.value == false) {
          _controller.forward(from: 0);
        }
      },
      child: SlideTransition(
        position: _controller.drive(
          Animatable<Offset>.fromCallback(
            (t) => Offset(tremblingTransform(3, t) * .05, 0),
          ),
        ),
        child: Text(
          widget.text,
          style: Theme.of(context).textStyleColored(
            (textTheme) => textTheme.bodySmall,
            (colorScheme) => colorScheme.error,
          ),
        ),
      ),
    );
  }

  late final _controller = AnimationController(vsync: this)
    ..duration = k.animationDurationLong;
}
