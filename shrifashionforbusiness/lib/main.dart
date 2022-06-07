import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/PartnerDetails.dart';
import 'package:shrifashionforbusiness/LoginSignup/LoginPage.dart';
import 'package:shrifashionforbusiness/UI/HomePage.dart';
import 'package:shrifashionforbusiness/UI/Login.dart';
// import 'package:shrifashionforbusiness /test.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrifashionforbusiness/test.dart';
import 'package:video_player/video_player.dart';
SharedPreferences localStorage;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
  MaterialColor colorCustom = MaterialColor(0xFF302f2c, color);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(
          color:HexColor("#302f2c"),
        ),
        accentIconTheme: IconThemeData(
          color:HexColor("#302f2c"),
        ),
        primaryIconTheme: IconThemeData(
          color:HexColor("#302f2c"),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color:  HexColor("#F1EFE4"),
        ),
        appBarTheme: AppBarTheme(
          elevation: 10.0,
          backgroundColor:  HexColor("#F1EFE4"),
        ),
        buttonColor: HexColor("#302f2c"),
        primarySwatch:colorCustom,
        scaffoldBackgroundColor: HexColor("#F1EFE4"),
        accentColor: HexColor("#302f2c"),
      ),
       home: MyApp(),
      //home:  CustomPickMultipleImages(),
    ),);
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
  Future<void> video;
  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    //categoryData().readCategoryData();
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
    // Platform messages may fail, so we use a try/catch PlatformException.
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

    try{
      localStorage = await SharedPreferences.getInstance();
      //localStorage.setString("partner_id", null);
      PartnerDetails.partner_id = localStorage.get('partner_id');
      print(PartnerDetails.partner_id);
      // print(PartnerDetails.partner_id);
      //localStorage.setString("guest_id", null);
      print("Inside try");
      print(PartnerDetails.partner_id);
    }
    catch(e)
    {
    }
    if (PartnerDetails.partner_id != null) {
      bool isDeactivated=false;
      final customer = FirebaseDatabase.instance.reference().child("partners");
      customer.once().then((DataSnapshot snapshot) {
        try
        {
          List<dynamic> cust = snapshot.value;
          cust.forEach((values) {
            try{
              if(values['partner_id'].toString()==PartnerDetails.partner_id.toString())
              {
                PartnerDetails.name=values['name'];
                PartnerDetails.store_id=values['store_id'];
                PartnerDetails.store_address=values['store_address'];
                PartnerDetails.store_name=values['store_name'];
                PartnerDetails.email=values['email'];
                PartnerDetails.image_name=values['image'];


                try{
                  if(values['status']=="Disapproved")
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
              if(values['partner_id'].toString()==PartnerDetails.partner_id.toString())
              {
                PartnerDetails.name=values['name'];
                PartnerDetails.store_id=values['store_id'];
                PartnerDetails.store_address=values['store_address'];
                PartnerDetails.store_name=values['store_name'];
                PartnerDetails.email=values['email'];
                PartnerDetails.image_name=values['image'];
                try{
                  if(values['status']=="Disapproved")
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
          Timer(
              Duration(seconds: 3,milliseconds: 500),
                  () => Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) => new HomePage())));

        }
        else
        {
          Fluttertoast.showToast(msg: "Your account has been deactivated");

          // Navigator.pushReplacement(context,
          //     new MaterialPageRoute(builder: (context) => new ActivateAccount()));
        }
      });
    }
    else
    {
      PartnerDetails.partner_id = localStorage.get('guest_id');
      Timer(
          Duration(seconds: 3,milliseconds: 500),
              () => Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => new mobileLogin())));

    }
    print("navigation");
   



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    'images/Logo.png',
                    // height: MediaQuery.of(context).size.height,
                    // width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              SpinKitRipple(color: Theme.of(context).buttonColor,)
            ])
    );
  }
}

