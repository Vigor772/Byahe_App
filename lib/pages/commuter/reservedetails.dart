import 'package:byahe_app/widgets/drawer/drawerheader.dart';
import 'package:byahe_app/widgets/drawer/drawerlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byahe_app/pages/login_auth.dart';

import '../login_auth.dart';

class ReserveDetails extends StatefulWidget {
  @override
  _ReserveDetailsState createState() => _ReserveDetailsState();
}

class _ReserveDetailsState extends State<ReserveDetails> {
  var bookingDetails = [];
  var name;

  @override
  initState() {
    super.initState();
    fetchCommuterName();
    fetchBookingDetails();
  }

  fetchCommuterName() async {
    dynamic result = await context.read<Authenticate>().retrieveName();
    if (result == null) {
      print('Unable to retrieve commuter name (reservedetails.dart');
    } else {
      if (mounted) {
        setState(() {
          name = result;
        });
      }
    }
  }

  fetchBookingDetails() async {
    dynamic result = await context.read<Authenticate>().displayBookings();
    if (result == null) {
      print('Unable to retrieve booking details (reserverdetails.dart)');
    } else {
      if (mounted) {
        setState(() {
          bookingDetails = result;
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
                    child: Column(children: <Widget>[
          Container(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("YOUR RESERVE/BOOKING",
                    style: TextStyle(color: Colors.yellow[700])),
              )),
          Container(
              child: Column(
                  children: bookingDetails
                      .map((info) => InkWell(
                          child: (info['customer_name'] == name &&
                                  info['customer_name'] != null)
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
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Text(
                                                "Status: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(info['status'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Colors.yellow)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Driver Name: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(info['driver_name'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Jeepney Plate No: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(info['plate_reference'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Customer's Name: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(info['customer_name'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Gender: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(info['gender'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Specified No. of Passengers: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(info['number_of_passengers'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Contact No: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(info['contact_number'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Customer Address: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(info['address'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Date of Reservation: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(info['date_to_reserve'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          Container(
                                            alignment: Alignment.bottomCenter,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.yellow[700],
                                                    minimumSize: Size(80, 35)),
                                                onPressed: () {},
                                                child: Text('Cancel Request')),
                                          )
                                        ]),
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
