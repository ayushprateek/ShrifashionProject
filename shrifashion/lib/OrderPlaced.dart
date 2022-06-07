import 'dart:async';
import 'package:shrifashion/Payment.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shrifashion/HomePage.dart';
import 'components/Color.dart';
import 'package:firebase_database/firebase_database.dart';
class OrderPlaced extends StatefulWidget {
  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {

  final cart = FirebaseDatabase.instance.reference().child("cart");
  @override
  void initState(){
    super.initState();
    discount=0.0;
    hasOrdered=false;
     hasRedeemed=false;
     amtRedeemed=0.0;
     points=0.0;
    cart.once().then(
            (DataSnapshot datasnapshot) {
              try {
                List<dynamic> values = datasnapshot.value;
                for (int i = 0; i < values.length; i++) {
                  try{
                    if (values[i]['customer_id'].toString() == customerId.toString()) {
                      cart.child(i.toString()).update(
                          {"status": 0.toString()});
                    }
                  }
                  catch(e)
                  {

                  }

                }
              }
              catch(e)
              {
                Map<dynamic,dynamic> values = datasnapshot.value;
                values.forEach((key, value) {try{
                  if (value['customer_id'].toString() == customerId.toString()) {
                    cart.child(key.toString()).remove();
                  }
                }
                catch(e)
                {

                }});
              }

        }).then((value) => setState((){}));
    Timer(Duration(seconds: 7), () {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          Dashboard()), (Route<dynamic> route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    var _width=MediaQuery.of(context).size.width;
    var _height=MediaQuery.of(context).size.height;
    // return Scaffold(
    //     backgroundColor: Colors.white,
    //     body: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children:<Widget>[
    //           // Container(
    //           //   color: barColor,
    //           //   height: _height/4,
    //           //   child: Center(child: Text("Your order has been placed successfully!",style: TextStyle(color: Colors.white),),),
    //           // ),
    //           Image.asset('images/OrderComplete.jpeg',height:_height/2,width: _width,),
    //           // SizedBox(height :30),
    //           SpinKitPulse(color: barColor,)
    //         ])
    // );
    return Scaffold(
      body: Container(color: Colors.white,
        child: Column(
            children:<Widget>[
              Expanded(child: Container()),
              Expanded(
                flex: 10,
                  child: Image.asset(
                    'images/OrderComplete2.jpeg',
                  fit: BoxFit.fill,
                  )),
              // SizedBox(height :30),
              Expanded(child: SpinKitPulse(color: Theme.of(context).buttonColor,))
            ]),
      ),
    );
  }
}