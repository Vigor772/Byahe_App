import 'package:byahe_app/pages/commuter/locationselection.dart';
import 'package:byahe_app/pages/register/registerdriver.dart';
import 'package:byahe_app/pages/register/registerdriverconfirmation.dart';
import 'package:flutter/material.dart';
import 'package:byahe_app/pages/login/loginpage.dart';
import 'package:byahe_app/pages/register/registerpage.dart';
import 'package:byahe_app/pages/register/registercommuternickname.dart';
import 'package:byahe_app/pages/register/registercommuter.dart';
import 'package:byahe_app/pages/commuter/routeselection.dart';
import 'package:byahe_app/pages/commuter/reservevehicle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:byahe_app/pages/login_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({ Key? key }) : super(key: key);

  @override
  /*Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/loginpage',
      routes: {
        '/loginpage': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/registercommuter': (context) => RegisterCommuter(),
        '/registercommuternickname': (context) => RegisterCommuterNickname(),
        '/registerdriver': (context) => RegisterDriver(),
        '/registerdriverconfirmation': (context) =>
            RegisterDriverConfirmation(),
        '/locationselection': (context) => LocationSelection(),
        '/routeselection': (context) => RouteSelection(),
        '/reservevehicle': (context) => ReserveVehicle()
      },
    );
  }*/
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
        home: Verify(),
      ),
    );
  }
}

class Verify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    if (user != null) {
      return LocationSelection();
    }
    return LoginPage();
  }
}
