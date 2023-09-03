import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:natura_app/Components/CommonTextField.dart';
import 'package:natura_app/Components/CustomNavigationDrawer.dart';
import '../Components/CustomAppBar.dart';
import '../Components/ImagePickerModal.dart';
import '../Domain/StaticSchematics.dart';
import '../Services/PickImageService.dart';

class UserPage extends StatefulWidget {
  UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController LoginController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();

  void initState() {
    super.initState();
    LoginController.text = GlobalStatics.UserLogin!;
    EmailController.text = GlobalStatics.UserEmail!;
    PhoneController.text = GlobalStatics.UserPhone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = GlobalStatics.UserPhoto!.startsWith('http')
        ? NetworkImage(GlobalStatics.UserPhoto!) as ImageProvider<Object>?
        : MemoryImage(
            Uint8List.fromList(base64.decode(GlobalStatics.UserPhoto!)));

    void ImagePickerShow(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ImagePickerModal();
        },
      );
    }

    void wrapImagePickerShow() {
      ImagePickerShow(context);
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
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
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
                                  onTap: wrapImagePickerShow,
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
                      CommonInputTextField(
                        controller: LoginController,
                        labelText: 'Login',
                        Type: 'NEXT',
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      CommonInputTextField(
                        controller: EmailController,
                        labelText: 'E-mail',
                        InputType: 'EMAIL',
                        Type: 'NEXT',
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      CommonInputTextField(
                        controller: PhoneController,
                        labelText: 'Telefone',
                        InputType: 'PHONE',
                        Type: 'DONE',
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        icon: Icon(Icons.save),
                        label: Text('SALVAR'),

                        /*style:  ElevatedButton.styleFrom(
                          backgroundColor: Theme(data: data, child: child),
                        ),*/
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
