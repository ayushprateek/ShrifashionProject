import 'package:shrifashion/CartIcon.dart';
import 'package:shrifashion/ImageURL.dart';
import 'package:shrifashion/AddButton.dart';
import 'package:flutter/material.dart';import 'dart:convert';
import 'package:shrifashion/Service/CartInsert.dart';
import 'package:html/parser.dart';
import 'package:shrifashion/StickyFooter.dart';
import 'package:shrifashion/components/FilterBottomSheet.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/components/ProductContainer.dart';
import 'package:shrifashion/components/SortBottomSheet.dart';
import 'package:shrifashion/pages/SearchedItems.dart';
import 'BottomSheet.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
class SearchItemsQuantity extends StatefulWidget {
  var query1;
  SearchItemsQuantity(var query1)
  {
    this.query1=query1;
  }
  @override
  _SearchItemsQuantityState createState() => _SearchItemsQuantityState();
}

class _SearchItemsQuantityState extends State<SearchItemsQuantity> {

  var cartId, productId, quantity;
  final key = GlobalKey<ScaffoldState>();

  final products = FirebaseDatabase.instance.reference().child("search");
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  List searchedList=[];
  String sort_order="N";

  // 1.	PRICE RANGE
  // 2.	DISCOUNT
  // 3.	COLOUR
  // 4.	MATERIAL
  // 5.	CLOUSER TYPE
  // 6.	RUNNING SURFACE
  // 7.	ARCH TYPE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StickyFooter(),
      key: key,
      appBar: AppBar(
        leading:  IconButton(
            icon: new Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            }),
        actions: <Widget>[
          CartCount()
        ],
        title: Text(widget.query1,style: TextStyle(fontFamily: custom_font,color: Colors.black),),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                children: [
                  Divider(
                    thickness: 1,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/18,
                    child: Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            color: Theme.of(context).scaffoldBackgroundColor,

                              textColor:Theme.of(context).buttonColor,

                              onPressed: () async {

                                showModalBottomSheet(context: context,
                                  backgroundColor: Colors.transparent,
                                  isDismissible: false,
                                  builder: (BuildContext context) => FractionallySizedBox(
                                    heightFactor: 0.5,
                                    child:SortBottomSheet(sort_order),
                                  ),)
                                    .then((value) {
                                  if(value != null && value != "" && value!=sort_order)
                                  {
                                    setState(() {
                                      this.sort_order=value;
                                    });

                                  }
                                  print(value);
                                });
                              },
                              child:  FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "Sort",
                                    style: TextStyle(
                                      fontFamily: custom_font,
                                        color:Theme.of(context).buttonColor,
                                        fontSize: 17
                                    ),
                                  ))),
                        ),
                        VerticalDivider(
                          thickness: 1,
                        ),
                        Expanded(
                          child:FlatButton(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              onPressed: () async {
                                showModalBottomSheet(context: context,
                                  backgroundColor: Colors.transparent,
                                  isDismissible: false,
                                  builder: (BuildContext context) => FractionallySizedBox(
                                    heightFactor: 1.6,
                                    child:FilterBottomSheet(sort_order),
                                  ),)
                                    .then((value) {
                                  if(value != null && value != "" && value!=sort_order)
                                  {
                                    setState(() {
                                      this.sort_order=value;
                                    });

                                  }
                                  print(value);
                                });
                              },
                              child:  FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "Filter",
                                    style: TextStyle(
                                        fontFamily: custom_font,
                                      color:Theme.of(context).buttonColor,
                                      fontSize: 17
                                    ),
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: products.once(),
              builder: (context, snapshot) {


                if (snapshot.hasData) {

                  searchedList.clear();
                  try
                  {
                    List<dynamic> values = snapshot.data.value;
                    values.forEach((values) {
                      if(values!=null && values['name'].toString().toLowerCase().contains(widget.query1.toLowerCase()))
                        searchedList.add(values);
                    });
                  }
                  catch(e)
                {
                  Map<dynamic,dynamic> values = snapshot.data.value;
                  values.forEach((key,values) {
                    if(values!=null && values['name'].toString().toLowerCase().contains(widget.query1.toLowerCase()))
                      searchedList.add(values);
                  });
                }
                if(sort_order=="L")
                  {
                    // SORT LOW TO HIGH
                    for(int i=0;i<searchedList.length;i++)
                      {

                        for(int j=0;j<searchedList.length-1;j++)
                          {
                            double price1=
                            searchedList[j]["new_price"]!=null?
                            double.parse(searchedList[j]["new_price"].toString()):
                            double.parse(searchedList[j]["old_price"].toString());

                            double price2=
                            searchedList[j+1]["new_price"]!=null?
                            double.parse(searchedList[j+1]["new_price"].toString()):
                            double.parse(searchedList[j+1]["old_price"].toString());

                            if(price1>price2){
                              var temp=searchedList[j];
                              searchedList[j]=searchedList[j+1];
                              searchedList[j+1]=temp;
                            }
                          }
                      }

                  }
                else
                if(sort_order=="H")
                {
                  // SORT HIGH TO LOW
                  for(int i=0;i<searchedList.length;i++)
                  {

                    for(int j=0;j<searchedList.length-1;j++)
                    {
                      double price1=
                      searchedList[j]["new_price"]!=null?
                      double.parse(searchedList[j]["new_price"].toString()):
                      double.parse(searchedList[j]["old_price"].toString());

                      double price2=
                      searchedList[j+1]["new_price"]!=null?
                      double.parse(searchedList[j+1]["new_price"].toString()):
                      double.parse(searchedList[j+1]["old_price"].toString());

                      if(price1<price2){
                        var temp=searchedList[j];
                        searchedList[j]=searchedList[j+1];
                        searchedList[j+1]=temp;
                      }
                    }
                  }
                }


                  return GridView.builder(
                    physics: ScrollPhysics(),
                    itemCount: searchedList.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,   childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.2)),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {

                      var manufacturer= searchedList[index]['store_name']==null?
                      "shrifashion":searchedList[index]['store_name'];
                      return ProductContainer(
                        min_order_qty: searchedList[index]['min_order_qty'],
                        manufacturer: manufacturer,
                        category_id: searchedList[index]['category_id'],
                        name: searchedList[index]['name'],
                        quantity: searchedList[index]['quantity'],
                        minimun: searchedList[index]['minimun'],
                        maximun: searchedList[index]['maximun'],
                        stock_status_id: searchedList[index]['stock_status_id'],
                        stock_status: searchedList[index]['stock_status'],
                        tag: searchedList[index]['tag'],
                        location: searchedList[index]['location'],
                        weight: searchedList[index]['weight'],
                        model: searchedList[index]['model'],
                        product_id: searchedList[index]['product_id'],
                        description: searchedList[index]['description'],
                        new_price: searchedList[index]['new_price'],
                        old_price: searchedList[index]['old_price'],
                        image: searchedList[index]['image'],
                        unit: searchedList[index]['unit'],
                      );
                    },
                  );


                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

