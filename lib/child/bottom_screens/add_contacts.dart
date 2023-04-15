import 'package:final_try/components/PrimaryButton.dart';
import 'package:flutter/material.dart';

class AddContactsPage extends StatelessWidget {
  const AddContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Make Widget Tree
    return SafeArea(
      //SafeArea ensures that content of widget doesnot overlap with device's status bar, nav bar, other ui elements
      child: Container(
        child: Column(//Column display child widgets verticallly one below other
            children: [
          PrimaryButton(
              title: "Add trusted contacts",
              onPressed:
                  () {}), //PrimButton display button with title add trusted contacts
        ]),
      ),
    );
  }
}
