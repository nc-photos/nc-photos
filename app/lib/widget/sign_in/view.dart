part of '../sign_in.dart';

/// A nice background that matches Nextcloud without breaking any copyright law
class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: Theme.of(context).nextcloudBlue),
        const Positioned(
          bottom: 60,
          left: -200,
          child: Opacity(
            opacity: .22,
            child: Icon(Icons.circle_outlined, color: Colors.white, size: 340),
          ),
        ),
        const Positioned(
          top: -120,
          left: -180,
          right: 0,
          child: Opacity(
            opacity: .1,
            child: Icon(Icons.circle_outlined, color: Colors.white, size: 620),
          ),
        ),
        const Positioned(
          bottom: -50,
          right: -120,
          child: Opacity(
            opacity: .27,
            child: Icon(Icons.circle_outlined, color: Colors.white, size: 400),
          ),
        ),
      ],
    );
  }
}

class _ConnectingBody extends StatelessWidget {
  const _ConnectingBody();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 64,
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: AppIntermediateCircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<StatefulWidget> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: Theme.of(context).widthLimitedContentMaxWidth,
          ),
          child: Column(
            children: [
              const Expanded(
                child: Center(
                  child: SingleChildScrollView(child: _SignInBody()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!ModalRoute.of(context)!.isFirst)
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          MaterialLocalizations.of(context).cancelButtonLabel,
                        ),
                      )
                    else
                      TextButton(
                        onPressed: () {
                          launch(help_util.nextcloudProviderUrl);
                        },
                        child: const Text("DON'T HAVE ONE?"),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          context.addEvent(const _Connect());
                        }
                      },
                      child: Text(L10n.global().connectButtonLabel),
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

  final _formKey = GlobalKey<FormState>();
}

class _SignInBody extends StatelessWidget {
  const _SignInBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10n.global().signInHeaderText2,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w100,
            ),
          ),
          const SizedBox(height: 16),
          _BlocSelector(
            selector: (state) => state.method,
            builder:
                (context, method) => FilledButton.tonal(
                  onPressed: () {
                    _onSignInMethodPressed(context);
                  },
                  child: Text(method.toOptionString()),
                ),
          ),
          const Row(
            children: [
              SizedBox(width: 64, child: _SchemeDropdown()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text("://"),
              ),
              Expanded(child: _ServerUrlInput()),
            ],
          ),
          const SizedBox(height: 8),
          _BlocSelector(
            selector: (state) => state.method,
            builder:
                (context, method) => ExpandableContainer(
                  isShow: method == _SignInMethod.usernamePassword,
                  child: const _UsernamePasswordForm(),
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSignInMethodPressed(BuildContext context) async {
    final pageContext = context;
    final result = await showDialog<_SignInMethod>(
      context: context,
      builder:
          (context) => FancyOptionPicker(
            items:
                _SignInMethod.values
                    .map(
                      (e) => FancyOptionPickerItem(
                        label: e.toOptionString(),
                        isSelected: pageContext.state.method == e,
                        onSelect: () {
                          Navigator.of(context).pop(e);
                        },
                      ),
                    )
                    .toList(),
          ),
    );
    if (result == null || !context.mounted) {
      return;
    }
    context.addEvent(_SetSignInMethod(result));
  }
}

class _SchemeDropdown extends StatelessWidget {
  const _SchemeDropdown();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: _BlocSelector(
        selector: (state) => state.scheme,
        builder:
            (context, scheme) => DropdownButtonFormField<_Scheme>(
              value: scheme,
              items:
                  _Scheme.values
                      .map(
                        (e) => DropdownMenuItem<_Scheme>(
                          value: e,
                          child: Text(e.toValueString()),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  context.addEvent(_SetScheme(value));
                }
              },
            ),
      ),
    );
  }
}

class _ServerUrlInput extends StatelessWidget {
  const _ServerUrlInput();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: L10n.global().serverAddressInputHint,
      ),
      keyboardType: TextInputType.url,
      validator: (value) {
        if (value!.trim().trimRightAny("/").isEmpty) {
          return L10n.global().serverAddressInputInvalidEmpty;
        }
        return null;
      },
      onChanged: (value) {
        context.addEvent(_SetServerUrl(value));
      },
    );
  }
}

class _UsernamePasswordForm extends StatelessWidget {
  const _UsernamePasswordForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: L10n.global().usernameInputHint,
          ),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (context.state.method != _SignInMethod.usernamePassword) {
              return null;
            }
            if (value!.trim().isEmpty) {
              return L10n.global().usernameInputInvalidEmpty;
            }
            return null;
          },
          onChanged: (value) {
            context.addEvent(_SetUsername(value));
          },
        ),
        const SizedBox(height: 8),
        _BlocSelector(
          selector: (state) => state.shouldObscurePassword,
          builder:
              (context, shouldObscurePassword) => TextFormField(
                decoration: InputDecoration(
                  hintText: L10n.global().passwordInputHint,
                  suffixIcon:
                      shouldObscurePassword
                          ? IconButton(
                            icon: const Icon(Icons.visibility_off_outlined),
                            onPressed: () {
                              context.addEvent(
                                const _SetObscurePassword(false),
                              );
                            },
                          )
                          : IconButton(
                            icon: const Icon(Icons.visibility_outlined),
                            onPressed: () {
                              context.addEvent(const _SetObscurePassword(true));
                            },
                          ),
                ),
                keyboardType: TextInputType.text,
                obscureText: shouldObscurePassword,
                validator: (value) {
                  if (context.state.method != _SignInMethod.usernamePassword) {
                    return null;
                  }
                  if (value!.trim().isEmpty) {
                    return L10n.global().passwordInputInvalidEmpty;
                  }
                  return null;
                },
                onChanged: (value) {
                  context.addEvent(_SetPassword(value));
                },
              ),
        ),
      ],
    );
  }
}

extension on _SignInMethod {
  String toOptionString() {
    switch (this) {
      case _SignInMethod.serverFlowV2:
        return L10n.global().signInViaNextcloudLoginFlowV2;
      case _SignInMethod.usernamePassword:
        return L10n.global().signInViaUsernamePassword;
    }
  }
}
