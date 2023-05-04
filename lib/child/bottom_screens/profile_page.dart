import 'package:final_try/child/child_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'USER PROFILE',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (user != null) ...[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        'Name: ${user!.displayName ?? ""}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        'Phone Number: ${user!.phoneNumber ?? ""}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        'Email: ${user!.email ?? ""}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _logout,
                    child: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }
}
