import 'package:byahe_app/pages/commuter/routeselection.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:byahe_app/widgets/drawer/drawerheader.dart';
import 'package:byahe_app/widgets/drawer/drawerlist.dart';
import 'package:flutter/material.dart';
import 'package:byahe_app/widgets/topbarmod.dart';
import 'package:byahe_app/pages/login_auth.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class LocationSelection extends StatefulWidget {
  //const LocationSelection({ Key key }) : super(key: key);

  @override
  _LocationSelectionState createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  final myController = TextEditingController();
  List locationList = [];

  @override
  void initState() {
    fetchLocationList();
    super.initState();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  fetchLocationList() async {
    dynamic results = await context.read<Authenticate>().getLocationList();

    if (results == null) {
      print('Unable to retrieve data');
    } else {
      setState(() {
        locationList = results;
      });
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
          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     onPressed: () {
          //       // handle the press
          //     },
          //   ),
          // ],
          title: Text('Byahe App',
              style: TextStyle(
                  color: Colors.yellow[700], fontWeight: FontWeight.bold)),
        ),
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
          child: Column(
            children: <Widget>[
              //Container(height: 50, child: TopBarMod()), //MAIN TOP BAR
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow[700])),
                        suffixIcon: InkWell(
                            child: Icon(
                          Icons.search,
                          color: Colors.yellow[700],
                        )),
                        hintText: ('Search here ...'),
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
              Container(
                  //color: Colors.yellow[700],
                  padding: EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: locationList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            color: Colors.yellow[700],
                            child: ListTile(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RouteSelection(
                                            locationList[index]['jeep_line'])));
                              },
                              title: Text(locationList[index]['jeep_line'],
                                  style: TextStyle(color: Colors.white)),
                              subtitle: Text(locationList[index]['location_id'],
                                  style: TextStyle(color: Colors.white)),
                            ));
                      }))
            ],
          ),
        ))));
  }

  /*Column(
                children: locationList
                    // ignore: non_constant_identifier_names
                    .map((location_id) => Container(
                        color: Colors.yellow[700],
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                            onTap: () {
                              // Navigator.pushNamed(context, '/routeselection');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RouteSelection()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text(location_id['jeep_line'],
                                      style: TextStyle(color: Colors.white)),
                                ),
                                /*Container(
                        child: locationStatusLayout(
                          location['status']),
                  )*/
                              ],
                            ))))
                    .toList()),*/
}
