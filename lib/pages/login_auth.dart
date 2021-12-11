import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:byahe_app/pages/driver/onboard.dart';
//import 'package:byahe_app/pages/commuter/locationselection.dart';
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
    String name;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          'full_name': name,
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

  Future bookings() async {
    String status;
    String useruid = FirebaseAuth.instance.currentUser.uid;
    var vehicle_plate;
    var fname;
    var gender;
    var address;
    var number;
    var numpass;
    var date;
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(useruid)
        .set({
          'status': status,
          'plate_reference': vehicle_plate,
          "customer name": fname,
          'gender': gender,
          'address': address,
          'contact_number': number,
          'number_of_passengers': numpass,
          'date_to_reserve': date,
        })
        .then((value) => print('Booking sent'))
        .catchError((onError) => print('Failed to add booking: $onError'));
  }

  Future<String> signupDriver(String email, String password) async {
    String fname;
    String lname;
    String jeepline;
    String jeeproute;
    String mobnum;
    String platenum;
    String userType;
    String vehicle_status = 'DRIVING';
    String status = "ONLINE";
    bool broadcast = false;
    String route_path;
    String seats_avail;
    bool queue = false;
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
          'route_path': route_path,
          'seats_avail': seats_avail,
          'mobile_number': mobnum,
          'vehicle_plate_number': platenum,
          'vehicle_status': vehicle_status,
          'queue': queue,
          'broadcast': broadcast,
          'status': status,
        });
      });
      return "Successfully Signed In";
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future retrieveName() async {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    String name;
    DocumentSnapshot usercat =
        await FirebaseFirestore.instance.collection('users').doc(useruid).get();
    if (usercat['user_type'] == "Commuter") {
      name = usercat['full_name'];
      return name;
    } else if (usercat['user_type'] == "Driver") {
      name = usercat['first_name'] + usercat['last_name'];
      return name;
    }
  }

  Future retrieveUsertype() async {
    String usertype;
    String useruid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot usercat =
        await FirebaseFirestore.instance.collection('users').doc(useruid).get();
    usertype = usercat['user_type'];
    return usertype;
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
        });
      });
      return locationList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // ignore: non_constant_identifier_names
  Future getAlleyList(var route_path) async {
    List alleyList = [];

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('route_path', isEqualTo: route_path)
          .get()
          .then((query) {
        query.docs.forEach((doc) {
          alleyList.add(doc.data());
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getDriverRoutePath() async {
    String driverRoute;
    String useruid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot usercat =
        await FirebaseFirestore.instance.collection('users').doc(useruid).get();
    driverRoute = usercat['route_path'];
    return driverRoute;
  }

  Future displayBookingsDriver(var plate) async {
    List bookingList = [];

    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .where('plate_reference', isEqualTo: plate)
          .get()
          .then((query) {
        query.docs.forEach((element) {
          bookingList.add(element);
        });
      });
      return bookingList;
    } catch (e) {
      print(e.toString());
    }
  }

  Future getRouteListDetails(String location) async {
    List routeList = [];

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('jeepney_line', isEqualTo: location)
          .get()
          .then((query) {
        query.docs.forEach((doc) {
          routeList.add(doc.data());
        });
      });
      return routeList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getLat() async {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    var latitude;
    DocumentSnapshot usercat =
        await FirebaseFirestore.instance.collection('users').doc(useruid).get();

    latitude = usercat['latitude'];
    return latitude;
  }

  Future getPlate() async {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    var plate;
    DocumentSnapshot usercat =
        await FirebaseFirestore.instance.collection('users').doc(useruid).get();
    plate = usercat['vehicle_plate_number'];
    return plate;
  }

  Future getLong() async {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    var longitude;
    DocumentSnapshot usercat =
        await FirebaseFirestore.instance.collection('users').doc(useruid).get();

    longitude = usercat['longitude'];
    return longitude;
  }

  Future getEmail() async {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    var email;
    DocumentSnapshot usercat =
        await FirebaseFirestore.instance.collection('users').doc(useruid).get();

    email = usercat['email'];
    return email;
  }

  Future updateQueueStatus(bool status) {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .update({'queue': status})
        .then((value) => print('Queue status updated'))
        .catchError((onError) => print('Failed to update status: $onError'));
  }

  Future updateBroadCast(bool status) {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .update({'broadcast': status})
        .then((value) => print('Broadcast Status updated'))
        .catchError((onError) => print('Failed to update status: $onError'));
  }
}
