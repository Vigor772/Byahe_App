import 'package:byahe_app/pages/commuter/routeselection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        print(locationList);
      });
    }
  }

  // ignore: missing_return
  Widget locationStatusLayout(String status) {
    switch (status) {
      case "LOW":
        {
          return Text(
            "• LOW",
            style: TextStyle(color: Colors.yellow[400]),
          );
        }
        break;

      case "MEDIUM":
        {
          return Text(
            "• MEDIUM",
            style: TextStyle(color: Colors.green[400]),
          );
        }
        break;

      case "HIGH":
        {
          return Text(
            "• HIGH",
            style: TextStyle(color: Colors.red[400]),
          );
        }
        break;
    }
  }

  var locationStatus = [
    {'location': 'Gusa', 'status': 'HIGH'},
    {'location': 'Cugman', 'status': 'LOW'},
    {'location': 'Lapasan', 'status': 'MEDIUM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
                child: Container(
      child: Column(
        children: <Widget>[
          Container(height: 50, child: TopBarMod()), //MAIN TOP BAR
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
                            Navigator.push(
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
