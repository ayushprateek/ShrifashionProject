
import 'package:shrifashion/categories/ThirdScreen.dart';
import 'package:shrifashion/categories/SecondScreen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../ImageURL.dart';
class HomeBanner extends StatefulWidget {
  var bannerName;
  HomeBanner(var bannerName) {
    this.bannerName = bannerName;
  }
  @override
  _HomeBannerState createState() => _HomeBannerState();
}
class _HomeBannerState extends State<HomeBanner> {

  List lists = [];
  List l = [];
  final banners = FirebaseDatabase.instance.reference().child("banners");

  var future_banner;
  @override
  void initState() {
    super.initState();
    // readbannersData();
    future_banner=banners.onValue;


  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: future_banner,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          lists.clear();
          l.clear();
          List<dynamic> values = snapshot.data.snapshot.value;
          values.forEach((values) {
            //----CONDITION-----
            if (values['status']=="True" && values['title'].toString().contains(widget.bannerName))
              lists.add(values);
          });


          if (lists.isNotEmpty) {
            for(int i=0;i<lists.length;i++)
            {
              if(i==2)
                l.add(FutureBuilder(
                  future: imageurl(context, lists[i]['image'],
                      FirebaseStorage.instance),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      try {
                        return ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(17),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => ThirdScreen(
                                        "60","ORGANIC SPICES")));
                              },
                              child: Image.network(
                                snap.data.image,
                                cacheWidth: 500,
                                fit: BoxFit.fill,
                              ),
                            ));
                      }
                      catch (e) {
                        return ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(17),
                            ),
                            child: Container());
                      }
                    }
                    else {
                      return Container();
                    }
                  },
                ),);
              else
              if(i==1)
                l.add(FutureBuilder(
                  future: imageurl(context, lists[i]['image'],
                      FirebaseStorage.instance),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      try {
                        return ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(17),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => SecondScreen(
                                        "59","STAPLES")));
                              },
                              child: Image.network(
                                snap.data.image,
                                cacheWidth: 500,
                                fit: BoxFit.fill,
                              ),
                            ));
                      }
                      catch (e) {
                        return ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(17),
                            ),
                            child: Container());
                      }
                    }
                    else {
                      return Container();
                    }
                  },
                ),);
              else
              if(i==3)
                l.add(FutureBuilder(
                  future: imageurl(context, lists[i]['image'],
                      FirebaseStorage.instance),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      try {
                        return ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(17),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => SecondScreen(
                                        "62","VEGETABLE")));
                              },
                              child: Image.network(
                                snap.data.image,
                                cacheWidth: 500,
                                fit: BoxFit.fill,
                              ),
                            ));
                      }
                      catch (e) {
                        return ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(17),
                            ),
                            child: Container());
                      }
                    }
                    else {
                      return Container();
                    }
                  },
                ),);
              else
              if(i==4)
                l.add(FutureBuilder(
                  future: imageurl(context, lists[i]['image'],
                      FirebaseStorage.instance),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      try {
                        return ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(17),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => SecondScreen(
                                        "61","FRUITS")));
                              },
                              child: Image.network(
                                snap.data.image,
                                cacheWidth: 500,
                                fit: BoxFit.fill,
                              ),
                            ));
                      }
                      catch (e) {
                        return ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(17),
                            ),
                            child: Container());
                      }
                    }
                    else {
                      return Container();
                    }
                  },
                ),);
              else
                l.add(FutureBuilder(
                  future: imageurl(context, lists[i]['image'],
                      FirebaseStorage.instance),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      try {
                        return ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(17),
                            ),
                            child: InkWell(
                              onTap: (){ },
                              child: Image.network(
                                snap.data.image,
                                cacheWidth: 500,
                                fit: BoxFit.fill,
                              ),
                            ));
                      }
                      catch (e) {
                        return ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(17),
                            ),
                            child: Container());
                      }
                    }
                    else {
                      return Container();
                    }
                  },
                ),);


            }
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Colors.white),
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 4,
              child: new Carousel(
                boxFit: BoxFit.cover,
                images: l,
                dotBgColor: Colors.purple.withOpacity(0),
                borderRadius: true,
                dotSize: 4.0,
                dotSpacing: 15.0,
                autoplay: true,
                animationCurve: Curves.fastOutSlowIn,
                animationDuration: Duration(milliseconds: 500),
              ),
            );
          }
          else {
            return Container();
          }
        }

        return Container();
      },
    );
  }
}
