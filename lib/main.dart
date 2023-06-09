import 'package:final_try/child/bottom_page.dart';
import 'package:final_try/db/share_pref.dart';
import 'package:final_try/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'child/child_login_screen.dart';

final navigatorkey = GlobalKey<
    ScaffoldMessengerState>(); //Manipulate scaffoldmessenger widget that shows snackbar and bottomsheet

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //ensure flutter framework is initialized
  await Firebase.initializeApp(); //initializes firebase
  await MySharedPreference.init(); // Initialize app's shared preference
  runApp(const MyApp()); // Runs MyApp widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.firaSansTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: MySharedPreference.getUserType(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == '') {
                return LoginScreen();
              }
              if (snapshot.data == 'child') {
                return BottomPage();
              } /*
              if (snapshot.data == 'parent ') {
                return ParentHomeScreen();
              }*/

              return progressIndicator(context);
            }));
  }
}


/*class CheckAuth extends StatelessWidget {
  //const CheckAuth({Key? key}) : super(key: key);
  checkData() {
    if (MySharedPreference.getUserType() == 'parent') {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}*/


