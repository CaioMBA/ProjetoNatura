import 'package:flutter/material.dart';

class CommonDropDownMenu extends StatefulWidget {
  Map<String, String> DpItems = Map<String, String>();
  String SelectedValue;

  CommonDropDownMenu(
      {super.key, required this.DpItems, required this.SelectedValue});

  @override
  State<CommonDropDownMenu> createState() => _State();
}

class _State extends State<CommonDropDownMenu> {
  List<DropdownMenuItem<String>> Items = [];

  void PopulateDropDown() {
    widget.DpItems.forEach((key, value) {
      Items.add(
        DropdownMenuItem(
          value: key,
          child: Text(value),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: widget.SelectedValue,
        items: Items,
        onChanged: (newValue) {
          setState(() {
            widget.SelectedValue = newValue!;
          });
        });
  }
}
