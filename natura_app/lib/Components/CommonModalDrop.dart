import 'package:flutter/material.dart';

import 'CommonDropDown.dart';
 // Import the CommonDropDownMenu widget

class CommonModalDrop extends StatelessWidget {
  final String Title;
  final String Label;
  final String SelectedValue; // Add this property for the dropdown's selected value
  final Map<String, String?> DpItems; // Add this property for the dropdown items
  final Function(String) onChanged; // Add this property for the dropdown onChanged callback

  CommonModalDrop({
    super.key,
    required this.Title,
    required this.Label,
    required this.SelectedValue,
    required this.DpItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.grey[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      title: Text(
        Title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            Label,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          CommonDropDownMenu( // Use the CommonDropDownMenu widget
            DpItems: DpItems,
            SelectedValue: SelectedValue,
            onChanged: onChanged,
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              onChanged(SelectedValue); // Call the onChanged callback when the button is pressed
            },
            child: Text(
              'Enviar',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
