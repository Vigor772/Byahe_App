//import 'package:byahe_app/pages/commuter/locationselection.dart';
import 'package:byahe_app/pages/login_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:byahe_app/widgets/topbarmod.dart';
import 'package:byahe_app/widgets/commuter/percentindicator.dart';
import 'package:byahe_app/pages/commuter/map.dart';
import 'package:flutter/rendering.dart';
import 'package:byahe_app/data/data.dart';
import 'package:provider/src/provider.dart';

class RouteSelection extends StatefulWidget {
  /*const RouteSelection(locationList, {Key key, @required this.locationLists})
      : super(key: key);*/
  var locationLists;
  RouteSelection(this.locationLists);
  //RouteSelection(locationList, {locationLists});
  @override
  _RouteSelectionState createState() =>
      _RouteSelectionState(this.locationLists);
}

class _RouteSelectionState extends State<RouteSelection> {
  List routeListDetails = [];
  var locationLists;
  _RouteSelectionState(this.locationLists);
  @override
  void initState() {
    fetchRouteList();
    super.initState();
  }

  fetchRouteList() async {
    dynamic results = await context.read<Authenticate>().getRouteListDetails();

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

  /*_RouteSelectionState() {
    locationRoute
      ..sort((route1, route2) {
        int status1 = route1['status'];
        int status2 = route2['status'];
        return status1.compareTo(status2);
      });
  }*/

  void resetQueued() {
    setState(() {
      locationRoute.map((route) {
        return route['queue'] = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              TopBarMod(),
              Container(
                  padding: EdgeInsets.all(15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Trip to $locationLists",
                        style:
                            TextStyle(fontSize: 20, color: Colors.yellow[700])),
                  )),
              Container(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: routeListDetails.length,
                      // ignore: missing_return
                      itemBuilder: (context, index) {
                        if (locationLists ==
                            routeListDetails[index]['jeepney_line']) {
                          return Card(
                              color: Colors.yellow[700],
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Map(routeListDetails)));
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
                        }
                      }))
            ],
          ),
        ),
      ),
    ));
  }
}



/*Column(
                    children: locationRoute
                        .map((route) => InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Map(route)));
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.yellow[700],
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "• " + route['route'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                          child: PercentIndicator(
                                              route['status'])),
                                    ]),
                                    Container(
                                      child: Icon(Icons.place,
                                          color: Colors.white),
                                    )
                                  ],
                                ))))
                        .toList()),*/
