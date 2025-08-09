import 'package:flutter/material.dart';

class SwitchFormField extends FormField<bool> {
  SwitchFormField({
    super.key,
    required bool super.initialValue,
    Widget? title,
    Widget? subtitle,
    Widget? subtitleTrue,
    Widget? subtitleFalse,
    bool? dense,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
  }) : super(
         builder: (field) {
           final value = field.value ?? initialValue;
           return SwitchListTile(
             value: value,
             contentPadding: const EdgeInsets.all(0),
             title: title,
             subtitle:
                 value
                     ? (subtitleTrue ?? subtitle)
                     : (subtitleFalse ?? subtitle),
             dense: dense,
             onChanged: field.didChange,
           );
         },
       );
}
