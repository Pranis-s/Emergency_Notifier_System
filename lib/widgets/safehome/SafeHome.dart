import 'dart:math';

import 'package:background_sms/background_sms.dart';
import 'package:final_try/components/PrimaryButton.dart';
import 'package:final_try/db/db_services.dart';
import 'package:final_try/model/contactsm.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  Position? _currentPosition;
  String? _currentAddress;
  LocationPermission? permission;

  _getPermissions() async =>
      await [Permission.sms].request(); //Function for permission
  _isPermissionGranted() async =>
      await Permission.sms.status.isGranted; //Function for permission status
  _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    await BackgroundSms.sendMessage(
            phoneNumber: phoneNumber, message: message, simSlot: simSlot)
        .then((SmsStatus status) {
      if (status == "sent ") {
        Fluttertoast.showToast(msg: "sent");
      } else {
        Fluttertoast.showToast(msg: "failed");
      }
    });
  }

//Function to get address for sending the address
  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: 'Location permission are denied');
      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: "Location permission permanently denied");
      }
    }
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatlon();
      });
    }).catchError(() {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatlon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.street}, ${place.locality}, ${place.country}, ";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getPermissions();
    _getCurrentLocation();
  }

  showModelSafehome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Send your location to your emergency contacts",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                if (_currentPosition != null) Text(_currentAddress!),
                PrimaryButton(
                    title: "Get Location",
                    onPressed: () {
                      _getCurrentLocation();
                    }),
                SizedBox(
                  height: 10,
                ),
                PrimaryButton(
                    title: "Send SOS",
                    onPressed: () async {
                      List<TContact> contactList =
                          await DatabaseHelper().getContactList();
                      String recipients = "";
                      // recipients bydefault= "111111111;22222222;3333333"
                      int i = 1;
                      for (TContact contact in contactList) {
                        recipients = recipients + contact.number;
                        if (i != contactList.length) {
                          recipients += ";";
                          i++;
                        }
                      }
                      String messageBody =
                          "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}. $_currentAddress";
                      if (await _isPermissionGranted()) {
                        contactList.forEach((element) {
                          _sendSms("${element.number}",
                              "In trouble, please reach me at $messageBody",
                              simSlot: 1);
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Something went wrong");
                      }
                    }),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModelSafehome(context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(),
          child: Row(children: [
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Send Location'),
                    subtitle: Text('Share Location'),
                  )
                ],
              ),
            ),
            ClipRRect(child: Image.asset('assets/route.jpg'))
          ]),
        ),
      ),
    );
  }
}
//Bottom