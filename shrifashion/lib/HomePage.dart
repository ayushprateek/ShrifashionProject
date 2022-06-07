import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shrifashion/CartIcon.dart';
import 'package:shrifashion/CustomDrawer.dart';
import 'package:shrifashion/Map.dart';
import 'package:shrifashion/Service/CustomLaunchURL.dart';
import 'package:shrifashion/Service/DatabaseConnections.dart';
import 'package:shrifashion/StickyFooter.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/components/HomePageCategory.dart';
import 'package:shrifashion/components/Footer.dart';
import 'package:shrifashion/components/TodaysDeal.dart';
import 'package:shrifashion/components/TopSellers.dart';
import 'package:shrifashion/navbar.dart';
import 'package:shrifashion/pages/ProductDetails.dart';
import 'package:shrifashion/pages/SmallBanners.dart';
import 'package:shrifashion/pages/banner.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/Color.dart';
class Dashboard extends StatefulWidget
{
  @override
  _DashboardState createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  final key = GlobalKey<ScaffoldState>();
  void initDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print("Navigating");
      String name;
      String product_id=deepLink.path.substring(12);
      search.orderByChild("product_id").equalTo(product_id).once().then((snapshot) {
        try
        {
          Map<dynamic,dynamic> values=snapshot.value;
          if(values!=null)
            values.forEach((key, value) {
              if(value!=null)
                name=value['name'];
            });
        }
        catch(e)
        {
          List<dynamic> values=snapshot.value;
          if(values!=null)
            values.forEach((value) {
              if(value!=null)
                name=value['name'];
            });
        }
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
            product_id,
            name
        )));
      });
      // Navigator.pushNamed(context, deepLink.path);
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
      //     deepLink.path.substring(12),
      //     "name"
      // )));
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            print("Navigating");
            print(deepLink.path);
            String name;
            String product_id=deepLink.path.substring(12);
            search.orderByChild("product_id").equalTo(product_id).once().then((snapshot) {
              try
                  {
                    Map<dynamic,dynamic> values=snapshot.value;
                    if(values!=null)
                      values.forEach((key, value) {
                        if(value!=null)
                          name=value['name'];
                      });
                  }
                  catch(e)
              {
                List<dynamic> values=snapshot.value;
                if(values!=null)
                  values.forEach((value) {
                    if(value!=null)
                      name=value['name'];
                  });
              }
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                  product_id,
                  name
              )));
            });

            // print("/product_id=114".substring(12));
            // Navigator.pushNamed(context, deepLink.path);


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
    return Scaffold(
        key: key,
        bottomNavigationBar: StickyFooter(),
        drawer: CustomDrawer(),
        appBar: AppBar(
          leading:  IconButton(
              icon: new Icon(Icons.menu,size: 30,),
              onPressed: () => key.currentState.openDrawer()),
          elevation: 0.0,

          actions: [
            CartCount()
            //IconButton(onPressed: (){}, icon: Icon(Icons.add_shopping_cart,color: Colors.black,))
          ],
          title: Column(
            children: <Widget>[
              Align(alignment: Alignment.topLeft, child: Container(
                height: 50.0,
                padding: const EdgeInsets.only(
                    left: 0.0, top: 15.0, right: 0.0, bottom: 0.0),
                child: Text("Hi Manish",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: custom_font,


                  ),
                ),
              ),),



            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Icon(Icons.search,),

                            Text("What are you looking for?"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(height: MediaQuery.of(context).size.height/6.5,child: HomePageCategory()),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: banner('HOME BANNER 1'),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: SmallBanners('OFFER BANNER 1'),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text("Categories",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 17
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: banner('HOME BANNER 2'),
                  // ),

                  TodaysDeal(false),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SmallBanners('OFFER BANNER 2'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Chappals",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17
                        ),
                      ),
                    ),
                  ),
                  Footer(parent_id: "89",name: "CHAPPALS",),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Kurti for Women",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17
                        ),
                      ),
                    ),
                  ),
                  Footer(parent_id: "90",name: "KURTI",),
                  FutureBuilder(
                      future: admin.once(),
                      builder: (context,snapshot){
                        if(!snapshot.hasData)
                          return Container();
                        var data=snapshot.data.value;
                        return Container(
                          color: Theme.of(context).buttonColor,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('About Us\n',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                   data[0]['description'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,
                                    fontSize: 15,
                                    //fontWeight: FontWeight.bold
                                  )
                              ),
                              Text('Follow Us\n',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(onPressed: (){
                                    customLaunchURL(data[0]['facebook']);
                                  }, icon: Icon(Icons.facebook,color: Colors.white,size: 40,)),
                                  IconButton(onPressed: (){
                                    customLaunchURL(data[0]['twitter']);
                                  }, icon: Icon(FlutterIcons.logo_twitter_ion,color: Colors.white,size: 40,)),
                                  IconButton(onPressed: (){
                                    customLaunchURL(data[0]['instagram']);
                                  }, icon: Icon(FlutterIcons.logo_instagram_ion,color: Colors.white,size: 40,))
                                ],
                              ),
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5),
                                child: Divider(color: Colors.white70,),
                              ),
                              Text(
                                  "All copyrights reserved by Shrifashion",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white70,
                                    fontSize: 15,
                                    //fontWeight: FontWeight.bold
                                  )
                              ),

                            ],
                          ),
                        );

                      }),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: SmallBanners('HOME BANNER 1'),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text("Women Sports wear",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 17
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Footer(parent_id: "57",name: "WOMEN SPORTS WEAR",),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: banner('FOOTER BANNER 1'),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text("Top Brands",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 17
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // TopBrands(),




                ],
              ),
            )),

    );
  }
}

