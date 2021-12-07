import 'package:byahe_app/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byahe_app/pages/login_auth.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class TopBarMod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          flex: 5,
          child: Row(children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage('assets/salac.jpg'),
                )),
            Container(
                child: Text(
              'ID : 2018101451',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            Container(
                child: false
                    // ignore: dead_code
                    ? RichText(
                        text: TextSpan(
                            text: "   Status: ",
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            children: <TextSpan>[
                              alleyCheck(),
                            ]),
                      )
                    : null)
          ])),
      Expanded(
          child: InkWell(
              onTap: () {
                print(MyApp.ping);
                if (MyApp.ping == true) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('WARNING'),
                          content: Text(
                              'You are not able to exit on this page while pinging!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('CLOSE'),
                            )
                          ],
                        );
                      });
                } else {
                  String status = "OFFLINE";
                  FirebaseAuth.instance.signOut();
                  context.read<Authenticate>().updateUserStatus(status);
                  Navigator.pop(context);
                }
                // Navigator.pop(context);
              },
              child: Image.asset('assets/icons8-reply-arrow-30.png')))
    ]);
  }
}

mixin authenticate {}

TextSpan alleyCheck() {
  if (MyApp.alley) {
    return TextSpan(
        text: "Alley",
        style:
            TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold));
  } else {
    return TextSpan(
        text: "Riding",
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold));
  }
}
