import 'package:byahe_app/pages/driver/pending.dart';
import 'package:byahe_app/pages/login_auth.dart';
import 'package:byahe_app/widgets/drawer/drawerheader.dart';
import 'package:byahe_app/widgets/drawer/drawerlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:byahe_app/widgets/topbarmod.dart';
import 'package:byahe_app/widgets/driver/navigationalcontainer.dart';
import 'package:byahe_app/data/data.dart';
import 'package:provider/src/provider.dart';

class Onboard extends StatefulWidget {
  // const Onboard({ Key? key }) : super(key: key);

  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int jeepcapacity = 12;
  var driverPlate;
  List getPingsOnboard = [];

  // ignore: missing_return
  Color checkVacant(int occupy) {
    double low = jeepcapacity * 0.5;
    double mid = jeepcapacity * 0.8;
    int high = jeepcapacity * 1;
    if (occupy <= low) {
      return Colors.greenAccent;
    } else if (occupy <= mid && occupy > low) {
      return Colors.yellow[700];
    } else if (occupy > mid && occupy <= high) {
      return Colors.redAccent;
    }
  }

  @override
  initState() {
    super.initState();
    fetchDriverPlate();
    fetchOnboardPing();
  }

  fetchOnboardPing() async {
    dynamic result = await context.read<Authenticate>().getAcceptedPingList();
    if (result == null) {
      print('Unable to get Onboard Ping (onboard.dart)');
    } else {
      if (mounted) {
        setState(() {
          getPingsOnboard = result;
        });
      }
    }
  }

  fetchDriverPlate() async {
    dynamic result = await context.read<Authenticate>().getPlate();
    if (result == null) {
      print('Unable to get driver plate (onboard.dart)');
    } else {
      if (mounted) {
        setState(() {
          driverPlate = result;
        });
      }
    }
  }

  String pageName = 'Onboard';
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
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Text(
                commuterinfo.length.toString() +
                    '/' +
                    this.jeepcapacity.toString(),
                style: TextStyle(
                    color: checkVacant(commuterinfo.length),
                    fontWeight: FontWeight.bold)),
          ),
          Container(
              child: Column(
            children: getPingsOnboard
                .map(
                  (commuter) => (commuter['pinged_driver'] == driverPlate)
                      ? Container(
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
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child:
                                          Icon(Icons.account_circle_outlined)),
                                  Container(
                                    child: (commuter['full_name'] != null)
                                        ? Text(
                                            'Commuter: ' +
                                                commuter['full_name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text('Fetching Name...',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                  )
                                ]),
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<Authenticate>()
                                        .resetPing(commuter['uid']);
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Image.asset(
                                      'assets/remove.png',
                                      width: 50,
                                    ),
                                  ),
                                )
                              ]))
                      : Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                        ),
                )
                .toList(),
          ))
        ])))));
  }
}
