import 'package:byahe_app/main.dart';
import 'package:byahe_app/pages/commuter/locationselection.dart';
import 'package:byahe_app/pages/driver/onboard.dart';
import 'package:byahe_app/pages/login/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byahe_app/pages/login_auth.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class TopBarMod extends StatefulWidget {
  @override
  _TopBarModState createState() => _TopBarModState();
}

class _TopBarModState extends State<TopBarMod> {
  var type;
  var name;
  @override
  initState() {
    retrieveUsertype();
    retrieveUserName();
    super.initState();
  }

  retrieveUsertype() async {
    dynamic result = await context.read<Authenticate>().retrieveUsertype();
    if (result == null) {
      print('Unable ro retrieve data');
    } else {
      setState(() {
        type = result;
        print('usertype: $type');
      });
    }
  }

  retrieveUserName() async {
    dynamic result = await context.read<Authenticate>().retrieveName();
    if (result == null) {
      print("Unable to retrieve user's name");
    } else {
      setState(() {
        name = result;
      });
    }
  }

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
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            Container(
                child: ElevatedButton(
              onPressed: () async {
                if (type == "Commuter") {
                  return showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Restricted Feature'),
                          content: Text('For drivers only'),
                          actions: <Widget>[
                            ElevatedButton(
                                child: Text("CLOSE"),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        );
                      });
                }
                if (MyApp.inboard == false) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Onboard()));
                  MyApp.inboard = true;
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LocationSelection()));
                  MyApp.inboard = false;
                }

                /*if (MyApp.ping == true) {
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
                }*/
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Colors.yellow[700],
              ),
              child: toOnboard(),
            )),
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
                  context.read<Authenticate>().updateUserStatus(status);
                  FirebaseAuth.instance.signOut();
                }
              },
              child: Image.asset('assets/icons8-reply-arrow-30.png')))
    ]);
  }

  toOnboard() {
    if (MyApp.inboard == false) {
      return Text('Onboard', style: TextStyle(fontWeight: FontWeight.bold));
    } else {
      return Text('Selection', style: TextStyle(fontWeight: FontWeight.bold));
    }
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
