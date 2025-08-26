import 'package:flutter/material.dart';

class SimpleInputDialog extends StatefulWidget {
  const SimpleInputDialog({
    super.key,
    required this.buttonText,
    this.titleText,
    this.initialText,
    this.hintText,
    this.validator,
    this.obscureText = false,
  });

  @override
  createState() => _SimpleInputDialogState();

  final String buttonText;
  final String? titleText;
  final String? initialText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
}

class _SimpleInputDialogState extends State<SimpleInputDialog> {
  @override
  build(BuildContext context) {
    return AlertDialog(
      title: widget.titleText == null ? null : Text(widget.titleText!),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration:
              widget.hintText == null
                  ? null
                  : InputDecoration(hintText: widget.hintText),
          validator: widget.validator,
          onSaved: (value) {
            _formValue.text = value!;
          },
          initialValue: widget.initialText,
          obscureText: widget.obscureText,
        ),
      ),
      actions: [
        TextButton(onPressed: _onButtonPressed, child: Text(widget.buttonText)),
      ],
    );
  }

  void _onButtonPressed() {
    if (_formKey.currentState?.validate() == true) {
      _formValue = _FormValue();
      _formKey.currentState!.save();
      Navigator.of(context).pop(_formValue.text);
    }
  }

  final _formKey = GlobalKey<FormState>();
  var _formValue = _FormValue();
}

class _FormValue {
  late String text;
}
