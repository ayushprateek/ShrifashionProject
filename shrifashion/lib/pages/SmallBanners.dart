
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrifashion/components/Color.dart';

import '../ImageURL.dart';
class SmallBanners extends StatefulWidget {
  var bannerName;

  SmallBanners(var bannerName) {
    this.bannerName = bannerName;
  }
  @override
  _SmallBannersState createState() => _SmallBannersState();
}
class _SmallBannersState extends State<SmallBanners> {

  List lists = [];
  List l = [];
  final banners = FirebaseDatabase.instance.reference().child("banners");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: banners.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          lists.clear();
          l.clear();
          List<dynamic> values = snapshot.data.snapshot.value;
          values.forEach((values) {
            //----CONDITION-----
            if (values['title'].toString().contains(widget.bannerName) && values['status']=="True")
              lists.add(values);
          });


          if (lists.isNotEmpty) {
            for(int i=0;i<lists.length;i++)
            {
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
                          child: Image.network(
                            snap.data.image,
                            cacheWidth: 500,
                            fit: BoxFit.fill,
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
                    Radius.circular(0),
                  ),

              ),
              height: MediaQuery.of(context).size.height / 8,
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
