import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:flutter/material.dart';
class Manufacturers extends StatefulWidget {
  @override
  _ManufacturersState createState() => _ManufacturersState();
}

class _ManufacturersState extends State<Manufacturers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: StickyFooter(),
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: backColor,
          title: Text('Manufacturers',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
        ),
        body: Container()
    );
  }
}
