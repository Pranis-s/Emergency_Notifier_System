import 'package:final_try/child/bottom_screens/contacts_page.dart';
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
        padding: EdgeInsets.all(12),
        child: Column(//Column display child widgets verticallly one below other
            children: [
          PrimaryButton(
              //PrimButton display button with title add trusted contacts
              title: "Add trusted contacts",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactsPage()));
              }),
        ]),
      ),
    );
  }
}
