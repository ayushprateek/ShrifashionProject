import 'package:shrifashion/BottomSheet.dart';
import 'package:shrifashion/CartIcon.dart';


import 'package:shrifashion/AddButton.dart';
import 'package:shrifashion/SearchItemsQuantity.dart';
import 'package:shrifashion/categories/SecondScreen.dart';
import 'package:shrifashion/components/AppName.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/components/ProductContainer.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'package:shrifashion/pages/SearchedItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:shrifashion/pages/Cart.dart';

import 'ImageURL.dart';
import 'Map.dart';


import 'components/Color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

//int counter=0;
int itemCount;

class NavbarOnly extends StatefulWidget {
  static var address;
  @override
  _NavbarOnlyState createState() => _NavbarOnlyState();
}

class _NavbarOnlyState extends State<NavbarOnly> {
  final address = FirebaseDatabase.instance.reference().child("address");
  List lists=[];
  int numOfAddress=0;
  var future_address;
  @override
  void initState()
  {
    super.initState();
    future_address=address.once();
    final deliveryCharge = FirebaseDatabase.instance.reference().child("deliveryCharge");

    deliveryCharge.once().then((DataSnapshot snapshot) {
      try{
        Map<dynamic,dynamic> values = snapshot.value;
        payableDeliveryCharge=double.parse(values[0]['charge'].toString());
      }
      catch(e)
      {
        List<dynamic> values = snapshot.value;
        payableDeliveryCharge=double.parse(values[0]['charge'].toString());
      }

    });

  }
  @override
  Widget build(BuildContext context) {


    return AppBar(
      elevation: 0.1,
      title: Column(

        children: <Widget>[
          Align(alignment: Alignment.topLeft, child: Text(app_name,style: TextStyle(
              fontFamily: custom_font
          ),)),
          Align(
            alignment: Alignment.bottomLeft,
            child: FutureBuilder(
              future: future_address,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  lists.clear();
                  numOfAddress=0;
                  List<dynamic> values = snapshot.data.value;
                  values.forEach((values) {
                    try{
                      if(values['customer_id']==customerId && values['status']=="1")
                      {
                        lists.add(values);
                        numOfAddress++;
                      }
                    }
                    catch(e)
                    {

                    }
                  });

                  if(lists.isNotEmpty)
                  {
                    NavbarOnly.address=
                        lists[0]['address_1'].toString().toUpperCase()+" "
                            +lists[0]['city'].toString().toUpperCase()+" "
                            +lists[0]['State'].toString().toUpperCase()+" "
                            +lists[0]['Country'].toString().toUpperCase()+" "
                            +lists[0]['postcode'].toString();
                    return GestureDetector(
                      onTap: () {
                        if(numOfAddress>=4)
                        {
                          Fluttertoast.showToast(
                              msg:
                              "You can not add more than 4 addresses",
                              toastLength: Toast
                                  .LENGTH_SHORT,
                              gravity:
                              ToastGravity
                                  .BOTTOM,
                              timeInSecForIosWeb:
                              1,
                              fontSize: 16.0);
                        }
                        else
                        {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder){
                                return new Container(
                                  height: MediaQuery.of(context).size.height/3,
                                  //could change this to Color(0xFF737373),
                                  //so you don't have to change MaterialApp canvasColor
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          topRight: const Radius.circular(10.0))),

                                  child:
                                  Column(
                                    children: [

                                      Align(
                                          alignment: Alignment.centerLeft, child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: new Text("Search Location",style: TextStyle(fontFamily: 'Source Sans Pro'),),
                                      )),

                                      GestureDetector(
                                        onTap: () {

                                          Navigator.of(context).pop(context);
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) => new MapScreen())).then((value) => setState((){}));


                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.near_me,),
                                              Flexible(
                                                  child: Text(
                                                    "Use Current Location",
                                                    style: TextStyle(fontSize: 14,
                                                      color: Theme.of(context).buttonColor,),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop(context);

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_on,),
                                              Flexible(
                                                  child: Text(
                                                    "Add a saved location",
                                                    style: TextStyle(fontSize: 14,
                                                      color: Theme.of(context).buttonColor,),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                );
                              }
                          );
                        }

                      },
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          NavbarOnly.address==null?
                          Flexible(
                              child: Text(
                                "Your Location",
                                style: TextStyle(fontSize: 14,fontFamily: 'Source Sans Pro'),
                              )):
                          Flexible(
                              child: Text(
                                NavbarOnly.address,
                                style: TextStyle(fontSize: 14,fontFamily: custom_font),
                              ))
                        ],
                      ),
                    );
                  }
                  else
                  {
                    return GestureDetector(
                      onTap: () {
                        // handle your click here
                        showModalBottomSheet(
                            context: context,
                            builder: (builder){
                              return new Container(
                                height: MediaQuery.of(context).size.height/3,
                                //could change this to Color(0xFF737373),
                                //so you don't have to change MaterialApp canvasColor
                                decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(10.0),
                                        topRight: const Radius.circular(10.0))),

                                child:
                                Column(
                                  children: [

                                    Align(
                                        alignment: Alignment.centerLeft, child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Text("Search Location" ,style: TextStyle(
                                          fontFamily: 'Source Sans Pro'
                                      ),),
                                    )),

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop(context);
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) => new MapScreen())).then((value) => setState((){}));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.near_me,
                                            ),
                                            Flexible(
                                                child: Text(
                                                  "Use Current Location",
                                                  style: TextStyle(fontSize: 14,
                                                      color:Theme.of(context).buttonColor,
                                                      fontFamily: 'Source Sans Pro'
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          NavbarOnly.address==null?
                          Flexible(
                              child: Text(
                                "Your Location",
                                style: TextStyle(fontSize: 14,
                                    fontFamily: 'Source Sans Pro'
                                ),
                              )):
                          Flexible(
                              child: Text(
                                NavbarOnly.address,
                                style: TextStyle(fontSize: 14,fontFamily: custom_font),
                              ))
                        ],
                      ),
                    );
                  }

                }
                return GestureDetector(
                  onTap: () {
                    // handle your click here
                    showModalBottomSheet(
                        context: context,
                        builder: (builder){
                          return new Container(
                            height: MediaQuery.of(context).size.height/3,
                            //could change this to Color(0xFF737373),
                            //so you don't have to change MaterialApp canvasColor
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0))),

                            child:
                            Column(
                              children: [

                                Align(
                                    alignment: Alignment.centerLeft, child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Text("Search Location" ,style: TextStyle(
                                      fontFamily: 'Source Sans Pro'
                                  ),),
                                )),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(context);
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => new MapScreen())).then((value) => setState((){}));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.near_me,
                                        ),
                                        Flexible(
                                            child: Text(
                                              "Use Current Location",
                                              style: TextStyle(fontSize: 14,
                                                  color:Theme.of(context).buttonColor,
                                                  fontFamily: 'Source Sans Pro'
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      NavbarOnly.address==null?
                      Flexible(
                          child: Text(
                            "Your Location",
                            style: TextStyle(fontSize: 14,
                                fontFamily: 'Source Sans Pro'
                            ),
                          )):
                      Flexible(
                          child: Text(
                            NavbarOnly.address,
                            style: TextStyle(fontSize: 14,fontFamily: custom_font),
                          ))
                    ],
                  ),
                );
              },
            ),
          )

        ],
      ),

      actions: <Widget>[
        CartCount()
      ],
    );
  }
}
class DataSearch extends SearchDelegate<String> {
  final products = FirebaseDatabase.instance.reference().child("search");
  //final suggestion = FirebaseDatabase.instance.reference().child("categorysuballproduct_final");
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  List searchedList=[];
  List lists=[];
  List list1=[];
  List list2=[];
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;


