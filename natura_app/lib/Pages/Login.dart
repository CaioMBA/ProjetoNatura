import 'package:flutter/material.dart';
import 'package:natura_app/Components/CommonTextField.dart';
import 'package:natura_app/Components/ModalResponse.dart';
import 'package:natura_app/Components/SignInButton.dart';
import 'package:natura_app/Components/SquareTile.dart';
import 'package:natura_app/Pages/Home.dart';
import 'package:natura_app/Services/SignUserService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/CommonModalShow.dart';
import '../Domain/DefaultApiResponseModel.dart';
import '../Domain/StaticSchematics.dart';
import '../Services/ChangePasswordService.dart';
import '../Services/GetUserExtraInfoService.dart';
import 'RegisterAccount.dart';

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

  late SharedPreferences loginData;
  bool? newUser;

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
    UserNameController.text = loginData.getString('UserName') ?? "";
    PasswordController.text = loginData.getString('Password') ?? "";

    if (!newUser!) {
      DefaultApiResponseModel? ResponseService = await SignIn(UserNameController.text, PasswordController.text);
      if (ResponseService?.STATUS == '1'){
        GlobalStatics.UserName = UserNameController.text;
        UserNameController.clear();
        PasswordController.clear();
        await GetExtraInfo(GlobalStatics.UserName);
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
  }

  Widget build(BuildContext context) {
    void SignInButtonFunction(String) async {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });

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
      if (ForgotPasswordController.text == ''){
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
              const SizedBox(height: 35),
              const SquareTile(
                imagePath: 'lib/Images/natura-logo.png',
                Height: 120,
              ),
              /*const Icon(
                    Icons.lock,
                    size: 100,
                  ),*/
              const SizedBox(height: 40),
              Text(
                'Bem-vindo(a) ao App Natura!',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              CommonInputTextField(
                  controller: UserNameController,
                  hintText: 'USUÁRIO | CPF | E-MAIL | TELEFONE',
                  obscureText: false),
              const SizedBox(height: 10),
              CommonInputTextField(
                  controller: PasswordController,
                  hintText: 'SENHA',
                  obscureText: true,
                  Type: 'DONE',
                  onSubmitted: SignInButtonFunction),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(
                        value: RememberMe,
                        onChanged: (newValue) {
                          setState(() {
                            RememberMe = newValue!;
                          });
                        }),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            RememberMe = !RememberMe;
                          });
                        },
                        child: Text(
                          'Lembrar do Login',
                          style: TextStyle(color: Colors.grey[700]),
                        )),
                    SizedBox(
                      width: 50,
                    ),
                    TextButton(
                      onPressed: ForgotPasswordModal,
                      child: Text(
                        'esqueceu a senha?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              SignInButton(text: 'Logar', onTap: signInWrapper),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.7,
                      color: Colors.grey[150],
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'ou entre com:',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.7,
                      color: Colors.grey[150],
                    ))
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    imagePath: 'lib/Images/google-logo.png',
                  ),
                  SizedBox(width: 15),
                  SquareTile(
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
