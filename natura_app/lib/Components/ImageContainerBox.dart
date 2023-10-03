import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageContainerBox extends StatelessWidget {
  final String description;
  final double? value;
  final int Sale = Random().nextInt(15) + 10;
  String? ImageInf;

  ImageContainerBox(
      {required this.description, required this.value, this.ImageInf = ''});

  @override
  Widget build(BuildContext context) {
    var backgroundImage = ImageInf!.startsWith('http')
        ? NetworkImage(ImageInf!) as ImageProvider<Object>?
        : MemoryImage(Uint8List.fromList(base64.decode(ImageInf!)));

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.grey[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
      content: Container(
        margin: EdgeInsets.zero,
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.465,
        padding: EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                description.length > 30
                    ? description.substring(0, 29)
                    : description,
                style: GoogleFonts.dmSerifDisplay(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.01), // Space between description and value
            FittedBox(
              fit: BoxFit.fill,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.amber,
                backgroundImage: backgroundImage,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.020,
            ),
            Text(
              '${Sale}% OFF',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'R\$ ${(value! - (value! * Sale / 100)).toStringAsFixed(2).toString().replaceAll('.', ',')}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'R\$ ${value!.toStringAsFixed(2).toString().replaceAll('.', ',')}',
              style: TextStyle(
                color: Colors.grey[500],
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.lineThrough),
            )
          ],
        ),
      ),
    );
  }
}
