import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CommonDatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final double? width;
  final String? Type;
  final void Function(String)? OnSubmitted;

  const CommonDatePickerField({
    super.key,
    required this.controller,
    required this.hintText,
    this.width,
    this.Type,
    this.OnSubmitted
  });

  @override
  _DatePickerTextFieldState createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<CommonDatePickerField> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('pt','BR'),
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.text =
            selectedDate!.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SizedBox(
        width: widget.width ?? 350,
        child: TextField(
          autocorrect: true,
          textAlign: TextAlign.center,
          readOnly: true,
          textInputAction: widget.Type == 'DONE' ? TextInputAction.done : TextInputAction.next,
          keyboardType: TextInputType.datetime,
          inputFormatters: [MaskedInputFormatter('##/##/####')],
          onSubmitted: widget.OnSubmitted ?? (value) {},
          onTap: () => _selectDate(context),
          controller: widget.controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
