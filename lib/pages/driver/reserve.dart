import 'dart:ui';
import 'package:byahe_app/pages/login_auth.dart';
import 'package:byahe_app/widgets/drawer/drawerheader.dart';
import 'package:byahe_app/widgets/drawer/drawerlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:byahe_app/widgets/topbarmod.dart';
import 'package:byahe_app/widgets/driver/navigationalcontainer.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class Reserve extends StatefulWidget {
  // const Reserve({ Key? key }) : super(key: key);

  @override
  _ReserveState createState() => _ReserveState();
}

class _ReserveState extends State<Reserve> {
  String pageName = 'Reserve';
  String platenum;
  var bookings = [];
  var drivername;
  bool accepted = false;
  bool rejected = false;

  @override
  void initState() {
    super.initState();
    fetchDriverPlate();
    fetchBookingDriver();
    fetchDriverName();
  }

  fetchDriverPlate() async {
    dynamic result = await context.read<Authenticate>().getPlate();
    if (result == null) {
      print('Unable to retrieve plate number(reserve.dart) panel');
    } else {
      if (mounted) {
        setState(() {
          platenum = result;
          print(platenum);
        });
      }
    }
  }

  fetchBookingDriver() async {
    dynamic result = await context.read<Authenticate>().displayBookings();

    if (result == null) {
      print('Unable to retrieve booking list for driver (reserve.dart)');
    } else {
      if (mounted) {
        setState(() {
          bookings = result;
          print(bookings);
        });
      }
    }
  }

  fetchDriverName() async {
    dynamic result = await context.read<Authenticate>().retrieveName();
    if (result == null) {
      print('Unable to retreive drivername(reserve.dart');
    } else {
      if (mounted) {
        setState(() {
          drivername = result;
          print('Retreived driver name: $drivername reserve.dart');
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
              child: Column(
                  children: bookings
                      .map((info) => InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Stack(
                                      //clipBehavior: Clip.hardEdge,
                                      children: [
                                        Center(
                                            child: Column(
                                          children: [
                                            Image.asset(
                                                'assets/undraw_off_road_9oae-removebg-preview.png'),
                                            Text('Plate Number Reference: ',
                                                style: TextStyle(fontSize: 16)),
                                            Text(info['plate_reference'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            Text('Customer Name: ',
                                                style: TextStyle(fontSize: 16)),
                                            Text(info['customer_name'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            Text('Gender: ',
                                                style: TextStyle(fontSize: 16)),
                                            Text(info['gender'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            Text('Address: ',
                                                style: TextStyle(fontSize: 16)),
                                            Text(info['address'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            Text('Contact Number: ',
                                                style: TextStyle(fontSize: 16)),
                                            Text(info['contact_number'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            Text('Number of Passengers: ',
                                                style: TextStyle(fontSize: 16)),
                                            Text(info['number_of_passengers'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            Text('Reservation Date: ',
                                                style: TextStyle(fontSize: 16)),
                                            Text(info['date_to_reserve'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.yellow[700],
                                                    minimumSize: Size(80, 35)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('BACK'))
                                          ],
                                        ))
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: (info['plate_reference'] == platenum &&
                                  info['plate_reference'] != null)
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      border: Border.all(
                                          width: 2, color: Colors.yellow[700]),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            color: Colors.grey,
                                            offset: Offset(3, 3)),
                                      ]),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Column(children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Icon(Icons
                                                  .account_circle_rounded)),
                                          Container(
                                            child: Text(
                                              info['customer_name'] +
                                                  ' ' +
                                                  info['date_to_reserve'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              child: Row(children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                var fnamePlate;
                                                var response = 'Accepted';
                                                fnamePlate =
                                                    info['customer_name'] +
                                                        info['plate_reference'];
                                                context
                                                    .read<Authenticate>()
                                                    .respondBooking(
                                                        fnamePlate, response);
                                                setState(() {
                                                  accepted = true;
                                                  rejected = false;
                                                });
                                              },
                                              child: (accepted == false)
                                                  ? Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      2),
                                                          child: Image.asset(
                                                            'assets/check.png',
                                                            width: 35,
                                                          ),
                                                        ),
                                                        Text('Accept',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 10)),
                                                      ],
                                                    )
                                                  : Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Text('Accepted',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 10))),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                var fnamePlate;
                                                var response = 'Rejected';
                                                fnamePlate =
                                                    info['customer_name'] +
                                                        info['plate_reference'];
                                                context
                                                    .read<Authenticate>()
                                                    .respondBooking(
                                                        fnamePlate, response);
                                                setState(() {
                                                  rejected = true;
                                                  accepted = false;
                                                });
                                              },
                                              child: (rejected == false)
                                                  ? Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      2),
                                                          child: Image.asset(
                                                            'assets/reject.png',
                                                            width: 35,
                                                          ),
                                                        ),
                                                        Text('Reject',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 10)),
                                                      ],
                                                    )
                                                  : Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Text(
                                                        'Rejected',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                            )
                                          ]))
                                        ]),
                                    Container(
                                        alignment: Alignment.bottomCenter,
                                        child: Text('Tap to view details',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w200,
                                                fontSize: 10)))
                                  ]))
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Center(
                                      /*child: Text('No Bookings Received',
                                        style: TextStyle(color: Colors.grey)),*/
                                      ))))
                      .toList()))
        ])))));
  }
}
