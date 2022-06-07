import 'package:connectivity/connectivity.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shrifashion/ActivateAccount.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shrifashion/TestApp.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'package:shrifashion/mobileOTP.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrifashion/signup.dart';
import 'package:shrifashion/HomePage.dart';
import 'ReadCtegoryData.dart';
import 'package:video_player/video_player.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print('on background $message');
}
SharedPreferences localStorage;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<int, Color> color =
  {
    50:Color.fromRGBO(48,47,44, .1),
    100:Color.fromRGBO(48,47,44, .2),
    200:Color.fromRGBO(48,47,44, .3),
    300:Color.fromRGBO(48,47,44, .4),
    400:Color.fromRGBO(48,47,44, .5),
    500:Color.fromRGBO(48,47,44, .6),
    600:Color.fromRGBO(48,47,44, .7),
    700:Color.fromRGBO(48,47,44, .8),
    800:Color.fromRGBO(48,47,44, .9),
    900:Color.fromRGBO(48,47,44, 1),
  };
  MaterialColor colorCustom = MaterialColor(0xFF005725, color);
  //MaterialColor colorCustom = MaterialColor(0xFF302f2c, color);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(
           // color:HexColor("#302f2c"),
            color:HexColor("#005725"),
        ),
        accentIconTheme: IconThemeData(
          color:HexColor("#005725"),
        ),
        primaryIconTheme: IconThemeData(
         // color:HexColor("#302f2c"),
          color:HexColor("#005725"),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          //color:  HexColor("#F1EFE4"),
          color:  Colors.white,
        ),
        appBarTheme: AppBarTheme(
          elevation: 10.0,
          //backgroundColor:  HexColor("#F1EFE4"),
          backgroundColor:  Colors.white,
        ),
        //buttonColor: HexColor("#302f2c"),
        buttonColor: HexColor("#005725"),
          primarySwatch:colorCustom,
      //scaffoldBackgroundColor: HexColor("#F1EFE4"),
      scaffoldBackgroundColor: Colors.white,
      //accentColor: HexColor("#302f2c"),
      accentColor: HexColor("#005725"),
      ),
      home: MyApp(),
     // home:  TestApp(),
    ),
  );
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}
class _MyAppState extends State<MyApp> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final key=GlobalKey<ScaffoldState>();
  VideoPlayerController controller;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<void> video;
  @override
  void initState() {
    // _firebaseMessaging.configure(
    //     onMessage: (message) async{
    //       // Fluttertoast.showToast(msg: "You have a new job request");
    //     },
    //     onResume: (message) async{
    //       // Fluttertoast.showToast(msg: "You have a new job request");
    //
    //     },
    //     onLaunch: (message) async{
    //       // Fluttertoast.showToast(msg: "You have a new job request");
    //     },
    //     onBackgroundMessage: myBackgroundMessageHandler
    //
    // );
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    categoryData().readCategoryData();
    super.initState();
  }
  @override
  void dispose() {
    //controller.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }
  Future<void> initConnectivity() async {
    ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {

    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.none:
        key.currentState
            .showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to get connectivity.'),
              backgroundColor:
              Colors
                  .red,
            ));
        break;
        default:
          navigate();
    }
  }
  void navigate() async {

    final version = FirebaseDatabase.instance.reference().child("version");
    version.once().then((DataSnapshot snapshot)  {

      List<dynamic> ver = snapshot.value;
      ver.forEach((values) async {
        try{
          if(int.parse(values['version'])>2)
          {
            animated_dialog_box.showScaleAlertBox(
                title:Center(child: Text("Update alert!")) , // IF YOU WANT TO ADD
                context: context,
                firstButton: MaterialButton(
                  // OPTIONAL BUTTON
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),

                  child: Text('Cancel',style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                secondButton: MaterialButton(
                  color: Theme.of(context).buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),

                  child: Text('Update',style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    try
                    {
                      launch("https://play.google.com/store/apps/details?id=com.shrisolutions.shrifashion");
                    }
                    catch(e)
                    {
                      print(e.toString());
                    }
                  },
                ),
                icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                yourWidget: Container(
                  child: Text('A new version of shrifashion is on play store, please update...'),
                ));
          }
          else
          {
            try{
              localStorage = await SharedPreferences.getInstance();
              // localStorage.setString("customerId", '112');
              customerId = localStorage.get('customerId');
              print(customerId);
              // print(customerId);
              //localStorage.setString("guest_id", null);
              print("Inside try");
              print(customerId);
            }
            catch(e)
            {
            }
            if (customerId != null) {
              bool isDeactivated=false;
              final customer = FirebaseDatabase.instance.reference().child("customer");
              customer.once().then((DataSnapshot snapshot) {
                try
                {
                  List<dynamic> cust = snapshot.value;
                  cust.forEach((values) {
                    try{
                      if(values['customer_id'].toString()==customerId.toString())
                      {
                        mobile=values['telephone'];
                        fname=values['firstname'];
                        lname=values['lastname'];
                        email=values['email'];
                        try{
                          if(values['status']=="False")
                          {
                            isDeactivated=true;
                          }

                        }
                        catch(e)
                        {

                        }
                      }

                    }
                    catch(e)
                    {}
                  });
                }
                catch(e)
                {
                  Map<dynamic,dynamic> cust = snapshot.value;
                  cust.forEach((key,values) {
                    try{
                      if(values['customer_id'].toString()==customerId.toString())
                      {
                        mobile=values['telephone'];
                        fname=values['firstname'];
                        lname=values['lastname'];
                        email=values['email'];
                        try{
                          if(values['status']=="False")
                          {
                            isDeactivated=true;
                          }

                        }
                        catch(e)
                        {

                        }
                      }

                    }
                    catch(e)
                    {}
                  });
                }

                if(!isDeactivated)
                {
                  Navigator.pushReplacement(context,
                      new MaterialPageRoute(builder: (context) => new Dashboard()));
                }
                else
                {

                  Navigator.pushReplacement(context,
                      new MaterialPageRoute(builder: (context) => new ActivateAccount()));
                }
              });
            }
            else
            {
              customerId = localStorage.get('guest_id');
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) => new mobileLogin()));
            }
          }

        }
        catch(e)
        {}
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                'images/Logo.png',
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.height/2,
              ),
            ),



          ],
        )
    );
  }
}