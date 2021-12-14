import 'dart:async';
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
    String name;
    bool queue = false;
    String status = "ONLINE";
    bool state = false;

    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          'full_name': name,
          "user_type": userType,
          'queue': queue,
          'status': 'ONLINE',
          'state': state,
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

  Future respondBooking(var fnamePlate, var response) {
    return FirebaseFirestore.instance
        .collection('bookings')
        .doc(fnamePlate)
        .update({'status': response})
        .then((value) => print('Successfully accepted the booking request'))
        .catchError((onError) => print('Failed to accept request: $onError'));
  }

  Future bookings() async {
    String status;
    String useruid = FirebaseAuth.instance.currentUser.uid;
    // ignore: non_constant_identifier_names
    var vehicle_plate;
    var drivername;
    var fname;
    var fnamePlate;
    var gender;
    var address;
    var number;
    var numpass;
    var date;
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(fnamePlate)
        .set({
          'status': status,
          'plate_reference': vehicle_plate,
          'driver_name': drivername,
          "customer_name": fname,
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
      name = usercat['last_name'];
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

  Future displayBookings() async {
    List bookingList = [];

    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .get()
          .then((query) {
        query.docs.forEach((doc) {
          bookingList.add(doc.data());
        });
      });
      return bookingList;
    } catch (e) {
      print(e.toString());
      return null;
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

  Future getCommuterQueueStatus() async {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    var queue;
    DocumentSnapshot usercat =
        await FirebaseFirestore.instance.collection('users').doc(useruid).get();
    queue = usercat['queue'];
    return queue;
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

  Future getTotalDriversRegistered() async {
    var counter = 0;
    try {
      await FirebaseFirestore.instance.collection('users').get().then((query) {
        query.docs.forEach((element) {
          if (element['user_type'] == 'Driver') {
            counter++;
          }
        });
      });
      return counter;
    } catch (e) {
      return e.toString();
    }
  }

  Future getTotalDriversInRoute(var jeepney_line) async {
    var counter = 0;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('jeepney_line', isEqualTo: jeepney_line)
          .get()
          .then((query) {
        query.docs.forEach((element) {
          if (element['user_type'] == 'Driver') {
            if (element['status'] == 'ONLINE') {
              counter++;
            }
          }
        });
      });
      return counter;
    } catch (e) {
      return e.toString();
    }
  }

  Future getDriverRoute() async {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    var driverRoute;

    DocumentSnapshot usercat =
        await FirebaseFirestore.instance.collection('users').doc(useruid).get();
    driverRoute = usercat['jeepney_line'];
    return driverRoute;
  }

  Future<void> clearPing() {
    var ping_status = 'Cancelled';
    String useruid = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .update({
          'ping_status': ping_status,
          'pinged_driver': null,
        })
        .then((value) => print('Updated Ping Status: Cancelled'))
        .catchError((onError) =>
            print('Failed to clear Commuter Current LandMark: $onError'));
  }

  Future<void> updatePing(var driverplate) {
    var ping_status = "Pending";
    String useruid = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .update({
          'ping_status': ping_status,
          'pinged_driver': driverplate,
        })
        .then((value) => print('Update Ping Status: Pending'))
        .catchError(
            (onError) => print('Failed to Update Ping Status into Pending'));
  }

  Future getPendingPingList() async {
    List pingList = [];
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('user_type', isEqualTo: 'Commuter')
          .where('ping_status', isEqualTo: 'Pending')
          .get()
          .then((query) {
        query.docs.forEach((doc) {
          pingList.add(doc.data());
        });
      });
      return pingList;
    } catch (e) {
      return e.toString();
    }
  }
}
