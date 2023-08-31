import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<String?> ChooseImageFile(String? type) async {
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  if (type == 'GALLERY') {
    image = await _picker.pickImage(source: ImageSource.gallery);
  } else {
    image = await _picker.pickImage(source: ImageSource.camera);
  }

  if (image == null) return null;

  Uint8List imageByte = await image.readAsBytes();
  String _base64 = base64Encode(imageByte);

  return _base64;
}

Future<bool> CheckNetImage(String imageUrl) async {
  bool imCheck = false;
  try {
    final http.Response response = await http.head(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      imCheck = true;
    }
  } catch (_) {
    imCheck = false;
  }
  return imCheck;
}
