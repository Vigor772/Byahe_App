import 'package:byahe_app/pages/driver/pending.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:byahe_app/widgets/topbarmod.dart';
import 'package:byahe_app/widgets/driver/navigationalcontainer.dart';
import 'package:byahe_app/data/data.dart';

class Onboard extends StatefulWidget {
  // const Onboard({ Key? key }) : super(key: key);

  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int jeepcapacity = 12;

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

  String pageName = 'Onboard';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
                child: Container(
                    child: Column(children: <Widget>[
      Container(height: 50, child: TopBarMod()),
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
            commuterinfo.length.toString() + '/' + this.jeepcapacity.toString(),
            style: TextStyle(
                color: checkVacant(commuterinfo.length),
                fontWeight: FontWeight.bold)),
      ),
      Container(
          child: Column(
        children: commuterinfo
            .map((commuter) => Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          color: Colors.grey,
                          offset: Offset(3, 3)),
                    ]),
                padding: EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage('assets/salac.jpg'),
                            )),
                        Container(
                          child: Text(
                            'ID: ' + commuter['commuter_id'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ]),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          'assets/remove.png',
                          width: 50,
                        ),
                      )
                    ])))
            .toList(),
      ))
    ])))));
  }
}
