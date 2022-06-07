import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:flutter/material.dart';
class System extends StatefulWidget {
  @override
  _SystemState createState() => _SystemState();
}

class _SystemState extends State<System> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: StickyFooter(),
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: backColor,
          title: Text('System',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
        ),
        body: Container()
    );
  }
}
