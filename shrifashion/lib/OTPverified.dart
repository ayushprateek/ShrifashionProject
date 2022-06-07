import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shrifashion/ActivateAccount.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/main.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:shrifashion/signup.dart';
import 'package:flutter/material.dart';
import 'package:shrifashion/HomePage.dart';
class OTPverified extends StatefulWidget {
  bool accountExists,isDeactivated;
  OTPverified(bool accountExists,bool isDeactivated)
  {
    this.accountExists=accountExists;
    this.isDeactivated=isDeactivated;
  }
  @override
  _OTPverifiedState createState() => _OTPverifiedState();
}
class _OTPverifiedState extends State<OTPverified> {@override
void initState() {
  super.initState();
  navigate();
}
void navigate()
 {
  if(widget.isDeactivated)
    {
      Timer(
          Duration(seconds: 3,milliseconds: 500),
              () => Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => new ActivateAccount())));
    }
  else
    {

      if(widget.accountExists)
      {
        //check if acount was deactivated
        if(localStorage.get('guest_id')!=null)
        {
          //ITS IS A GUEST ACCOUNT
          FirebaseDatabase.instance.reference().child("customer")
              .orderByChild("customer_id").equalTo(localStorage.get('guest_id'))
              .once().then((DataSnapshot snapshot) {

            try
            {
              Map<dynamic,dynamic> values = snapshot.value;
              if(values!=null)
              values.forEach((key,values) {
                FirebaseDatabase.instance.reference().child("customer").child(key.toString()).remove();

              });
            }
            catch(e)
            {
              List<dynamic> values = snapshot.value;
              if(values!=null)
              for(int i=0;i<values.length;i++)
              {
                FirebaseDatabase.instance.reference().child("customer").child(i.toString()).remove();
              }
            }

          });
          //UPDATE CART
          FirebaseDatabase.instance.reference().child("cart")
              .orderByChild("customer_id").equalTo(localStorage.get('guest_id'))
              .once().then((DataSnapshot snapshot) {

            try
            {
              Map<dynamic,dynamic> values = snapshot.value;
              if(values!=null)
              values.forEach((key,values) {
                FirebaseDatabase.instance.reference().child("cart").child(key.toString()).update(
                    {
                      "customer_id":customerId
                    });

              });
            }
            catch(e)
            {
              List<dynamic> values = snapshot.value;
              if(values!=null)
              for(int i=0;i<values.length;i++)
              {
                FirebaseDatabase.instance.reference().child("cart").child(i.toString()).update(
                    {
                      "customer_id":customerId
                    });
              }
            }
          });;
          //UPDATE ADDRESS
          FirebaseDatabase.instance.reference().child("address")
              .orderByChild("customer_id").equalTo(localStorage.get('guest_id'))
              .once().then((DataSnapshot snapshot) {
            try
            {
              Map<dynamic,dynamic> values = snapshot.value;
              if(values!=null)
              values.forEach((key,values) {
                FirebaseDatabase.instance.reference().child("address").child(key.toString()).update(
                    {
                      "customer_id":customerId
                    });
              });
            }
            catch(e)
            {
              List<dynamic> values = snapshot.value;
              if(values!=null)
              for(int i=0;i<values.length;i++)
              {
                FirebaseDatabase.instance.reference().child("address").child(i.toString()).update(
                    {
                      "customer_id":customerId
                    });
              }
            }

          });;
          //DELETE FROM COUPON
          FirebaseDatabase.instance.reference().child("coupons")
              .orderByChild("code").equalTo("ECO-A0"+localStorage.get('guest_id').toString())
              .once().then((DataSnapshot snapshot) {
            try
            {
              Map<dynamic,dynamic> values = snapshot.value;
              if(values!=null)
              values.forEach((key,values) {
                FirebaseDatabase.instance.reference().child("coupons").child(key.toString()).remove();

              });
            }
            catch(e)
            {
              List<dynamic> values = snapshot.value;
              if(values!=null)
              for(int i=0;i<values.length;i++)
              {
                FirebaseDatabase.instance.reference().child("coupons").child(i.toString()).remove();
              }
            }
          });
          localStorage.setString("guest_id", null);
        }
        if(mobileLogin.isComingFromCart)
          {
            mobileLogin.isComingFromCart=false;
            Fluttertoast.showToast(
                msg:
                "Remove duplicate products (if any)",
                toastLength: Toast
                    .LENGTH_LONG,
                gravity:
                ToastGravity
                    .BOTTOM,
                timeInSecForIosWeb:
                1,
                fontSize: 16.0);
            Timer(
                Duration(seconds: 3,milliseconds: 500),
                    () => Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (context) => new Cart())));
          }
        else
          {
            Timer(
                Duration(seconds: 3,milliseconds: 500),
                    () => Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (context) => new Dashboard())));
          }
      }
      else
      {
        Timer(
            Duration(seconds: 3,milliseconds: 500),
                () => Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => new Signup())));
      }
    }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  'images/Tick.jpeg',
                  height: MediaQuery.of(context).size.height/2.5,
                  width: MediaQuery.of(context).size.height/2.5,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height/8,
            ),
            Container(
              child: Center(child: Text("Your OTP has been verified",
                style: TextStyle(color: Colors.black,
                  fontFamily: custom_font,
                  fontSize: 20
                ),)),
            ),


          ]
      )
  );
}
}
