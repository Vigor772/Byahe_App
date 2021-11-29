// ignore_for_file: await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticate {
  final FirebaseAuth _auth;

  Authenticate(this._auth);

  Stream<User> get authStateChanges => _auth.idTokenChanges();

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Logged In";
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String> signupCommuter(String email, String password) async {
    String userType;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "user_type": userType,
          "email": email,
          "password": password,
        });
      });
      return "Successfully Signed In";
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String> signupDriver(String email, String password) async {
    String fname;
    String lname;
    String jeepline;
    String jeeproute;
    String mobnum;
    String platenum;
    String userType;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          'uid': user.uid,
          'user_type': userType,
          'email': email,
          'password': password,
          'first_name': fname,
          'last_name': lname,
          'jeepney_line': jeepline,
          'jeepney_route': jeeproute,
          'mobile_number': mobnum,
          'vehicle_plate_number': platenum,
        });
      });
      return "Successfully Signed In";
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser;
  }

  Future getCurrentUid() async {
    return await FirebaseAuth.instance.currentUser.uid;
  }

  Future userType(String curruser) async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot item) {
        Map<String, dynamic> curruser = item.data();
        return curruser['user_type'];
      });
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
