import 'dart:convert';

import 'package:shrifashion/pages/Cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'mobileLogin.dart';
import 'package:firebase_database/firebase_database.dart';



class CartCount extends StatefulWidget {
  @override
  _CartCountState createState() => _CartCountState();

}

class _CartCountState extends State<CartCount> {
  final cart = FirebaseDatabase.instance.reference().child("cart");
  final product = FirebaseDatabase.instance.reference().child("search");
  int itemCount=0;
  List cartProducts=[];
  @override
  void initState() {
    final deliveryCharge = FirebaseDatabase.instance.reference().child("deliveryCharge");

    deliveryCharge.once().then((DataSnapshot snapshot) {
      try{
        Map<dynamic,dynamic> values = snapshot.value;
        payableDeliveryCharge=double.parse(values[0]['charge'].toString());
      }
      catch(e)
      {
        List<dynamic> values = snapshot.value;
        payableDeliveryCharge=double.parse(values[0]['charge'].toString());
      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  StreamBuilder(
        stream: cart.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            itemCount=0;
            cartProducts.clear();
            try{
              List<dynamic> values= snapshot.data.snapshot.value ;
              values.forEach((values) {
                try{
                  if(values['customer_id']==customerId)
                  {
                    cartProducts.add(values);
                    itemCount++;
                  }
                }
                catch(e){

                }
              });
            }
            catch(e)
          {
            Map<dynamic,dynamic> values= snapshot.data.snapshot.value ;
            values.forEach((key,values) {
              try{
                if(values['customer_id']==customerId )
                {
                  cartProducts.add(values);
                  itemCount++;
                }
              }
              catch(e){

              }
            });
          }




            return new Stack(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  new Cart()))
                          .then((value) => setState(() {}));
                    }),
               itemCount != 0
                    ? new Positioned(
                  right: 30,

                  child: new Container(
                    padding: EdgeInsets.all(2),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      itemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                    : new Container()
              ],
            );
          } else {
            return IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new Cart()))
                      .then((value) => setState(() {}));
                });
          }
          //return Container();
        },
      ),
    );
  }


}
