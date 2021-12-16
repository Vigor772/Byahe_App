// ignore_for_file: missing_return
import 'dart:async';
import 'dart:typed_data';
import 'package:byahe_app/main.dart';
import 'package:byahe_app/pages/commuter/reservevehicle.dart';
import 'package:byahe_app/pages/login_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:byahe_app/widgets/topbarmod.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locate;
import 'package:provider/src/provider.dart';
// ignore: implementation_imports

// ignore: must_be_immutable
class Map extends StatefulWidget {
  var routeData;
  Map(this.routeData);
  @override
  _MapState createState() => _MapState(this.routeData);
}

class _MapState extends State<Map> {
  String useruid = FirebaseAuth.instance.currentUser.uid;
  var routeData;
  var latitude;
  var longitude;
  var email;
  //var queueStatus;
  var currentUserType;
  bool state = false;
  List commuterData = [];
  _MapState(this.routeData);
  StreamSubscription _locationSubscription;
  locate.Location _locationTracker = locate.Location();
  GoogleMapController _controller;
  Marker marker;
  Marker marker2;
  List<Marker> usersMarkers = [];
  Circle circle;

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/jeep_icon.png");
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> getMarker2() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load('assets/red_arrow.png');
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(
      locate.LocationData newLocalData, Uint8List imageData) {
    LatLng driverLocation =
        LatLng(routeData['latitude'], routeData['longitude']);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: driverLocation,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("arrow"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: driverLocation,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void updateMarkerCommuter(
      locate.LocationData newLocalData, Uint8List imageData2) {
    //LatLng commuter = LatLng(latitude, longitude);
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    //print(commuter);
    print(latlng);
    this.setState(() {
      marker2 = Marker(
          markerId: MarkerId(email.toString()),
          position: /*commuter,*/ latlng,
          rotation: newLocalData.heading,
          infoWindow: InfoWindow(title: '$email pinged'),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData2));
    });
  }

  fetchCurrentUser() async {
    dynamic result = await context.read<Authenticate>().retrieveUsertype();

    if (result == null) {
      print('Unable to retrieve user type');
    } else {
      if (mounted) {
        currentUserType = result;
      }
    }
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.345345345,
                  target: LatLng(routeData['latitude'], routeData['longitude']),
                  tilt: 0,
                  zoom: 18)));
          updateMarkerAndCircle(newLocalData, imageData);
          usersMarkers.add(marker);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void getCommuterLocation() async {
    try {
      Uint8List imageData2 = await getMarker2();
      var location = await _locationTracker.getLocation();
      updateMarkerCommuter(location, imageData2);
      await FirebaseFirestore.instance.collection('users').doc(useruid).set({
        'latitude': location.latitude,
        'longitude': location.longitude,
      }, SetOptions(merge: true));
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      usersMarkers.add(marker2);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLat();
    fetchLong();
    fetchEmail();
    fetchCurrentUser();
  }

  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    //queueStatus.dispose();
    super.dispose();
  }

  fetchLat() async {
    dynamic results = await context.read<Authenticate>().getLat();

    if (results == null) {
      print('Unable to retrieve commuter info');
    } else {
      if (mounted) {
        setState(() {
          latitude = results;
        });
      }
    }
  }

  fetchLong() async {
    dynamic results = await context.read<Authenticate>().getLong();

    if (results == null) {
      print('Unable to retrieve commuter info');
    } else {
      if (mounted) {
        setState(() {
          longitude = results;
        });
      }
    }
  }

  fetchEmail() async {
    dynamic results = await context.read<Authenticate>().getEmail();

    if (results == null) {
      print('Unable to retrieve commuter info');
    } else {
      if (mounted) {
        setState(() {
          email = results;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => state
            ? showDialog<bool>(
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
                })
            : true,
        child: Scaffold(
            backgroundColor: state ? Colors.grey[200] : null,
            body: SingleChildScrollView(
                child: SafeArea(
                    child: Container(
              child: Column(
                children: <Widget>[
                  //Container(height: 50, child: TopBarMod()), //MAIN TOP BAR
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  state ? Colors.redAccent : Colors.yellow[700],
                              width: 2)),
                      height: 400.0,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                routeData['latitude'], routeData['longitude'])),
                        markers: Set.of(usersMarkers),
                        circles: Set.of((circle != null) ? [circle] : []),
                        onMapCreated: (GoogleMapController controller) async {
                          _controller = controller;
                          getCurrentLocation();
                          /*if (MyApp.ping == true) {
                            getCommuterLocation();
                          }*/
                        },
                      )),
                  Container(
                      child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child: state
                              ? Text('PINGING ...',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold))
                              : null),
                      Container(
                          child: state
                              ? Image.asset('assets/car_ride_tester.gif',
                                  height: 100)
                              : Image.asset(
                                  'assets/undraw_fast_car_p4cu-removebg-preview.png',
                                  height: 100)),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Column(children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    child: Row(
                                  children: <Widget>[
                                    Text("Status : ",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      "${routeData['vehicle_status']}",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                                Container(
                                    child: Row(children: <Widget>[
                                  Text(
                                    "Vehicle Plate Number: ",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${routeData['vehicle_plate_number']}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        decoration: TextDecoration.underline,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]))
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Seats availability : ",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "5/${routeData['seats_avail']}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.green,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ))
                                ]),
                            Row(children: <Widget>[
                              Container(
                                  child: Wrap(
                                      direction: Axis.vertical,
                                      children: <Widget>[
                                    Text(
                                      "ROUTE : ",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${routeData['route_path']}",
                                      style: TextStyle(
                                          color: Colors.green,
                                          decoration: TextDecoration.underline,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]))
                            ])
                          ])),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: state
                              ? Container(
                                  height: 50,
                                  width: 200,
                                  margin: EdgeInsets.all(10),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          cancelPing();
                                          context
                                              .read<Authenticate>()
                                              .clearPing();
                                          MyApp.ping = false;
                                          state = false;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.redAccent,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12), // <-- Radius
                                          ),
                                          side: BorderSide(
                                              color: Colors.redAccent)),
                                      child: Text('CANCEL NOW!')))
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                          if (currentUserType == "Driver") {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Driver can't ping"),
                                                    content: Text(
                                                        'This function is for commuters only'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('CLOSE'),
                                                      )
                                                    ],
                                                  );
                                                });
                                          } else if (currentUserType ==
                                              "Commuter") {
                                            setState(() {
                                              //savePing();
                                              getCommuterLocation();
                                              state = true;
                                              context
                                                  .read<Authenticate>()
                                                  .updatePing(routeData[
                                                      'vehicle_plate_number']);
                                              MyApp.ping = true;
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            onPrimary: Colors.yellow[700],
                                            side: BorderSide(
                                                color: Colors.yellow[700])),
                                        child: Text(
                                          "QUEUE NOW!",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReserveVehicle(
                                                          routeData)));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            onPrimary: Colors.yellow[700],
                                            primary: Colors.white,
                                            side: BorderSide(
                                                color: Colors.yellow[700])),
                                        child: Text("RESERVE NOW!",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)))
                                  ],
                                ))
                    ],
                  ))
                ],
              ),
            )))));
  }

  /*Future<void> savePing() async {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    try {
      final locate.LocationData currentLocation =
          await _locationTracker.getLocation();
      await FirebaseFirestore.instance.collection('users').doc(useruid).set({
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }*/

  /*getCoordinates() async {
    Uint8List imageData2 = await getMarker2();
    setState(() {
      usersMarkers.add(Marker(
          markerId: MarkerId(email),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: '$email pinged',
          ),
          icon: BitmapDescriptor.fromBytes(imageData2)));
    });
  }*/

  cancelPing() {
    Marker mark = usersMarkers
        .firstWhere((mark) => mark.markerId.value == email, orElse: () => null);
    setState(() {
      usersMarkers.remove(mark);
    });
  }
}
