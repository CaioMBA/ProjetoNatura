import 'package:flutter/material.dart';
import 'package:natura_app/Pages/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomNavigationDrawer extends StatefulWidget {
  CustomNavigationDrawer({super.key});

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  late SharedPreferences loginData;
  String? Username = 'User';
  String? Password = '';

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
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[buildHeader(context), buildMenuItems(context)],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
        color: Colors.amber,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.amber,
              backgroundImage:
                  NetworkImage('https://picsum.photos/250?image=9'),
            ),
            SizedBox(height: 10),
            Text(Username!,
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            Text(
              'e-mail',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.blue),
            ),
          ],
        ));
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text(
              'Home',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          )
        ],
      ),
    );
  }
}