    return parsedString;
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    //actions of appbar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];


  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }
  @override
  Widget buildResults(BuildContext context) {
    // Navigator.of(context).pop();
   // Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchItemsQuantity(query)));
     showResults(context);
    return  SearchItemsQuantity(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView(
        children: [

          Container(
            height: 20.0,
          ),
          Container(
            child: StreamBuilder(
              stream: products.onValue,
              builder: (context, snapshot) {

                if (snapshot.hasData) {
                  try
                  {
                    List<dynamic> values = snapshot.data.snapshot.value;
                    values.forEach((values) {
                      //----CONDITION-----
                      if(values!=null && values['parent_id']=="59")
                        lists.add(values);
                    });
                    if(lists.isEmpty)
                    {
                      values.forEach((values) {
                        //----CONDITION-----
                        if(values!=null && values['category_id']=="59")
                          lists.add(values);
                      });
                    }
                  }
                  catch(e) {
                    Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                    values.forEach((key,values) {
                      //----CONDITION-----
                      if(values!=null && values['parent_id']=="59")
                        lists.add(values);
                    });
                    if(lists.isEmpty)
                    {
                      values.forEach((kay,values) {
                        //----CONDITION-----
                        if(values!=null && values['category_id']=="59")
                          lists.add(values);
                      });
                    }
                }

                  if(lists.isNotEmpty)
                  {
                    int len=lists.length;

                    if(len>=7)
                    {
                      len=7;
                    }


                    return GridView.builder(
                      physics: ScrollPhysics(),
                      itemCount: len,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.2)),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {

                        var manufacturer=lists[index]['manufacturer']==null?'shrifashion':lists[index]['manufacturer'];


                        return ProductContainer(
                          min_order_qty:lists[index]['min_order_qty'],
                          manufacturer: manufacturer,
                          category_id: lists[index]['category_id'],
                          name: lists[index]['name'],
                          quantity: lists[index]['quantity'],
                          minimun: lists[index]['minimun'],
                          maximun: lists[index]['maximun'],
                          stock_status_id: lists[index]['stock_status_id'],
                          stock_status: lists[index]['stock_status'],
                          tag: lists[index]['tag'],
                          location: lists[index]['location'],
                          weight: lists[index]['weight'],
                          model: lists[index]['model'],
                          product_id: lists[index]['product_id'],
                          description: lists[index]['description'],
                          new_price: lists[index]['new_price'],
                          old_price: lists[index]['old_price'],
                          image: lists[index]['image'],
                          unit: lists[index]['unit'],
                        );






                        //Text(snapshot.data[index].name,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),);
                      },
                    );
                  }
                  else
                  {
                    return Container();
                  }

                }

                return Container();
              },
            ),
          ),

          Container(
            height: 20.0,
          ),

          // VEGETABLES



          //FRUITS
        ],
      );
    } else {
      return FutureBuilder(
        future: products.once(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            searchedList.clear();

            try
            {
              List<dynamic> values = snapshot.data.value;
              values.forEach((values) {
                if(values!=null && values['name'].toString().toLowerCase().contains(query.toLowerCase()))
                  searchedList.add(values);
              });
            }
            catch(e)
          {
            Map<dynamic,dynamic> values = snapshot.data.value;
            values.forEach((key,values) {
              if(values!=null && values['name'].toString().toLowerCase().contains(query.toLowerCase()))
                searchedList.add(values);
            });
          }





            return ListView.builder(
              physics: ScrollPhysics(),
              itemCount: searchedList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index) {
                var data = snapshot.data;
                return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      showResults(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              new SearchItemsQuantity(searchedList[index]['name'])));
                    },
                    leading: Icon(Icons.search),
                    title: Text(searchedList[index]['name']));
              },
            );
          }
          return ListTile(
              onTap: () {
                showResults(context);
              },
              leading: Icon(Icons.search),
              title: Container());
        },
      );
    }
  }
}



