import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/add_post_screen.dart';
import 'package:instagram_clone/screen/feed_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _pageIndex = value;
          });
          
        },
        children: const[
          FeedPage(),
          Text("Home2"),
          AddPostPage(),
          Text("Home"),
          Text("Home")
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
            _pageController.jumpToPage(_pageIndex);
          });
          
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: mobileBackgroundColor,
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.home,color: (_pageIndex==0) ? primaryColor:secondaryColor),label: '',backgroundColor: primaryColor),
        BottomNavigationBarItem(icon: Icon(Icons.search,color: _pageIndex==1? primaryColor:secondaryColor),label: '',backgroundColor: primaryColor),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle,color: _pageIndex==2? primaryColor:secondaryColor),label: '',backgroundColor: primaryColor),
        BottomNavigationBarItem(icon: Icon(Icons.favorite,color: _pageIndex==3? primaryColor:secondaryColor),label: '',backgroundColor: primaryColor),
        BottomNavigationBarItem(icon: Icon(Icons.person,color: _pageIndex==4? primaryColor:secondaryColor),label: '',backgroundColor: primaryColor),
      ]),
    );
  }
}