import 'package:contacts_service/contacts_service.dart';
import 'package:final_try/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  filterContact() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = element.displayName!.toLowerCase();
        bool nameMatch = contactName.contains(searchTerm);
        if (nameMatch == true) {
          setState(() {
            contactsFiltered = _contacts;
          });
        }
        return true;
      });
    }
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
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
    return Scaffold(
      body: contacts.length == 0
          ? Center(child: CircularProgressIndicator()) //Progress indicator
          : Column(
              children: [
                TextField(
                  autofocus: true,
                  controller: searchController,
                  decoration: InputDecoration(
                      labelText: "Search Contact",
                      prefixIcon: Icon(Icons.search)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      Contact contact = contacts[index];
                      return ListTile(
                          title:
                              Text(contact.displayName!), //shows contact name
                          subtitle: Text(contact.phones!.isNotEmpty
                              ? contact.phones!.elementAt(0).value ?? ""
                              : ""),
                          //shows the contact number
                          leading: contact.avatar != null &&
                                  contact.avatar!.length > 0
                              ? CircleAvatar(
                                  backgroundColor: primaryColor,
                                  backgroundImage: MemoryImage(contact.avatar!),
                                )
                              : CircleAvatar(
                                  backgroundColor: primaryColor,
                                  child: Text(contact.initials()),
                                ));
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
