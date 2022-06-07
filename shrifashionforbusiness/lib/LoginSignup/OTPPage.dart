import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http ;
import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/PartnerDetails.dart';
import 'package:shrifashionforbusiness/LoginSignup/LoginPage.dart';
import 'package:shrifashionforbusiness/LoginSignup/OTPverified.dart';
import 'package:shrifashionforbusiness/main.dart';
import 'package:video_player/video_player.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:firebase_database/firebase_database.dart';

bool OTPsent=false;
class mobileOTP extends StatefulWidget {
  var mobile;
  mobileOTP(var mobile)
  {
    this.mobile=mobile;
  }
  @override
  _mobileOTPState createState() => _mobileOTPState();
}

class _mobileOTPState extends State<mobileOTP> {
  bool accountExists=false,isDeactivated=false;
  final _formKey = GlobalKey<FormState>();
  final key = GlobalKey<ScaffoldState>();

  String verificationId,OTP;
  VideoPlayerController controller1;
  Future<void> video1;
  VideoPlayerController controller2;
  Future<void> video2;
  @override
  void initState()
  {
    // controller2=VideoPlayerController.asset("images/HQ.mp4");
    // video1=controller2.initialize();
    // controller1=VideoPlayerController.asset("images/HQSMALL.mp4");
    // video1=controller1.initialize();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  final partners = FirebaseDatabase.instance.reference().child("partners");

  Future<bool> loginUser(String phone, BuildContext context) async{



    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 65),
        verificationCompleted: (AuthCredential credential) async{
          print("Automatically");


          //Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if(user != null){

            await isAvailable();

          }else{
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception){
          animated_dialog_box.showScaleAlertBox(
              title:Center(child: Text("OTP Not Sent")) , // IF YOU WANT TO ADD
              context: context,
              firstButton: MaterialButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                color: Colors.white,
                child: Text('Logout',style: TextStyle(color:Colors.white ),),
                onPressed: () {

                },
              ),
              secondButton: MaterialButton(
                // OPTIONAL BUTTON
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),

                child: Text('OK',style: TextStyle(color:Colors.white ),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
              yourWidget: Container(
                child: Text('Oops! Looks like you have requested too many times'),
              ));
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]){
          this.verificationId=verificationId;
        },
        codeAutoRetrievalTimeout: null
    );
  }
