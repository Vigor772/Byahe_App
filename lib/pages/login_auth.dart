import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byahe_app/pages/driver/onboard.dart';
import 'package:byahe_app/pages/commuter/locationselection.dart';
import 'package:flutter/widgets.dart';

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
    String vehicle_status;
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
          'vehicle_status': vehicle_status,
        });
      });
      return "Successfully Signed In";
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future retrieveUsertype(Widget onboard, Widget location) async {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot usercat =
        await FirebaseFirestore.instance.collection('users').doc(useruid).get();
    if (usercat['user_type'] == "Driver") {
      return onboard;
    } else if (usercat['user_type'] == "Commuter") {
      return location;
    }
  }

  Future updateVehicleStatus(String status) {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .update({'vehicle_status': status})
        .then((value) => print('Status updated'))
        .catchError((onError) => print('Failed to update status: $onError'));
  }

  Future getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future updateUserStatus(String status) {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .update({'status': status})
        .then((value) => print('User now online'))
        .catchError((onError) => print('Failed to update status: $onError'));
  }

  Future getLocationList() async {
    List locationList = [];

    try {
      await FirebaseFirestore.instance
          .collection('locations')
          .get()
          .then((query) {
        query.docs.forEach((doc) {
          locationList.add(doc.data());
          print(locationList);
        });
      });
      return locationList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
