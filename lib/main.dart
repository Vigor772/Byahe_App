import 'package:byahe_app/pages/commuter/locationselection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:byahe_app/pages/login/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:byahe_app/pages/login_auth.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:byahe_app/pages/driver/onboard.dart';
import 'package:byahe_app/pages/register/registerdriver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({ Key? key }) : super(key: key);
  static bool alley = false;
  static bool ping = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Authenticate>(
          create: (_) => Authenticate(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<Authenticate>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        title: 'BYAHE',
        home: VerifySession(),
      ),
    );
  }
}

class VerifySession extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //FirebaseAuth.instance.signOut();
    final user = context.watch<User>();

    if (user != null) {
      currUser(user);
    }
    return LoginPage();
  }
}

Future<User> currUser(user) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .get()
      .then((DocumentSnapshot<Map> item) async {
    Map<String, dynamic> activeuser = item.data();
    final value = activeuser['user_type'];
    if (value != null) {
      if (value == "Driver") {
        return Onboard();
      } else {
        return LocationSelection();
      }
    }
  });
  return null;
}
