import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_try/child/bottom_screens/contacts_page.dart';
import 'package:final_try/components/PrimaryButton.dart';
import 'package:final_try/db/db_services.dart';
import 'package:final_try/model/contactsm.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<TContact>? contactList;
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

  void deleteContact(TContact contact) async {
    int result = await databaseHelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact removed successfully");
      showList();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((Timestamp) {
      showList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (contactList == null) {
      contactList = [];
    }
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
              onPressed: () async {
                bool result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactsPage()));
                if (result == true) {
                  showList();
                }
              }),
          Expanded(
            child: ListView.builder(
                //shrinkWrap: true,
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(contactList![index].name),
                      trailing: IconButton(
                        onPressed: () {
                          deleteContact(contactList![index]);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                }),
          )
        ]),
      ),
    );
  }
}
