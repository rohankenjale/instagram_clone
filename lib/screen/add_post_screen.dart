import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:uuid/uuid.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  bool isLoading = false;
  TextEditingController _captionController = TextEditingController();
  Future<void> upladPost() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isLoading = true;
    });
    
    if (_captionController.text.trim().isEmpty) {
      showDialog(context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Invalid Input"),
          content: Text("Plese enter a Caption"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Okay"))
          ],
        );
      });
      return;
    }
    String postid = Uuid().v1();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final _firestore = FirebaseFirestore.instance;
    final user = await _firestore.collection('users').doc(uid).get();
    String username = user['username'];
    try {
      await _firestore.collection('posts').doc(postid).set({
      'caption' : _captionController.text,
      'userid' :uid,
      'username':username,
      'postId': postid,
      'datePublished': DateTime.now(),
      'likes': [],
    });
    setState(() {
      _captionController.text='';
      isLoading=false;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Posted')));
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( error.toString() ?? ("Upload Failed"))));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            
          },
          ),
          title: Text('Post To'),
          centerTitle: false,
        actions: [
          TextButton(
            onPressed: upladPost,
            child: Text('Post'))
        ],
      ),
      body:
       Column(
        children: [
          isLoading ? Padding(
            padding: const EdgeInsets.only(top: 8,bottom: 8),
            child: LinearProgressIndicator(
            ),
          ):Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                        backgroundImage: NetworkImage('https://www.upwork.com/profile-portraits/c1xZih9c2sOZqreDCLvLOlopUodbvOh5il0qyL--h5VL9YsdDX8E4vgcVgRIZ03wMF'),
                      ),
          SizedBox(
            width: 260,
            child: TextField(
              controller: _captionController,
              maxLines: 3,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Write a Caption'
              )
            ),
          )
            ],
          )
        ],
      ),
    );
  }
}