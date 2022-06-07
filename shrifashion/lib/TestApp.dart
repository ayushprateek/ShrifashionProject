
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:html/parser.dart';
import 'package:shrifashion/DynamicLinks/Create.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/pages/ProductDetails.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestApp(),
    );
  }
}
class TestApp extends StatefulWidget {

  @override
  _TestAppState createState() => _TestAppState();
}
class _TestAppState extends State<TestApp> {


  final key=GlobalKey<ScaffoldState>();
  void initDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print("Navigating");
      // Navigator.pushNamed(context, deepLink.path);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
          deepLink.path.substring(12),
          "name"
      )));
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            print("Navigating");
            print(deepLink.path);

            print("/product_id=114".substring(12));
            // Navigator.pushNamed(context, deepLink.path);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                deepLink.path.substring(12),
                "name"
            )));
            Navigator.pushNamed(context, deepLink.path);
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );
  }
  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final customers = FirebaseDatabase.instance.reference().child("manage_stock");
    return Scaffold(
        key: key,

        body: Center(
          child: ElevatedButton(
            onPressed: ()async{
              String str=await DynamicLinksService.createDynamicLink("product_id=113");
              print(str);
            },
            child: Text("Hello"
            ),
          ),
        )
    );
  }
}
