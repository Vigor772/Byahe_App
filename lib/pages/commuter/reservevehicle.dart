import 'package:byahe_app/pages/login_auth.dart';
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
  var genders = ['Male', 'Female'];
  _ReserveVehicleState(this.routeData);
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController numpass = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
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
                      controller: lname,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700])),
                          labelText: 'Last name',
                          border: OutlineInputBorder()),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: fname,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow[700])),
                          labelText: "First name",
                          border: OutlineInputBorder()),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: gender,
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
                      controller: address,
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
                      controller: number,
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
                      controller: numpass,
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
                      controller: dateCtl,
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
                        dateCtl.text = date.toIso8601String().split('T')[0];
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
                var fnameControl = fname.text.trim();
                var lnameControl = lname.text.trim();
                var genderControl = gender.text.trim();
                var addControl = address.text.trim();
                var contactControl = number.text.trim();
                var numpassControl = numpass.text.trim();
                var dateControl = dateCtl.text.trim();

                if (fnameControl.isEmpty ||
                    lnameControl.isEmpty ||
                    genderControl.isEmpty ||
                    addControl.isEmpty ||
                    contactControl.isEmpty ||
                    numpassControl.isEmpty ||
                    dateControl.isEmpty) {
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
                } else {
                  context.read<Authenticate>().bookings(
                      routeData['vehicle_plate'],
                      fname,
                      lname,
                      gender,
                      address,
                      number,
                      numpass,
                      dateCtl);
                  showDialog(
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
                Navigator.pop(context);
              },
              child: Text("CONFIRM")),
        )
      ]),
    ))));
  }
}
