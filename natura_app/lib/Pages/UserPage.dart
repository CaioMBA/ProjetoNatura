import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:natura_app/Components/CommonTextField.dart';
import 'package:natura_app/Components/CustomNavigationDrawer.dart';
import 'package:natura_app/Services/UserServices.dart';
import '../Components/CustomAppBar.dart';
import '../Components/ImagePickerModal.dart';
import '../Components/ModalResponse.dart';
import '../Domain/DefaultApiResponseModel.dart';
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
    var backgroundImage = GlobalStatics.UserPhoto!.startsWith('http')
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

    void ChangeDetails() async {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });

      DefaultApiResponseModel? ResponseService = await ChangeUserDetailsService(
          GlobalStatics.UserLogin!,
          LoginController.text,
          EmailController.text,
          PhoneController.text);
      if (ResponseService == null) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return ModalResponse(
                MSG: 'Erro na API, por favor tentar novamente mais tarde',
                STATUS: '0',
                Type: 'WARNING',
                Seconds: 3,
              );
            });
      }
      if (ResponseService!.STATUS == '1') {
        await GetExtraInfo(LoginController.text);
        setState(() {
          backgroundImage = GlobalStatics.UserPhoto!.startsWith('http')
              ? NetworkImage(GlobalStatics.UserPhoto!) as ImageProvider<Object>?
              : MemoryImage(
              Uint8List.fromList(base64.decode(GlobalStatics.UserPhoto!)));
          GlobalStatics.UserLogin = LoginController.text;
        });
      }
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ModalResponse(
              MSG: ResponseService!.MSG,
              STATUS: ResponseService!.STATUS,
              Type: ResponseService.STATUS == '1' ? 'SUCCESS' : 'WARNING',
              Seconds: 3,
            );
          });
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
                                  onTap: () {
                                    ImagePickerShow(context);
                                  },
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
                                  GlobalStatics.UserLogin!,
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
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      CommonInputTextField(
                          controller: EmailController,
                          labelText: 'E-mail',
                          InputType: 'EMAIL',
                          Type: 'NEXT',
                          width: MediaQuery.of(context).size.width * 0.8),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      CommonInputTextField(
                        controller: PhoneController,
                        labelText: 'Telefone',
                        InputType: 'PHONE',
                        onSubmitted: (String x) {
                          ChangeDetails();
                        },
                        width: MediaQuery.of(context).size.width * 0.8,
                        Type: 'DONE',
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      FloatingActionButton.extended(
                        onPressed: ChangeDetails,
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
