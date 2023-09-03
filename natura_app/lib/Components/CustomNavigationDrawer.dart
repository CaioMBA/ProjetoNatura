import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natura_app/Pages/Home.dart';
import 'package:natura_app/Pages/UserPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Domain/StaticSchematics.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  final ThemeIcon = CupertinoIcons.moon_stars;

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
    ImageProvider<Object>? backgroundImage = GlobalStatics.UserPhoto!.startsWith('http')
        ? NetworkImage(GlobalStatics.UserPhoto!) as ImageProvider<Object>?
        : MemoryImage(Uint8List.fromList(base64.decode(GlobalStatics.UserPhoto!)));


    return Material(
      color: Colors.amber,
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UserPage()));
        },
        child: Container(
            padding: EdgeInsets.only(
                top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.amber,
                  backgroundImage: backgroundImage,
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
      ),
    );
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
            title: const Text('Favoritos'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          IconButton(
            icon: Icon(ThemeIcon),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
