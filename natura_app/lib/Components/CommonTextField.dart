import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CommonInputTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  bool? obscureText;
  final String? Type;
  final String? InputType;
  final void Function(String)? onSubmitted;
  final double? width;
  final bool? IsPassword;

  CommonInputTextField(
      {super.key,
      required this.controller,
      this.hintText,
      this.labelText,
      this.obscureText = false,
      this.Type = 'NEXT',
      this.InputType = 'TEXT',
      this.onSubmitted,
      this.width,
      this.IsPassword = false});

  @override
  State<CommonInputTextField> createState() => _CommonInputTextFieldState();
}

class _CommonInputTextFieldState extends State<CommonInputTextField> {
  TextInputType? InputFormatType;

  @override
  void initState() {
    widget.obscureText = widget.IsPassword! ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    TextInputFormatter? Formatter =
        FilteringTextInputFormatter.deny(RegExp(r''));

    switch (widget.InputType) {
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
        width: widget.width ?? MediaQuery.of(context).size.width * 0.92,
        child: TextField(
          autocorrect: true,
          textAlign: TextAlign.center,
          controller: widget.controller,
          obscureText: widget.obscureText!,
          keyboardType: InputFormatType,
          inputFormatters: [Formatter],
          textInputAction: widget.Type == 'DONE'
              ? TextInputAction.done
              : TextInputAction.next,
          onSubmitted: widget.onSubmitted ?? (value) {},
          decoration: InputDecoration(
            labelText: widget.labelText,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: widget.hintText,
            suffixIcon: widget.IsPassword!
                ? IconButton(
                    icon: Icon(
                        widget.obscureText!
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark),
                    onPressed: () {
                      setState(() {
                        widget.obscureText = !widget.obscureText!;
                      });
                    },
                  )
                : null,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
