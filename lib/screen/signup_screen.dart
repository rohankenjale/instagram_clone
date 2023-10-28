import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screen/home_screen.dart';
import 'package:instagram_clone/screen/login_screen.dart';

import '../utils/colors.dart';
import '../widgets/text_feild_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
 final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_usernameController.text.trim().isEmpty || _emailController.text.trim().isEmpty||_passwordController.text.trim().isEmpty
    || _bioController.text.trim().isEmpty || !_emailController.text.contains('@') || _passwordController.text.length < 8 
    ) {
      
      showDialog(context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Invalid Input"),
          content: Text("Plese enter valid email, password, username and bio"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Okay"))
          ],
        );
      });

      return;

    }
    final cred = await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    _firestore.collection('users').doc(cred.user!.uid).set({
      'uid' : cred.user!.uid,
      "email" : _emailController.text,
      'bio' : _bioController.text,
      'username' : _usernameController.text
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 54,
              ),
              const SizedBox(
                height: 40,
              ),
              // Stack(
              //   children: [
              //     // const CircleAvatar(
              //     //         radius: 64,
              //     //         backgroundImage: NetworkImage(
              //     //             'https://i.stack.imgur.com/l60Hf.png'),
              //     //         backgroundColor: Colors.red,
              //     //       ),
              //     Positioned(
              //       bottom: -10,
              //       left: 80,
              //       child: IconButton(
              //         onPressed: (){},
              //         icon: const Icon(Icons.add_a_photo),
              //       ),
              //     )
              //   ],
              // ),
              const SizedBox(
                height: 15,
              ),
              TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFieldInput(
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signUp,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), 
                      gradient: LinearGradient(
                          begin: Alignment.centerRight, end: Alignment.centerLeft, 
                          colors: [Color(0xffff3d00), Color(0xff150098)], )),
                  child: const Text(
                          'Sign up',
                        )
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Already have an account?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Login.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}