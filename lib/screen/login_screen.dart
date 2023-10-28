import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screen/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/text_feild_input.dart';

import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_emailController.text.trim().isEmpty||_passController.text.trim().isEmpty|| !_emailController.text.contains('@') || _passController.text.length < 8 
    ) {
      
      showDialog(context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Invalid Input"),
          content: Text("Plese enter valid email, password"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Okay"))
          ],
        );
      });

      return;

    }
    try {
      await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));

    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( error.message ?? ("Authentication Failed"))));
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Container(),flex: 2,),
                      SvgPicture.asset("assets/ic_instagram.svg",color: primaryColor,height: 64,),
                      SizedBox(height: 64,),
                      TextFieldInput(textEditingController: _emailController, hintText: "Enter your Email", textInputType: TextInputType.emailAddress),
                      SizedBox(height: 10),
                      TextFieldInput(textEditingController: _passController, hintText: "Enter Password", textInputType: TextInputType.text, isPass: true,),
                      SizedBox(height: 22),
            InkWell(
              onTap: login,
              child: Container(
                child: Text("login"),
                alignment: Alignment.center,
                          width: 394,
                          height: 61,
                          decoration:     BoxDecoration(
                      borderRadius: BorderRadius.circular(5), 
                      gradient: LinearGradient(
                          begin: Alignment.centerRight, end: Alignment.centerLeft, 
                          colors: [Color(0xffff3d00), Color(0xff150098)], ))
                          ),
            ),
                  Flexible(child: Container(),flex: 2,),
            Text(
                        "Don’t have an account? ",
                        style: TextStyle(
                          color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w200,
                        )
                    ),
            InkWell(
              onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => const SignupScreen(),));
              },
              child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                          )
                      ),
            )
                    ],
                ),
        ),
      )
    );
  }
}