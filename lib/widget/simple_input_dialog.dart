import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SimpleInputDialog extends StatefulWidget {
  SimpleInputDialog({
    Key? key,
    this.initialText,
    this.hintText,
    this.validator,
  }) : super(key: key);

  @override
  createState() => _SimpleInputDialogState();

  final String? initialText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
}

class _SimpleInputDialogState extends State<SimpleInputDialog> {
  @override
  build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: widget.hintText == null
              ? null
              : InputDecoration(hintText: widget.hintText),
          validator: widget.validator,
          onSaved: (value) {
            _formValue.text = value!;
          },
          initialValue: widget.initialText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _onSavePressed,
          child: Text(
            MaterialLocalizations.of(context).saveButtonLabel,
          ),
        ),
      ],
    );
  }

  void _onSavePressed() {
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