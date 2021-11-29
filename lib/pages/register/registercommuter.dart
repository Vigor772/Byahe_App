import 'package:byahe_app/pages/register/registercommuternickname.dart';
import 'package:flutter/material.dart';
import 'package:byahe_app/widgets/closebutton.dart';
import 'package:byahe_app/pages/login_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:byahe_app/pages/login/loginpage.dart';

class RegisterCommuter extends StatefulWidget {
  @override
  _RegisterCommuterState createState() => _RegisterCommuterState();
}

class _RegisterCommuterState extends State<RegisterCommuter> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final String userType = "Commuter";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: <Widget>[
          SafeArea(
            child: CloseButtonBlack(),
          ),
          Text(
            'BYAHE',
            style: TextStyle(
              fontFamily: 'Thasadith',
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
              fontSize: 60,
            ),
          ),
          Image.asset('assets/undraw_town_r6pc__1_-removebg-preview.png'),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow[700]),
                        borderRadius: BorderRadius.circular(17)),
                    labelText: "Email",
                    border: OutlineInputBorder()),
              )),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow[700]),
                        borderRadius: BorderRadius.circular(17)),
                    labelText: "Password",
                    border: OutlineInputBorder()),
              )),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 30),
            child: ElevatedButton(
              onPressed: () {
                final String email = emailController.text.trim();
                final String password = passwordController.text.trim();

                if (email.isEmpty) {
                  return ("Email is Empty");
                } else {
                  if (password.isEmpty) {
                    return ("Password is Empty");
                  } else {
                    context
                        .read<Authenticate>()
                        .signupCommuter(email, password)
                        .then((value) async {
                      User user = FirebaseAuth.instance.currentUser;
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .set({
                        "uid": user.uid,
                        "user_type": userType,
                        "email": email,
                        "password": password,
                      });
                    });
                    return showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Successfully Signed Up'),
                            content: Text('Back to Login'),
                            actions: <Widget>[
                              ElevatedButton(
                                  child: Text("CLOSE"),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  })
                            ],
                          );
                        });
                  }
                }
              },
              child: Text("CONFIRM"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.yellow[700],
                  fixedSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pushNamed(
                        //     context, '/registercommuternickname');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterCommuterNickname()));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          fixedSize: Size(300, 50),
                          shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(color: Colors.yellow, width: 0.1),
                              borderRadius: BorderRadius.circular(20))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(5),
                                child: Image.asset(
                                  'assets/google.png',
                                  width: 30,
                                )),
                            RichText(
                              text: TextSpan(
                                  text: "Register using ",
                                  style: TextStyle(color: Colors.black),
                                  children: const <TextSpan>[
                                    TextSpan(
                                        text: "Google",
                                        style:
                                            TextStyle(color: Colors.redAccent)),
                                    TextSpan(text: " Account")
                                  ]),
                            )
                          ]))),
              Container(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pushNamed(
                        //     context, '/registercommuternickname');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterCommuterNickname()));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          fixedSize: Size(300, 50),
                          shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(color: Colors.yellow, width: 0.1),
                              borderRadius: BorderRadius.circular(20))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(5),
                                child: Image.asset(
                                  'assets/facebook.png',
                                  width: 30,
                                )),
                            RichText(
                              text: TextSpan(
                                  text: "Register using ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  children: const <TextSpan>[
                                    TextSpan(
                                        text: "Facebook",
                                        style: TextStyle(
                                            color: Colors.blueAccent)),
                                    TextSpan(text: " Account")
                                  ]),
                            )
                          ])))
            ],
          )
        ],
      ),
    )));
  }
}
