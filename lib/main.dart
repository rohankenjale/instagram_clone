import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/home_screen.dart';
import 'package:instagram_clone/screen/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ?
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBQ3Unnyfp-Q_Rryg1wGL-NATjLvEzsYR8",
        appId: "1:803895945710:android:310be5d73484bbadb186ff",
        messagingSenderId: "803895945710",
        projectId: "instagram-clone-501f8",
      ),
    ): await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), 
      builder:(ctx,snapshot){
        if (snapshot.hasData) {
          return HomePage();
        }

        return LoginPage();
      }, )
    );
  }
}