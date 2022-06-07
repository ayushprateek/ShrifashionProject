import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:flutter/material.dart';
class Manufacturers extends StatefulWidget {
  @override
  _ManufacturersState createState() => _ManufacturersState();
}

class _ManufacturersState extends State<Manufacturers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: StickyFooter(),
        appBar: AppBar(
          elevation: 10.0,

          title: Text('Manufacturers',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
        ),
        body: Container()
    );
  }
}
