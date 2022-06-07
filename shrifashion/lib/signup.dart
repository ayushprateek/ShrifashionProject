import 'dart:convert';

import 'package:shrifashion/SendEmail.dart';
import 'package:shrifashion/mobileOTP.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shrifashion/mobileLogin.dart';
import 'package:shrifashion/HomePage.dart';

import 'components/Color.dart';
import 'main.dart';
import 'package:firebase_database/firebase_database.dart';
bool clicked=true;
class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fnameTextController = TextEditingController();
  TextEditingController _lnameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  final custLast = FirebaseDatabase.instance.reference().child("customer").limitToLast(1);
  final customer = FirebaseDatabase.instance.reference().child("customer");
  String sex='M';
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Profile Details',
          style: TextStyle(color: Colors.black,fontFamily: 'Fredoka One'),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new mobileLogin()));
          },
          child: Icon(
            Icons.clear,
            color: Colors.black, // add custom icons also
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //---------FirstName-----------------
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _fnameTextController,
                            decoration: new InputDecoration(
                              filled: true,

                              prefixIcon: Icon(
                                Icons.person,

                              ),
                              //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                              fillColor: Colors.white,
                              hoverColor: Colors.red,
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide:
                                    new BorderSide(color: Theme.of(context).buttonColor,),
                              ),
                              //focusColor:HexColor("#27ab87"),
                              // isDense: true,
                              hintText: "First Name",
                              // fillColor: Colors.red,

                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            //keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
//------------LastName-----------------
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _lnameTextController,
                            decoration: new InputDecoration(
                              filled: true,
                              prefixIcon: Icon(
                                Icons.person,

                              ),
                              fillColor: Colors.white,
                              hoverColor: Colors.red,
                              //focusColor:HexColor("#27ab87"),
                              // isDense: true,
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide:
                                    new BorderSide(color: Theme.of(context).buttonColor,),
                              ),
                              hintText: "Last Name",
                              // fillColor: Colors.red,

                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            //keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
//-----------Email-----------------

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: new InputDecoration(
                              filled: true,

                              fillColor: Colors.white,
                              hoverColor: Colors.red,
                              //focusColor:HexColor("#27ab87"),
                              // isDense: true,
                              prefixIcon: Icon(
                                Icons.email,

                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide:
                                    new BorderSide(color:Theme.of(context).buttonColor,),
                              ),
                              hintText: "Email",
                              // fillColor: Colors.red,

                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            //keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:60.0,bottom: 20),
                          child: Text("I am a",
                              style: TextStyle(color: Colors.black,fontFamily: 'Fredoka One')),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(

                                  child:
                                  Radio(
                                    activeColor: Theme.of(context).buttonColor,
                                    value: 'M',
                                    groupValue: sex ,
                                    onChanged: (value){
                                      setState(() {
                                        sex='M';
                                      });
                                    },

                                  )
                              ),
                              Expanded(
                                flex:2,
                                  child:
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    sex='M';
                                  });
                                },
                                child: ClipRRect(
                                  child: Image.asset('images/male_user.jpeg'),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              )
                              ),


                              Expanded(child:
                              InkWell(
                                onTap: (){

                                },
                                child: Container(),
                              )
                              ),
                              Expanded(

                                  child:
                                  Radio(
                                    activeColor: Theme.of(context).buttonColor,
                                    value: 'F',
                                    groupValue: sex ,
                                    onChanged: (value){
                                      setState(() {
                                        sex='F';
                                      });
                                    },

                                  )
                              ),
                              Expanded(
                                  flex:2,
                                  child:
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        sex='F';
                                      });
                                    },
                                    child: ClipRRect(
                                      child: Image.asset('images/female_user.jpeg'),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),

                      ],
                    )),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(10.0),

            elevation: 0.0,
            child: MaterialButton(
              onPressed: () async {
                if(clicked)
                  {
                    clicked=false;
                    await register();
                    await createReward();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        Dashboard()), (Route<dynamic> route) => false);
                  }
              },
              minWidth: MediaQuery.of(context).size.width,
              child: Text(
                "Register",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void register() async {
    if(localStorage.get('guest_id')!=null)
    {
      //ITS IS A GUEST ACCOUNT
      customerId = localStorage.get('guest_id');
      localStorage.setString("customerId", customerId);
      localStorage.setString("guest_id", null);
      FirebaseDatabase.instance.reference().child("customer")
          .orderByChild("customer_id").equalTo(customerId)
          .once().then((DataSnapshot snapshot) {
            try
            {
              Map<dynamic,dynamic> values = snapshot.value;
              values.forEach((key,values) {
                FirebaseDatabase.instance.reference().child("customer").child(key.toString()).update(
                    {
                      "email":_emailTextController.text.toString(),
                      "sex":sex.toString(),
                      "firstname":_fnameTextController.text.toString(),
                      "lastname":_lnameTextController.text.toString(),
                      "language_id":"1",
                      "telephone":mobile.toString(),
                    });

              });
            }
            catch(e)
        {
          List<dynamic> values = snapshot.value;
         for(int i=0;i<values.length;i++)
           {
             FirebaseDatabase.instance.reference().child("customer").child(i.toString()).update(
                 {
                   "email":_emailTextController.text.toString(),
                   "sex":sex.toString(),
                   "firstname":_fnameTextController.text.toString(),
                   "lastname":_lnameTextController.text.toString(),
                   "language_id":"1",
                   "telephone":mobile.toString(),
                 });
           }
        }

      });







      String str="Welcome and thank you for registering at shrifashion!\n\nYour account has now been created and you can log in by using your email address and password by visiting our website or at the following URL:<br><br> https://shrifashion.com/index.php?route=account/login <br><br> Upon logging in, you will be able to access other services including reviewing past orders, printing invoices and editing your account information.<br><br>Thanks,<br>shrifashion.";
      sendEmail(_emailTextController.text, "shrifashion", "Hi", "Greetings", str);



    }
    else
      {
        try {
          email=_emailTextController.text;
          custLast.once().then(
                  (DataSnapshot datasnapshot){
                Map<dynamic,dynamic> values= datasnapshot.value;
                values.forEach((key,value){
                  customerId=key.toString();
                  int newKey=int.parse(key.toString())+1;
                  customer.child(newKey.toString()).set({
                    "customer_id":customerId.toString(),
                    "date_added":DateTime.now().toIso8601String(),
                    "email":_emailTextController.text.toString(),
                    "sex":sex.toString(),
                    "firstname":_fnameTextController.text.toString(),
                    "lastname":_lnameTextController.text.toString(),
                    "language_id":"1",
                    "telephone":mobile.toString(),
                  });
                  localStorage.setString("customerId", customerId.toString());
                });
                String str="Welcome and thank you for registering at shrifashion!\n\nYour account has now been created and you can log in by using your email address and password by visiting our website or at the following URL:<br><br> https://shrifashion.com/index.php?route=account/login <br><br> Upon logging in, you will be able to access other services including reviewing past orders, printing invoices and editing your account information.<br><br>Thanks,<br>shrifashion.";
                sendEmail(_emailTextController.text, "shrifashion", "Hi", "Greetings", str);
                createCoupon();
              }
          );
        } catch (e) {
          print(e.toString());
        }
      }
  }
  Future<void> createCoupon()async {
    final coupon = FirebaseDatabase.instance.reference().child("coupons");
    final couponLast = FirebaseDatabase.instance.reference().child("coupons").limitToLast(1);
    final coupon_master = FirebaseDatabase.instance.reference().child("coupon_master");
    final coupon_master_last = FirebaseDatabase.instance.reference().child("coupon_master").limitToLast(1);
    String  shareCode="VEG-A0"+customerId.toString();
    coupon_master_last.once().then(
            (DataSnapshot datasnapshot){
          Map<dynamic,dynamic> values= datasnapshot.value;
          values.forEach((key,value){
             couponId = key.toString();
            int newKey=int.parse(key.toString())+1;
            coupon_master.child(newKey.toString()).set({
              "code":shareCode.toString().trim(),
              "coupon_id":couponId,
              "date_end":DateTime.parse("2050-01-01").toIso8601String(),
              "date_start":DateTime.now().toIso8601String(),
              "discount":"85",
              "name":"Referral Discount",
              "status":"False",
              "total":"0.0000",
              "type":"F",
              "uses_total":"1"
            });
          });
        }
    );

    couponLast.once().then(
            (DataSnapshot datasnapshot){
          Map<dynamic,dynamic> values= datasnapshot.value;
          values.forEach((key,value){
            int newKey=int.parse(key.toString())+1;
            coupon.child(newKey.toString()).set({
              "category_id":"0",
              "code":shareCode.toString().trim(),
              "coupon_id":couponId,
              "date_end":DateTime.parse("2050-01-01").toIso8601String(),
              "date_start":DateTime.now().toIso8601String(),
              "discount":"85",
              "name":"Referral Discount",
              "product_id":"0",
              "status":"False",
              "total":"0.0000",
              "type":"F",
              "uses_total":"1"
            });
          });
        }
    );


  }
  Future<void> createReward(){
    final coupon = FirebaseDatabase.instance.reference().child("customer_rewards");
    final couponLast = FirebaseDatabase.instance.reference().child("customer_rewards").limitToLast(1);
    couponLast.once().then(
            (DataSnapshot datasnapshot){
          Map<dynamic,dynamic> values= datasnapshot.value;
          values.forEach((key,value){
            couponId = key.toString();
            int newKey=int.parse(key.toString())+1;
            coupon.child(newKey.toString()).set({
              "customer_id":customerId.toString(),
              "firstname":_fnameTextController.text.toString(),
              "lastname":_lnameTextController.text.toString(),
              "points":"0"
            });
          });
        }
    );
  }

}
