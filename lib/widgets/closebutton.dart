<<<<<<< HEAD
import 'package:flutter/material.dart';

class CloseButtonBlack extends StatelessWidget {
  // const CloseButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 30,
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/loginpage');
          },
          child: Image.asset('assets/closeblack.png')),
    );
  }
}
=======
import 'package:flutter/material.dart';

class CloseButtonBlack extends StatelessWidget {
  // const CloseButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 30,
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/loginpage');
          },
          child: Image.asset('assets/closeblack.png')),
    );
  }
}
>>>>>>> a122225eab9ed4383b1d42fd563083f0ac68eab1
