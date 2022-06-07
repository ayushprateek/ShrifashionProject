import 'dart:convert';


import 'package:firebase_database/firebase_database.dart';
import 'package:shrifashion/HomePage.dart';
import 'package:shrifashion/main.dart';
import 'package:shrifashion/mobileOTP.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'components/Color.dart';
String customerId;
class mobileLogin extends StatefulWidget {
  static bool isComingFromCart=false;
  @override
  _mobileLoginState createState() => _mobileLoginState();
}
class _mobileLoginState extends State<mobileLogin> {
  double div=1.35;
  final _formKey = GlobalKey<FormState>();
  final key=GlobalKey<ScaffoldState>();
  TextEditingController _mobileTextController = TextEditingController();
  bool accountExists=false;
  @override
  Widget build(BuildContext context) {
    _keyboardIsVisible();
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,

      resizeToAvoidBottomInset: false,
      body: SizedBox(
        child: Stack(
          children: [
            Positioned(
              top: _width / div,
              left: _width/2.7,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    'images/Logo.png',
                    height: MediaQuery.of(context).size.height/8,
                    width: MediaQuery.of(context).size.height/8,
                  ),
                ),
              ),
            ),
            Positioned(
              top: _height / div,
              child: Container(

                  width: _width,
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        FittedBox(
                          child: Text(
                            "Let's get you started",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          fit: BoxFit.scaleDown,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: _width / 1.2,
                            height: _height / 20,
                            child: Row(
                              children: [
                                Expanded(
                                  flex:3,
                                  child: TextFormField(
                                    onTap: (){
                                      setState(() {
                                        div=1.9;
                                      });
                                    },

                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(10),
                                    ],
                                    controller: _mobileTextController,
                                    decoration: new InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      filled: true,
                                      // prefixText: '  +91 |  ',
                                      prefixIcon: Text('  +91 |  ',style: TextStyle(fontSize: 17,),),
                                      prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 23),
                                      // Icon(Icons.phone_android, color: HexColor("#27ab87"),),
                                      fillColor: Colors.white,
                                      hoverColor: Colors.red,
                                      //focusColor:HexColor("#27ab87"),
                                      // isDense: true,
                                      hintText: "Enter Your Mobile Number",
                                      // fillColor: Colors.red,
                                      focusedBorder: new OutlineInputBorder(

                                        borderRadius: new BorderRadius.circular(10.0),
                                        borderSide: new BorderSide(
                                          color:Theme.of(context).buttonColor,

                                        ),
                                      ) ,
                                      //labelStyle: TextStyle(color: HexColor("#27ab87")),

                                      border: new OutlineInputBorder(

                                        borderRadius: new BorderRadius.circular(10.0),
                                        borderSide: new BorderSide(
                                            color: Colors.red

                                        ),
                                      ),
                                      //fillColor: Colors.green
                                    ),
                                    keyboardType: TextInputType.number,
                                    style: new TextStyle(
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex:2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:Theme.of(context).buttonColor,
                                      ),
                                      width: _width / 1.5,
                                      height: _height / 20,
                                      child: MaterialButton(
                                        onPressed: () async {
                                          Navigator.push(context, new MaterialPageRoute(builder: (context) => new mobileOTP(_mobileTextController.text)));


                                          //Navigator.of(context).pushNamed('/mobileOTP');
                                        },
                                        minWidth: MediaQuery.of(context).size.width,
                                        child: FittedBox(
                                          child: Text(
                                            "GET OTP",
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
                                ),
                              ],
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "You will get OTP on this number",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.grey),
                              ),
                              //fit: BoxFit.scaleDown,
                            ),
                            Expanded(
                              flex: 3,
                              child: OutlineButton(
                                borderSide: BorderSide( color: Colors.transparent),
                                child: Text(
                                  "Skip",
                                  style: TextStyle(color: Colors.grey,fontSize: 12,),
                                  textAlign: TextAlign.left,
                                ),
                                onPressed: ()async{
                                  await register();


                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                  Dashboard()), (Route<dynamic> route) => false);
                                  //Navigator.push(context, MaterialPageRoute(builder: ((context)=>Dashboard())));
                                },
                              ),
                              //fit: BoxFit.scaleDown,
                            ),
                          ],
                        ),
                        Container(
                          height: 120,
                          color: Theme.of(context).scaffoldBackgroundColor,)
                      ],
                    ),
                  )),
            ),

          ],
        ),
      ),
    );
  }
  bool _keyboardIsVisible() {
    if(MediaQuery.of(context).viewInsets.bottom == 0.0)
    {
      setState(() {
        div=1.35;
      });
    }
    else{
      setState(() {
        div=1.9;
      });
    }
    print(!(MediaQuery.of(context).viewInsets.bottom == 0.0));
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  void register() async {
    customerId = localStorage.get('guest_id');
    //IF IT HAS A GUEST ID (GUEST ID !=NULL) IS HAS ALREADY REGISTER FOR GUEST
    //IF IT HAS NO GUEST ID(GUEST ID==NULL) THEN REGISTER
    if(customerId==null)
      {
        final custLast = FirebaseDatabase.instance.reference().child("customer").limitToLast(1);
        final customer = FirebaseDatabase.instance.reference().child("customer");
        try {

          custLast.once().then(
                  (DataSnapshot datasnapshot){
                Map<dynamic,dynamic> values= datasnapshot.value;
                values.forEach((key,value){
                  customerId=key.toString();
                  int newKey=int.parse(key.toString())+1;
                  customer.child(newKey.toString()).set({
                    "customer_id":customerId.toString(),
                    "date_added":DateTime.now().toIso8601String(),
                    "email":"guest@shrifashion.com",
                    "sex":"M",
                    "firstname":"Guest",
                    "lastname":"Account",
                    "language_id":"1",
                    "telephone":"xxxxx",
                  });
                  localStorage.setString("customerId", customerId.toString());
                  localStorage.setString("guest_id", customerId.toString());
                });
                // String str="Welcome and thank you for registering at shrifashion!\n\nYour account has now been created and you can log in by using your email address and password by visiting our website or at the following URL:<br><br> https://shrifashion.com/index.php?route=account/login <br><br> Upon logging in, you will be able to access other services including reviewing past orders, printing invoices and editing your account information.<br><br>Thanks,<br>shrifashion.";
                // sendEmail(_emailTextController.text, "shrifashion", "Hi", "Greetings", str);
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
          if(values!=null)
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
}
