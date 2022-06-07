
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shrifashion/CartIcon.dart';
import 'package:shrifashion/StickyFooter.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/components/ProductContainer.dart';
import 'package:shrifashion/components/SubCategories.dart';
import 'package:shrifashion/navbar.dart';
import 'package:shrifashion/pages/banner.dart';

import '../SubCategoryQuantity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SecondScreen extends StatefulWidget {
  var categoryId, name, productId;
  SecondScreen(var categoryId, var name) {
    this.categoryId = categoryId;
    this.name = name;
  }
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  var cartId, productId, quantity;


  final cart = FirebaseDatabase.instance.reference().child("cart");
  final cartLast = FirebaseDatabase.instance.reference().child("cart").limitToLast(1);
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;

  List lists=[];
  List lists2=[];

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  final key = GlobalKey<ScaffoldState>();
  List myList=[];
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;
  bool hasCompleted=false;

  bool isSet=false;
  _getMoreData() {
    int max= _currentMax + 10;
    if(max>lists.length)
    {
      hasCompleted=true;
      max=lists.length;
    }
    for (int i = _currentMax; i < max; i++) {
      myList.add(lists[i]);
    }

    _currentMax = _currentMax + 10;

    setState(() {});
  }
  void initState()
  {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final products = FirebaseDatabase.instance.reference().child("search").orderByChild("parent_id").equalTo(widget.categoryId);



    return Scaffold(
      bottomNavigationBar: new StickyFooter(),
      key: key,
      appBar: new AppBar(
        title: Text(
          _parseHtmlString(widget.name),
          style: TextStyle(fontFamily: custom_font,
          color: Theme.of(context).buttonColor),
        ),

        actions: <Widget>[CartCount()],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child:banner(widget.name.toString().toUpperCase()),
              ),
              //SUB CATEGORY
              SubCategories(widget.categoryId),
              //SubCategoryQuantity(widget.categoryId),
              Container(
                child: StreamBuilder(
                  stream: products.onValue,
                  builder: (context, snapshot) {
                    print(snapshot.connectionState);
                    if (snapshot.hasData) {
                      lists.clear();
                      try
                      {
                        List<dynamic> values = snapshot.data.snapshot.value;
                        if(values!=null)
                          values.forEach((values) {
                            //----CONDITION-----
                            // if(values['parent_id']==widget.categoryId)
                            if(values!=null)
                              lists.add(values);
                          });
                      }
                      catch(e)
                      {
                        Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                        if(values!=null)
                          values.forEach((key,values) {
                            //----CONDITION-----
                            // if(values['parent_id']==widget.categoryId)
                            if(values!=null)
                              lists.add(values);
                          });
                      }





                      if(lists.isNotEmpty)
                      {
                        if(!isSet)
                        {
                          isSet=true;
                          int max=10;
                          if(max>=lists.length)
                          {
                            hasCompleted=true;
                            max=lists.length;
                          }

                          myList = List.generate(max, (i) => lists[i]);
                        }
                        return GridView.builder(
                          physics: ScrollPhysics(),
                          itemCount: myList.length + 1,
                          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,   childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.2)),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, index) {
                            if (index == myList.length) {
                              if(hasCompleted)
                              {
                                return Container();
                              }
                              return Center(child: CupertinoActivityIndicator());
                            }
                            var data;
                            String _unit;String str;
                            data = snapshot.data;

                            try{
                              _unit = double.parse(lists[index]['weight']).toStringAsFixed(0) +
                                  " " +
                                  lists[index]['unit'];

                              str = lists[index]['name'].toString();

                            }
                            catch(e)
                            {
                              print(e.toString());
                            }
                            var manufacturer= lists[index]['manufacturer']==null?
                            "Ecomandi":lists[index]['manufacturer'];

                            return ProductContainer(
                              min_order_qty: lists[index]['min_order_qty'],
                              unit: lists[index]['unit'],
                              name: lists[index]['name'],
                              image: lists[index]['image'],
                              old_price: lists[index]['old_price'],
                              new_price: lists[index]['new_price'],
                              description: lists[index]['description'],
                              product_id: lists[index]['product_id'],
                              model: lists[index]['model'],
                              weight: lists[index]['weight'],
                              location: lists[index]['location'],
                              tag: lists[index]['tag'],
                              category_id: lists[index]['category_id'],
                              stock_status: lists[index]['stock_status'],
                              stock_status_id: lists[index]['stock_status_id'],
                              manufacturer: manufacturer,
                              maximun: lists[index]['maximun'],
                              minimun: lists[index]['minimun'],
                              quantity: lists[index]['quantity'],
                            );






                            Text(snapshot.data[index].name,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),);
                          },
                        );
                      }
                      else
                      {
                        final products = FirebaseDatabase.instance.reference().child("categorysuballproduct_final").orderByChild("category_id").equalTo(widget.categoryId);
                        return Container(
                          child: StreamBuilder(
                            stream: products.onValue,
                            builder: (context, snapshot) {
                              print(snapshot.connectionState);
                              if (snapshot.hasData) {
                                lists.clear();
                                try
                                {
                                  List<dynamic> values = snapshot.data.snapshot.value;
                                  if(values!=null)
                                    values.forEach((values) {
                                      //----CONDITION-----
                                      // if(values['parent_id']==widget.categoryId)
                                      if(values!=null)
                                        lists.add(values);
                                    });
                                }
                                catch(e)
                                {
                                  Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                                  if(values!=null)
                                    values.forEach((key,values) {
                                      //----CONDITION-----
                                      // if(values['parent_id']==widget.categoryId)
                                      if(values!=null)
                                        lists.add(values);
                                    });
                                }



                                if(lists.isNotEmpty)
                                {
                                  if(!isSet)
                                  {
                                    isSet=true;
                                    int max=10;
                                    if(max>=lists.length)
                                    {
                                      hasCompleted=true;
                                      max=lists.length;
                                    }

                                    myList = List.generate(10, (i) => lists[i]);
                                  }
                                  return GridView.builder(
                                    physics: ScrollPhysics(),

                                    itemCount: myList.length + 1,
                                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,   childAspectRatio: MediaQuery.of(context).size.width /
                                        (MediaQuery.of(context).size.height / 6)),
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, index) {
                                      if (index == myList.length) {
                                        if(hasCompleted)
                                        {
                                          return Container();
                                        }
                                        return Center(child: CupertinoActivityIndicator());
                                      }
                                      var data;
                                      String _unit;String str;
                                      data = snapshot.data;
                                      try{
                                        _unit = double.parse(lists[index]['weight']).toStringAsFixed(0) +
                                            " " +
                                            lists[index]['unit'];

                                        str = lists[index]['name'].toString();

                                      }
                                      catch(e)
                                      {
                                        print(e.toString());
                                      }
                                      var manufacturer= lists[index]['manufacturer']==null?
                                      "Ecomandi":lists[index]['manufacturer'];

                                      return ProductContainer(
                                        min_order_qty: lists[index]['min_order_qty'],
                                        unit: lists[index]['unit'],
                                        name: lists[index]['name'],
                                        image: lists[index]['image'],
                                        old_price: lists[index]['old_price'],
                                        new_price: lists[index]['new_price'],
                                        description: lists[index]['description'],
                                        product_id: lists[index]['product_id'],
                                        model: lists[index]['model'],
                                        weight: lists[index]['weight'],
                                        location: lists[index]['location'],
                                        tag: lists[index]['tag'],
                                        category_id: lists[index]['category_id'],
                                        stock_status: lists[index]['stock_status'],
                                        stock_status_id: lists[index]['stock_status_id'],
                                        manufacturer: manufacturer,
                                        maximun: lists[index]['maximun'],
                                        minimun: lists[index]['minimun'],
                                        quantity: lists[index]['quantity'],
                                      );






                                      Text(snapshot.data[index].name,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),);
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

                    } else {
                      print("Snapshot is null");
                    }

                    return Container();
                  },
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}

