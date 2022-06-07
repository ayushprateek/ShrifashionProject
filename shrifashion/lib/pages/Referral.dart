
import 'package:shrifashion/CartIcon.dart';
import 'package:shrifashion/StickyFooter.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/main.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_share/flutter_share.dart';
String  shareCode="FASHION-A0"+customerId.toString();
class Referral extends StatefulWidget {
  @override
  _ReferralState createState() => _ReferralState();
}
class _ReferralState extends State<Referral> {

  final rewards = FirebaseDatabase.instance.reference().child("customer_rewards");
  final key = GlobalKey<ScaffoldState>();

  String msg = 'Get Rs.85 off on your next order only on shrifashion \n Referral Code :$shareCode\n\nDownload and Apply Now :\nhttps://play.google.com/store/apps/details?id=com.shrisolutions.shrifashion';

  @override
  Widget build(BuildContext context) {
    if(localStorage.get('guest_id')!=null)
      {
        shareCode="FASHION-A0"+"0";
      }
    var _height = MediaQuery.of(context).size.height;
    var _widht = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
        appBar: new AppBar(
          title: Text('Refer & Earn',style: TextStyle(fontFamily: custom_font,color: Colors.black),),
          leading:  IconButton(
              icon: new Icon(Icons.arrow_back_ios,color: Colors.black,),
              onPressed: (){
                Navigator.pop(context);
              }),

          actions: <Widget>[
            CartCount()
          ],
        ),
        body: SingleChildScrollView(
          child: Container(

            child: Column(
              children: [
                SizedBox(
                  height:15
                ),
                StreamBuilder(
                  stream: rewards.onValue,
                  builder: (context, snapshot) {
                    var points="";
                    List<dynamic> values ;
                    try{
                      values = snapshot.data.snapshot.value;
                      values.forEach((values) {
                        try{
                          if(values['customer_id']==customerId.toString() )
                          {
                            points=values['points'];
                          }
                        }
                        catch(e){
                        }
                      });
                    }catch(e){}


                    points=points==""?"0":points;
                    if (snapshot.hasData) {
                      return Container(

                        height: _height * .15,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Total Rewards Balance",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "\u{20B9}"+points,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Expanded(
                                    child:  Image.asset('images/Logo.png',
                                      fit: BoxFit.fill,
                                      // width: MediaQuery.of(context).size.width/8,
                                      // height: MediaQuery.of(context).size.width/8,
                                    ),

                                  ),
                                  // Expanded(
                                  //   flex: 2,
                                  //   child: Container(),
                                  // ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      );
                    } else {
                      return Container(
                         
                        height: _height * .15,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Total Rewards Balance",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "\u{20B9}0",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Expanded(

                                    child:  Image.asset('images/Logo.png',
                                      fit: BoxFit.fill,
                                      // width: MediaQuery.of(context).size.width/8,
                                      // height: MediaQuery.of(context).size.width/8,
                                    ),

                                  ),
                                  // Expanded(
                                  //   flex: 2,
                                  //   child: Container(),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),

                Container(
                   
                  height: _height * .13,
                  child: Padding(
                    padding: const EdgeInsets.only(left:10.0,right: 10,bottom: 5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Share Your Referral code with your family and friends and get Rs.85 as reward when they order from shrifashion",
                        style: TextStyle(color: Colors.grey, fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
                Container(

                  height: _height * .06,
                  decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).buttonColor),
                     
                  ),
                  margin: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Material(

                          borderRadius: BorderRadius.circular(10.0),

                          elevation: 0.0,
                          child: MaterialButton(
                            onPressed: () async {},
                            minWidth: MediaQuery.of(context).size.width,
                            child: Text(
                              "Your referral code:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                   
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                shareCode,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                            ),
                            IconButton(
                              onPressed: (){
                                Clipboard.setData(new ClipboardData(text: shareCode));
                                Fluttertoast.showToast(
                                    msg:
                                    "Coupon copied",
                                    toastLength: Toast
                                        .LENGTH_SHORT,
                                    gravity:
                                    ToastGravity
                                        .BOTTOM,
                                    timeInSecForIosWeb:
                                    1,
                                    fontSize: 16.0);
                              },
                              icon: Icon(Icons.content_copy,),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                   
                  child: Row(
                    children: [

                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: _height * .05,
                            child: OutlineButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Theme.of(context).buttonColor
                              ),
                              onPressed: () async {
                                if(localStorage.get('guest_id')!=null)
                                {
                                  key.currentState.showSnackBar(SnackBar(
                                    content: Text('Login/Signup to continue'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 1,milliseconds: 500),
                                  ));
                                }
                                else
                                  {
                                    try
                                        {
                                          share();
                                        }
                                        catch(e)
                                {

                                }
                                  }

                              },
                              //minWidth: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Expanded(child: Icon(Icons.share,)),
                                  Expanded(
                                    flex:5,
                                    child: Text(
                                      "Share",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context).buttonColor,
                                          fontWeight: FontWeight.bold,
                                        fontSize: 20
                                          ),
                                    ),
                                  ),
                                  Expanded(child: Container())
                                ],
                              ),
                            ),
                          ),
                        ),),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: _height * .05,
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () async {
                                  if(localStorage.get('guest_id')!=null)
                                  {
                                    key.currentState.showSnackBar(SnackBar(
                                      content: Text('Login/Signup to continue'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 1,milliseconds: 500),
                                    ));
                                  }
                                  else
                                  FlutterShareMe()
                                      .shareToWhatsApp(msg: msg);
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex:1,
                                        child: Icon(FlutterIcons.logo_whatsapp_ion, )),
                                    Expanded(
                                      flex:5,
                                      child: FittedBox(
                                        child: Text(
                                          "Invite Via Whatsapp",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                             
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                   
                  height: _height * .335,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 12,
                        child:Image.asset('images/Logo.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: FittedBox(
                              child: RichText(
                                text: TextSpan(
                                    text: 'Share & Get Rs.85 Off',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[

                                      TextSpan(
                                        text: '\n',
                                        style: TextStyle(
                                            ),
                                      ),
                                      TextSpan(
                                        text:
                                        'On your next order!! Invite your friends to \n '
                                            'shrifashion with Your Unique referral code.',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                    ]),

                                textAlign: TextAlign.center,
                              ),
                            ),
                          )),
                      Expanded(child: Container())
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
        bottomNavigationBar: new StickyFooter()
    );
  }
  Future<void> share() async {

    await FlutterShare.share(
      title: "Refer and Earn",
      text: msg,
      //linkUrl: 'https://flutter.dev/',
      //chooserTitle: 'Example Chooser Title',


    );
  }
}

