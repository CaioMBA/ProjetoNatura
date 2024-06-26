import 'package:flutter/material.dart';

import 'CommonTextField.dart';

class CommonModalShow extends StatelessWidget {
  final String Title;
  final String Label;
  final TextEditingController controller;
  final void Function(String)? onSubmitted;

  const CommonModalShow(
      {super.key,
      this.onSubmitted,
      required this.Title,
      required this.controller,
      required this.Label});

  @override
  Widget build(BuildContext context) {
    void onSubmittedWrapper() {
      onSubmitted!('');
    }

    return AlertDialog(
      backgroundColor: Colors.grey[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      title: Text(
        Title,
        style: const TextStyle(
          color: Colors.black
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            Label,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          CommonInputTextField(
              controller: controller,
              hintText: 'Digite aqui...',
              Type: 'DONE',
              obscureText: false,
              onSubmitted: onSubmitted),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onSubmittedWrapper,
            child: const Text(
              'Enviar',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}
