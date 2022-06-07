import 'package:shrifashionadmin/Masters/Categories.dart';
import 'package:shrifashionadmin/Masters/Coupons.dart';
import 'package:shrifashionadmin/Masters/Products.dart';
import 'package:shrifashionadmin/Masters/SubCategories.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class StickyFooter extends StatefulWidget {
  @override
  _StickyFooterState createState() => _StickyFooterState();
}

class _StickyFooterState extends State<StickyFooter> {
  final cart = FirebaseDatabase.instance.reference().child("cart");
  final product = FirebaseDatabase.instance.reference().child("search");
  int numOfCartItems=0;
  double saved=0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 2*(MediaQuery.of(context).size.height)/24,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap:(){
                        // Navigator.pop(context);
                        // Navigator.push(context,
                        //     new MaterialPageRoute(builder: (context) => new Dashboard()));
                      },
                      child: Column(
                        children: [
                          Expanded(
                            flex:3,
                            child: Image.asset('images/launcher.jpeg',
                              //'images/LogoWithTM.jpg',
                              // width: MediaQuery.of(context).size.width/13,
                            ),
                          ),
                          Expanded(child: FittedBox(child: Text("Home",style: TextStyle(fontSize: 12),))),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: ((context)=>Categories())));
                      },
                      child: FittedBox(
                        child: Column(
                          children: [
                            IconButton(
                              icon: Icon(FlutterIcons.buffer_mco,color: Colors.black,),
                            ),
                            Text("Categories"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: ((context)=>SubCategories())));
                      },
                      child: FittedBox(
                        child: Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.category,color: Colors.black,),
                            ),
                            Text("Sub-category "),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){


                        Navigator.push(context, MaterialPageRoute(builder: ((context)=>Products())));


                      },
                      child: FittedBox(
                        child: Column(
                          children: [
                            IconButton(
                              icon: Icon(FlutterIcons.box_open_faw5s,color: Colors.black,),
                            ),
                            Text("Products"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: ((context)=>Coupons())));

                      },
                      child: FittedBox(
                        child: Column(
                          children: [
                            IconButton(
                              icon: Icon(FlutterIcons.tags_faw,color: Colors.black,),
                            ),
                            Text("Coupons"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Text(""),)

        ],
      ),
    );
  }
}


