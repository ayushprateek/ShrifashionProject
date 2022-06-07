import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shrifashion/CartIcon.dart';
import 'package:shrifashion/DynamicLinks/Create.dart';
import 'package:shrifashion/ImageURL.dart';
import 'package:shrifashion/Service/CRUD.dart';
import 'package:shrifashion/Service/DatabaseConnections.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:flutter_share/flutter_share.dart';
class CustomPickMultipleImages extends StatefulWidget {
  @override
  _CustomPickMultipleImagesState createState() => _CustomPickMultipleImagesState();
}

class _CustomPickMultipleImagesState extends State<CustomPickMultipleImages> {


  @override
  void initState() {
    super.initState();
  }
  void shareImage(String imageUrl) async {
    final response = await http.get(imageUrl);
    final bytes = response.bodyBytes;
    final Directory temp = await getTemporaryDirectory();
    final File imageFile = File('${temp.path}/tempImage.png');
    imageFile.writeAsBytesSync(response.bodyBytes);
    FlutterShare.shareFile(title: "Test",filePath: '${temp.path}/tempImage.png', text: 'Test Description',);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Pick multiple image'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Share"),
          onPressed: (){
            //shareImage("https://shuchibusiness.in/assets/images/img-05.jpg");
            shareImage("https://shrisolutions.com/uploads/about_01.jpg");
          },
        ),
      ),
    );
  }

}
class ProductDetails extends StatefulWidget {
  String product_id, name;
  ProductDetails(String product_id,String name)
  {
    this.product_id=product_id;
    this.name=name;
  }
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}
class _ProductDetailsState extends State<ProductDetails> {
  bool enabled=true;
  List lists=[],l=[];
  String imageUrl,description;
  void shareImage(BuildContext context) async {
    final response = await http.get(imageUrl);
    final bytes = response.bodyBytes;
    final Directory temp = await getTemporaryDirectory();
    final File imageFile = File('${temp.path}/ProductImage.png');
    imageFile.writeAsBytesSync(response.bodyBytes);
    Navigator.pop(context);
    FlutterShare.shareFile(title: widget.name,filePath: '${temp.path}/ProductImage.png', text: description,);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name,
          style: TextStyle(
            fontFamily: custom_font,
            color: Colors.black
          ),
        ),
        actions: <Widget>[CartCount()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                StreamBuilder(
                  stream: FirebaseDatabase.instance.reference().child("prod_images").orderByChild("product_id").equalTo(widget.product_id).onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      lists.clear();
                      l.clear();
                      try
                      {
                        Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                        if(values!=null)
                          values.forEach((key,values) {
                            //----CONDITION-----
                            if (values!=null)
                              lists.add(values);
                          });
                      }
                      catch(e)
                      {
                        List<dynamic> values = snapshot.data.snapshot.value;
                        if(values!=null)
                          values.forEach((values) {
                            //----CONDITION-----
                            if (values!=null)
                              lists.add(values);
                          });
                      }
                      if (lists.isNotEmpty) {
                        for(int i=0;i<lists.length;i++)
                        {
                          l.add(FutureBuilder(
                            future: imageurl(context, lists[i]['image'],
                                FirebaseStorage.instance),
                            builder: (context, snap) {
                              if (snap.hasData) {
                                try {
                                  if(i==0)
                                    {
                                      imageUrl=snap.data.image;
                                    }
                                  return Image.network(
                                    snap.data.image,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height/2.4,
                                    cacheWidth: 999,
                                    fit: BoxFit.fill,
                                  );
                                }
                                catch (e) {
                                  return Container();
                                }
                              }
                              else {
                                return Container();
                              }
                            },
                          ),);

                        }
                        return Container(
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.all(
                          //     Radius.circular(15),
                          //   ),
                          //
                          // ),
                          height: MediaQuery.of(context).size.height/2.4,
                          child: new Carousel(
                            boxFit: BoxFit.cover,
                            images: l,
                            dotBgColor: Colors.purple.withOpacity(0),
                            borderRadius: true,
                            dotSize: 4.0,
                            dotSpacing: 15.0,
                            autoplay: true,
                            animationCurve: Curves.fastOutSlowIn,
                            animationDuration: Duration(milliseconds: 500),
                          ),
                        );
                      }
                      else {
                        return Container();
                      }
                    }

                    return Container();
                  },
                ),
                Positioned(
                  top: 25,
                    right: 20,
                  child: IconButton(
                    onPressed: () async{
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content:Container(
                                height: MediaQuery.of(context).size.height/20,
                                width: MediaQuery.of(context).size.width/1.5,
                                child: Center(child: CircularProgressIndicator(),)),

                          );
                        },
                      );
                      String str=await DynamicLinksService.createDynamicLink("product_id=${widget.product_id}");
                      print(str);
                      description+="\n$str";
                      shareImage(context);
                    },
                    icon: Icon(Icons.share,color: Theme.of(context).buttonColor,size: 30,),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 30),
              child: StreamBuilder(
                stream: FirebaseDatabase.instance.reference().child("search").orderByChild("product_id").equalTo(widget.product_id).onValue,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.hasData) {
                    var data;

                    try
                    {
                      List<dynamic> values = snapshot.data.snapshot.value;
                      if(values!=null)
                        values.forEach((values) {
                          //----CONDITION-----
                          if(values!=null )
                            data=values;
                        });

                    }
                    catch(e)
                    {
                      Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                      if(values!=null)
                        values.forEach((key,values) {
                          if(values!=null )
                            data=values;
                        });
                    }
                    if(data!=null)
                    {
                      double margin=double.parse(data['old_price'].toString())-double.parse(data['new_price'].toString());
                      description="Name: " +data['name']+"\nPrice: "+data['new_price']+"\nMRP:"+data['old_price']+"\nMargin: "+margin.toString()+"\nDescription:"+data['description'];
                      String min_order_qty=data['min_order_qty']==null||data['min_order_qty']==""?"1":data['min_order_qty'];
                      return   Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(data['name'],
                                style: TextStyle(
                                  fontFamily: custom_font,
                                  fontSize: 22
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("From: "+data['store_name'],
                                style: TextStyle(
                                  fontFamily: custom_font,
                                  fontSize: 15
                                ),
                              ),
                            ),
                            data['old_price']!=null && data['old_price']!=""?
                            Row(
                              children: [
                                Text("\u{20b9}"+double.parse(data['new_price'].toString()).toStringAsFixed(0),
                                  style: TextStyle(
                                    fontFamily: custom_font,
                                    fontSize: 22
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text("\u{20b9}"+double.parse(data['old_price'].toString()).toStringAsFixed(0),
                                  style: TextStyle(

                                    fontSize: 15,
                                    decoration: TextDecoration.lineThrough
                                  ),
                                ),

                              ],
                            ) :
                            Text("\u{20b9}"+double.parse(data['new_price'].toString()).toStringAsFixed(0),
                              style: TextStyle(
                                  fontFamily: custom_font,
                                  fontSize: 22
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Margin: \u{20b9}"+margin.toString(),
                                style: TextStyle(
                                    fontFamily: custom_font,
                                    fontSize: 19
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Order in the pack of : "+min_order_qty+" "+data['unit'],
                                style: TextStyle(
                                    fontFamily: custom_font,
                                    fontSize: 20
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 3,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Discription",
                                style: TextStyle(
                                    fontFamily: custom_font,
                                    color: Colors.grey
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(data['description'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                    fontSize: 15
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              thickness: 3,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            StreamBuilder(
                              stream: cart2.onValue,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var quantity;
                                  try{
                                    Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                                    if(values!=null)
                                      values.forEach((key,value){
                                        try{
                                          if(value!=null)
                                            if(value['customer_id'].toString()==customerId.toString() && value['product_id']==widget.product_id)
                                              quantity=value['quantity'];
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
                                      values.forEach((value){
                                        try{
                                          if(value!=null)
                                            if(value['customer_id'].toString()==customerId.toString() && value['product_id']==widget.product_id)
                                              quantity=value['quantity'];
                                        }
                                        catch(e)
                                        {

                                        }
                                      });
                                  }
                                  if(quantity==0||quantity==null)
                                  {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height/17,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,

                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black54,
                                            blurRadius: 10.0,
                                            spreadRadius: 5,
                                            offset: const Offset(0.0, 5.0),
                                          ),
                                        ],
                                      ),
                                      child: RaisedButton(
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: BorderRadius.circular(15.0),
                                        // ),
                                          textColor: Colors.white,
                                          // color: barColor,
                                          onPressed: () async {
                                            if(enabled)
                                              {
                                                enabled=false;
                                                addToCart(data['image'], data['name'], data['old_price'], data['new_price'], data['product_id'], data['unit'], data['weight'], data['stock_status_id'], data['stock_status'], data['category_id'], data['store_name'],data['min_order_qty']);
                                              }

                                          },
                                          child:  FittedBox(
                                              fit: BoxFit.contain,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "ADD TO CART",
                                                    style: TextStyle(fontSize: 20,color: Colors.white70),
                                                  ),
                                                  SizedBox(width: 15,),

                                                  Icon(Icons.add_shopping_cart,color: Colors.white70)
                                                ],
                                              ),
                                            ),)),
                                    );
                                  }
                                  else{
                                    enabled=true;
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height/17,
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.rectangle,

                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black54,
                                                  blurRadius: 10.0,
                                                  spreadRadius: 5,
                                                  offset: const Offset(0.0, 5.0),
                                                ),
                                              ],
                                            ),
                                            child: RaisedButton(
                                              // shape: RoundedRectangleBorder(
                                              //   borderRadius: BorderRadius.circular(15.0),
                                              // ),
                                                textColor: Colors.white,
                                                // color: barColor,
                                                onPressed: () async {
                                                  int x=int.parse(quantity);
                                                  // x--;
                                                  int min_order_qty=int.tryParse(data['min_order_qty'].toString())??1;
                                                  x-=min_order_qty;
                                                  updateCart(x,widget.product_id);
                                                },
                                                child:  Icon(Icons.remove,color: Colors.white70,)
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Container(
                                            child: Center(child: Text(
                                                quantity,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: custom_font
                                              ),
                                            )),

                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height/17,
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.rectangle,

                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black54,
                                                  blurRadius: 10.0,
                                                  spreadRadius: 5,
                                                  offset: const Offset(0.0, 5.0),
                                                ),
                                              ],
                                            ),
                                            child: RaisedButton(
                                              // shape: RoundedRectangleBorder(
                                              //   borderRadius: BorderRadius.circular(15.0),
                                              // ),
                                                textColor: Colors.white,
                                                // color: barColor,
                                                onPressed: () async {
                                                  int x=int.parse(quantity);
                                                  //x++;
                                                  int min_order_qty=int.tryParse(data['min_order_qty'].toString())??1;
                                                  x+=min_order_qty;
                                                  updateCart(x,widget.product_id);
                                                },
                                                child:  Icon(Icons.add,color: Colors.white70,)
                                            ),
                                          ),
                                        ),



                                      ],
                                    );
                                  }
                                }
                                else {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height/17,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,

                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 10.0,
                                          spreadRadius: 5,
                                          offset: const Offset(0.0, 5.0),
                                        ),
                                      ],
                                    ),
                                    child: RaisedButton(
                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius: BorderRadius.circular(15.0),
                                      // ),
                                        textColor: Colors.white,
                                        // color: barColor,
                                        onPressed: () async {
                                          if(enabled)
                                          {
                                            enabled=false;
                                            addToCart(data['image'], data['name'], data['old_price'], data['new_price'], data['product_id'], data['unit'], data['weight'], data['stock_status_id'], data['stock_status'], data['category_id'], data['store_name'],data['min_order_qty']);
                                          }
                                        },
                                        child:  FittedBox(
                                            fit: BoxFit.contain,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "ADD TO CART",
                                                  style: TextStyle(fontSize: 20,color: Colors.white70),
                                                ),
                                                SizedBox(width: 15,),

                                                Icon(Icons.add_shopping_cart,color: Colors.white70)
                                              ],
                                            ),
                                          ),
                                        )),
                                  );

                                }

                              },
                            ),
                          ],
                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}
