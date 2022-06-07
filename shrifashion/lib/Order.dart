

import 'package:shrifashion/BottomSheet.dart';
import 'package:shrifashion/CartIcon.dart';
import 'package:shrifashion/ImageURL.dart';
import 'package:shrifashion/SendEmail.dart';
import 'package:shrifashion/components/Font.dart';

import 'package:shrifashion/pages/Cart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

import 'components/Color.dart';

import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
class Order extends StatefulWidget {
  var orderId,date,status;
  Order(var order_id,var date,var status)
  {
    this.orderId=order_id;
    this.date=date;
    this.status=status;
  }



  @override
  _OrderState createState() => _OrderState();
}
//String orderSummaryTable="<table><tr><th>Name</th><th>Price</th></tr> $nameprice </table>";
String orderSummary="<table><tr><th>Name</th><th>Quantity</th><th>Price</th></tr>$orderProductNamePrice</table>";
String orderProductNamePrice;
String bill;
class _OrderState extends State<Order> {
  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  final key = GlobalKey<ScaffoldState>();
  var itemPrice,savedPrice,deliveriCharge,total;
  final order_ids = FirebaseDatabase.instance.reference().child("order_ids");
  final orders = FirebaseDatabase.instance.reference().child("orders");
  List list_summary=[];
  List list_address=[];
  List list_products=[];
  String method;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.height;

