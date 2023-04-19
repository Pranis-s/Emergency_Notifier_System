import 'package:final_try/child/bottom_screens/contacts_page.dart';
import 'package:final_try/components/PrimaryButton.dart';
import 'package:final_try/db/db_services.dart';
import 'package:final_try/model/contactsm.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<TContact>? contactList = [];
  int count = 0;

  void showList() {
    Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContact>> contactListFuture =
          databaseHelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          this.contactList = value;
          this.count = value.length;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    showList();

    super.initState();
  }

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
          ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(contactList![index].name),
                  ),
                );
              })
        ]),
      ),
    );
  }
}
