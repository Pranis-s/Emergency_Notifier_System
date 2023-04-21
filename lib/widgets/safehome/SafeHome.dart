import 'package:flutter/material.dart';

class SafeHome extends StatelessWidget {
  showModelSafehome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Send SOS Location")], //sos page location
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
