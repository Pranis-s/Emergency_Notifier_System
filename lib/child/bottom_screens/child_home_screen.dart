import 'package:final_try/widgets/home_widgets/CustomCarouel.dart';
import 'package:final_try/widgets/home_widgets/emergency.dart';
import 'package:final_try/widgets/home_widgets/live_safe.dart';
import 'package:final_try/widgets/safehome/SafeHome.dart';
import 'package:flutter/material.dart';
import 'package:dcdg/dcdg.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // const HomeScreen({super.key});
  int qIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              /*CustomAppBar(
                quoteIndex: qIndex,
                //onTap: getRandomQuote(),
              ),*/
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CustomCarouel(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Emergency Numbers:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Emergency(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Explore LiveSafe",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    LiveSafe(),
                    SafeHome(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
