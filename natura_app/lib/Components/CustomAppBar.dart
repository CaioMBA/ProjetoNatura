import 'package:flutter/material.dart';
import 'package:natura_app/Domain/StaticSchematics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/Login.dart';

class CustomAppBar extends AppBar {
  final String Title;

  CustomAppBar({super.key, required this.Title});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  late SharedPreferences loginData;
  String? Username;
  String? Password;

  @override
  void initState() {
    super.initState();
    GetUser();
  }

  void GetUser() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      Username = loginData.getString('UserName');
    });
  }

  @override
  Widget build(BuildContext context) {
    void SignOut() {
      loginData.setBool('Login', true);
      loginData.setBool('OutsideAppSigned', false);
      loginData.setString('UserName', '');
      loginData.setString('Password', '');
      GlobalStatics.UserLogin = '';
      GlobalStatics.UserEmail = '';
      GlobalStatics.UserPhoto = '';
      GlobalStatics.UserPhone = '';
      GlobalStatics.UserUnique = '';
      GlobalStatics.UserBirthday = '';
      GlobalStatics.UserName = '';
      GlobalStatics.UserID = 0;

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }

    return AppBar(
        //backgroundColor: Colors.transparent,
        //elevation: 0,
        title: Text(
          widget.Title,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        actions: [
          IconButton(
            onPressed: SignOut,
            icon: const Icon(Icons.logout),
          )
        ],
        leading: null);
  }
}
