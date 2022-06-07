import 'package:shrifashion/ImageURL.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:shrifashion/components/ProductContainer.dart';

import 'BottomSheet.dart';
import 'AddButton.dart';
import 'Service/CartInsert.dart';


import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
class SubCategoryQuantity extends StatefulWidget {
  var categoryId;
  SubCategoryQuantity(var categoryId)
  {
    this.categoryId=categoryId;
  }
  @override
  _SubCategoryQuantityState createState() => _SubCategoryQuantityState();
}

class _SubCategoryQuantityState extends State<SubCategoryQuantity> {
  var cartId, productId, quantity;
  final key = GlobalKey<ScaffoldState>();

  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  //final products = FirebaseDatabase.instance.reference().child("categorysuballproduct_final");
  final products = FirebaseDatabase.instance.reference().child("search");
  var future_products;
  List lists=[];
  @override
  void initState()
  {
    future_products=products.once();
    super.initState();
  }



  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;


    return parsedString;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: products.onValue,
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.hasData) {
            print('Category');
            lists.clear();
            print(widget.categoryId);

            try
            {
              List<dynamic> values = snapshot.data.snapshot.value;
              values.forEach((values) {
                //----CONDITION-----

                if(values!=null && values['category_id']==widget.categoryId)
                  lists.add(values);
              });
              if(lists.isEmpty)
              {
                values.forEach((values) {
                  //----CONDITION-----
                  if(values!=null && values['parent_id']==widget.categoryId)
                    lists.add(values);
                });
              }
            }
            catch(e)
          {
            Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
            values.forEach((key,values) {
              //----CONDITION-----
              if(values!=null && values['category_id']==widget.categoryId)
                lists.add(values);
            });
            if(lists.isEmpty)
            {
              values.forEach((key,values) {
                //----CONDITION-----
                if(values!=null && values['parent_id']==widget.categoryId)
                  lists.add(values);
              });
            }
          }






            if(lists.isNotEmpty)
              {
                return GridView.builder(
                  physics: ScrollPhysics(),
                  itemCount: lists.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,   childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 6)),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    

                    var manufacturer= lists[index]['manufacturer']==null?
                    "shrifashion":lists[index]['manufacturer'];

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
}
