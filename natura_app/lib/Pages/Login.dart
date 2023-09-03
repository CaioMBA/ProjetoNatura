import 'dart:core';
import 'package:flutter/material.dart';
import 'package:natura_app/Components/CommonTextField.dart';
import 'package:natura_app/Components/ModalResponse.dart';
import 'package:natura_app/Components/SignInButton.dart';
import 'package:natura_app/Components/SquareTile.dart';
import 'package:natura_app/Pages/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/CommonModalShow.dart';
import '../Domain/DefaultApiResponseModel.dart';
import '../Domain/OutsideAppSignInResponse.dart';
import '../Domain/StaticSchematics.dart';
import '../Services/OutsideAppSignInService.dart';
import '../Services/UserServices.dart';
import 'RegisterAccount.dart';
import 'RegisterAccountWithOutsideApp.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserNameController = TextEditingController();
  final PasswordController = TextEditingController();
  final ForgotPasswordController = TextEditingController();
  bool RememberMe = false;
  bool SignedWithGoogle = false;

  late SharedPreferences loginData;
  bool? newUser;
  bool? OutsideAppSigned;

  @override
  void initState() {
    super.initState();
    UserNameController.clear();
    PasswordController.clear();
    CheckIfAlreadyLoggedIn();
  }

  void CheckIfAlreadyLoggedIn() async {
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('Login') ?? true);
    OutsideAppSigned = (loginData.getBool('OutsideAppSigned') ?? false);
    UserNameController.text = loginData.getString('UserName') ?? "";
    PasswordController.text = loginData.getString('Password') ?? "";

    if (!newUser!) {
      if (OutsideAppSigned!) {
        //GlobalStatics.UserName = UserNameController.text;
        //UserNameController.clear();
        //PasswordController.clear();
        await GetExtraInfo(UserNameController.text);
        if (GlobalStatics.UserName == '') {
          UserNameController.clear();
          PasswordController.clear();
          loginData.setBool('OutsideAppSigned', false);
          loginData.setBool('Login', true);
          loginData.setString('UserName', '');
          loginData.setString('Password', '');
          return;
        } else {
          Navigator.pushReplacement(
              context, new MaterialPageRoute(builder: (context) => HomePage()));
          return;
        }
      }
      DefaultApiResponseModel? ResponseService =
          await SignIn(UserNameController.text, PasswordController.text);
      if (ResponseService?.STATUS == '1') {
        GlobalStatics.UserName = UserNameController.text;
        UserNameController.clear();
        PasswordController.clear();
        await GetExtraInfo(GlobalStatics.UserName);
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => HomePage()));
        return;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    void SignInButtonFunction(String s) async {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });

      if (UserNameController.text == "" || PasswordController.text == "") {
        String? MSG = "";
        MSG += UserNameController.text == ''
            ? 'Campo CREDENCIAL não pode ser vazio'
            : '';
        MSG += MSG == '' ? '' : '\n';
        MSG += PasswordController.text == ''
            ? 'Campo SENHA não pode ser vazio'
            : '';
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return ModalResponse(
                MSG: MSG,
                STATUS: '0',
                Type: 'WARNING',
                Seconds: 3,
              );
            });
        return;
      }

      DefaultApiResponseModel? ResponseService =
          await SignIn(UserNameController.text, PasswordController.text);
      if (ResponseService?.STATUS != null && ResponseService?.STATUS == "1") {
        if (RememberMe) {
          loginData.setBool('Login', false);

          loginData.setString('UserName', UserNameController.text);
          loginData.setString('Password', PasswordController.text);
        }
        await GetExtraInfo(UserNameController.text);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        PasswordController.clear();
        UserNameController.clear();
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

    void signInWrapper() {
      SignInButtonFunction('');
    }

    void ForgotPasswordCall(String) async {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      if (ForgotPasswordController.text == '') {
        Navigator.pop(context);
        return showDialog(
            context: context,
            builder: (context) {
              return ModalResponse(
                MSG: "O campo de Credencial é obrigatório!",
                STATUS: "0",
                Type: 'WARNING',
                Seconds: 3,
              );
            });
      }

      DefaultApiResponseModel? ResponseService =
          await ChangePassword(ForgotPasswordController.text, null, null, true);

      ForgotPasswordController.clear();

      if (ResponseService != null) {
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
    }

    void ForgotPasswordModal() {
      showDialog(
          context: context,
          builder: (context) {
            return CommonModalShow(
              Title: 'Esqueceu a senha?',
              Label: 'USUÁRIO | CPF | E-MAIL | TELEFONE',
              controller: ForgotPasswordController,
              onSubmitted: ForgotPasswordCall,
            );
          });
    }

    void GoogleSignInMethod() async {
      try {
        OutsideAppSignInResponse? CheckSignIn = await SignInWithGoogle();
        CheckSignIn?.Valid = CheckSignIn.Valid ?? false;
        if (CheckSignIn == null) {
          return;
        }
        if (CheckSignIn.Valid!) {
          SignedWithGoogle = true;
          if (RememberMe) {
            loginData.setBool('Login', false);
            loginData.setBool('OutsideAppSigned', true);

            loginData.setString('UserName', CheckSignIn!.Account!.email);
            loginData.setString('Password', '');
          }
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterAccountWithOutsideApp(
                      UserLogin: CheckSignIn?.Account?.email,
                      Email: CheckSignIn?.Account?.email,
                      Name: CheckSignIn?.Account?.displayName,
                      Photo: CheckSignIn?.Account?.photoUrl)));
        }
      } catch (_) {
        try {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } catch (_) {}
      }
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              SquareTile(
                imagePath: 'lib/Images/natura-logo.png',
                Height: MediaQuery.of(context).size.height * 0.18,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Text(
                'Bem-vindo(a) ao App Natura!',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              CommonInputTextField(
                  controller: UserNameController,
                  hintText: 'USUÁRIO | CPF | E-MAIL | TELEFONE',
                  obscureText: false),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              CommonInputTextField(
                  controller: PasswordController,
                  hintText: 'SENHA',
                  IsPassword: true,
                  Type: 'DONE',
                  onSubmitted: SignInButtonFunction),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.07),
                  child: Row(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                            value: RememberMe,
                            onChanged: (newValue) {
                              setState(() {
                                RememberMe = newValue!;
                              });
                            }),
                        Container(
                          margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.04),
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  RememberMe = !RememberMe;
                                });
                              },
                              child: Text(
                                'Lembrar do Login',
                                style: TextStyle(color: Colors.grey[700]),
                              )),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.04),
                      child: TextButton(
                        onPressed: ForgotPasswordModal,
                        child: Text(
                          'esqueceu a senha?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  ])),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              SignInButton(text: 'Logar', onTap: signInWrapper),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                            thickness:
                                MediaQuery.of(context).size.height * 0.002,
                            color: Colors.grey[150])),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Text(
                        'ou entre com:',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: MediaQuery.of(context).size.height * 0.002,
                      color: Colors.grey[150],
                    ))
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.035),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    onTap: GoogleSignInMethod,
                    imagePath: 'lib/Images/google-logo.png',
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  SquareTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ModalResponse(
                              STATUS: '0',
                              MSG: 'FUNÇÃO AINDA NÃO IMPLEMENTADA!',
                              Type: 'ERROR',
                              Seconds: 1,
                            );
                          });
                    },
                    imagePath: 'lib/Images/apple-logo.png',
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Não tem cadastro ainda?'),
                SizedBox(width: 5),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterAccount()));
                    },
                    child: Text(
                      'Cadastre-se agora!',
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
