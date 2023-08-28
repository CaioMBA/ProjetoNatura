import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';

class ModalResponse extends StatelessWidget {
  final String? MSG;
  final String? STATUS;
  final String? Type;
  final int? Seconds;

  ModalResponse(
      {super.key,
      this.STATUS,
      this.MSG,
      this.Type = 'FALSE',
      this.Seconds = 1});

  Color ColorChoice = Colors.grey;

  @override
  Widget build(BuildContext context) {
    switch (Type) {
      case "SUCCESS":
        ColorChoice = Colors.green;
        break;
      case "WARNING":
        ColorChoice = Colors.yellow;
        break;
      case "ERROR":
        ColorChoice = Colors.red;
        break;
    }

    Future.delayed(Duration(seconds: Seconds!), () {
      try {
        Navigator.of(context).pop(true);
      } catch (_) {}
    });
    return AlertDialog(
        backgroundColor: ColorChoice,
        title: Center(
            child: StrokeText(
                text: MSG ?? 'Sem resposta da API',
                textStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                strokeColor: Colors.black,
                strokeWidth: 5)));
  }
}
