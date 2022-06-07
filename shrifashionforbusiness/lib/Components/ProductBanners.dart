

import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrifashionforbusiness/Components/GetImageUrl.dart';
import 'package:shrifashionforbusiness/Components/ProductImage.dart';

class ProductBanners extends StatefulWidget {

  var product_id,name;
  ProductBanners(var product_id,var name) {
    this.product_id = product_id;
    this.name=name;
  }
  @override
  _ProductBannersState createState() => _ProductBannersState();
}
class _ProductBannersState extends State<ProductBanners> {
  List lists = [];
  List l = [];
  final banners = FirebaseDatabase.instance.reference().child("prod_images");
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
      stream: banners.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          lists.clear();
          l.clear();
          List<dynamic> values = snapshot.data.snapshot.value;
          values.forEach((values) {
            //----CONDITION-----
            if (values['product_id']==widget.product_id)
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
                          child: InkWell(
                            onTap: (){
                              //prod_image_id
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductImage(lists[i]['prod_image_id'],widget.name)));
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
                  .height / 2.0,
              child: new Carousel(
                boxFit: BoxFit.cover,
                images: l,
                dotBgColor: Colors.purple.withOpacity(0),
                borderRadius: true,
                dotSize: 6.0,
                dotColor: Colors.black,

                dotSpacing: 15.0,
                autoplay: false,
                animationCurve: Curves.fastOutSlowIn,
                // animationDuration: Duration(milliseconds: 500),
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
