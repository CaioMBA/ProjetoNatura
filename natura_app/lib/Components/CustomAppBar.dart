import 'package:flutter/material.dart';
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
    GetUserPassword();
  }

  void GetUserPassword() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      Username = loginData.getString('UserName');
      Password = loginData.getString('Password');
    });
  }

  Widget build(BuildContext context) {
    void SignOut() {
      loginData.setBool('Login', true);
      loginData.setString('UserName', '');
      loginData.setString('Password', '');
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => LoginPage()));
    }

    return AppBar(
        //automaticallyImplyLeading: false,
        title: Text(
          widget.Title!,
        ),
        actions: [
          IconButton(
            onPressed: SignOut,
            icon: Icon(Icons.logout),
          )
        ],
        leading: null);
  }
}
