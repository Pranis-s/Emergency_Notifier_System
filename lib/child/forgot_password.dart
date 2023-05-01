import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_try/child/child_login_screen.dart';
import 'package:final_try/components/custom_textfield.dart';
import 'package:final_try/db/share_pref.dart';
import 'package:final_try/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/PrimaryButton.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController forgetPasswordController = TextEditingController();
  bool isPasswordShown = true;
  bool isRetypePasswordShown = true;

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              isLoading
                  ? progressIndicator(context)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'RESET PASSWORD',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                Image.asset(
                                  'assets/logo.png',
                                  height: 100,
                                  width: 100,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomTextField(
                                    controller: forgetPasswordController,
                                    hintText: 'Enter Email',
                                    textInputAction: TextInputAction.next,
                                    keyboardtype: TextInputType.emailAddress,
                                    prefix: Icon(Icons.person),
                                    /*onsave: (email) {
                                      _formData['email'] = email ?? "";
                                    },
                                    validate: (email) {
                                      if (email!.isEmpty ||
                                          email.length < 3 ||
                                          !email.contains("@")) {
                                        return 'Enter Correct Email';
                                      }
                                      return null;
                                    },*/
                                  ),
                                  PrimaryButton(
                                    title: 'Send Request',
                                    onPressed: () async {
                                      var forgotEmail =
                                          forgetPasswordController.text.trim();

                                      try {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: forgotEmail)
                                            .then((value) => {
                                                  print("Email is sent"),
                                                  Get.off(() => LoginScreen())
                                                });
                                      } on FirebaseAuthException catch (e) {
                                        print("Error $e");
                                      }
                                      /*if (_formKey.currentState!.validate()) {
                                        if (_formData['email']
                                            .toString()
                                            .isEmpty) {
                                          // show error dialog if email is empty
                                          /*showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Error'),
                                              content: Text(
                                                  'Please enter a correct email.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('OK'),
                                                )
                                              ],
                                            ),
                                          );*/
                                        } else {
                                          // send password reset email
                                          
                                          /*await FirebaseAuth.instance
                                              .sendPasswordResetEmail(
                                                  email: _formData['email']
                                                      .toString());
                                          Navigator.of(context).pop();*/
                                        }
                                      }*/
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
