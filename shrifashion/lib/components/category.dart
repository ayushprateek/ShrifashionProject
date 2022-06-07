import 'dart:async';
import 'dart:math';

import 'package:shrifashion/ImageURL.dart';

import 'package:shrifashion/StickyFooter.dart';
import 'package:shrifashion/ReadCtegoryData.dart';
import 'package:shrifashion/categories/ThirdScreen.dart';
import 'package:shrifashion/categories/SecondScreen.dart';
import 'package:shrifashion/components/Font.dart';

import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:shrifashion/components/ProductContainer.dart';
import 'package:shrifashion/navbar.dart';
import 'package:hexcolor/hexcolor.dart';

import '../BottomSheet.dart';
import '../CartIcon.dart';


import 'Color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}
class _CategoriesState extends State<Categories> {
  final products = FirebaseDatabase.instance.reference().child("search").limitToFirst(40);
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;

  final category = FirebaseDatabase.instance.reference().child("category").orderByChild("status").equalTo("True");
  List randomProducts=[];
  List lists=[];
  List lists2=[];





  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;


    return parsedString;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        leading:  IconButton(
            icon: new Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            }),
        title: Text(
          "Shop by Category",
          style: TextStyle(
              fontFamily: custom_font,
            color: Colors.black,
          ),
        ),

        actions: <Widget>[CartCount()],
      ),
      body: Container(color: Colors.white,
        child: ListView(
          children: [
            Container(

              width: MediaQuery.of(context).size.width,
              height: 50.0,
              padding: const EdgeInsets.only(
                  left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    showSearch(context: context, delegate: DataSearch());
                  },
                  child: ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(bottom: 13),
                      child: Text(
                        'Search banana,oil,potato..',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                          fontFamily: 'Source Sans Pro',
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    leading: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // CATEGORY LIST TILE

            StreamBuilder(
                stream: category.onValue,
                builder: (context, snapshot)  {

                  if (snapshot.hasData) {
                    lists2.clear();
                    try
                    {
                      Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                      if(values!=null)
                        values.forEach((key,values) {
                          if(values!=null)
                          try{
                            lists2.add(values);
                          }
                          catch(e)
                          {

                          }

                        });
                    }
                    catch(e)
                  {
                    List<dynamic> values = snapshot.data.snapshot.value;
                    if(values!=null)
                      values.forEach((values) {
                        if(values!=null)
                        try{
                          lists2.add(values);
                        }
                        catch(e)
                        {

                        }

                      });
                  }

                    if(lists2.isNotEmpty)
                      return ListView.builder(
                          itemCount: lists2.length,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final subCategory = FirebaseDatabase.instance.reference().child("categorysub_final").orderByChild("parent_id").equalTo(lists2[index]['category_id']);
                            Widget image;
                            image=FutureBuilder(
                                future: imageurl(context, lists2[index]['image'], FirebaseStorage.instance),
                                builder: (context,snap){
                                  Widget image=Container();
                                  if(snap.hasData)
                                  {

                                    try{
                                      image=Image.network(
                                        snap.data.image,
                                        fit: BoxFit.fill,
                                      );
                                    }
                                    catch(e)
                                    {
                                      image=Container();
                                    }
                                    return image;
                                  }
                                  else
                                  {
                                    return Container();
                                  }
                                }
                            );
                            return ExpansionTile(
                              leading: Container(
                                width: MediaQuery.of(context).size.width / 10,
                                height: MediaQuery.of(context).size.width / 10,
                                child: image,
                              ),
                              title: new Text(_parseHtmlString(lists2[index]['name'])),
                              children: [
                                FutureBuilder(
                                    future: FirebaseDatabase.instance.reference().child("categorysub_final").orderByChild("parent_id").equalTo(lists2[index]['category_id']).once(),
                                    builder: (context, snapshot)  {
                                      if (snapshot.hasData) {
                                        lists.clear();
                                        try
                                        {
                                          List<dynamic> values = snapshot.data.value;
                                          if(values!=null)
                                          values.forEach((values) {
                                            if(values!=null && values['status']=="True")
                                              lists.add(values);
                                          });
                                        }
                                        catch(e)
                                        {
                                          Map<dynamic,dynamic> values = snapshot.data.value;
                                          if(values!=null )
                                          values.forEach((key,values) {
                                            if(values!=null && values['status']=="True")
                                              lists.add(values);
                                          });
                                        }

                                        if(lists.isNotEmpty)
                                        {
                                          return ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: lists.length,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, index) {

                                              return FutureBuilder(
                                                future: imageurl(context, lists[index]["image"],FirebaseStorage.instance),
                                                builder: (context,snap){
                                                  if(snap.hasData)
                                                  {
                                                    Widget image;
                                                    try{
                                                      image=ClipRRect(
                                                          borderRadius: BorderRadius.circular(15),
                                                          child: Image.network(
                                                              snap.data.image,
                                                              fit: BoxFit.fill,
                                                              width: MediaQuery.of(context).size.width / 10,
                                                              height: MediaQuery.of(context).size.width / 10
                                                          ));
                                                    }
                                                    catch(e){
                                                      image=ClipRRect(
                                                          borderRadius: BorderRadius.circular(15),
                                                          child: Container(
                                                              width: MediaQuery.of(context).size.width / 10,
                                                              height: MediaQuery.of(context).size.width / 10
                                                          )
                                                      );
                                                    }
                                                    return  ListTile(
                                                      leading:Container(
                                                        width: MediaQuery.of(context).size.width / 10,
                                                        height: MediaQuery.of(context).size.width / 10,
                                                        child: image,
                                                      ),
                                                      title: new Text(_parseHtmlString(lists[index]['name'])),
                                                      trailing: Icon(Icons.keyboard_arrow_right),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder: (context) => ThirdScreen(
                                                                    lists[index]['category_id'],
                                                                    lists[index]['name'])));
                                                      },
                                                    );
                                                  }
                                                  else
                                                  {
                                                    return  ListTile(
                                                      leading:Container(
                                                          width: MediaQuery.of(context).size.width / 10,
                                                          height: MediaQuery.of(context).size.width / 10,
                                                          child:image
                                                      ),
                                                      title: new Text(_parseHtmlString(lists[index]['name'])),
                                                      trailing: Icon(Icons.keyboard_arrow_right),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                                builder: (context) => SecondScreen(
                                                                    lists[index]['category_id'],
                                                                    lists[index]['name'])));
                                                      },
                                                    );
                                                  }
                                                },

                                              );


                                            },
                                          );
                                        }
                                        else
                                        {
                                          return  ListTile(
                                            leading: Container(
                                                width: MediaQuery.of(context).size.width / 10,
                                                height: MediaQuery.of(context).size.width / 10,
                                                child: image,

                                            ),
                                            title: new Text(_parseHtmlString(lists2[index]['name'])),
                                            trailing: Icon(Icons.keyboard_arrow_right),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) => ThirdScreen(
                                                          lists2[index]['category_id'],
                                                          lists2[index]['name'])));
                                            },
                                          );
                                        }





                                      }
                                      else
                                      {
                                        return CircularProgressIndicator();
                                      }
                                    }

                                ),

                              ],
                            );
                          }
                      );
                    else
                      return
                        Container();
                  }
                  else
                  {
                    return Center(child: CircularProgressIndicator(),);
                  }
                }

            ),

            Padding(
              padding: const EdgeInsets.only(top:8.0,bottom: 8),
              child: Container(

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Featured Products",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: products.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  randomProducts.clear();
                  try
                  {
                    List<dynamic> values = snapshot.data.snapshot.value;
                    values.forEach((values) {
                      if(values!=null)
                      randomProducts.add(values);
                    });
                  }
                  catch(e)
                {
                  Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                  values.forEach((key,values) {
                    if(values!=null)
                      randomProducts.add(values);
                  });
                }
                  return GridView.builder(
                    physics: ScrollPhysics(),
                    itemCount: randomProducts.length,

                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,   childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.2)),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      String _unit =   double.parse(randomProducts[index]['weight'])
                          .toStringAsFixed(0) +
                          " "+randomProducts[index]['unit'];

                      String str = randomProducts[index]['name'].toString();
                      int len = str.length;
                      if (len >= 20) {
                        str = str.substring(0, 20) + "...";
                      }
                      var manufacturer= randomProducts[index]['store_name']==null?
                          "shrifashion":randomProducts[index]['store_name'];
                      return ProductContainer(
                        min_order_qty: randomProducts[index]['min_order_qty'],
                        manufacturer: manufacturer,
                        category_id: randomProducts[index]['category_id'],
                        name: randomProducts[index]['name'],
                        quantity: randomProducts[index]['quantity'],
                        minimun: randomProducts[index]['minimun'],
                        maximun: randomProducts[index]['maximun'],
                        stock_status_id: randomProducts[index]['stock_status_id'],
                        stock_status: randomProducts[index]['stock_status'],
                        tag: randomProducts[index]['tag'],
                        location: randomProducts[index]['location'],
                        weight: randomProducts[index]['weight'],
                        model: randomProducts[index]['model'],
                        product_id: randomProducts[index]['product_id'],
                        description: randomProducts[index]['description'],
                        new_price: randomProducts[index]['new_price'],
                        old_price: randomProducts[index]['old_price'],
                        image: randomProducts[index]['image'],
                        unit: randomProducts[index]['unit'],
                      );

                      // Text(snapshot.data[index].name,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),);
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: StickyFooter(),
    );
  }
}
