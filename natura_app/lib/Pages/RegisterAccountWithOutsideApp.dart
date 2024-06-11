import 'package:flutter/material.dart';
import 'package:natura_app/Pages/Login.dart';
import '../Components/CommonDatePickerField.dart';
import '../Components/CommonTextField.dart';
import '../Components/ModalResponse.dart';
import '../Components/SignInButton.dart';
import '../Components/SquareTile.dart';
import '../Domain/DefaultApiResponseModel.dart';
import '../Services/UserServices.dart';
import 'Home.dart';

class RegisterAccountWithOutsideApp extends StatefulWidget {
  final String? UserLogin;
  final String? Email;
  final String? Name;
  final String? Photo;

  const RegisterAccountWithOutsideApp(
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

  @override
  Widget build(BuildContext context) {
    FullNameController.text = widget.Name!;
    UserNameController.text = widget.UserLogin!;
    EmailController.text = widget.UserLogin!;

    void SignUpButtonFunction(String s) async {
      String? Phone;
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

      if (PhoneController.text != '') {
        Phone = PhoneController.text;
        Phone = Phone.replaceAll(' ', '')
            .replaceAll('-', '')
            .replaceAll('(', '')
            .replaceAll(')', '');
      }

      DefaultApiResponseModel? ResponseService = await SignUp(
          FullNameController.text,
          UserNameController.text,
          PasswordController.text,
          EmailController.text,
          Phone,
          BirthdayController.text,
          CpfCnpjController.text,
          widget.Photo.toString());
      if (ResponseService?.STATUS != null && ResponseService?.STATUS == "1") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        PasswordController.clear();
        ConfirmPasswordController.clear();
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return ModalResponse(
                MSG: ResponseService!.MSG,
                STATUS: ResponseService.STATUS,
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              SquareTile(
                imagePath: 'lib/Images/natura-logo.png',
                Height: MediaQuery.of(context).size.height * 0.18,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'Cadastre-se em nosso App!',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonInputTextField(
                      width: MediaQuery.of(context).size.width * 0.45,
                      controller: FullNameController,
                      hintText: 'Nome Completo *',
                      obscureText: false),
                  CommonInputTextField(
                      controller: UserNameController,
                      width: MediaQuery.of(context).size.width * 0.45,
                      hintText: 'Usuário *',
                      obscureText: false)
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonInputTextField(
                      width: MediaQuery.of(context).size.width * 0.45,
                      controller: PasswordController,
                      hintText: 'Senha *',
                      IsPassword: true),
                  CommonInputTextField(
                      controller: ConfirmPasswordController,
                      width: MediaQuery.of(context).size.width * 0.45,
                      hintText: 'Confirmar Senha *',
                      IsPassword: true)
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonDatePickerField(
                      width: MediaQuery.of(context).size.width * 0.45,
                      controller: BirthdayController,
                      hintText: 'Data Nascimento *'),
                  CommonInputTextField(
                    controller: CpfCnpjController,
                    width: MediaQuery.of(context).size.width * 0.45,
                    hintText: 'CPF | CNPJ *',
                    obscureText: false,
                    InputType: 'NUMBER',
                    Type: 'DONE',
                    onSubmitted: SignUpButtonFunction,
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              SignInButton(text: 'Cadastrar', onTap: signUpWrapper),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Divider(
                    color: Colors.grey,
                    thickness: MediaQuery.of(context).size.height * 0.002,
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Já tem cadastro?'),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                    child: const Text(
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
