import 'package:byahe_app/data/data.dart';
import 'package:byahe_app/pages/login_auth.dart';
import 'package:byahe_app/widgets/drawer/drawerheader.dart';
import 'package:byahe_app/widgets/drawer/drawerlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:byahe_app/widgets/topbarmod.dart';
import 'package:byahe_app/widgets/driver/navigationalcontainer.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter/painting.dart';

class Pending extends StatefulWidget {
  // const Pending({ Key? key }) : super(key: key);

  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  String pageName = 'Pending';
  List getPings = [];
  var driverPlate;
  var placeValue;

  @override
  initState() {
    super.initState();
    fetchDriverPlate();
    fetchPingList();
  }

  fetchDriverPlate() async {
    dynamic result = await context.read<Authenticate>().getPlate();
    if (result == null) {
      print('Unable to retreive email (pending.dart)');
    } else {
      setState(() {
        driverPlate = result;
      });
    }
  }

  fetchPingList() async {
    dynamic result = await context.read<Authenticate>().getPendingPingList();
    if (result == null) {
      print('Unable to retrieve ping list (pending.dart)');
    } else {
      setState(() {
        getPings = result;
      });
    }
  }

  Future<void> getAddressFromCoordinates(var latitude, var longitude) async {
    var currentLandMark;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    currentLandMark = '${place.street}, ${place.locality}';
    return currentLandMark;
  }

  @override
  Widget build(BuildContext context) {
    getPings.map((value) => placeValue =
        getAddressFromCoordinates(value['latitude'], value['longitude']));
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
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: RichText(
                text: TextSpan(
                    text: "Total Pending :",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                          text: pending.length.toString(),
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold)),
                    ]),
              )),
          Container(
              child: Column(
                  children: getPings
                      .map((value) => Container(
                          decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.grey,
                                    offset: Offset(3, 3)),
                              ]),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: (value['pinged_driver'] != null &&
                                  value['pinged_driver'] == driverPlate)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                      Row(children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Icon(
                                                Icons.account_circle_rounded)),
                                        Container(
                                          child: ListTile(
                                            title: Text(
                                              placeValue,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(value['email']),
                                          ),
                                        )
                                      ]),
                                      Row(children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: InkWell(
                                              child: Image.asset(
                                                'assets/check.png',
                                                width: 50,
                                              ),
                                              onTap: () {}),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: InkWell(
                                              child: Image.asset(
                                                'assets/reject.png',
                                                width: 50,
                                              ),
                                              onTap: () {}),
                                        )
                                      ])
                                    ])
                              : Row(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Center(
                                          child: Text('No Pending Pings',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ))
                                  ],
                                )))
                      .toList()))
        ])))));
  }
}
