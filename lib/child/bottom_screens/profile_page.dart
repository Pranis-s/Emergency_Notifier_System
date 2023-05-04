import 'package:final_try/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../child_login_screen.dart';

class ProfilePage extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    final name = user?.displayName;
    final email = user?.email;
    final phone = user?.phoneNumber;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'USER PROFILE',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Name: ${name ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 20,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: ${email ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 20,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Phone: ${phone ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 20,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await auth.signOut();
                    Get.offAll(() => LoginScreen());
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