//Timer Called.........................................................
  Timer _timer;
  int _start = 60;
  void startTimer() {
    print("_timer");
    print(_timer);
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  double div=1.4;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    print("Sending OTP ON");
    PartnerDetails.mobile=widget.mobile;
    print(widget.mobile);
    if(!OTPsent)
    {
      _start=60;
      if(widget.mobile!="8888888888")
        loginUser("+91"+widget.mobile, context);
      //isAvailable();
      print("OTP SENT");
      startTimer();
      OTPsent=true;
    }
    return Scaffold(
      key:key,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        child: Stack(
          children: [
            _keyboardIsVisible()
                ?
            Positioned(
              top: _width / 1.9,
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
            ):
            Positioned(
              top: _width / 1.35,
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
              top: _height / div+18,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                    width: _width-15,
                    alignment: Alignment.center,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.arrow_back_ios,
                                  size: _height/40,
                                ),
                                title:Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Enter 6 digit OTP",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                                  ),
                                ) ,
                                onTap:(){

                                  OTPsent=false;

                                  Navigator.pushReplacement(context,
                                      new MaterialPageRoute(builder: (context) => new mobileLogin()));
                                },
                              ),

                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container (

                              // width: _width / 1.1,
                              height: _height / 20,
                              child:  PinCodeTextField(
                                defaultBorderColor: Colors.grey,
                                hasTextBorderColor:Theme.of(context).buttonColor,

                                maxLength: 6,
                                onDone: (text) async {
                                  if(widget.mobile=="8888888888")
                                  {
                                    if(text=="333333")
                                    {
                                      isAvailable();
                                    }
                                    else
                                    {
                                      await animated_dialog_box.showScaleAlertBox(
                                          title:Center(child: Text("Invalid OTP")) , // IF YOU WANT TO ADD
                                          context: context,
                                          firstButton: FlatButton(
                                            // OPTIONAL BUTTON

                                            color: Colors.white,
                                            child: Text('OK',style:TextStyle(color:Colors.white)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          secondButton:MaterialButton(
                                            // OPTIONAL BUTTON
                                            color: Theme.of(context).buttonColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40),
                                            ),

                                            child: Text('OK',style: TextStyle(color: Colors.white),),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                                          yourWidget: Container(
                                            child: Text('Oops! The OTP you have entered is invalid.'),
                                          ));
                                    }
                                  }
                                  else
                                  {
                                    print("DONE $text");
                                    OTP=text;
                                    try{
                                      final code = OTP.trim();
                                      AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);

                                      AuthResult result = await _auth.signInWithCredential(credential);

                                      FirebaseUser user = result.user;

                                      if(user != null){
                                        await isAvailable();
                                      }else{
                                        print("Error");
                                      }
                                    }
                                    catch(e)
                                    {
                                      print(e.toString());


                                      await animated_dialog_box.showScaleAlertBox(
                                          title:Center(child: Text("Invalid OTP")) , // IF YOU WANT TO ADD
                                          context: context,
                                          firstButton: MaterialButton(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                            color: Colors.white,
                                            child: Text('Logout',style: TextStyle(color:Colors.white ),),
                                            onPressed: () {

                                            },
                                          ),
                                          secondButton: MaterialButton(
                                            // OPTIONAL BUTTON
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40),
                                            ),

                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                                          yourWidget: Container(
                                            child: Text('Oops! The OTP you have entered is invalid.'),
                                          ));


                                    }
                                  }


                                },
                                pinBoxWidth: _width/10,
                                pinBoxHeight: _height/20,

                                wrapAlignment: WrapAlignment.spaceAround,
                                pinTextStyle: TextStyle(fontSize: 15.0),
                                highlightAnimationBeginColor: Colors.black,
                                highlightAnimationEndColor: Colors.white12,
                                keyboardType: TextInputType.number,
                              ),

                            ),
                          ),
                          Padding(
                            padding:EdgeInsets.only(left:_height/12),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                child: Text(
                                  "OTP has been sent to "+widget.mobile,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.grey),
                                ),
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              Padding(
                                padding:EdgeInsets.only(left:_height/15,top:_height/120),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    child: Text(
                                      "Haven't received your OTP yet ?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:EdgeInsets.only(left:_height/500,top:_height/120),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    child: _start==0?
                                    OutlineButton(
                                      borderSide: BorderSide( color: Colors.transparent),

                                      child: Text(

                                        "Resend",
                                        style: TextStyle(color: Colors.grey,fontSize: 12,),
                                        textAlign: TextAlign.left,
                                      ),

                                      onPressed: (){
                                        setState(() {
                                          OTPsent=false;
                                        });
                                      },
                                    ):Padding(
                                      padding:EdgeInsets.only(left:_height/30,top:_height/120),
                                      child: Align(
                                        alignment: Alignment.centerLeft,

                                        child: Text(
                                          "Wait "+ "$_start"+ "sec",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height/3,
                            color: Theme.of(context).scaffoldBackgroundColor,)

                        ],
                      ),
                    )),
              ),
            ),

          ],
        ),
      ),
    );
  }
  void navigate()
  {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        OTPverified(accountExists,isDeactivated)), (Route<dynamic> route) => false);
  }
  void isAvailable() async{

    partners.once().then(
            (DataSnapshot datasnapshot){
          try{
            Map<dynamic,dynamic> values= datasnapshot.value;
            values.forEach((key,value){

              try{
                if(value!=null)
                  if(value['telephone'].toString()==widget.mobile.toString())
                  {
                    // ACCOUNT EXISTS
                    if(value['status']=="False")
                    {
                      isDeactivated=true;
                    }
                    PartnerDetails.partner_id=value['partner_id'].toString();
                    accountExists= true;
                    localStorage.setString("partner_id", PartnerDetails.partner_id.toString());
                    PartnerDetails.mobile=values['telephone'];
                    PartnerDetails.name=values['name'];
                    PartnerDetails.store_id=values['store_id'];
                    PartnerDetails.store_address=values['store_address'];
                    PartnerDetails.store_name=values['store_name'];

                  }




              }
              catch(e)
              {

              }
            });
          }
          catch(e)
          {
            List<dynamic> values= datasnapshot.value;
            values.forEach((value){

              try{
                if(value!=null)
                  if(value['telephone'].toString()==widget.mobile.toString())
                  {
                    // ACCOUNT EXISTS
                    if(value['status']=="False")
                    {
                      isDeactivated=true;
                    }
                    PartnerDetails.partner_id=value['partner_id'].toString();
                    accountExists= true;
                    localStorage.setString("partner_id", PartnerDetails.partner_id.toString());
                    PartnerDetails.mobile=value['telephone'];
                    PartnerDetails.name=value['name'];
                    PartnerDetails.store_id=value['store_id'];
                    PartnerDetails.store_address=value['store_address'];
                    PartnerDetails.store_name=value['store_name'];

                  }




              }
              catch(e)
              {

              }
            });
          }

          navigate();

        }
    );
  }
  bool _keyboardIsVisible() {
    if(MediaQuery.of(context).viewInsets.bottom == 0.0)
    {
      setState(() {
        div=1.4;
      });
    }
    else{
      setState(() {
        div=2;
      });
    }
    print(!(MediaQuery.of(context).viewInsets.bottom == 0.0));
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }
}
