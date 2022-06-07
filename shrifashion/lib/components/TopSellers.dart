
import 'package:shrifashion/ImageURL.dart';
import 'package:shrifashion/AddButton.dart';
import 'package:shrifashion/Service/CartInsert.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/ProductContainer.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
class TopBrands extends StatefulWidget {
  @override
  _TopBrandsState createState() => _TopBrandsState();
}

class _TopBrandsState extends State<TopBrands> {
  var cartId, productId, quantity;
  final key = GlobalKey<ScaffoldState>();

  final products = FirebaseDatabase.instance.reference().child("brands");
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
    return Container(
      child: StreamBuilder(
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
                if(values!=null)
                  lists.add(values);
              });
              if(lists.isEmpty)
              {
                values.forEach((values) {
                  //----CONDITION-----
                  if(values!=null)
                    lists.add(values);

                });
              }
            }
            catch(e)
            {
              Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
              values.forEach((key,values) {
                //----CONDITION-----
                if(values!=null )
                  lists.add(values);

              });
              if(lists.isEmpty)
              {
                values.forEach((key,values) {
                  //----CONDITION-----
                  if(values!=null)
                    lists.add(values);

                });
              }
            }




            if(lists.isNotEmpty)
            {
              print("Length");
              print(lists.length);
              return GridView.builder(
                physics: ScrollPhysics(),
                itemCount: 9,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height /1.5)),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index) {
                  Widget image=Container(
                    width: MediaQuery.of(context)
                        .size
                        .width /
                        2.5,
                  );
                  var link;
                  image= FutureBuilder(
                      future: imageurl(context,lists[index]['image'], FirebaseStorage.instance),
                      builder: (context,snap){
                        Widget image=Container(
                          width: MediaQuery.of(context)
                              .size
                              .width /
                              2.5,
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
                                  2.5,
                            );
                          }
                          catch(e)
                          {
                            image=Container(
                              width: MediaQuery.of(context)
                                  .size
                                  .width /
                                  2.5,
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
                                2.5,
                          );
                        }
                      }
                  );

                  var manufacturer= lists[index]['manufacturer']==null?
                  "shrifashion":lists[index]['manufacturer'];

                  return Container(
                    margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).buttonColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: (){
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: image,
                                      ),
                                    ],
                                  ),
                                ),
                                flex: 3, //elevation: 10,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child:Container(),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            lists[index]['name'].toString(),
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                ),
                                flex: 4, //elevation: 10,
                              )
                            ],
                          ),
                        ),
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
      ),
    );
  }
}
