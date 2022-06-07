
import 'package:shrifashion/ImageURL.dart';
import 'package:shrifashion/AddButton.dart';
import 'package:shrifashion/Service/CartInsert.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:shrifashion/categories/SecondScreen.dart';
import 'package:shrifashion/components/ProductContainer.dart';
//FeaturedProducts
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
class HomePageCategory extends StatefulWidget {
  @override
  _HomePageCategoryState createState() => _HomePageCategoryState();
}

class _HomePageCategoryState extends State<HomePageCategory> {
  var cartId, productId, quantity;
  final key = GlobalKey<ScaffoldState>();

  final products = FirebaseDatabase.instance.reference().child("category");
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  var future_products;
  @override
  void initState()
  {
    future_products=products.onValue;
    super.initState();
  }
  List lists=[];


  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: future_products,
      builder: (context, snapshot) {
        print(snapshot.connectionState);
        if (snapshot.hasData) {
          lists.clear();

          try
          {
            List<dynamic> values = snapshot.data.snapshot.value;
            values.forEach((values) {
              //----CONDITION-----
              if(values!=null && values['status']=="True")
                lists.add(values);
            });
            if(lists.isEmpty)
            {
              values.forEach((values) {
                //----CONDITION-----
                if(values!=null && values['status']=="True")
                  lists.add(values);

              });
            }
          }
          catch(e)
          {
            Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
            values.forEach((key,values) {
              //----CONDITION-----
              if(values!=null && values['status']=="True")
                lists.add(values);

            });
            if(lists.isEmpty)
            {
              values.forEach((key,values) {
                //----CONDITION-----
                if(values!=null && values['status']=="True")
                  lists.add(values);

              });
            }
          }




          if(lists.isNotEmpty)
          {
            return ListView.builder(
              physics: ScrollPhysics(),
              itemCount: lists.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index) {

                var link;
                Widget image= ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: FutureBuilder(
                      future: imageurl(context,lists[index]['image'], FirebaseStorage.instance),
                      builder: (context,snap){
                        Widget image=Container(
                        );
                        if(snap.hasData)
                        {
                          link=snap.data.image;

                          try{
                            image=Image.network(
                              snap.data.image,
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context)
                                  .size
                                  .width /
                                  5,
                              height: MediaQuery.of(context)
                                  .size
                                  .width /
                                  5,
                            );
                          }
                          catch(e)
                          {
                            image=Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width /
                                  5,
                              height: MediaQuery.of(context)
                                  .size
                                  .width /
                                  5,
                            );
                          }
                          return image;
                        }
                        else
                        {
                          return Container(
                            width: MediaQuery.of(context)
                                .size
                                .width /
                                5,
                          );
                        }
                      }
                  ),
                );

                var manufacturer= lists[index]['manufacturer']==null?
                "shrifashion":lists[index]['manufacturer'];

                return Container(
                  margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context)=>SecondScreen(lists[index]['category_id'], lists[index]['name']))));
                    },
                    child: Column(
                      children: [
                        image,
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 15),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              lists[index]['name'].toString(),
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          else
          {
            return Container();
          }

        } else {
          print("Snapshot is null");
        }

        return Container();
      },
    );
  }
}
