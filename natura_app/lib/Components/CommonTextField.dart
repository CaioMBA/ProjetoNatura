import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CommonInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Type;
  final String? InputType;
  final void Function(String)? onSubmitted;
  final double? width;

  CommonInputTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.Type = 'NEXT',
      this.InputType = 'TEXT',
      this.onSubmitted,
      this.width = 350});

  TextInputType? InputFormatType;

  @override
  Widget build(BuildContext context) {
    TextInputFormatter? Formatter =
        FilteringTextInputFormatter.deny(RegExp(r''));

    switch (InputType) {
      case 'TEXT':
        InputFormatType = TextInputType.text;
        break;
      case 'NUMBER':
        InputFormatType = TextInputType.number;
        Formatter = FilteringTextInputFormatter.digitsOnly;
        break;
      case 'PHONE':
        InputFormatType = TextInputType.phone;
        Formatter = PhoneInputFormatter();
        break;
      case 'EMAIL':
        InputFormatType = TextInputType.emailAddress;
        break;
      case 'DATE':
        InputFormatType = TextInputType.datetime;
        break;
      default:
        InputFormatType = TextInputType.text;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SizedBox(
        width: width ?? 350,
        child: TextField(
          autocorrect: true,
          textAlign: TextAlign.center,
          controller: controller,
          obscureText: obscureText,
          keyboardType: InputFormatType,
          inputFormatters: [Formatter],
          textInputAction:
              Type == 'DONE' ? TextInputAction.done : TextInputAction.next,
          onSubmitted: onSubmitted ?? (value) {},
          decoration: InputDecoration(
            //labelText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
