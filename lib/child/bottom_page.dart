import 'package:final_try/child/bottom_screens/add_contacts.dart';
import 'package:final_try/child/bottom_screens/chat_page.dart';
import 'package:final_try/child/bottom_screens/child_home_screen.dart';
import 'package:final_try/child/bottom_screens/contacts_page.dart';
import 'package:final_try/child/bottom_screens/profile_page.dart';
import 'package:flutter/material.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    AddContactsPage(),
    ChatPage(),
    ProfilePage(),
  ];
  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: 'Contacts', icon: Icon(Icons.contacts)),
            BottomNavigationBarItem(
                label: 'Chat',
                icon: Icon(
                  Icons.chat,
                )),
            BottomNavigationBarItem(
                label: 'Profile',
                icon: Icon(
                  Icons.person,
                )),
            /*BottomNavigationBarItem(
                label: 'Reviews',
                icon: Icon(
                  Icons.reviews,
                ))*/
          ]),
    );
  }
}
