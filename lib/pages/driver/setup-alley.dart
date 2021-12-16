import 'dart:async';
import 'package:byahe_app/data/data.dart';
import 'package:byahe_app/main.dart';
import 'package:byahe_app/pages/driver/setup-check.dart';
import 'package:byahe_app/widgets/drawer/drawerheader.dart';
import 'package:byahe_app/widgets/drawer/drawerlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:byahe_app/widgets/topbarmod.dart';
import 'package:byahe_app/widgets/driver/navigationalcontainer.dart';
import 'package:byahe_app/pages/login_auth.dart';
import 'package:provider/src/provider.dart';
import 'package:location/location.dart' as locate;
import 'package:permission_handler/permission_handler.dart';

class SetupAlley extends StatefulWidget {
  // const SetupAlley({ Key? key }) : super(key: key);

  @override
  _SetupAlleyState createState() => _SetupAlleyState();
}

class _SetupAlleyState extends State<SetupAlley> {
  String pageName = 'Set-up';
  //String groupname = 'MODA JEEP ORG';
  //String myPlatenumber = 'KMJS 000';
  String status;
  String driverPath;
  String driverPlate;
  bool vehicleStatus;
  var alleyList = [];
  final locate.Location location = locate.Location();
  StreamSubscription<locate.LocationData> _locationSubscription;

  @override
  void initState() {
    super.initState();
    requestForPerms();
    fetchPath();
    fetchAlleyList();
    fetchPlateNum();
    fetchVehicleStatus();
    location.changeSettings(
        interval: 300, accuracy: locate.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  fetchPath() async {
    dynamic result = await context.read<Authenticate>().getDriverRoutePath();
    if (result == null) {
      print('Unable to retrieve driver path (setup-alley.dart)');
    } else {
      if (mounted) {
        setState(() {
          driverPath = result;
        });
      }
    }
  }

  fetchPlateNum() async {
    dynamic result = await context.read<Authenticate>().getPlate();
    if (result == null) {
      print('Unable to retrieve driver plate number (setup-alley.dart)');
    } else {
      if (mounted) {
        setState(() {
          driverPlate = result;
        });
      }
    }
  }

  fetchVehicleStatus() async {
    dynamic result = await context.read<Authenticate>().retrieveVehicleStatus();
    if (result == null) {
      print('Unable to retreive vehicle_status (setup-alley.dart)');
    } else {
      if (mounted) {
        setState(() {
          vehicleStatus = result;
        });
      }
    }
  }

  fetchAlleyList() async {
    dynamic result = await context.read<Authenticate>().getAlleyList();
    if (result == null) {
      print('Unable to retrieve driver alley list (setup-alley.dart');
    } else {
      if (mounted) {
        setState(() {
          alleyList = result;
        });
      }
    }
  }

  Container alleyFunction() {
    if (MyApp.alley == false) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.yellow[700]),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Text('ALLEY NOW !', style: TextStyle(color: Colors.yellow[700])),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.redAccent),
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Text('CANCEL NOW!', style: TextStyle(color: Colors.white)),
      );
    }
  }

  Future<void> getLiveLocation() async {
    String useruid = FirebaseAuth.instance.currentUser.uid;
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError.toString());
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((locate.LocationData currentLocation) async {
      await FirebaseFirestore.instance.collection('users').doc(useruid).set({
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
      }, SetOptions(merge: true));
    });
  }

  stopLiveLocation() async {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  requestForPerms() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('Request granted');
    } else if (status.isDenied) {
      requestForPerms();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  broadcastLocation() {
    if (MyApp.broadcast == false) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.yellow[700]),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: <Widget>[
            Container(
              child: Icon(Icons.place),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('BROADCAST',
                  style: TextStyle(color: Colors.yellow[700])),
            )
          ],
        ),
      );
    } else if (MyApp.broadcast == true) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.redAccent),
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: <Widget>[
            Container(
              child: Icon(Icons.place),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('STOP', style: TextStyle(color: Colors.yellow[700])),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            bottomOpacity: 0.0,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.yellow[700]),
            title: Text('Byahe App',
                style: TextStyle(
                    color: Colors.yellow[700], fontWeight: FontWeight.bold))),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [DrawerHead(), DrawerList()],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: SafeArea(
                child: Container(
                    child: Column(children: <Widget>[
          //Container(height: 50, child: TopBarMod()),
          Container(
            child: Text(
              this.pageName.toUpperCase(),
              style: TextStyle(color: Colors.yellowAccent[700], fontSize: 30),
            ),
          ),
          NavigationalContainer(this.pageName),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    width: 180,
                    height: 70,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SetupAlley()));
                        },
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Colors.yellow[700],
                        ),
                        child: Text("Alley",
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    width: 180,
                    height: 70,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SetupCheck()));
                        },
                        style: ElevatedButton.styleFrom(
                            onPrimary: Colors.yellow[700],
                            primary: Colors.white),
                        child: Text("Check drivers",
                            style: TextStyle(fontWeight: FontWeight.bold))))
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          if (MyApp.broadcast == true) {
                            context.read<Authenticate>().updateBroadCast(false);
                            stopLiveLocation();
                            MyApp.broadcast = false;
                          } else if (MyApp.broadcast == false) {
                            MyApp.broadcast = true;
                            context.read<Authenticate>().updateBroadCast(true);
                            getLiveLocation();
                          }
                          /*setState(() {
                        MyApp.broadcast = !MyApp.broadcast;
                      });*/
                        },
                        child: broadcastLocation()),
                    InkWell(
                        onTap: () {
                          if (MyApp.alley == true) {
                            /*for (var map in alleyList) {
                              if (map['vehicle_plate_number'] == driverPlate) {
                                alleyList.remove(map);
                                context
                                    .read<Authenticate>()
                                    .updateVehicleStatus(status = 'DRIVING');
                                break;
                              }
                            }*/
                            context
                                .read<Authenticate>()
                                .updateVehicleStatus(status = 'DRIVING');
                          } else {
                            /*alleyList
                                .add({'vehicle_plate_number': driverPlate});*/
                            context
                                .read<Authenticate>()
                                .updateVehicleStatus(status = 'ALLEY');
                          }
                          setState(() {
                            MyApp.alley = !MyApp.alley;
                          });
                        },
                        child: alleyFunction())
                  ])),
          Container(
              child: Text("$driverPath Alley",
                  style: TextStyle(color: Colors.grey))),
          Container(
              child: Column(
                  children: alleyList
                      .map(
                        (jeep) => (jeep['route_path'] == driverPath &&
                                jeep['vehicle_status'] == "ALLEY")
                            ? Container(
                                decoration: BoxDecoration(
                                    color: driverPlate ==
                                            jeep['vehicle_plate_number']
                                        ? Colors.yellowAccent[700]
                                        : Colors.yellow[700],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          color: Colors.grey,
                                          offset: Offset(3, 3)),
                                    ]),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Container(
                                          child: Text(
                                            jeep['vehicle_plate_number'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            ' Driver: ${jeep["last_name"]}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ]),
                                      Container(
                                        child: Icon(Icons.more_horiz),
                                      )
                                    ]))
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 1),
                              ),
                      )
                      .toList()))
        ])))));
  }
}
