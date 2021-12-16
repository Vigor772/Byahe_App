import 'package:byahe_app/pages/login_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:byahe_app/widgets/drawer/drawerheader.dart';
import 'package:byahe_app/widgets/drawer/drawerlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:byahe_app/widgets/topbarmod.dart';
import 'package:byahe_app/pages/commuter/map.dart';
import 'package:flutter/rendering.dart';
import 'package:location/location.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

// ignore: must_be_immutable
class RouteSelection extends StatefulWidget {
  var locationLists;
  RouteSelection(this.locationLists);
  @override
  _RouteSelectionState createState() =>
      _RouteSelectionState(this.locationLists);
}

class _RouteSelectionState extends State<RouteSelection> {
  List routeListDetails = [];
  var locationLists;
  var email;
  var userType;
  Location _locationTracker = Location();
  _RouteSelectionState(this.locationLists);
  @override
  void initState() {
    fetchRouteList();
    fetchEmail();
    fetchUserType();
    super.initState();
  }

  fetchUserType() async {
    dynamic result = await context.read<Authenticate>().retrieveUsertype();

    if (result == null) {
      print('Unable to retrieve usertype (routeselection.dart');
    } else {
      if (mounted) {
        setState(() {
          userType = result;
        });
      }
    }
  }

  fetchRouteList() async {
    dynamic results =
        await context.read<Authenticate>().getRouteListDetails(locationLists);

    if (results == null) {
      print("Can't retrieve data");
    } else {
      if (mounted) {
        setState(() {
          routeListDetails = results;
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
        )),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Trip to $locationLists",
                            style: TextStyle(
                                fontSize: 20, color: Colors.yellow[700])),
                      )),
                  Container(
                    child: new ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: routeListDetails.length,
                        itemBuilder: (context, index) {
                          return new Card(
                              color: Colors.yellow[700],
                              child: new ListTile(
                                onTap: () async {
                                  if (routeListDetails[index]['status'] ==
                                      'OFFLINE') {
                                    return showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text("Can't retrieve location"),
                                            content: Text('User Offline'),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                  child: Text("CLOSE"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  })
                                            ],
                                          );
                                        });
                                  }
                                  if (routeListDetails[index]['broadcast'] ==
                                      false) {
                                    return showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("User is online"),
                                            content: Text(
                                                'But live location is turned off'),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                  child: Text("CLOSE"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  })
                                            ],
                                          );
                                        });
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Map(routeListDetails[index])));
                                },
                                title: Text(
                                    routeListDetails[index]['jeepney_route'],
                                    style: TextStyle(color: Colors.white)),
                                subtitle: Text(
                                    routeListDetails[index]['last_name'],
                                    style: TextStyle(color: Colors.white)),
                                leading: Icon(Icons.place, color: Colors.white),
                                trailing: Text(
                                    routeListDetails[index]['status'],
                                    style: TextStyle(color: Colors.white)),
                              ));
                        }),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
