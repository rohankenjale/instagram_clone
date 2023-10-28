import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.snap});

  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final _firestore = FirebaseFirestore.instance;
  Future<void> likePost(String postId, String userid, List likes) async {
  try {
    if (likes.contains(userid)) {
      await _firestore.collection('posts').doc(postId).update({
        'likes' : FieldValue.arrayRemove([userid])
    });
    }
    else{
      await _firestore.collection('posts').doc(postId).update({
        'likes' : FieldValue.arrayUnion([userid])
    });
    }
  } catch (e) {
    print(e.toString());
  }
  }

  Future deletePost(String postId) async {
    Navigator.pop(context);
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: mobileBackgroundColor,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://media.licdn.com/dms/image/D5603AQEXuYtG1YYwbw/profile-displayphoto-shrink_800_800/0/1685275124696?e=2147483647&v=beta&t=Tdu8qXN_DbH3JA96_lYfB1VVkdMFK92DaDMOMpWIWX0'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        children: [
                          Text(widget.snap['username'],style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    )
                  ),
                  IconButton(onPressed: (){
                    showDialog(context: context, 
                    builder: (context)=> Dialog(
                      child: Container(
                        height: 60,
                        child: ListView(
                          children: ['Delete']
                          .map((e) => InkWell(
                            onTap: (){
                              deletePost(widget.snap['postId']);
                            },
                            child: Container(
                              height: 50,
                              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                              child: Text(e)),
                          )).toList(),
                        ),
                      ),
                    )
                    );
                  }, 
                  icon: Icon(Icons.more_vert))
                ],
              ),

            ),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network('https://media.licdn.com/dms/image/D5603AQEXuYtG1YYwbw/profile-displayphoto-shrink_800_800/0/1685275124696?e=2147483647&v=beta&t=Tdu8qXN_DbH3JA96_lYfB1VVkdMFK92DaDMOMpWIWX0',
              fit: BoxFit.cover,
            
              ),
            ),
            Row(
              children: [
                IconButton(onPressed: (){
                  likePost(widget.snap['postId'], widget.snap['userid'], widget.snap['likes']);
                },
                 icon: Icon( widget.snap['likes'].contains(widget.snap['userid'])? Icons.favorite : Icons.favorite_border_outlined ,color: Colors.red,)),
                IconButton(onPressed: (){}, icon: Icon(Icons.comment_outlined)),
                IconButton(onPressed: (){}, icon: Icon(Icons.send)),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(onPressed: (){}, icon: Icon(Icons.bookmark_border))
                    ),
                ),
              ],
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.snap['likes'].length} likes', style: Theme.of(context).textTheme.bodyMedium,),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 8),
                    child: RichText(text: TextSpan(
                      style: TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          text: widget.snap['username']
                        ),
                        TextSpan(
                          text: "  ${widget.snap['caption']}"
                        ),
                      ]
                    )),
                  ),
                  InkWell(
                    child: Container(
                      child: Text('veiw all', 
                      style: TextStyle(
                        fontSize: 16, color: secondaryColor
                      ),
                      ),
                    ),
                  ),
                  Container(
                      child: Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()), 
                      style: TextStyle(
                        fontSize: 16, color: secondaryColor
                      ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      );
  }
}