    return Scaffold(

      key: key,
      appBar: new AppBar(
        title: Text('My Orders',style: TextStyle(fontFamily: custom_font,color: Colors.black),),
        leading:  IconButton(
            icon: new Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        actions: <Widget>[
          CartCount()

        ],
      ),
      body: ListView(
        children: [

          //ORDERID AND DATE
          Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(5.0, 2.0),
                ),
              ],
            ),
            margin: EdgeInsets.only(left: 8, top: 8, right: 8),
            height: _height / 10,
            child: Padding(
              padding: EdgeInsets.only(left: _width / 50, top: _width / 70),
              child: Text("Order ID - " +widget.orderId +"\n\n"+
                  "Order Date - "+ widget.date),
            ),
          ),
          StreamBuilder(
            stream: order_ids.onValue,
            builder: (context, snapshot) {
              List<dynamic> values ;
              list_summary.clear();
              try{
                values = snapshot.data.snapshot.value;
                values.forEach((values) {
                  try{
                    if(values['order_id']==widget.orderId.toString())
                    {
                      list_summary.add(values);

                    }
                  }
                  catch(e){
                  }
                });
              }catch(e){

              }

              if (list_summary.isNotEmpty) {
                bill="";
                return GridView.builder(
                  physics: ScrollPhysics(),
                  itemCount: 1,
                  scrollDirection: Axis.vertical,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 6),
                  ),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {

                    String cost="";
                    cost=!list_summary[index]['total'].toString().startsWith('0')? double.parse(list_summary[index]['productCost']).toStringAsFixed(2)
                        :
                    double.parse(list_summary[index]['total']).toStringAsFixed(2);
                     bill="<tr><td>Sub Total</td><td>$cost</td></tr>";
                     String total= (double.parse(list_summary[index]['total']) ).toStringAsFixed(2);
                     bill+="<tr><td>Total</td><td>$total</td></tr>";

                    return Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(Consts.padding),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(5.0, 2.0),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 8, right: 8,top: 8.0,bottom: 8.0),
                      height: _height/5,

                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0,right: 15),
                            child: Column(
                              children: [
                                Align(
                                  alignment:Alignment.centerLeft,
                                  child: Text(
                                    "Summary",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                Divider(),
                                Table(
                                  children: [
                                    TableRow(children: [
                                      Text(list_summary[0]['numOfProducts']+" * Total Item Price",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.left),
                                      !list_summary[index]['total'].toString().startsWith('0')? Text("\u{20B9}${(double.parse(list_summary[index]['productCost'])).toStringAsFixed(2)}",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right):
                                      Text("\u{20B9}${(double.parse(list_summary[index]['total'])).toStringAsFixed(2)}",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),


                                    TableRow(children: [
                                      Text(
                                        "Delivery Charges",
                                        textScaleFactor: 1,
                                        textAlign: TextAlign.left,
                                      ),
                                      double.parse(list_summary[index]['productCost'])<600? Text(

                                          "\u{20B9}${ 30.toStringAsFixed(2)}",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right):Text(

                                          "\u{20B9}${0.toStringAsFixed(2)}",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),
                                  ],
                                ),

                                list_summary[index]['coupon']!=null?Table(
                                  // textDirection: TextDirection.rtl,
                                  // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                                  //border:TableBorder.all(width: 1.0,color: Colors.blue),
                                  children: [

                                    TableRow(children: [
                                      Text(
                                        list_summary[index]['coupon']+" Used",
                                        textScaleFactor: 1,
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                          "\u{20B9}${(double.parse(list_summary[index]['discount']) ).toStringAsFixed(2)}",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),
                                  ],
                                ):Table(),

                                list_summary[index]['store_credit']!=null?Table(
                                  // textDirection: TextDirection.rtl,
                                  // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                                  //border:TableBorder.all(width: 1.0,color: Colors.blue),
                                  children: [

                                    TableRow(children: [
                                      Text(
                                        "Store credit used",
                                        textScaleFactor: 1,
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                          "\u{20B9}${(double.parse(list_summary[index]['store_credit']) ).toStringAsFixed(2)}",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),
                                  ],
                                ):Table(),


                                Divider(),
                                Table(
                                  // textDirection: TextDirection.rtl,
                                  // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                                  //border:TableBorder.all(width: 1.0,color: Colors.blue),
                                  children: [

                                    TableRow(children: [
                                      Text(
                                        "Total Amount",
                                        textScaleFactor: 1,
                                        textAlign: TextAlign.left,
                                      ),
                                      !list_summary[index]['total'].toString().startsWith('0')? Text(

                                          "\u{20B9}${(double.parse(list_summary[index]['total']) ).toStringAsFixed(2)}",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right):
                                      Text(

                                          "\u{20B9}${(double.parse(list_summary[index]['total']) ).toStringAsFixed(2)}",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //),
                    );
                  },
                );
              } else {
                return Container();
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top:20.0,bottom: 4.0,left: 22.0),
            child: Text(
              "Payment Method",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          StreamBuilder(
            stream: order_ids.onValue,
            builder: (context, snapshot) {
              List<dynamic> values ;
              list_address.clear();
              try{
                values = snapshot.data.snapshot.value;
                values.forEach((values) {
                  try{
                    if(values['order_id']==widget.orderId.toString())
                    {
                      method=values['payment_code'];

                    }
                  }
                  catch(e){
                  }
                });
              }catch(e){

              }

              if (method!=null) {
                method=method=="null"?"cod":method;

                return GridView.builder(
                  physics: ScrollPhysics(),
                  itemCount: 1,
                  scrollDirection: Axis.vertical,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 10),
                  ),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(Consts.padding),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(5.0, 2.0),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 8, right: 8,top: 8.0,bottom: 8.0),
                      height: _height/2,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0,right: 15),
                            child: Column(
                              children: [
                                Table(
                                  children: [
                                    TableRow(children: [
                                      Text("Paid Via",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.left),
                                      Text(method.toUpperCase(),
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),



                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //),
                    );
                  },
                );
              } else {
                return Container();
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top:20.0,bottom: 4.0,left: 22.0),
            child: Text(
              "Shipping address",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder(
            stream: order_ids.onValue,
            builder: (context, snapshot) {
              List<dynamic> values ;
              list_address.clear();
              try{
                values = snapshot.data.snapshot.value;
                values.forEach((values) {
                  try{
                    if(values['order_id']==widget.orderId.toString())
                    {
                      list_address.add(values);

                    }
                  }
                  catch(e){
                  }
                });
              }catch(e){

              }

              if (list_address.isNotEmpty) {
                bill="";
                return GridView.builder(
                  physics: ScrollPhysics(),
                  itemCount: 1,
                  scrollDirection: Axis.vertical,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 3.5),
                  ),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(Consts.padding),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(5.0, 2.0),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 8, right: 8,top: 8.0,bottom: 8.0),
                      height: _height/2,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0,right: 15),
                            child: Column(
                              children: [
                                Table(
                                  children: [
                                    TableRow(children: [
                                      Text("Shipping location",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.left),
                                      Text(list_address[index]['shipping_company'],
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),
                                    TableRow(children: [
                                      Text("Name",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.left),
                                      Text(list_address[index]['shipping_firstname']+" "+list_address[index]['shipping_lastname'],
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),
                                    TableRow(children: [
                                      Text("Shipping flat",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.left),
                                      Text(list_address[index]['shipping_flat'],
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),
                                    TableRow(children: [
                                      Text("Society",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.left),
                                      Text(list_address[index]['shipping_society'],
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),
                                    TableRow(children: [
                                      Text("Address",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.left),
                                      Text(list_address[index]['shipping_address_1'],
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),
                                    TableRow(children: [
                                      Text("Postcode",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.left),
                                      Text(list_address[index]['shipping_postcode'],
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),

                                    TableRow(children: [
                                      Text("City",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.left),
                                      Text(list_address[index]['shipping_city'],
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),
                                    TableRow(children: [
                                      Text("State",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.left),
                                      Text(list_address[index]['shipping_zone'],
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),
                                    TableRow(children: [
                                      Text("Country",
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.left),
                                      Text(list_address[index]['shipping_country'],
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right),
                                    ]),


                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //),
                    );
                  },
                );
              } else {
                return Container();
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top:20.0,bottom: 4.0,left: 22.0),
            child: Text(
              "Items in this order",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //PRODUCTS
          StreamBuilder(
            stream: orders.onValue,
            builder: (context, snapshot) {
              if(snapshot.hasData)
                {
                  list_products.clear();

                  try{
                    Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                    values.forEach((key,values) {
                      try{
                        if(values!=null && values['order_id']==widget.orderId.toString())
                        {
                          list_products.add(values);

                        }
                      }
                      catch(e){
                      }
                    });
                  }catch(e){
                    List<dynamic> values = snapshot.data.snapshot.value;
                    values.forEach((values) {
                      try{
                        if(values!=null && values['order_id']==widget.orderId.toString())
                        {
                          list_products.add(values);

                        }
                      }
                      catch(e){
                      }
                    });
                  }

                  if (list_products.isNotEmpty) {
                    orderProductNamePrice="";


                    return Column(
                      children: [
                        GridView.builder(
                          physics: ScrollPhysics(),
                          itemCount: list_products.length,
                          scrollDirection: Axis.vertical,
                          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: MediaQuery.of(context).size.width /
                                (MediaQuery.of(context).size.height / 10),
                          ),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, index) {

                            String str = list_products[index]['name'].toString();
                            int len = str.length;

                            if (len >=30) {
                              str = str.substring(0, 30) + "...";
                            }
                            String name=list_products[index]['name'].toString();
                            String price=double.parse(list_products[index]['SellingPrice']).toStringAsFixed(0);
                            String qty=list_products[index]['quantity'];
                            orderProductNamePrice+="<tr><td>$name</td><td>$qty</td><td>$price</td></tr>";
                            Widget image;
                            try
                            {
                              image=FutureBuilder(
                                future: imageurl(context, list_products[index]['image'], FirebaseStorage.instance),
                                builder: (context,snap){
                                  if(snap.hasData)
                                  {
                                    Widget img;
                                    try
                                    {
                                      img=Image.network(
                                        snap.data.image,
                                        fit: BoxFit.fill,
                                      );
                                    }
                                    catch(e)
                                    {
                                      img=Container();
                                    }
                                    return img;


                                  }
                                  else
                                  {
                                    return Container();
                                  }
                                },

                              );
                            }
                            catch(e)
                            {
                              image=Container();
                            }
                            return Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(Consts.padding),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 13.0,
                                    offset: const Offset(10.0, 10.0),
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(left: 2, top: 4, right: 8,bottom: 4),

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: InkWell(
                                  onTap: (){ },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: image,
                                        ),
                                        flex: 2, //elevation: 10,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0,right: 8,top: 8,bottom: 10),
                                          child: Column(
                                            children: [

                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    _parseHtmlString(list_products[index]['name'].toString()),
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 13.0,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                flex: 1,
                                              ),

                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                  Alignment.centerLeft,
                                                  child:Text( list_products[index]['orderStatus'],
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),),
                                                ),
                                                flex: 1,
                                              ),
                                              Expanded(
                                                child: Align(
                                                    alignment:
                                                    Alignment.topLeft,
                                                    child:Text( list_products[index]['quantity']+" * "+"\u{20B9}"+double.parse(list_products[index]['SellingPrice']).toStringAsFixed(0))),

                                                flex: 1,
                                              )

                                            ],
                                          ),
                                        ),

                                        flex: 5, //elevation: 10,
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              //),
                            );
                          },
                        ),
                        widget.status=="Processing" || widget.status=="Pending"?
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          margin: EdgeInsets.only(
                              left: 8, top: 10, right: 8, bottom: 10),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            onPressed: ()async {
                              await animated_dialog_box.showScaleAlertBox(
                                  title:Center(child: Text("Cancel")) , // IF YOU WANT TO ADD
                                  context: context,
                                  firstButton: MaterialButton(
                                    // OPTIONAL BUTTON
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),

                                    child: Text('No',style: TextStyle(color: Colors.white),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  secondButton: MaterialButton(
                                    // FIRST BUTTON IS REQUIRED
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    color: Colors.white,
                                    child: Text('Yes'),
                                    onPressed: () {
                                      setState(() {
                                        widget.status="Cancelled";
                                        cancelOrder(widget.orderId);
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                                  yourWidget: Container(
                                    child: Text('Are you sure you want cancel this order?'),
                                  ));
                            },
                            child: Text(
                              "Cancel order",
                              style: new TextStyle(color: Colors.white),
                            ),
                            color: Colors.red,
                          ),
                        )
                            :Container(),
                      ],
                    );
                  }
                  else {
                    return Container();
                  }
                }
              else
                {
                  return Container();
                }



            },
          ),
        ],
      ),

    );
  }
  Future<void> cancelOrder(var order_id)async
  {
    order_ids.once().then(
            (DataSnapshot datasnapshot) {
          List<dynamic> values = datasnapshot.value;
          for (int i = 0; i < values.length; i++) {
            try{
              if (values[i]['order_id'].toString() == order_id.toString()) {
                order_ids.child(i.toString()).update(
                    {"orderStatus": "Cancelled"});
              }
            }
            catch(e)
            {

            }

          }
        });
    orders.once().then((DataSnapshot datasnapshot) {
          List<dynamic> values = datasnapshot.value;
          for (int i = 0; i < values.length; i++) {
            try{
              if (values[i]['order_id'].toString() == order_id.toString()) {
                orders.child(i.toString()).update(
                    {"orderStatus": "Cancelled"});
              }
            }
            catch(e)
            {

            }
          }
          Fluttertoast.showToast(
              msg:
              "Order canceled",
              toastLength: Toast
                  .LENGTH_SHORT,
              gravity:
              ToastGravity
                  .BOTTOM,
              timeInSecForIosWeb:
              1,
              fontSize: 16.0);

        });
    sendEmail(email, "shrifashion", "ORDER#$order_id", "Your order has been canceled", "Order #$order_id was canceled at your request and your payment has been voided . <br><br> <h1>Items in this order</h1>$orderSummary<br>$bill <br><br>Thanks,<br>shrifashion.");
    sendEmailToAdmin("ORDER#$order_id","An order has been cancelled!","Hi,Order #$order_id was canceled at your request and your payment has been voided . <br><br> <h1>Items in this order</h1>$orderSummary<br>$bill <br><br>Thanks,<br>shrifashion.");
  }
}
