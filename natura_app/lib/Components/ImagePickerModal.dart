
import 'package:flutter/material.dart';
import 'package:natura_app/Components/CommonTextField.dart';
import 'package:natura_app/Components/ModalResponse.dart';
import 'package:natura_app/Domain/StaticSchematics.dart';
import '../Services/PickImageService.dart';

class ImagePickerModal extends StatelessWidget {
  ImagePickerModal({super.key});

  final NetImage = TextEditingController();


  @override
  Widget build(BuildContext context) {
    void ImagePickerShow(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Digite o Link da Imagem'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonInputTextField(
                  controller: NetImage,
                  hintText: 'Digite aqui...',
                  obscureText: false,
                  Type: 'DONE',
                  onSubmitted: (String) async {
                    try {
                      Navigator.pop(context);
                      var ImCheck = await CheckNetImage(NetImage.text);
                      if (ImCheck) {
                        GlobalStatics.UserPhoto = NetImage.text;
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ModalResponse(
                                MSG: 'LINK DE IMAGEM INVÁLIDO',
                                STATUS: '0',
                                Type: 'WARNING',
                                Seconds: 3,
                              );
                            });
                      }
                      Navigator.pop(context);
                    } catch (_) {}
                  },
                )
              ],
            ),
          );
        },
      );
    }

    void wrapImagePickerShow() {
      ImagePickerShow(context);
    }

    return AlertDialog(
      title: const Text('Selecionar Imagem'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Câmera'),
            onTap: () async{
              String? Base64Bytes = await ChooseImageFile('CAMERA');
              try {
                GlobalStatics.UserPhoto = Base64Bytes.toString();
              } catch (_) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ModalResponse(
                        MSG: 'Imagem Inválida!',
                        STATUS: '0',
                        Type: 'WARNING',
                        Seconds: 3,
                      );
                    });
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Galeria'),
            onTap: () async {
              String? Base64Bytes = await ChooseImageFile('GALLERY');
              try {
                GlobalStatics.UserPhoto = Base64Bytes.toString();
              } catch (_) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ModalResponse(
                        MSG: 'Imagem Inválida!',
                        STATUS: '0',
                        Type: 'WARNING',
                        Seconds: 3,
                      );
                    });
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
              leading: const Icon(Icons.wifi),
              title: const Text('Digite o Link'),
              onTap: wrapImagePickerShow)
        ],
      ),
    );
  }
}
