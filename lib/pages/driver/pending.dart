import 'package:byahe_app/data/data.dart';
import 'package:byahe_app/pages/login_auth.dart';
import 'package:byahe_app/widgets/drawer/drawerheader.dart';
import 'package:byahe_app/widgets/drawer/drawerlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int seatCap;
  Stream<QuerySnapshot> pendingpings;
  int current_occupied;
  String useruid = FirebaseAuth.instance.currentUser.uid;

  @override
  initState() {
    super.initState();
    fetchDriverPlate();
    fetchPingList();
    fetchCurrentOccupied();
    fetchGetSeatCapacity();
  }

  fetchDriverPlate() async {
    dynamic result = await context.read<Authenticate>().getPlate();
    if (result == null) {
      print('Unable to retreive email (pending.dart)');
    } else {
      if (mounted) {
        setState(() {
          driverPlate = result;
        });
      }
    }
  }

  fetchGetSeatCapacity() async {
    dynamic result = await context.read<Authenticate>().getSeatCapacity();
    if (result == null) {
      print('Unable to retreive seat capacity(pending.dart)');
    } else {
      if (mounted) {
        setState(() {
          seatCap = result;
        });
      }
    }
  }

  fetchCurrentOccupied() async {
    dynamic result = await context.read<Authenticate>().getOccupied();
    if (result == null) {
      print('Unable to retreive current occupied (pending.dart)');
    } else {
      if (mounted) {
        setState(() {
          current_occupied = result;
        });
      }
    }
  }

  fetchPingList() async {
    dynamic result = await context.read<Authenticate>().getPendingPingList();
    if (result == null) {
      print('Unable to retrieve ping list (pending.dart)');
    } else {
      setState(() {
        getPings = result;
        print(getPings);
      });
    }
  }

  /*Future getAddressFromCoordinates(var latitude, var longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    setState(() {
      placeValue = '${place.street}, ${place.locality}';
    });
  }*/

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
          Container(
            child: Text(
              this.pageName.toUpperCase(),
              style: TextStyle(color: Colors.yellowAccent[700], fontSize: 30),
            ),
          ),
          NavigationalContainer(this.pageName),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: InkWell(
                onTap: () {
                  if (current_occupied <= seatCap) {
                    setState(() {
                      current_occupied++;
                    });
                    context
                        .read<Authenticate>()
                        .updateOccupied(current_occupied);
                  } else if (current_occupied > seatCap) {
                    context.read<Authenticate>().updateOccupied(seatCap);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Onboard Already At Max Capacity"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('CLOSE'),
                              )
                            ],
                          );
                        });
                  }
                },
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.yellow[700],
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Text(
                      'Load Anonymous+',
                      style: TextStyle(color: Colors.white),
                    ))),
          ),
          Container(
              child: StreamBuilder(
                  stream: pendingpings = FirebaseFirestore.instance
                      .collection('users')
                      .where('pinged_driver', isEqualTo: useruid)
                      .where('user_type', isEqualTo: "Commuter")
                      .where('ping_status', isEqualTo: "Pending")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                          child:
                              Center(child: Text('Failed to Retreive Info')));
                    }
                    if (snapshot.hasData == false) {
                      return Container(
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Center(child: CircularProgressIndicator()));
                    }
                    return Column(
                      children: snapshot.data.docs
                          .map((commuter) => Container(
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
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Icon(
                                              Icons.account_circle_rounded)),
                                      Column(
                                        children: [
                                          Container(
                                            child: (commuter[
                                                        'place_in_words'] !=
                                                    null)
                                                ? Text(
                                                    commuter['place_in_words'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  )
                                                : Text('Fetching Location...',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12)),
                                          ),
                                          Container(
                                            child: (commuter['full_name'] !=
                                                    null)
                                                ? Text(commuter['full_name'],
                                                    style:
                                                        TextStyle(fontSize: 10))
                                                : Text("Fetching Name...",
                                                    style: TextStyle(
                                                        fontSize: 10)),
                                          ),
                                        ],
                                      )
                                    ]),
                                    Row(children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          var ping_status;
                                          ping_status = 'Onboard';
                                          context
                                              .read<Authenticate>()
                                              .pingResponse(
                                                  commuter['uid'], ping_status);
                                          setState(() {
                                            current_occupied++;
                                          });
                                          context
                                              .read<Authenticate>()
                                              .updateOccupied(current_occupied);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Image.asset(
                                            'assets/check.png',
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          var ping_status;
                                          ping_status = "Rejected";
                                          context
                                              .read<Authenticate>()
                                              .pingResponse(
                                                  commuter['uid'], ping_status);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Image.asset(
                                            'assets/reject.png',
                                            width: 50,
                                          ),
                                        ),
                                      )
                                    ])
                                  ])))
                          .toList(),
                    );
                  }))
        ])))));
  }
}


/*Column(
                  children:Container(
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
                          child: (/*value['pinged_driver'] != null &&*/
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
                                            title: //(placeValue != null)
                                                /*? Text(
                                                    placeValue,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                :*/
                                                Text('Fetching data'),
                                            subtitle: (value['email'] != null)
                                                ? Text(value['email'])
                                                : Text('Fetching data'),
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
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Center(
                                    child: Text('No Pending Pings',
                                        style: TextStyle(color: Colors.grey)),
                                  )))
                      .toList())*/