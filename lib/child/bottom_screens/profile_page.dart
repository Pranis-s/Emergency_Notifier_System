import 'package:final_try/child/child_login_screen.dart';
import 'package:final_try/components/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/SecondaryButton.dart';
import '../../utils/constants.dart';
import '../forgot_password.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? name;

  @override
  void initState() {
    super.initState();
    name = FirebaseAuth.instance.currentUser;
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
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 150,
                  color: primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (name != null) ...[
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
                        'User: ${name!.email ?? ""}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                  SizedBox(height: 35.0),
                  PrimaryButton(
                    title: "LOGOUT",
                    onPressed: _logout,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.5 -
                  280.0, // 40.0 is half the height of the Container
              left: 0,
              right: 0,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "To Reset Password,",
                      style: TextStyle(fontSize: 18),
                    ),
                    SecondaryButton(
                      title: 'Click Here',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ),
                      ),
                    ),
                  ],
                ),
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
//profile reset