import 'package:shrifashion/CartIcon.dart';
import 'package:shrifashion/ImageURL.dart';
import 'package:shrifashion/AddButton.dart';
import 'package:shrifashion/Service/CartInsert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:shrifashion/StickyFooter.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/components/ProductContainer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
class TodaysDeal extends StatefulWidget {
  bool displayAll;
  TodaysDeal(bool displayAll){
    this.displayAll=displayAll;
  }
  @override
  _TodaysDealState createState() => _TodaysDealState();
}
class _TodaysDealState extends State<TodaysDeal> {
  var cartId, productId, quantity;
  final key = GlobalKey<ScaffoldState>();
  final products = FirebaseDatabase.instance.reference().child("search").limitToLast(8);
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
            if(values!=null)
            values.forEach((values) {
              //----CONDITION-----
              if(values!=null)
                lists.add(values);
            });
            if(lists.isEmpty)
            {
              if(values!=null)
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
            if(values!=null)
            values.forEach((key,values) {
              //----CONDITION-----
              if(values!=null )
                lists.add(values);

            });
            if(lists.isEmpty)
            {
              if(values!=null)
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
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Today's Deals",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                          ),
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (){
                            Widget AllDeals=Scaffold(
                              bottomNavigationBar: new StickyFooter(),
                              appBar: new AppBar(
                                title: Text(
                                  "All Deals",
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
                                      SizedBox(height: 15,),
                                      TodaysDeal(true),
                                    ],
                                  ),
                                ),
                              ) ,
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AllDeals));
                          },
                          child: Text("Show All",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                  physics: ScrollPhysics(),
                  itemCount: widget.displayAll?lists.length:8,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.2)),
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
                    var manufacturer= lists[index]['store_name']==null?
                    "Shrifashion":lists[index]['store_name'];
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
                ),
              ],
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
