import 'package:byahe_app/pages/login_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:byahe_app/widgets/topbarmod.dart';
import 'package:byahe_app/data/data.dart';
import 'package:provider/src/provider.dart';

// ignore: must_be_immutable
class ReserveVehicle extends StatefulWidget {
  // const ReserveVehicle({ Key? key }) : super(key: key);
  var routeData;
  ReserveVehicle(this.routeData);

  @override
  _ReserveVehicleState createState() => _ReserveVehicleState(this.routeData);
}

class _ReserveVehicleState extends State<ReserveVehicle> {
  var routeData;
  _ReserveVehicleState(this.routeData);
  TextEditingController fnameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController numpassController = TextEditingController();
  TextEditingController dateCtlController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
                child: Container(
      child: Column(children: <Widget>[
        Container(height: 50, child: TopBarMod()),
        Container(
            padding: EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("RESERVE/BOOKING",
                  style: TextStyle(color: Colors.yellow[700])),
            )),
        Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.yellow[700]))),
            padding: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(routeData['route_path'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[800])),
              ),
              Container(
                child: Row(children: <Widget>[
                  Text("Driver's name : "),
                  Text(routeData['first_name'] + routeData['last_name'])
                ]),
              ),
              Container(
                child: Row(children: <Widget>[
                  Text("Jeepney Line : "),
                  Text(routeData['jeepney_line'])
                ]),
              ),
              /*Container(
                child: Row(children: <Widget>[
                  Text("License number : "),
                  Text("${driverInfo[1]['license_number']}")
                ]),
              ),*/
              Container(
                child: Row(children: <Widget>[
                  Text("Vehicle Plate Number : "),
                  Text(routeData['vehicle_plate_number'])
                ]),
              ),
              Container(
                child: Row(children: <Widget>[
                  Text("Contact Number : "),
                  Text(routeData['mobile_number'])
                ]),
              ),
            ])),
        Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.yellow[700]))),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              child: Column(children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: fnameController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700])),
                          labelText: 'Fullname',
                          border: OutlineInputBorder()),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: genderController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700])),
                          labelText: "Gender",
                          border: OutlineInputBorder()),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700])),
                          labelText: "Address",
                          border: OutlineInputBorder()),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: numberController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700])),
                          labelText: "Contact number",
                          border: OutlineInputBorder()),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: numpassController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700])),
                          labelText: "Number of Passengers",
                          border: OutlineInputBorder()),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: dateCtlController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_today_sharp),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow[700])),
                        border: OutlineInputBorder(),
                        labelText: "Desired Reservation Date",
                      ),
                      onTap: () async {
                        DateTime date = DateTime(1900);
                        FocusScope.of(context).requestFocus(new FocusNode());

                        date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));

                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                        dateCtlController.text =
                            date.toIso8601String().split('T')[0];
                      },
                    )),
              ]),
            )),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.yellow[700], minimumSize: Size(200, 50)),
              onPressed: () {
                var fname = fnameController.text.trim();
                var gender = genderController.text.trim();
                var address = addressController.text.trim();
                var number = numberController.text.trim();
                var numpass = numpassController.text.trim();
                var date = dateCtlController.text.trim();

                if (fname.isEmpty |
                    gender.isEmpty |
                    address.isEmpty |
                    number.isEmpty |
                    numpass.isEmpty |
                    date.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Complete the fields to proceed"),
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
                } else if (!(fname.isEmpty |
                    gender.isEmpty |
                    address.isEmpty |
                    number.isEmpty |
                    numpass.isEmpty |
                    date.isEmpty)) {
                  var vehicle_plate = routeData['vehicle_plate_number'];
                  var status = 'Pending';
                  context.read<Authenticate>().bookings().then((value) async {
                    User user = FirebaseAuth.instance.currentUser;
                    await FirebaseFirestore.instance
                        .collection('bookings')
                        .doc(user.uid)
                        .set({
                      'status': status,
                      'plate_reference': vehicle_plate,
                      "customer name": fname,
                      'gender': gender,
                      'address': address,
                      'contact_number': number,
                      'number_of_passengers': numpass,
                      'date_to_reserve': date,
                    });
                  });
                  fnameController.clear();
                  genderController.clear();
                  numberController.clear();
                  numpassController.clear();
                  dateCtlController.clear();
                  addressController.clear();
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Booking Request Submitted"),
                          content: Text("Wait for the driver's response"),
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
              child: Text("CONFIRM")),
        )
      ]),
    ))));
  }
}
