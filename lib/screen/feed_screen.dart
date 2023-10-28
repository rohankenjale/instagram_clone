import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_layout.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset('assets/ic_instagram.svg',
        color: primaryColor, height: 32,
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.message_outlined))
        ],
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder:(context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              return PostCard(
                snap: snapshot.data!.docs[index].data(),
              );
            }
            );
        })  
    );
  }
}
