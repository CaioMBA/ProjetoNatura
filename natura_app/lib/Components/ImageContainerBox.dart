import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../Domain/StaticSchematics.dart';

class ImageContainerBox extends StatelessWidget {
  final String description;
  final String value;
  String? ImageInf;

  ImageContainerBox({required this.description, required this.value, this.ImageInf = ''});



  @override
  Widget build(BuildContext context) {
    var backgroundImage = ImageInf!.startsWith('http')
        ? NetworkImage(ImageInf!) as ImageProvider<Object>?
        : MemoryImage(
        Uint8List.fromList(base64.decode(ImageInf!)));

    return SizedBox(
      width: 300,
      height: 350,
      child: Container(
        padding: EdgeInsets.all(28.0),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Box background color
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0), // Space between description and value
            Text(
              'R\$ $value',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.amber,
              backgroundImage: backgroundImage,
            ),
            SizedBox(height: 25,),
            Text(
              'DESCONTO DE 50%',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
