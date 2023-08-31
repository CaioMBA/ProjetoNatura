import 'package:flutter/material.dart';
import 'package:natura_app/Pages/Login.dart';
import 'package:natura_app/Services/SignUserService.dart';
import '../Components/CommonDatePickerField.dart';
import '../Components/CommonTextField.dart';
import '../Components/ModalResponse.dart';
import '../Components/SignInButton.dart';
import '../Components/SquareTile.dart';
import '../Domain/DefaultApiResponseModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Home.dart';

class RegisterAccountWithOutsideApp extends StatefulWidget {
  final String? UserLogin;
  final String? Email;
  final String? Name;
  final String? Photo;

  RegisterAccountWithOutsideApp(
      {super.key, this.Email, this.UserLogin, this.Name, this.Photo});

  @override
  State<RegisterAccountWithOutsideApp> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccountWithOutsideApp> {
  final FullNameController = TextEditingController();
  final UserNameController = TextEditingController();
  final PasswordController = TextEditingController();
  final ConfirmPasswordController = TextEditingController();
  final CpfCnpjController = TextEditingController();
  final EmailController = TextEditingController();
  final PhoneController = TextEditingController();
  final BirthdayController = TextEditingController();
  late final String? PhotoLink;

  @override
  Widget build(BuildContext context) {
    FullNameController.text = widget.Name!;
    UserNameController.text = widget.UserLogin!;
    EmailController.text = widget.UserLogin!;
    PhotoLink = widget.Photo;

    void SignUpButtonFunction(String) async {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      if (FullNameController.text == '' ||
          UserNameController.text == '' ||
          PasswordController.text == '' ||
          ConfirmPasswordController.text == '' ||
          EmailController.text == '' ||
          BirthdayController.text == '' ||
          CpfCnpjController.text == '') {
        PasswordController.clear();
        ConfirmPasswordController.clear();
        Navigator.pop(context);
        return showDialog(
            context: context,
            builder: (context) {
              return ModalResponse(
                MSG: "OS CAMPOS COM * SÃO OBRIGATÓRIOS",
                STATUS: "0",
                Type: 'WARNING',
                Seconds: 3,
              );
            });
      }
      if (PasswordController.text != ConfirmPasswordController.text) {
        Navigator.pop(context);
        PasswordController.clear();
        ConfirmPasswordController.clear();
        return showDialog(
            context: context,
            builder: (context) {
              return ModalResponse(
                MSG: "OS CAMPOS SENHA E CONFIRMAR SENHA SÃO DIVERGENTES",
                STATUS: "0",
                Type: 'WARNING',
                Seconds: 3,
              );
            });
      }

      DefaultApiResponseModel? ResponseService = await SignUp(
          FullNameController.text,
          UserNameController.text,
          PasswordController.text,
          EmailController.text,
          PhoneController.text,
          BirthdayController.text,
          CpfCnpjController.text,
          PhotoLink);
      if (ResponseService?.STATUS != null && ResponseService?.STATUS == "1") {
        if (PhoneController.text != '') {
          final Uri url = Uri.parse('https://t.me/NotifyApi_bot');
          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {}
        }

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        PasswordController.clear();
        ConfirmPasswordController.clear();
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return ModalResponse(
                MSG: ResponseService!.MSG,
                STATUS: ResponseService!.STATUS,
                Type: 'WARNING',
                Seconds: 3,
              );
            });
      }
    }

    void signUpWrapper() {
      SignUpButtonFunction('');
    }

    return Scaffold(
        //resizeToAvoidBottomInset: false,
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/Images/background-green_pink_leaves.jpeg'),
              fit: BoxFit.cover)),
      child: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              const SquareTile(
                imagePath: 'lib/Images/natura-logo.png',
                Height: 120,
              ),
              const SizedBox(height: 20),
              Text(
                'Cadastre-se em nosso App!',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonInputTextField(
                      width: 175,
                      controller: FullNameController,
                      hintText: 'Nome Completo *',
                      obscureText: false),
                  CommonInputTextField(
                      controller: UserNameController,
                      width: 175,
                      hintText: 'Usuário *',
                      obscureText: false)
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonInputTextField(
                      width: 175,
                      controller: PasswordController,
                      hintText: 'Senha *',
                      obscureText: true),
                  CommonInputTextField(
                      controller: ConfirmPasswordController,
                      width: 175,
                      hintText: 'Confirmar Senha *',
                      obscureText: true)
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonInputTextField(
                    controller: EmailController,
                    hintText: 'E-mail *',
                    obscureText: false,
                    InputType: 'EMAIL',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonInputTextField(
                    controller: PhoneController,
                    hintText: 'Telefone',
                    obscureText: false,
                    InputType: 'PHONE',
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonDatePickerField(
                      width: 175,
                      controller: BirthdayController,
                      hintText: 'Data Nascimento *'),
                  CommonInputTextField(
                    controller: CpfCnpjController,
                    width: 175,
                    hintText: 'CPF | CNPJ *',
                    obscureText: false,
                    InputType: 'NUMBER',
                    Type: 'DONE',
                    onSubmitted: SignUpButtonFunction,
                  )
                ],
              ),
              const SizedBox(height: 25),
              SignInButton(text: 'Cadastrar', onTap: signUpWrapper),
              const SizedBox(height: 35),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 0.7,
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Já tem cadastro?'),
                SizedBox(width: 5),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      'Logar agora!',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                    ))
              ])
            ],
          ),
        ),
      )),
    ));
  }
}
