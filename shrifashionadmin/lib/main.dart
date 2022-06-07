import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/UI/HomePage.dart';
import 'package:shrifashionadmin/UI/Login.dart';
import 'package:shrifashionadmin/test.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
SharedPreferences localStorage;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(primarySwatch:Colors.green,
          accentColor: barColor,
        highlightColor: barColor,
          scrollbarTheme: ScrollbarThemeData().copyWith(
        thumbColor: MaterialStateProperty.all(barColor),
      ),),
      home: MyApp(),
       // home:  CustomPickMultipleImages(),
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
    print("navigation");
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (context) => new HomePage()));
      // Timer(
      //     Duration(seconds: 3,milliseconds: 500),
      //         () => Navigator.pushReplacement(context,
      //         new MaterialPageRoute(builder: (context) => new Login())));



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        backgroundColor: barColor,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(),
              // Center(
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(15.0),
              //     child: Image.asset(
              //       'images/veg_logo4.jpeg',
              //       // height: MediaQuery.of(context).size.height,
              //       // width: MediaQuery.of(context).size.width,
              //     ),
              //   ),
              // ),
              //SpinKitRipple(color: backColor,)
            ])
    );
  }
}

