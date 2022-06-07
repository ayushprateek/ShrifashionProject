
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrifashion/components/Color.dart';

import '../ImageURL.dart';
class banner extends StatefulWidget {
  var bannerName;
  banner(var bannerName)
  {
    this.bannerName = bannerName;
  }
  @override
  _bannerState createState() => _bannerState();
}
class _bannerState extends State<banner> {
  List lists = [];
  List l = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final banners = FirebaseDatabase.instance.reference().child("banners").orderByChild("title").equalTo(widget.bannerName);
    return StreamBuilder(
      stream: banners.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          lists.clear();
          l.clear();
          try
          {
            Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
            if(values!=null)
              values.forEach((key,values) {
                //----CONDITION-----
                if (values!=null && values['status']=="True")
                  lists.add(values);
              });
          }
          catch(e)
        {
          List<dynamic> values = snapshot.data.snapshot.value;
          if(values!=null)
            values.forEach((values) {
              //----CONDITION-----
              if (values!=null && values['status']=="True")
                lists.add(values);
            });
        }



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
                            child: Container(
                                color: Colors.grey[200]
                            ));
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
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),

              ),
              height: MediaQuery.of(context).size.height / 4,
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
