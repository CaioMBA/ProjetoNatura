import 'package:flutter/material.dart';

class CommonDropDownMenu extends StatefulWidget {
  final Map<String, String?> DpItems;
  final String SelectedValue;
  final Function(String) onChanged;

  const CommonDropDownMenu({
    Key? key,
    required this.DpItems,
    required this.SelectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CommonDropDownMenu> createState() => _CommonDropDownMenuState();
}

class _CommonDropDownMenuState extends State<CommonDropDownMenu> {
  List<DropdownMenuItem<String>> Items = [];

  @override
  void initState() {
    super.initState();
    _populateDropDown();
  }

  void _populateDropDown() {
    widget.DpItems.forEach((key, value) {
      if (value != null){
        Items.add(
          DropdownMenuItem(
            value: key,
            child: Text(value ?? ''),
          ),
        );
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.SelectedValue,
      items: Items,
      onChanged: (newValue) {
        setState(() {
          widget.onChanged(newValue!);
        });
      },
    );
  }
}
