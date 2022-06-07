
import 'package:firebase_database/firebase_database.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shrifashion/CartIcon.dart';


import 'package:shrifashion/StickyFooter.dart';

import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/components/ProductContainer.dart';
import 'package:shrifashion/navbar.dart';
import 'package:flutter/material.dart';

import 'package:html/parser.dart';


class ThirdScreen extends StatefulWidget {
  var categoryId,name;

  ThirdScreen(var categoryId,var name)
  {
    this.categoryId=categoryId;
    this.name=name;
  }
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}
class _ThirdScreenState extends State<ThirdScreen> {
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }


  var cartId,productId,quantity;
  final key=GlobalKey<ScaffoldState>();
  List lists=[];
  TextEditingController query=TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(bottom: 6.0,left: 4,right: 4,top: 15),
                child: Container(
                  height: MediaQuery.of(context).size.height/16,
                  child: TextFormField(
                    controller: query,
                    onChanged: (value){
                      setState(() {
                        query.text;
                      });
                    },
                    decoration: new InputDecoration(
                      filled: true,
                      labelText: 'Search',


                      //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                      fillColor: Colors.white,
                      hoverColor: Colors.red,
                      focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide:
                        new BorderSide(color: Theme.of(context).buttonColor,),
                      ),
                      //focusColor:HexColor("#27ab87"),
                      // isDense: true,
                      hintText: "Search",
                      // fillColor: Colors.red,

                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),


                    //keyboardType: TextInputType.number,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseDatabase.instance.reference().child("search").onValue,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.hasData) {
                    lists.clear();
                    print("Firebase products");
                    try
                    {
                      List<dynamic> values = snapshot.data.snapshot.value;
                      if(values!=null)
                      values.forEach((values) {
                        //----CONDITION-----
                        if(values!=null && values['category_id']==widget.categoryId
                        &&( query.text.isNotEmpty?values['name'].toString().toUpperCase().contains(query.text.toUpperCase()):true))
                          lists.add(values);
                      });
                      if(lists.isEmpty)
                      {
                        values.forEach((values) {
                          //----CONDITION-----
                          if(values!=null && values['parent_id']==widget.categoryId
                              &&( query.text.isNotEmpty?values['name'].toString().toUpperCase().contains(query.text.toUpperCase()):true))
                            lists.add(values);

                        });
                      }
                    }
                    catch(e)
                    {
                      Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                      if(values!=null)
                      values.forEach((key,values) {
                        //----CONDITION-----
                        if(values!=null &&values['category_id']==widget.categoryId  && (query.text.isNotEmpty?values['name'].toString().toUpperCase().contains(query.text.toUpperCase()):true))
                          lists.add(values);

                      });
                      if(lists.isEmpty)
                      {
                        values.forEach((key,values) {
                          //----CONDITION-----
                          if(values!=null && values['parent_id']==widget.categoryId  && (query.text.isNotEmpty?values['name'].toString().toUpperCase().contains(query.text.toUpperCase()):true))
                            lists.add(values);

                        });
                      }
                    }
                    //if(query.text.isNotEmpty?lists[index]['name'].toString().toUpperCase().contains(query.text.toUpperCase()):true)




                    if(lists.isNotEmpty)
                    {
                      return GridView.builder(
                        physics: ScrollPhysics(),
                        itemCount: lists.length,
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: MediaQuery.of(context).size.width /
                                (MediaQuery.of(context).size.height / 1.2)),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          var manufacturer= lists[index]['store_name']==null?
                          "shrifashion":lists[index]['store_name'];

                          return ProductContainer(
                            min_order_qty: lists[index]['min_order_qty'],
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

            ],
          ),
        ),
      ),
    );
  }
}
