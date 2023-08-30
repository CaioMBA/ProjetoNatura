import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:natura_app/Components/CustomNavigationDrawer.dart';
import '../Components/CustomAppBar.dart';
import '../Domain/StaticSchematics.dart';
import '../Services/PickImageService.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundImage = GlobalStatics.UserPhoto!.startsWith('http')
        ? NetworkImage(GlobalStatics.UserPhoto!) as ImageProvider<Object>?
        : MemoryImage(
            Uint8List.fromList(base64.decode(GlobalStatics.UserPhoto!)));


    void _showImagePickerDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Selecionar Imagem'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Câmera'),
                  onTap: () {
                    var Base64Bytes = ChooseImageFile('CAMERA');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text('Galeria'),
                  onTap: () {
                    var Base64Bytes = ChooseImageFile('GALLERY');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                    leading: Icon(Icons.wifi), title: Text('Digite o Link'))
              ],
            ),
          );
        },
      );
    }
    void WrapDialog(){
      _showImagePickerDialog(context);
    }

    return Scaffold(
        appBar: CustomAppBar(Title: 'Edição de Usuário'),
        drawer: CustomNavigationDrawer(),
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'lib/Images/background-green_pink_leaves.jpeg'),
                    fit: BoxFit.cover)),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                    padding: EdgeInsets.only(
                        top: 24 + MediaQuery.of(context).padding.top,
                        bottom: 24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 72,
                          backgroundColor: Colors.black,
                          child: InkWell(
                            onTap: WrapDialog,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.amber,
                              backgroundImage: backgroundImage,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(GlobalStatics.UserName!,
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            GlobalStatics.UserEmail!,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    )),
              ],
            )));
  }
}