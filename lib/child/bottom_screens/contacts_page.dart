import 'package:contacts_service/contacts_service.dart';
import 'package:final_try/db/db_services.dart';
import 'package:final_try/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dcdg/dcdg.dart';

import '../../model/contactsm.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = []; //creating object
  List<Contact> contactsFiltered = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+:" : "";
    });
  }

  filterContact() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlattern = flattenPhoneNumber(searchTerm);
        String contactName = element.displayName!.toLowerCase();
        bool nameMatch = contactName.contains(searchTerm);
        if (nameMatch == true) {
          return true;
        }
        if (searchTermFlattern.isEmpty) {
          return false;
        }
        var phone = element.phones!.firstWhere((p) {
          String phnFlattered = flattenPhoneNumber(p.value!);
          return phnFlattered.contains(searchTermFlattern);
        });
        return phone.value != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContact();
      });
    } else {
      handInvalidPermissions(permissionStatus);
    }
  }

  handInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      dialogueBox(context, "Access to contacts denied by the user.");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialogueBox(context, "Maybe contacts does not exist in this device.");
    }
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  getAllContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearchIng = searchController.text.isNotEmpty;
    bool listItemExit = (contactsFiltered.length > 0 || contacts.length > 0);

    return Scaffold(
      body: contacts.length == 0
          ? Center(
              child:
                  CircularProgressIndicator()) // This is a progress indicator
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: true,
                      controller: searchController,
                      decoration: InputDecoration(
                          labelText: "Search Contact",
                          prefixIcon: Icon(Icons.search)),
                    ),
                  ),
                  listItemExit == true
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: isSearchIng == true
                                ? contactsFiltered.length
                                : contacts.length,
                            itemBuilder: (BuildContext context, int index) {
                              Contact contact = isSearchIng == true
                                  ? contactsFiltered[index]
                                  : contacts[index];
                              return ListTile(
                                  title: Text(contact
                                      .displayName!), //shows contact name
                                  subtitle: Text(contact.phones!.isNotEmpty
                                      ? contact.phones!.elementAt(0).value ?? ""
                                      : ""),
                                  //shows the contact number
                                  leading: contact.avatar != null &&
                                          contact.avatar!.length > 0
                                      ? CircleAvatar(
                                          backgroundColor: primaryColor,
                                          backgroundImage:
                                              MemoryImage(contact.avatar!),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: primaryColor,
                                          child: Text(contact.initials()),
                                        ),
                                  onTap: () {
                                    if (contact.phones!.length > 0) {
                                      final String phoneNum =
                                          contact.phones!.elementAt(0).value!;
                                      final String name = contact.displayName!;
                                      _addContact(TContact(phoneNum, name));
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Phone number of this contact does not exist");
                                    }
                                  });
                            },
                          ),
                        )
                      : Container(
                          child: Text("Searching"),
                        ),
                ],
              ),
            ),
    );
  }

  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact");
    }
    Navigator.of(context).pop(true);
  }
}
