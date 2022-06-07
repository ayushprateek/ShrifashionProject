import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:shrifashion/HomePage.dart';
import 'package:shrifashion/ImageURL.dart';
import 'package:shrifashion/Map.dart';
import 'package:shrifashion/Service/CRUD.dart';
import 'package:shrifashion/ShikharPayment.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'package:shrifashion/mobileOTP.dart';
import 'package:shrifashion/navbar.dart';
import 'package:shrifashion/pages/coupon.dart';
import '../BottomSheet.dart';
import '../editAddress.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../main.dart';
double max_discount=0.0;
String orderSummaryTable="<table><tr><th>Name</th><th>Price</th></tr> $nameprice </table>";
String nameprice;
List productId=[];
bool isDeliverable=false;
List productQuantity=[];
List productPrice=[];
List categoryId=[];
List parentId=[];
List couponProductId=[];
List couponCategoryId=[];
double couponTotal;
var couponId;
var paymentAddressId='', shippingAddressId='',addressID,couponDiscount;
double toPay=0.0;
double discount=0.0;
var cartAmt=0.0,couponType;
var coupon="Apply Coupon/Referral code";
var couponDescription;
double payableDeliveryCharge=0.0;
bool hasRedeemed=false;
double amtRedeemed=0.0;
double points=0.0;
String numOfProducts;
double deliveryCharge=0.0;
var company,email,state,address_1,address_id,city,country,customer_id,fname,lname,postcode,society,flat;
bool isSet=false;
class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}
class _CartState extends State<Cart> {
  final cart = FirebaseDatabase.instance.reference().child("cart");
  final product = FirebaseDatabase.instance.reference().child("search");
  final PINS = FirebaseDatabase.instance.reference().child("codes");
  final cartLast = FirebaseDatabase.instance.reference().child("cart").limitToLast(1);
  final firebase_address = FirebaseDatabase.instance.reference().child("address");

  final manage_stock = FirebaseDatabase.instance.reference().child("manage_stock");
  final couponCalculation=FirebaseDatabase.instance.reference().child("coupons");
  final rewards = FirebaseDatabase.instance.reference().child("customer_rewards");
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  final fb = FirebaseDatabase.instance;
  double saved=0;
  var future_cart,future_address;
  List cartProducts=[];
  List addressList=[],Pins=[];
  final key = GlobalKey<ScaffoldState>();
  int numOfAddress=0;
  bool isAllInStock=true;
  var cartID,quantity;
  int number = 0,numOfCartItems=0;
  double payableAmt = 0;


  TextEditingController quantityController = TextEditingController();
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
  @override
  void initState() {
    PINS.once().then((DataSnapshot snapshot) {
      List<dynamic> values = snapshot.value;
      Pins.clear();

      values.forEach((values) {
        if(values!=null && values['status']=="True")
          Pins.add(values);
      });
    });
    final customer = FirebaseDatabase.instance.reference().child("customer");
    customer.once().then((DataSnapshot snapshot) {
      try
      {
        Map<dynamic,dynamic> cust = snapshot.value;
        cust.forEach((key,values) {
          try{
            if(values['customer_id'].toString()==customerId.toString())
            {
              mobile=values['telephone'];
              fname=values['firstname'];;
              lname=values['lastname'];
              email=values['email'];
            }
          }
          catch(e)
          {}
        });
      }
      catch(e)
      {
        List<dynamic> cust = snapshot.value;
        cust.forEach((values) {
          try{
            if(values['customer_id'].toString()==customerId.toString())
            {
              mobile=values['telephone'];
              fname=values['firstname'];;
              lname=values['lastname'];
              email=values['email'];
            }
          }
          catch(e)
          {}
        });
      }

    });
  }
  void calculateCouponAmt()  {
    if(coupon!="Apply Coupon/Referral code")
    {
      double sum=0.0;
      bool isProductCoupon=false;
      for(int i=0;i<couponProductId.length;i++)
      {
        isProductCoupon=true;
        for(int j=0;j<productId.length;j++)
        {
          if(couponProductId[i]==productId[j])
          {
            double price=double.parse(productPrice[j])*double.parse(productQuantity[j]);
            sum+=price;
          }
        }
      }
      for(int i=0;i<couponCategoryId.length;i++)
      {
        isProductCoupon=true;
        for(int j=0;j<categoryId.length;j++)
        {
          if(couponCategoryId[i]==categoryId[j])
          {
            isProductCoupon=true;
            double price=double.parse(productPrice[j])*double.parse(productQuantity[j]);
            sum+=price;
          }
        }
      }
      double total=couponTotal;
      if(cartAmt<total)
      {
        discount=0.0;
        coupon="Apply Coupon/Referral code";
      }
      else
      {
        double d=double.parse(couponDiscount);
        var per=d.toStringAsFixed(0);
        if(couponType=='P')
        {
          couponType='P';

          if(sum!=0.0)
          {
            //PRODUCT DISCOUNT COUPON
            double disc=(double.parse(couponDiscount)/100)*sum;
            if(max_discount!=0 && disc>max_discount)
            {
              disc=max_discount;
            }
            discount=disc;
            toPay-=disc;
            couponDescription="Flat $per% off";

          }
          else{
            if(!isProductCoupon)
            {
              double disc=(double.parse(couponDiscount)/100)*cartAmt;
              if(max_discount!=0 && disc>max_discount)
              {
                disc=max_discount;
              }
              discount=disc;
              toPay-=disc;
              couponDescription="Flat $per% off";
            }
            else
            {
              //hasApplied=false;
              discount=0.0;
              coupon="Apply Coupon/Referral code";
              coupon_code="0000";
              couponType=null;
              couponDiscount="";
              couponDescription="";
              this.widget;
            }
          }
        }
        else
        if(couponType=='F')
        {
          couponType='F';
          double disc=double.parse(couponDiscount);
          discount=disc;
          toPay=toPay-disc;
          couponDescription="Flat \u{20B9}$per off";
        }
        toPay;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: new AppBar(

        leading:  IconButton(
            icon: new Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            }),
        title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Checkout',
              style: TextStyle(fontFamily: custom_font,color:Colors.black),)),

        actions: <Widget>[
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new Dashboard()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "+ Add more items",
                      style: TextStyle(
                      color:Colors.black,
                          fontSize: 18),
                    )),
              )),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                child: StreamBuilder(
                  stream: cart.onValue,
                  builder: (context, snapshot) {
                    itemCount = 0;
                    if (snapshot.hasData) {
                      cartAmt=0.0;
                      cartProducts.clear();
                      productQuantity.clear();
                      productPrice.clear();
                      productId.clear();
                      categoryId.clear();
                      nameprice="";

                      try{
                        List<dynamic> values  = snapshot.data.snapshot.value;
                        values.forEach((values) {
                          try{
                            if(values['customer_id']==customerId && values['status']=="1")
                            {
                              cartProducts.add(values);

                              numOfCartItems++;
                              if(values['newPrice']==null)
                              {
                                String name=values['name'];
                                double p=double.parse(values['oldPrice'])*double.parse(values['quantity']);
                                String price=double.parse(p.toString()).toStringAsFixed(2);
                                nameprice+="<tr><td>$name</td><td>$price</td></tr>";
                                productPrice.add(values['oldPrice']);
                                cartAmt=cartAmt+(double.parse(values['oldPrice']*double.parse(values['quantity'])));
                              }
                              else
                              {
                                String name=values['name'];
                                double p=double.parse(values['newPrice'])*double.parse(values['quantity']);
                                String price=double.parse(p.toString()).toStringAsFixed(2);
                                nameprice+="<tr><td>$name</td><td>$price</td></tr>";
                                productPrice.add(values['newPrice']);
                                cartAmt=cartAmt+(double.parse(values['newPrice'])*double.parse(values['quantity']));
                              }
                            }
                          }
                          catch(e){
                          }
                        });
                      }catch(e){

                        Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
                        values.forEach((key,values) {
                          try{
                            if(values['customer_id']==customerId && values['status']=="1")
                            {
                              cartProducts.add(values);

                              numOfCartItems++;
                              if(values['newPrice']==null)
                              {
                                String name=values['name'];
                                double p=double.parse(values['oldPrice'])*double.parse(values['quantity']);
                                String price=double.parse(p.toString()).toStringAsFixed(2);
                                nameprice+="<tr><td>$name</td><td>$price</td></tr>";
                                productPrice.add(values['oldPrice']);
                                cartAmt=cartAmt+(double.parse(values['oldPrice']*double.parse(values['quantity'])));
                              }
                              else
                              {
                                String name=values['name'];
                                double p=double.parse(values['newPrice'])*double.parse(values['quantity']);
                                String price=double.parse(p.toString()).toStringAsFixed(2);
                                nameprice+="<tr><td>$name</td><td>$price</td></tr>";
                                productPrice.add(values['newPrice']);
                                cartAmt=cartAmt+(double.parse(values['newPrice'])*double.parse(values['quantity']));
                              }
                            }
                          }
                          catch(e){
                          }
                        });
                      }


                      for(int i=0;i<cartProducts.length;i++)
                      {
                        try
                        {
                          productId.add(cartProducts[i]['product_id']);
                          productQuantity.add(cartProducts[i]['quantity']);
                          categoryId.add(cartProducts[i]['category_id']);
                        }
                        catch(e)
                        {

                        }
                      }
                      calculateCouponAmt();
                      if(coupon!="Apply Coupon/Referral code")
                      {
                        //coupon applied
                        //cartAmt=cartAmt-(double.parse(discount.toString()));
                      }
                      else
                      {
                        discount=0;
                      }
                      deliveryCharge = cartAmt < 600 ? payableDeliveryCharge : 0;
                      if(cartProducts.length!=0 )
                      {
                        return Column(
                          children: [
                            GridView.builder(
                              physics: ScrollPhysics(),
                              itemCount: cartProducts.length,
                              scrollDirection: Axis.vertical,
                              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 7),
                              ),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, index) {
                                numOfCartItems = cartProducts.length;
                                String _unit = cartProducts[index]['option_name']!=null &&cartProducts[index]['option_name']!=""?cartProducts[index]['option_name']:double.parse(cartProducts[index]['weight']).toStringAsFixed(0) + " " + cartProducts[index]['unit'];
                                var _qty = cartProducts[index]['quantity'].toString();
                                String str = cartProducts[index]['name'].toString();
                                var manufacturer;
                                try
                                {
                                  manufacturer=cartProducts[index]['manufacturer']==null?'Shrifashion':cartProducts[index]['manufacturer'];
                                }
                                catch(e)
                                {
                                  manufacturer='Shrifashion';
                                }

                                int len = str.length;
                                if (len >= 20) {
                                  str = str.substring(0, 20) + "...";
                                }
                                number = int.parse(cartProducts[index]['quantity']);
                                if(cartProducts[index]['stock_status_id']!='7')
                                {
                                  isAllInStock=false;
                                  double margin=double.parse(cartProducts[index]['oldPrice'])-double.parse(cartProducts[index]['newPrice']);
                                  //OUT OF STOCK
                                  return Container(
                                    child: FutureBuilder(
                                      future: imageurl(context, cartProducts[index]["image"],FirebaseStorage.instance),
                                      builder: (context,snap){
                                        if(snap.hasData)
                                        {
                                          try{
                                            return Container(
                                              margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                              decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 10.0,
                                                    offset: const Offset(5.0, 2.0),
                                                  ),
                                                ],
                                              ),

                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:  EdgeInsets.all(MediaQuery.of(context).size.width/60),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(15),
                                                                child: Image.network(
                                                                  snap.data.image,
                                                                  fit: BoxFit.fill,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    flex: 2, //elevation: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 8.0, top: 2),
                                                            child: Align(
                                                                alignment:
                                                                Alignment.centerLeft,
                                                                child: Text(
                                                                  manufacturer,
                                                                  style: TextStyle(
                                                                    color: Colors.grey,
                                                                  ),
                                                                )),
                                                          ),
                                                          flex: 4,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(
                                                                left: 8.0, right: 8.0),
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                _parseHtmlString(cartProducts[index]['name'].toString()),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                          flex: 5,
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(
                                                                      left: 8.0,
                                                                      right: 8.0),
                                                                  child: Align(
                                                                    alignment:
                                                                    Alignment.centerLeft,
                                                                    child: Material(
                                                                      // color: HexColor("#E3F1DF"),
                                                                        elevation: 0.0,
                                                                        child:
                                                                        Text(
                                                                          _unit,
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(""),
                                                              )
                                                            ],
                                                          ),
                                                          flex: 5,
                                                        ),
                                                        cartProducts[index]['newPrice']!=null && cartProducts[index]['newPrice']!="0.0000"?
                                                        Expanded(

                                                          child: Row(
                                                            children: [
                                                              Expanded(

                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                        child: FittedBox(
                                                                          child: Text(
                                                                            "\u{20B9}${double.parse(cartProducts[index]['newPrice']).toStringAsFixed(0)}",
                                                                            style: TextStyle(
                                                                                fontSize: 17,
                                                                                color: Colors.orange,
                                                                                fontWeight:
                                                                                FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                        child: FittedBox(
                                                                          child: Text(
                                                                            "\u{20B9}${double.parse(cartProducts[index]['oldPrice']).toStringAsFixed(0)}",
                                                                            style: TextStyle(
                                                                                fontSize: 17,
                                                                                color: Colors.grey,
                                                                                decoration: TextDecoration
                                                                                    .lineThrough),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [

                                                                      Expanded(
                                                                        child: Text(""),

                                                                      ),
                                                                      Container(
                                                                        child: Expanded(
                                                                          flex: 5,
                                                                          child: Padding(
                                                                            padding:  EdgeInsets.only(bottom:2.0),
                                                                            child: Padding(
                                                                              padding:
                                                                              const EdgeInsets.all(2.0,),
                                                                              child: RaisedButton(
                                                                                  shape:
                                                                                  RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                        15.0),
                                                                                  ),
                                                                                  textColor:
                                                                                  Colors
                                                                                      .white,
                                                                                  color: Colors.grey,
                                                                                  padding:
                                                                                  const EdgeInsets
                                                                                      .all(
                                                                                      4.0),
                                                                                  onPressed:
                                                                                      () async {
                                                                                    cart.once().then(
                                                                                            (DataSnapshot datasnapshot) {
                                                                                          List<dynamic> values = datasnapshot.value;
                                                                                          for (int i = 0; i < values.length; i++) {
                                                                                            try{
                                                                                              if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                                                                  values[i]['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                                                                                cart.child(i.toString()).remove();


                                                                                              }
                                                                                            }
                                                                                            catch(e)
                                                                                            {

                                                                                            }

                                                                                          }
                                                                                        }).then((value) => setState((){

                                                                                      toPay;
                                                                                      deliveryCharge;
                                                                                      cartAmt;
                                                                                    }));
                                                                                    setState(() {
                                                                                      discount=0.0;
                                                                                      coupon="Apply Coupon/Referral code";
                                                                                      this.widget;
                                                                                    });
                                                                                  },
                                                                                  child:
                                                                                  FittedBox(
                                                                                    child: Text(
                                                                                      "Remove",
                                                                                      style: TextStyle(
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .bold,
                                                                                          fontSize:
                                                                                          20),
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )

                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                          flex: 5,
                                                        ):
                                                        Expanded(
                                                          flex: 5,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left: 8.0),
                                                                        child: Align(
                                                                          alignment: Alignment
                                                                              .topLeft,
                                                                          child: FittedBox(
                                                                            fit: BoxFit
                                                                                .scaleDown,
                                                                            child: Text(
                                                                              "\u{20B9}${double.parse(cartProducts[index]['oldPrice']).toStringAsFixed(0)}",
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .orange,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [

                                                                      Expanded(
                                                                        child: Text(""),

                                                                      ),
                                                                      Container(
                                                                        child: Expanded(
                                                                          flex: 5,
                                                                          child: Padding(
                                                                            padding:  EdgeInsets.only(bottom:2.0),
                                                                            child: Padding(
                                                                              padding:
                                                                              const EdgeInsets.all(2.0,),
                                                                              child: RaisedButton(
                                                                                  shape:
                                                                                  RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                        15.0),
                                                                                  ),
                                                                                  textColor:
                                                                                  Colors
                                                                                      .white,
                                                                                  color: Colors.grey,
                                                                                  padding:
                                                                                  const EdgeInsets
                                                                                      .all(
                                                                                      4.0),
                                                                                  onPressed:
                                                                                      () async {
                                                                                    cart.once().then(
                                                                                            (DataSnapshot datasnapshot) {
                                                                                          List<dynamic> values = datasnapshot.value;
                                                                                          for (int i = 0; i < values.length; i++) {
                                                                                            try{
                                                                                              if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                                                                  values[i]['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                                                                                cart.child(i.toString()).remove();


                                                                                              }
                                                                                            }
                                                                                            catch(e)
                                                                                            {

                                                                                            }

                                                                                          }
                                                                                        }).then((value) => setState((){

                                                                                      toPay;
                                                                                      deliveryCharge;
                                                                                      cartAmt;

                                                                                    }));
                                                                                    setState(() {
                                                                                      discount=0.0;
                                                                                      coupon="Apply Coupon/Referral code";
                                                                                      this.widget;
                                                                                    });




                                                                                  },
                                                                                  child:
                                                                                  FittedBox(
                                                                                    child: Text(
                                                                                      "Remove",
                                                                                      style: TextStyle(
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .bold,
                                                                                          fontSize:
                                                                                          20),
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )

                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                        ),


                                                      ],
                                                    ),

                                                    flex: 3, //elevation: 10,
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                          catch(e){

                                            return Container(
                                              margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                              decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 10.0,
                                                    offset: const Offset(5.0, 2.0),
                                                  ),
                                                ],
                                              ),

                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:  EdgeInsets.all(MediaQuery.of(context).size.width/60),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(15),
                                                                child: Container(),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    flex: 2, //elevation: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 8.0, top: 2),
                                                            child: Align(
                                                                alignment:
                                                                Alignment.centerLeft,
                                                                child: Text(
                                                                  manufacturer,
                                                                  style: TextStyle(
                                                                    color: Colors.grey,
                                                                  ),
                                                                )),
                                                          ),
                                                          flex: 4,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(
                                                                left: 8.0, right: 8.0),
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                _parseHtmlString(cartProducts[index]['name'].toString()),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                          flex: 5,
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(
                                                                      left: 8.0,
                                                                      right: 8.0),
                                                                  child: Align(
                                                                    alignment:
                                                                    Alignment.centerLeft,
                                                                    child: Material(
                                                                      // color: HexColor("#E3F1DF"),
                                                                        elevation: 0.0,
                                                                        child:
                                                                        Text(
                                                                          _unit,
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(""),
                                                              )
                                                            ],
                                                          ),
                                                          flex: 5,
                                                        ),
                                                        cartProducts[index]['newPrice']!=null && cartProducts[index]['newPrice']!="0.0000"?
                                                        Expanded(

                                                          child: Row(
                                                            children: [
                                                              Expanded(

                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                        child: FittedBox(
                                                                          child: Text(
                                                                            "\u{20B9}${double.parse(cartProducts[index]['newPrice']).toStringAsFixed(0)}",
                                                                            style: TextStyle(
                                                                                fontSize: 17,
                                                                                color: Colors.orange,
                                                                                fontWeight:
                                                                                FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                        child: FittedBox(
                                                                          child: Text(
                                                                            "\u{20B9}${double.parse(cartProducts[index]['oldPrice']).toStringAsFixed(0)}",
                                                                            style: TextStyle(
                                                                                fontSize: 17,
                                                                                color: Colors.grey,
                                                                                decoration: TextDecoration
                                                                                    .lineThrough),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [

                                                                      Expanded(
                                                                        child: Text(""),

                                                                      ),
                                                                      Container(
                                                                        child: Expanded(
                                                                          flex: 5,
                                                                          child: Padding(
                                                                            padding:  EdgeInsets.only(bottom:2.0),
                                                                            child: Padding(
                                                                              padding:
                                                                              const EdgeInsets.all(2.0,),
                                                                              child: RaisedButton(
                                                                                  shape:
                                                                                  RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                        15.0),
                                                                                  ),
                                                                                  textColor:
                                                                                  Colors
                                                                                      .white,
                                                                                  color: Colors.grey,
                                                                                  padding:
                                                                                  const EdgeInsets
                                                                                      .all(
                                                                                      4.0),
                                                                                  onPressed:
                                                                                      () async {
                                                                                    cart.once().then(
                                                                                            (DataSnapshot datasnapshot) {
                                                                                          List<dynamic> values = datasnapshot.value;
                                                                                          for (int i = 0; i < values.length; i++) {
                                                                                            try{
                                                                                              if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                                                                  values[i]['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                                                                                cart.child(i.toString()).remove();


                                                                                              }
                                                                                            }
                                                                                            catch(e)
                                                                                            {

                                                                                            }

                                                                                          }
                                                                                        }).then((value) => setState((){

                                                                                      toPay;
                                                                                      deliveryCharge;
                                                                                      cartAmt;

                                                                                    }));
                                                                                    setState(() {
                                                                                      this.widget;

                                                                                      discount=0.0;
                                                                                      coupon="Apply Coupon/Referral code";

                                                                                    });




                                                                                  },
                                                                                  child:
                                                                                  FittedBox(
                                                                                    child: Text(
                                                                                      "Remove",
                                                                                      style: TextStyle(
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .bold,
                                                                                          fontSize:
                                                                                          20),
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )

                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                          flex: 5,
                                                        ):
                                                        Expanded(
                                                          flex: 5,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left: 8.0),
                                                                        child: Align(
                                                                          alignment: Alignment
                                                                              .topLeft,
                                                                          child: FittedBox(
                                                                            fit: BoxFit
                                                                                .scaleDown,
                                                                            child: Text(
                                                                              "\u{20B9}${double.parse(cartProducts[index]['oldPrice']).toStringAsFixed(0)}",
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .orange,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Expanded(
                                                                    //   child: Padding(
                                                                    //     padding:
                                                                    //     const EdgeInsets.only(left: 8.0),
                                                                    //     child: Align(
                                                                    //       alignment: Alignment.topLeft,
                                                                    //       child: FittedBox(
                                                                    //         fit: BoxFit.scaleDown,
                                                                    //         child: Text(
                                                                    //           "",
                                                                    //
                                                                    //         ),
                                                                    //       ),
                                                                    //     ),
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [

                                                                      Expanded(
                                                                        child: Text(""),

                                                                      ),
                                                                      Container(
                                                                        child: Expanded(
                                                                          flex: 5,
                                                                          child: Padding(
                                                                            padding:  EdgeInsets.only(bottom:2.0),
                                                                            child: Padding(
                                                                              padding:
                                                                              const EdgeInsets.all(2.0,),
                                                                              child: RaisedButton(
                                                                                  shape:
                                                                                  RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                        15.0),
                                                                                  ),
                                                                                  textColor:
                                                                                  Colors
                                                                                      .white,
                                                                                  color: Colors.grey,
                                                                                  padding:
                                                                                  const EdgeInsets
                                                                                      .all(
                                                                                      4.0),
                                                                                  onPressed:
                                                                                      () async {
                                                                                    cart.once().then(
                                                                                            (DataSnapshot datasnapshot) {
                                                                                          List<dynamic> values = datasnapshot.value;
                                                                                          for (int i = 0; i < values.length; i++) {
                                                                                            try{
                                                                                              if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                                                                  values[i]['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                                                                                cart.child(i.toString()).remove();


                                                                                              }
                                                                                            }
                                                                                            catch(e)
                                                                                            {

                                                                                            }

                                                                                          }
                                                                                        }).then((value) => setState((){

                                                                                      toPay;
                                                                                      deliveryCharge;
                                                                                      cartAmt;

                                                                                    }));
                                                                                    setState(() {
                                                                                      this.widget;

                                                                                      discount=0.0;
                                                                                      coupon="Apply Coupon/Referral code";

                                                                                    });




                                                                                  },
                                                                                  child:
                                                                                  FittedBox(
                                                                                    child: Text(
                                                                                      "Remove",
                                                                                      style: TextStyle(
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .bold,
                                                                                          fontSize:
                                                                                          20),
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )

                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                        ),


                                                      ],
                                                    ),

                                                    flex: 3, //elevation: 10,
                                                  )
                                                ],
                                              ),
                                            );
                                          }



                                        }
                                        else
                                        {

                                          return Container(
                                            margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10.0,
                                                  offset: const Offset(5.0, 2.0),
                                                ),
                                              ],
                                            ),

                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:  EdgeInsets.all(MediaQuery.of(context).size.width/60),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(15),
                                                              child: Container(),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  flex: 2, //elevation: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 8.0, top: 2),
                                                          child: Align(
                                                              alignment:
                                                              Alignment.centerLeft,
                                                              child: Text(
                                                                manufacturer,
                                                                style: TextStyle(
                                                                  color: Colors.grey,
                                                                ),
                                                              )),
                                                        ),
                                                        flex: 4,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 8.0, right: 8.0),
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              _parseHtmlString(cartProducts[index]['name'].toString()),
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight:
                                                                  FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                        flex: 5,
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    left: 8.0,
                                                                    right: 8.0),
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment.centerLeft,
                                                                  child: Material(
                                                                    // color: HexColor("#E3F1DF"),
                                                                      elevation: 0.0,
                                                                      child:
                                                                      Text(
                                                                        _unit,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                      )
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(""),
                                                            )
                                                          ],
                                                        ),
                                                        flex: 5,
                                                      ),
                                                      cartProducts[index]['newPrice']!=null && cartProducts[index]['newPrice']!="0.0000"?
                                                      Expanded(

                                                        child: Row(
                                                          children: [
                                                            Expanded(

                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: FittedBox(
                                                                        child: Text(
                                                                          "\u{20B9}${double.parse(cartProducts[index]['newPrice']).toStringAsFixed(0)}",
                                                                          style: TextStyle(
                                                                              fontSize: 17,
                                                                              color: Colors.orange,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: FittedBox(
                                                                        child: Text(
                                                                          "\u{20B9}${double.parse(cartProducts[index]['oldPrice']).toStringAsFixed(0)}",
                                                                          style: TextStyle(
                                                                              fontSize: 17,
                                                                              color: Colors.grey,
                                                                              decoration: TextDecoration
                                                                                  .lineThrough),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: [

                                                                    Expanded(
                                                                      child: Text(""),

                                                                    ),
                                                                    Container(
                                                                      child: Expanded(
                                                                        flex: 5,
                                                                        child: Padding(
                                                                          padding:  EdgeInsets.only(bottom:2.0),
                                                                          child: Padding(
                                                                            padding:
                                                                            const EdgeInsets.all(2.0,),
                                                                            child: RaisedButton(
                                                                                shape:
                                                                                RoundedRectangleBorder(
                                                                                  borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(
                                                                                      15.0),
                                                                                ),
                                                                                textColor:
                                                                                Colors
                                                                                    .white,
                                                                                color: Colors.grey,
                                                                                padding:
                                                                                const EdgeInsets
                                                                                    .all(
                                                                                    4.0),
                                                                                onPressed:
                                                                                    () async {
                                                                                  cart.once().then(
                                                                                          (DataSnapshot datasnapshot) {
                                                                                        List<dynamic> values = datasnapshot.value;
                                                                                        for (int i = 0; i < values.length; i++) {
                                                                                          try{
                                                                                            if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                                                                values[i]['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                                                                              cart.child(i.toString()).remove();


                                                                                            }
                                                                                          }
                                                                                          catch(e)
                                                                                          {

                                                                                          }

                                                                                        }
                                                                                      }).then((value) => setState((){

                                                                                    toPay;
                                                                                    deliveryCharge;
                                                                                    cartAmt;

                                                                                  }));
                                                                                  setState(() {
                                                                                    this.widget;
                                                                                    discount=0.0;
                                                                                    coupon="Apply Coupon/Referral code";
                                                                                  });




                                                                                },
                                                                                child:
                                                                                FittedBox(
                                                                                  child: Text(
                                                                                    "Remove",
                                                                                    style: TextStyle(
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .bold,
                                                                                        fontSize:
                                                                                        20),
                                                                                  ),
                                                                                )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )

                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                        flex: 5,
                                                      ):
                                                      Expanded(
                                                        flex: 5,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left: 8.0),
                                                                      child: Align(
                                                                        alignment: Alignment
                                                                            .topLeft,
                                                                        child: FittedBox(
                                                                          fit: BoxFit
                                                                              .scaleDown,
                                                                          child: Text(
                                                                            "\u{20B9}${double.parse(cartProducts[index]['oldPrice']).toStringAsFixed(0)}",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .orange,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // Expanded(
                                                                  //   child: Padding(
                                                                  //     padding:
                                                                  //     const EdgeInsets.only(left: 8.0),
                                                                  //     child: Align(
                                                                  //       alignment: Alignment.topLeft,
                                                                  //       child: FittedBox(
                                                                  //         fit: BoxFit.scaleDown,
                                                                  //         child: Text(
                                                                  //           "",
                                                                  //
                                                                  //         ),
                                                                  //       ),
                                                                  //     ),
                                                                  //   ),
                                                                  // ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: [

                                                                    Expanded(
                                                                      child: Text(""),

                                                                    ),
                                                                    Container(
                                                                      child: Expanded(
                                                                        flex: 5,
                                                                        child: Padding(
                                                                          padding:  EdgeInsets.only(bottom:2.0),
                                                                          child: Padding(
                                                                            padding:
                                                                            const EdgeInsets.all(2.0,),
                                                                            child: RaisedButton(
                                                                                shape:
                                                                                RoundedRectangleBorder(
                                                                                  borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(
                                                                                      15.0),
                                                                                ),
                                                                                textColor:
                                                                                Colors
                                                                                    .white,
                                                                                color: Colors.grey,
                                                                                padding:
                                                                                const EdgeInsets
                                                                                    .all(
                                                                                    4.0),
                                                                                onPressed:
                                                                                    () async {
                                                                                  cart.once().then(
                                                                                          (DataSnapshot datasnapshot) {
                                                                                        List<dynamic> values = datasnapshot.value;
                                                                                        for (int i = 0; i < values.length; i++) {
                                                                                          try{
                                                                                            if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                                                                values[i]['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                                                                              cart.child(i.toString()).remove();


                                                                                            }
                                                                                          }
                                                                                          catch(e)
                                                                                          {

                                                                                          }

                                                                                        }
                                                                                      }).then((value) => setState((){

                                                                                    toPay;
                                                                                    deliveryCharge;
                                                                                    cartAmt;

                                                                                  }));
                                                                                  setState(() {
                                                                                    this.widget;
                                                                                    discount=0.0;
                                                                                    coupon="Apply Coupon/Referral code";
                                                                                  });




                                                                                },
                                                                                child:
                                                                                FittedBox(
                                                                                  child: Text(
                                                                                    "Remove",
                                                                                    style: TextStyle(
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .bold,
                                                                                        fontSize:
                                                                                        20),
                                                                                  ),
                                                                                )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )

                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                      ),


                                                    ],
                                                  ),

                                                  flex: 3, //elevation: 10,
                                                )
                                              ],
                                            ),
                                          );


                                        }
                                      },


                                    ),
                                  );
                                }
                                else
                                {
                                  double margin=double.parse(cartProducts[index]['oldPrice'])-double.parse(cartProducts[index]['newPrice']);
                                  // IN STOCK

                                  return Container(
                                    child: FutureBuilder(
                                      future: imageurl(context, cartProducts[index]["image"],FirebaseStorage.instance),
                                      builder: (context,snap){
                                        if(snap.hasData)
                                        {

                                          try{
                                            return Container(
                                              margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                              decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 10.0,
                                                    offset: const Offset(5.0, 2.0),
                                                  ),
                                                ],
                                              ),

                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:  EdgeInsets.all(MediaQuery.of(context).size.width/60),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(15),
                                                                child: Image.network(
                                                                  snap.data.image,
                                                                  fit: BoxFit.fill,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    flex: 2, //elevation: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 8.0, top: 2),
                                                            child: Align(
                                                                alignment:
                                                                Alignment.centerLeft,
                                                                child: Text(
                                                                  manufacturer,
                                                                  style: TextStyle(
                                                                    color: Colors.grey,
                                                                  ),
                                                                )),
                                                          ),
                                                          flex: 4,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(
                                                                left: 8.0, right: 8.0),
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                _parseHtmlString(cartProducts[index]['name'].toString()),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                          flex: 5,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(
                                                                left: 8.0, right: 8.0),
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                "Margin "+margin.toString(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                          flex: 3,
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(
                                                                      left: 8.0,
                                                                      right: 8.0),
                                                                  child: Align(
                                                                    alignment:
                                                                    Alignment.centerLeft,
                                                                    child: Material(
                                                                      // color: HexColor("#E3F1DF"),
                                                                        elevation: 0.0,
                                                                        child:
                                                                        Text(
                                                                          _unit,
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(""),
                                                              )
                                                            ],
                                                          ),
                                                          flex: 5,
                                                        ),
                                                        cartProducts[index]['newPrice']!=null && cartProducts[index]['newPrice']!="0.0000"?
                                                        Expanded(

                                                          child: Row(
                                                            children: [
                                                              Expanded(

                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                        child: FittedBox(
                                                                          child: Text(
                                                                            "\u{20B9}${double.parse(cartProducts[index]['newPrice']).toStringAsFixed(0)}",
                                                                            style: TextStyle(
                                                                                fontSize: 17,
                                                                                color: Colors.orange,
                                                                                fontWeight:
                                                                                FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                        child: FittedBox(
                                                                          child: Text(
                                                                            "\u{20B9}${double.parse(cartProducts[index]['oldPrice']).toStringAsFixed(0)}",
                                                                            style: TextStyle(
                                                                                fontSize: 17,
                                                                                color: Colors.grey,
                                                                                decoration: TextDecoration
                                                                                    .lineThrough),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [

                                                                      Expanded(
                                                                        child: Text(""),

                                                                      ),
                                                                      productCount(index)

                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                          flex: 5,
                                                        ):
                                                        Expanded(
                                                          flex: 5,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left: 8.0),
                                                                        child: Align(
                                                                          alignment: Alignment
                                                                              .topLeft,
                                                                          child: FittedBox(
                                                                            fit: BoxFit
                                                                                .scaleDown,
                                                                            child: Text(
                                                                              "\u{20B9}${double.parse(cartProducts[index]['oldPrice']).toStringAsFixed(0)}",
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .orange,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Expanded(
                                                                    //   child: Padding(
                                                                    //     padding:
                                                                    //     const EdgeInsets.only(left: 8.0),
                                                                    //     child: Align(
                                                                    //       alignment: Alignment.topLeft,
                                                                    //       child: FittedBox(
                                                                    //         fit: BoxFit.scaleDown,
                                                                    //         child: Text(
                                                                    //           "",
                                                                    //
                                                                    //         ),
                                                                    //       ),
                                                                    //     ),
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [

                                                                      Expanded(
                                                                        child: Text(""),

                                                                      ),
                                                                      productCount(index)

                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                        ),


                                                      ],
                                                    ),

                                                    flex: 3, //elevation: 10,
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                          catch(e){
                                            return Container(
                                              margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                              decoration: new BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 10.0,
                                                    offset: const Offset(5.0, 2.0),
                                                  ),
                                                ],
                                              ),

                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:  EdgeInsets.all(MediaQuery.of(context).size.width/60),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(15),
                                                                child: Container(),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    flex: 2, //elevation: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 8.0, top: 2),
                                                            child: Align(
                                                                alignment:
                                                                Alignment.centerLeft,
                                                                child: Text(
                                                                  manufacturer,
                                                                  style: TextStyle(
                                                                    color: Colors.grey,
                                                                  ),
                                                                )),
                                                          ),
                                                          flex: 4,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(
                                                                left: 8.0, right: 8.0),
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                _parseHtmlString(cartProducts[index]['name'].toString()),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                          flex: 5,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(
                                                                left: 8.0, right: 8.0),
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                "Margin "+margin.toString(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                          flex: 3,
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(
                                                                      left: 8.0,
                                                                      right: 8.0),
                                                                  child: Align(
                                                                    alignment:
                                                                    Alignment.centerLeft,
                                                                    child: Material(
                                                                      // color: HexColor("#E3F1DF"),
                                                                        elevation: 0.0,
                                                                        child:
                                                                        Text(
                                                                          _unit,
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(""),
                                                              )
                                                            ],
                                                          ),
                                                          flex: 5,
                                                        ),
                                                        cartProducts[index]['oldPrice']!=null && cartProducts[index]['oldPrice']!="0.0000" && cartProducts[index]['oldPrice']!=""?
                                                        Expanded(

                                                          child: Row(
                                                            children: [
                                                              Expanded(

                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                        child: FittedBox(
                                                                          child: Text(
                                                                            "\u{20B9}${double.parse(cartProducts[index]['newPrice']).toStringAsFixed(0)}",
                                                                            style: TextStyle(
                                                                                fontSize: 17,
                                                                                color: Colors.orange,
                                                                                fontWeight:
                                                                                FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left:8.0),
                                                                        child: FittedBox(
                                                                          child: Text(
                                                                            "\u{20B9}${double.parse(cartProducts[index]['oldPrice']).toStringAsFixed(0)}",
                                                                            style: TextStyle(
                                                                                fontSize: 17,
                                                                                color: Colors.grey,
                                                                                decoration: TextDecoration
                                                                                    .lineThrough),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [

                                                                      Expanded(
                                                                        child: Text(""),

                                                                      ),
                                                                      productCount(index)

                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                          flex: 5,
                                                        ):
                                                        Expanded(
                                                          flex: 5,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left: 8.0),
                                                                        child: Align(
                                                                          alignment: Alignment
                                                                              .topLeft,
                                                                          child: FittedBox(
                                                                            fit: BoxFit
                                                                                .scaleDown,
                                                                            child: Text(
                                                                              "\u{20B9}${double.parse(cartProducts[index]['newPrice']).toStringAsFixed(0)}",
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .orange,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Expanded(
                                                                    //   child: Padding(
                                                                    //     padding:
                                                                    //     const EdgeInsets.only(left: 8.0),
                                                                    //     child: Align(
                                                                    //       alignment: Alignment.topLeft,
                                                                    //       child: FittedBox(
                                                                    //         fit: BoxFit.scaleDown,
                                                                    //         child: Text(
                                                                    //           "",
                                                                    //
                                                                    //         ),
                                                                    //       ),
                                                                    //     ),
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 2,
                                                                  child: Row(
                                                                    children: [

                                                                      Expanded(
                                                                        child: Text(""),

                                                                      ),
                                                                      productCount(index)

                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                        ),


                                                      ],
                                                    ),

                                                    flex: 3, //elevation: 10,
                                                  )
                                                ],
                                              ),
                                            );
                                          }



                                        }
                                        else
                                        {
                                          return Container(
                                            margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                                            decoration: new BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10.0,
                                                  offset: const Offset(5.0, 2.0),
                                                ),
                                              ],
                                            ),

                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:  EdgeInsets.all(MediaQuery.of(context).size.width/60),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(15),
                                                              child: Container(),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  flex: 2, //elevation: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 8.0, top: 2),
                                                          child: Align(
                                                              alignment:
                                                              Alignment.centerLeft,
                                                              child: Text(
                                                                manufacturer,
                                                                style: TextStyle(
                                                                  color: Colors.grey,
                                                                ),
                                                              )),
                                                        ),
                                                        flex: 4,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 8.0, right: 8.0),
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              _parseHtmlString(cartProducts[index]['name'].toString()),
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight:
                                                                  FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                        flex: 5,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 8.0, right: 8.0),
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              "Margin "+margin.toString(),
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight:
                                                                  FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                        flex: 3,
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    left: 8.0,
                                                                    right: 8.0),
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment.centerLeft,
                                                                  child: Material(
                                                                    // color: HexColor("#E3F1DF"),
                                                                      elevation: 0.0,
                                                                      child:
                                                                      Text(
                                                                        _unit,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                      )
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(""),
                                                            )
                                                          ],
                                                        ),
                                                        flex: 5,
                                                      ),
                                                      cartProducts[index]['oldPrice']!=null && cartProducts[index]['oldPrice']!="0.0000" && cartProducts[index]['oldPrice']!=""?
                                                      Expanded(

                                                        child: Row(
                                                          children: [
                                                            Expanded(

                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: FittedBox(
                                                                        child: Text(
                                                                          "\u{20B9}${double.parse(cartProducts[index]['newPrice']).toStringAsFixed(0)}",
                                                                          style: TextStyle(
                                                                              fontSize: 17,
                                                                              color: Colors.orange,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left:8.0),
                                                                      child: FittedBox(
                                                                        child: Text(
                                                                          "\u{20B9}${double.parse(cartProducts[index]['oldPrice']).toStringAsFixed(0)}",
                                                                          style: TextStyle(
                                                                              fontSize: 17,
                                                                              color: Colors.grey,
                                                                              decoration: TextDecoration
                                                                                  .lineThrough),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: [

                                                                    Expanded(
                                                                      child: Text(""),

                                                                    ),
                                                                    productCount(index)

                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                        flex: 5,
                                                      ):
                                                      Expanded(
                                                        flex: 5,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left: 8.0),
                                                                      child: Align(
                                                                        alignment: Alignment
                                                                            .topLeft,
                                                                        child: FittedBox(
                                                                          fit: BoxFit
                                                                              .scaleDown,
                                                                          child: Text(
                                                                            "\u{20B9}${double.parse(cartProducts[index]['newPrice']).toStringAsFixed(0)}",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .orange,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // Expanded(
                                                                  //   child: Padding(
                                                                  //     padding:
                                                                  //     const EdgeInsets.only(left: 8.0),
                                                                  //     child: Align(
                                                                  //       alignment: Alignment.topLeft,
                                                                  //       child: FittedBox(
                                                                  //         fit: BoxFit.scaleDown,
                                                                  //         child: Text(
                                                                  //           "",
                                                                  //
                                                                  //         ),
                                                                  //       ),
                                                                  //     ),
                                                                  //   ),
                                                                  // ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: [

                                                                    Expanded(
                                                                      child: Text(""),

                                                                    ),
                                                                    productCount(index)

                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                      ),


                                                    ],
                                                  ),

                                                  flex: 3, //elevation: 10,
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      },


                                    ),
                                  );
                                }




                              },
                            ),


                          ],
                        );



                      }
                      else
                      {
                        return Column(
                          children: [
                            Container(
                              child: Image.asset('images/Empty.jpg'),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => new Dashboard()))
                                      .then((value) => setState(() {}));
                                },
                                textColor: Colors.white,
                                color: Colors.red,
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(
                                  "Click Here to Shop",
                                ),
                              ),
                            ),
                            Container(
                              width:MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),

                              ),
                              margin: EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    Text("  "),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        'images/bike.jpeg',
                                        fit: BoxFit.fill,
                                        width: MediaQuery.of(context).size.width / 10,
                                        height: MediaQuery.of(context).size.width / 10    ,
                                      ),
                                    ),
                                    deliveryCharge!=0?Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "   Add items worth \u{20B9}600 more to avail free delivery",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ):
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "   Congrats, you are eligible for free delivery!",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                    } else {


                      return Column(
                        children: [
                          Container(
                            child: Image.asset('images/Empty.jpg'),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new Dashboard()))
                                    .then((value) => setState(() {}));
                              },
                              textColor: Colors.white,
                              color: Colors.red,
                              padding: const EdgeInsets.all(8.0),
                              child: new Text(
                                "Click Here to Shop",
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              Divider(),
              //COUPONS
              StreamBuilder(
                  stream: cart.onValue,
                  builder: (context, snapshot) {

                    if (snapshot.hasData) {
                      List list=[];

                      try{
                        List<dynamic> values  = snapshot.data.snapshot.value;
                        values.forEach((values) {
                          try{
                            if(values['customer_id']==customerId && values['status']=="1")
                            {
                              list.add(values);
                            }
                          }
                          catch(e){

                          }
                        });
                      }catch(e){

                        Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
                        values.forEach((key,values) {
                          try{
                            if(values['customer_id']==customerId && values['status']=="1")
                            {
                              list.add(values);
                            }
                          }
                          catch(e){

                          }
                        });
                      }


                      if(list.isNotEmpty)
                      {
                        if(coupon=="Apply Coupon/Referral code") {
                          discount = 0;
                          coupon_code = "0000";
                        }
                        return coupon=="Apply Coupon/Referral code"?
                        Row(
                          children: [
                            Expanded(
                                child:Container()
                            ),
                            Expanded(
                              flex:2,
                              child: Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(left: 15.0, right: 2.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset("images/percentage.jpeg",
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex:8,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                margin: EdgeInsets.only(left: 0.0, right: 15.0),
                                child: InkWell(
                                  onTap: () {

                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(builder: (context) => new Coupon()),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        coupon,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex:2,
                                child: Container()),
                          ],
                        ):
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.asset("images/Tick.jpeg",
                                  fit: BoxFit.scaleDown,
                                  height: 40,
                                ),
                              ),
                              Expanded(
                                flex:3,
                                child: InkWell(
                                  onTap: () {
                                    if(coupon=="Apply Coupon/Referral code")
                                    {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(builder: (context) => new Coupon()),
                                      );
                                    }
                                    else
                                    {
                                      Fluttertoast.showToast(
                                          msg:
                                          "Coupon already added",
                                          toastLength: Toast
                                              .LENGTH_SHORT,
                                          gravity:
                                          ToastGravity
                                              .BOTTOM,
                                          timeInSecForIosWeb:
                                          1,
                                          fontSize: 16.0);
                                    }



                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        coupon +" Applied",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex:3,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        discount=0.0;
                                        coupon="Apply Coupon/Referral code";
                                        coupon_code="0000";
                                        couponType=null;
                                        couponDiscount="";
                                        couponDescription="";
                                        this.widget;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Remove",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else
                        return Container();
                    }
                    else
                    {
                      return Container();
                    }

                  }
              ),


              Divider(),
              Container(
                child: StreamBuilder(
                  stream: cart.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      double totalItemPrice=0.0;
                      numOfCartItems=0;
                      cartAmt=0.0;
                      double saved=0;

                      try{
                        List<dynamic> values=snapshot.data.snapshot.value;
                        values.forEach((values) {
                          try{
                            if(values['customer_id']==customerId && values['status']=="1")
                            {

                              numOfCartItems++;
                              if(values['newPrice']!=null)
                              {
                                // BOTH ARE THERE
                                double save=double.parse(values['oldPrice'])-double.parse(values['newPrice']);
                                save=save*double.parse(values['quantity']);
                                saved=saved+save;
                                double price=double.parse(values['oldPrice'])*double.parse(values['quantity']);
                                totalItemPrice=totalItemPrice+price;

                                cartAmt=cartAmt+(double.parse(values['newPrice'])*double.parse(values['quantity']));
                              }

                              else
                              {
                                // ONLY OLD PRICE IS THERE
                                double price=double.parse(values['oldPrice'])*double.parse(values['quantity']);
                                totalItemPrice=totalItemPrice+price;
                                cartAmt=cartAmt+(double.parse(values['oldPrice'])*double.parse(values['quantity']));
                              }
                            }

                          }
                          catch(e){
                          }
                        });
                      }
                      catch(e){
                        Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                        values.forEach((key,values) {
                          try{
                            if(values['customer_id']==customerId && values['status']=="1")
                            {

                              numOfCartItems++;
                              if(values['newPrice']!=null)
                              {
                                // BOTH ARE THERE
                                double save=double.parse(values['oldPrice'])-double.parse(values['newPrice']);
                                save=save*double.parse(values['quantity']);
                                saved=saved+save;
                                double price=double.parse(values['oldPrice'])*double.parse(values['quantity']);
                                totalItemPrice=totalItemPrice+price;

                                cartAmt=cartAmt+(double.parse(values['newPrice'])*double.parse(values['quantity']));
                              }

                              else
                              {
                                // ONLY OLD PRICE IS THERE
                                double price=double.parse(values['oldPrice'])*double.parse(values['quantity']);
                                totalItemPrice=totalItemPrice+price;
                                cartAmt=cartAmt+(double.parse(values['oldPrice'])*double.parse(values['quantity']));
                              }
                            }

                          }
                          catch(e){
                          }
                        });
                      }

                      if (numOfCartItems == 0) {
                        return Container();
                      }
                      else {
                        return GridView.builder(
                          physics: ScrollPhysics(),
                          itemCount: 1,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: MediaQuery.of(context).size.width /
                                (MediaQuery.of(context).size.height / 3.4),
                          ),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, index) {
                            if(coupon=="Apply Coupon/Referral code")
                            {
                              discount=0;
                              coupon_code="0000";
                            }
                            else
                            {
                              discount=0;
                              calculateCouponAmt();
                            }

                            double priceSaving=saved;
                            saved=saved+discount;
                            cartAmt=totalItemPrice-priceSaving;
                            deliveryCharge = cartAmt < 600 ? payableDeliveryCharge : 0.0;
                            toPay=totalItemPrice-saved+deliveryCharge;
                            var freeDelivery=(600-cartAmt).toStringAsFixed(0);
                            if(hasRedeemed)
                            {
                              toPay=toPay-amtRedeemed;
                              saved=saved+amtRedeemed;
                            }
                            numOfProducts=numOfCartItems.toString();

                            return Container(
                              color: Colors.white,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 8.0,bottom: 8),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Bill Details",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                        ),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: Text(
                                                        "$numOfCartItems x Total Items Price")),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0,top:8),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: Text(
                                                      "\u{20B9}${totalItemPrice.toStringAsFixed(2)}",
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: Text(
                                                      "Price Saving",
                                                      style: TextStyle(
                                                        color:
                                                        Theme.of(context).buttonColor,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0,top:8),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: Text(
                                                      "-\u{20B9}"+priceSaving.toStringAsFixed(2), //+ "\u{20B9}${double.parse(data[index].FinalPrice).toStringAsFixed(2)}",
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0,right:8),
                                          child: Divider(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,top: 4),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: Text("Cart Amount")),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0,top:9),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child:Text(
                                                      "\u{20B9}${cartAmt.toStringAsFixed(2)}",
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        coupon!="Apply Coupon/Referral code"?
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,top:4),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: FittedBox(child: Text(coupon+" ("+couponDescription+")"))),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: Text("-"+
                                                        "\u{20B9}"+discount.toStringAsFixed(2))),
                                              ),
                                            ),
                                          ],
                                        ):
                                        Row(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,top: 4,bottom:0),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child:
                                                    Text("Delivery Charges")),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0,top:8),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: Text(
                                                      "+\u{20B9}${deliveryCharge.toStringAsFixed(2)}",
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                        hasRedeemed?
                                        Row(
                                          children: [
                                            Expanded(
                                              flex:3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,top: 4,bottom:8),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child:
                                                    Text("Store credit Utilized")),
                                              ),
                                            ),
                                            Expanded(
                                              flex:2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom:6.0,left:8),
                                                child: InkWell(
                                                  //borderSide: BorderSide( color: Colors.white,width: 0.0, ),
                                                  child: Text('Remove',style: TextStyle(color: Colors.orange,decoration: TextDecoration.underline,fontWeight: FontWeight.bold),),
                                                  onTap: (){
                                                    setState(() {
                                                      hasRedeemed=false;
                                                      amtRedeemed=0.0;
                                                      points=0.0;
                                                    });

                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex:2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child:FittedBox(
                                                      child: Text(
                                                        "-\u{20B9}${amtRedeemed.toStringAsFixed(2)}",
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ):
                                        StreamBuilder(

                                          stream: rewards.onValue,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              List<dynamic> values ;
                                              try{
                                                values = snapshot.data.snapshot.value;
                                                values.forEach((values) {
                                                  try{
                                                    if(values['customer_id']==customerId.toString() )
                                                    {
                                                      points=double.parse(values['points']);
                                                    }
                                                  }
                                                  catch(e){
                                                  }
                                                });
                                              }catch(e){}
                                              if(points==0.0)
                                              {
                                                return Container();
                                              }
                                              else
                                              {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      flex:4,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(
                                                            left: 8.0,top: 4,bottom:8),
                                                        child: Align(
                                                          alignment:
                                                          Alignment.centerLeft,
                                                          child: FittedBox(
                                                            child: RichText(
                                                              text: new TextSpan(
                                                                style: new TextStyle(
                                                                  color: Colors.black,
                                                                ),

                                                                children: <TextSpan>[
                                                                  new TextSpan(
                                                                      text: 'Store credit available ('),

                                                                  new TextSpan(
                                                                    text: '\u{20B9}${points.toStringAsFixed(0)}',
                                                                    style: new TextStyle(
                                                                      color:Colors.orange,
                                                                    ),
                                                                  ),
                                                                  new TextSpan(
                                                                      text: ')'),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          //Text("Store credit available "+"(\u{20B9}${points.toStringAsFixed(0)})")),
                                                        ),
                                                      ),),
                                                    Expanded(
                                                      flex:2,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:6.0),
                                                        child: InkWell(
                                                          //borderSide: BorderSide( color: Colors.white,width: 0.0, ),
                                                          child: Text('Redeem',style: TextStyle(color: Colors.orange,decoration: TextDecoration.underline,fontWeight: FontWeight.bold),),
                                                          onTap: (){
                                                            if(!hasRedeemed)
                                                            {
                                                              hasRedeemed=true;
                                                              if(cartAmt>points)
                                                              {
                                                                setState(() {
                                                                  amtRedeemed=points;
                                                                  points=0.0;

                                                                  // rewardUpdate("0");
                                                                });
                                                              }
                                                              else
                                                              {
                                                                setState(() {
                                                                  points=points-cartAmt;
                                                                  amtRedeemed=cartAmt;
                                                                  // rewardUpdate(points);
                                                                });

                                                              }

                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child:Container()
                                                    )
                                                  ],
                                                );
                                              }

                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width:MediaQuery.of(context).size.width,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),

                                                ),
                                                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Row(
                                                    children: [
                                                      Text("  "),
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(15),
                                                        child: Image.asset(
                                                          'images/bike.jpeg',
                                                          fit: BoxFit.fill,
                                                          width: MediaQuery.of(context).size.width / 10,
                                                          height: MediaQuery.of(context).size.width / 10    ,
                                                        ),
                                                      ),
                                                      deliveryCharge!=0?Expanded(
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            "   Add items worth \u{20B9}$freeDelivery more to avail free delivery",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ):
                                                      Expanded(
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            "   Congrats, you are eligible for free delivery!",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,top: 8),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: new RichText(
                                                      text: new TextSpan(
                                                        style: new TextStyle(
                                                          color: Colors.black,
                                                        ),

                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                              text: 'To pay'),
                                                          new TextSpan(
                                                            text: ' (Saved \u{20B9}'+saved.toStringAsFixed(2)+')',
                                                            style: new TextStyle(
                                                                color:Colors.orange,
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0,top:8),
                                                child: Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child:
                                                    Text("\u{20B9}"+toPay.toStringAsFixed(2))),
                                              ),
                                            ),
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
                      }
                    }

                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),



              Padding(
                padding: const EdgeInsets.only(left:8.0,right:8,bottom: 4.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),

              // ADDRESS

              StreamBuilder(
                stream: firebase_address.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    addressList.clear();
                    try
                    {
                      Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                      values.forEach((key,values) {
                        try{
                          if(values['customer_id']==customerId.toString() && values['status']==1.toString() )
                          {
                            addressList.add(values);
                            paymentAddressId=addressList[0]['address_id'];
                          }

                        }
                        catch(e)
                        {

                        }
                      });
                    }
                    catch(e)
                    {
                      List<dynamic> values = snapshot.data.snapshot.value;
                      values.forEach((values) {
                        try{
                          if(values['customer_id']==customerId.toString() && values['status']==1.toString() )
                          {
                            addressList.add(values);
                            paymentAddressId=addressList[0]['address_id'];
                          }

                        }
                        catch(e)
                        {

                        }
                      });
                    }

                    numOfAddress=addressList.length;
                    return ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount: addressList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      addAutomaticKeepAlives: true,
                      itemBuilder: (BuildContext context, index) {

                        if(!isSet)
                        {
                          shippingAddressId = paymentAddressId =addressID=addressList[index]['address_id'];
                          company=addressList[index]['company'].toString();
                          state=addressList[index]['state'].toString();
                          address_1=addressList[index]['address_1'];
                          address_id=addressList[index]['address_id'];
                          city=addressList[index]['city'];
                          country=addressList[index]['country'];
                          customer_id=addressList[index]['customer_id'];
                          postcode=addressList[index]['postcode'];
                          society=addressList[index]['society'];
                          flat=addressList[index]['flat'];
                          String lane=addressList[index]['lane']!=null?addressList[index]['lane']:"";
                          String landmark=addressList[index]['landmark']!=null?addressList[index]['landmark']:"";
                          address_1=address_1+" "+lane+" Near: "+landmark;


                          isSet=true;
                        }
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
                          margin: EdgeInsets.only(left: 15.0, right: 15.0,bottom:10),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                child: Radio(
                                  activeColor: Theme.of(context).buttonColor,
                                  value: addressList[index]['address_id'],
                                  groupValue: addressID ,
                                  onChanged: (value){
                                    company=addressList[index]['company'].toString();
                                    state=addressList[index]['state'].toString();
                                    address_1=addressList[index]['address_1'];
                                    address_id=addressList[index]['address_id'];
                                    city=addressList[index]['city'];
                                    country=addressList[index]['country'];
                                    customer_id=addressList[index]['customer_id'];
                                    postcode=addressList[index]['postcode'];
                                    society=addressList[index]['society'];
                                    flat=addressList[index]['flat'];
                                    String lane=addressList[index]['lane']!=null?addressList[index]['lane']:"";
                                    String landmark=addressList[index]['landmark']!=null?addressList[index]['landmark']:"";
                                    address_1=address_1+" "+lane+" Near: "+landmark;
                                    setState(() {

                                      shippingAddressId = paymentAddressId =addressID=value;
                                    });
                                  },

                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      company=addressList[index]['company'].toString();
                                      state=addressList[index]['state'].toString();
                                      address_1=addressList[index]['address_1'];
                                      address_id=addressList[index]['address_id'];
                                      city=addressList[index]['city'];
                                      country=addressList[index]['country'];
                                      customer_id=addressList[index]['customer_id'];
                                      postcode=addressList[index]['postcode'];
                                      society=addressList[index]['society'];
                                      flat=addressList[index]['flat'];
                                      String lane=addressList[index]['lane']!=null?addressList[index]['lane']:"";
                                      String landmark=addressList[index]['landmark']!=null?addressList[index]['landmark']:"";
                                      address_1=address_1+" "+lane+" Near: "+landmark;

                                      shippingAddressId = paymentAddressId =addressID=addressList[index]['address_id'];
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 8.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                addressList[index]
                                                ['company']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),
                                              )),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 8.0,bottom: 8.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            children: [
                                              Text(
                                                addressList[index]
                                                ['flat']
                                                    .toString()
                                                    .toUpperCase() +
                                                    " " +
                                                    addressList[index]
                                                    ['society']
                                                        .toString()
                                                        .toUpperCase() +
                                                    " " +

                                                    addressList[index]
                                                    ['lane']
                                                        .toString()
                                                        .toUpperCase() +" "+

                                                    addressList[index]
                                                    ['landmark']
                                                        .toString()
                                                        .toUpperCase() +" "+
                                                    addressList[index]
                                                    ['address_1']
                                                        .toString()
                                                        .toUpperCase() +
                                                    " " +
                                                    addressList[index]
                                                    ['city']
                                                        .toString()
                                                        .toUpperCase() +
                                                    " " +
                                                    addressList[index]
                                                    ['state']
                                                        .toString()
                                                        .toUpperCase() +
                                                    " " +
                                                    addressList[index]
                                                    ['country']
                                                        .toString()
                                                        .toUpperCase() +
                                                    " " +
                                                    addressList[index]['postcode'].toString(),
                                                maxLines: 4,
                                                style: TextStyle(
                                                    color: Colors.grey, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                flex: 8,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child:OutlineButton(
                                            borderSide: BorderSide( color: Colors.transparent),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15.0),
                                            ),
                                            textColor: Colors.white,
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(2.0),
                                            onPressed: () async {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) => new editAddress(
                                                          addressList[index]['first_name'],
                                                          addressList[index]['last_name'],
                                                          addressList[index]['address_id'],
                                                          addressList[index]['customer_id'],
                                                          addressList[index]['flat'],

                                                          addressList[index]['society'],
                                                          addressList[index]['company'],
                                                          addressList[index]['address_1'],
                                                          addressList[index]['address_2'],

                                                          addressList[index]['postcode'],
                                                          addressList[index]['country'],
                                                          addressList[index]['state'],
                                                          addressList[index]['city'],
                                                          addressList[index]['lane'],
                                                          addressList[index]['landmark']
                                                      ))).then((value) => setState((){}));
                                            },
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: new Text(
                                                "Edit",
                                                style: TextStyle(color: Theme.of(context).buttonColor),
                                              ),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2.0,right: 2.0,bottom: 2.0),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child:OutlineButton(
                                            borderSide: BorderSide( color: Colors.transparent),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15.0),
                                            ),
                                            textColor: Colors.white,
                                            color: Colors.white,
                                            padding: const EdgeInsets.all(0.0),
                                            onPressed: () async {

                                              addressID = addressList[index]['address_id'];
                                              setState(() {
                                                confirm();
                                              });

                                            },
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: new Text(
                                                "Delete",
                                                style: TextStyle(color: Theme.of(context).buttonColor),
                                              ),
                                            )),
                                        /*RaisedButton(
                                          child: FittedBox(child: Text('Edit')),
                                          onPressed: () {
                                          },
                                        ),*/
                                      ),
                                    ),
                                  ],
                                ),
                                flex: 2,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else
                  {
                    return Container();
                  }
                },
              ),
              Container(
                width: 4*MediaQuery.of(context).size.width/3,
                height: MediaQuery.of(context).size.height/22,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                margin: EdgeInsets.only(
                    left: 8, top:8, right: 8, bottom: 2),
                child: MaterialButton(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  color:Theme.of(context).buttonColor,
                  onPressed: () {
                    if(numOfAddress<4)
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
                                    child: new Text("Search Location"),
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
                                          Icon(Icons.near_me, ),
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

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on, ),
                                          Flexible(
                                              child: Text(
                                                "Add a saved location",
                                                style: TextStyle(fontSize: 14,
                                                  color:Theme.of(context).buttonColor,),
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
                    else
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
                  },
                  child: Text(
                    "Add a new address + ",
                    style: new TextStyle(color: Colors.white,),
                  ),

                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: StreamBuilder(
          stream: cart.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var finaPrice=0.0,numOfCartItems=0;
              double sumOfOldPrice=0.0;
              saved=0;

              try{
                List<dynamic> values= snapshot.data.snapshot.value;
                values.forEach((values) {
                  try{
                    if(values['customer_id']==customerId && values['status']=="1")
                    {

                      numOfCartItems++;
                      if(values['newPrice']!=null)
                      {
                        // BOTH ARE THERE
                        double save=double.parse(values['oldPrice'])-double.parse(values['newPrice']);
                        save=save*double.parse(values['quantity']);
                        saved=saved+save;
                        double price=double.parse(values['oldPrice'])*double.parse(values['quantity']);
                        sumOfOldPrice=sumOfOldPrice+price;
                        finaPrice=finaPrice+(double.parse(values['newPrice'])*double.parse(values['quantity']));
                      }

                      else
                      {
                        // ONLY OLD PRICE IS THERE
                        double price=double.parse(values['oldPrice'])*double.parse(values['quantity']);
                        sumOfOldPrice=sumOfOldPrice+price;
                        finaPrice=finaPrice+(double.parse(values['oldPrice'])*double.parse(values['quantity']));
                      }
                    }
                  }
                  catch(e){

                  }
                });
              }
              catch(e)
              {

                Map<dynamic,dynamic> values= snapshot.data.snapshot.value;
                values.forEach((key,values) {
                  try{
                    if(values['customer_id']==customerId && values['status']=="1")
                    {

                      numOfCartItems++;
                      if(values['newPrice']!=null)
                      {
                        // BOTH ARE THERE
                        double save=double.parse(values['oldPrice'])-double.parse(values['newPrice']);
                        save=save*double.parse(values['quantity']);
                        saved=saved+save;
                        double price=double.parse(values['oldPrice'])*double.parse(values['quantity']);
                        sumOfOldPrice=sumOfOldPrice+price;
                        finaPrice=finaPrice+(double.parse(values['newPrice'])*double.parse(values['quantity']));
                      }

                      else
                      {
                        // ONLY OLD PRICE IS THERE
                        double price=double.parse(values['oldPrice'])*double.parse(values['quantity']);
                        sumOfOldPrice=sumOfOldPrice+price;
                        finaPrice=finaPrice+(double.parse(values['oldPrice'])*double.parse(values['quantity']));
                      }
                    }
                  }
                  catch(e){

                  }
                });
              }



              if (numOfCartItems == 0) {
                return Container(
                  height: MediaQuery.of(context).size.height / 10,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: new Text("Total Amount:"),
                          subtitle: Text("\u{20B9}0"),
                        ),
                      ),
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            Fluttertoast.showToast(

                                msg:
                                "Please add something to the cart",
                                toastLength: Toast
                                    .LENGTH_SHORT,
                                gravity:
                                ToastGravity.BOTTOM,
                                timeInSecForIosWeb:
                                1,
                                fontSize: 16.0);
                          },
                          child: Text(
                            "Check out",
                            style: new TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                );
              }
              else {
                deliveryCharge = finaPrice < 600 ? payableDeliveryCharge : 0;
                toPay = finaPrice + deliveryCharge;
                return GridView.builder(
                  physics: ScrollPhysics(),
                  itemCount: 1,
                  scrollDirection: Axis.vertical,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 12),
                  ),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    if(coupon=="Apply Coupon/Referral code")
                    {
                      //NO COUPON APPLIED
                      discount=0;
                      coupon_code="0000";
                    }
                    else
                    {
                      //discount=0.0;
                      //calculateCouponAmt();
                    }
                    saved=saved+discount;

                    toPay=sumOfOldPrice-saved+deliveryCharge;
                    if(hasRedeemed)
                      toPay=toPay-amtRedeemed;


                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      margin: EdgeInsets.only(
                          left: 8, top: 8, right: 8, bottom: 10),
                      child: MaterialButton(
                        color: Theme.of(context).buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          print(cartAmt);
                          if(localStorage.get('guest_id')!=null)
                          {

                            //ITS IS A GUEST ACCOUNT
                            mobileLogin.isComingFromCart=true;
                            Navigator.push(context, MaterialPageRoute(builder: ((context)=>mobileLogin())));
                          }
                          else
                          {
                            if(!isAllInStock)
                            {
                              key.currentState.showSnackBar(SnackBar(
                                content: Text('Remove out of stock products'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 1,milliseconds: 500),
                              ));
                            }
                            else
                            {
                              bool isDesiredQtyAvailable=true;
                              String p_name;
                              int stock_qty2;
                              manage_stock.once().then((DataSnapshot snapshot) {
                                List<dynamic> values = snapshot.value;
                                try{
                                  for (int i=0;i<values.length;i++)
                                  {
                                    try
                                    {
                                      for (int j=0;j<productId.length;j++)
                                      {
                                        if(values[i]['product_id']==productId[j])
                                        {
                                          int stock_qty=int.parse(values[i]['quantity']);
                                          if(int.parse(productQuantity[j])>stock_qty)
                                          {
                                            stock_qty2=int.parse(values[i]['quantity']);
                                            isDesiredQtyAvailable=false;
                                            p_name=values[i]['product_name'];
                                            break;
                                          }
                                        }

                                      }
                                    }
                                    catch(e)
                                    {

                                    }
                                  }
                                }
                                catch(e)
                                {

                                }
                                if(!isDesiredQtyAvailable)
                                {
                                  key.currentState.showSnackBar(SnackBar(
                                    content: Text('We currently have only $stock_qty2 $p_name left in stock!'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 1,milliseconds: 500),
                                  ));
                                }
                                else if (shippingAddressId == null ||
                                    paymentAddressId == null ||
                                    shippingAddressId == '' ||
                                    paymentAddressId == '') {
                                  key.currentState.showSnackBar(SnackBar(
                                    content: Text('Please add an address!'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 1,milliseconds: 500),
                                  ));
                                }
                                else {

                                  isDeliverable=true;
                                  //TODO: SET isDeliverable=FALSE FOR ADDRESS
                                  firebase_address.once().then((DataSnapshot snapshot) {
                                    try
                                    {
                                      Map<dynamic,dynamic> values = snapshot.value;
                                      try{
                                        values.forEach((key,values) {
                                          try
                                          {
                                            if(values['address_id']==addressID && values['customer_id']==customerId)
                                            {
                                              for (int i=0;i<Pins.length;i++)
                                              {
                                                if(Pins[i]['PIN']==values['postcode'])
                                                {
                                                  isDeliverable=true;
                                                }

                                              }
                                            }
                                          }
                                          catch(e)
                                          {
                                            print(e.toString());
                                          }


                                        });
                                      }
                                      catch(e)
                                      {

                                      }
                                    }
                                    catch(e)
                                    {
                                      List<dynamic> values = snapshot.value;
                                      try{
                                        values.forEach((values) {
                                          try
                                          {
                                            if(values['address_id']==addressID && values['customer_id']==customerId)
                                            {
                                              for (int i=0;i<Pins.length;i++)
                                              {
                                                if(Pins[i]['PIN']==values['postcode'])
                                                {
                                                  isDeliverable=true;
                                                }

                                              }
                                            }
                                          }
                                          catch(e)
                                          {
                                            print(e.toString());
                                          }


                                        });
                                      }
                                      catch(e)
                                      {

                                      }
                                    }






                                    if(isDeliverable)
                                    {
                                      cart.orderByChild("customer_id").equalTo(customerId).once().then((snapshot) {
                                        bool placeOrder=true;
                                        try
                                        {

                                          Map<dynamic,dynamic> values=snapshot.value;
                                          if(values!=null)
                                            values.forEach((key,value) {
                                              if(value!=null)
                                                {
                                                  int min_order_qty=int.tryParse(value['min_order_qty'].toString())??1;
                                                  int qty=int.tryParse(value['quantity'].toString())??1;
                                                  if(min_order_qty>qty)
                                                    {
                                                      placeOrder=false;
                                                      // Fluttertoast.showToast(msg: "You can order minimum of "+min_order_qty.toString()+" of "+value['name']+" ");
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You can order minimum of "+min_order_qty.toString()+" of "+value['name']+" ",style: TextStyle(color:Colors.white,),),backgroundColor: Colors.red,));
                                                    }

                                                }

                                            });
                                        }
                                        catch(e)
                                        {
                                          List<dynamic> values=snapshot.value;
                                          if(values!=null)
                                            values.forEach((value) {
                                              if(value!=null)
                                              {
                                                int min_order_qty=int.tryParse(value['min_order_qty'].toString())??1;
                                                int qty=int.tryParse(value['quantity'].toString())??1;
                                                if(min_order_qty>qty)
                                                {
                                                  placeOrder=false;
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You can order minimum of "+min_order_qty.toString()+" of "+value['name']+" ",style: TextStyle(color:Colors.white,),),backgroundColor: Colors.red,));

                                                }

                                              }

                                            });
                                        }
                                        if(placeOrder)
                                          {
                                            Navigator.push(context,MaterialPageRoute(builder: (context)=>CheckRazor()));
                                          }
                                      });

                                      // Navigator.push(
                                      //   context,
                                      //   new MaterialPageRoute(
                                      //       builder: (context) => new Payment()),
                                      // ).then((value) => setState(() {}));
                                      //sendCartOrder();

                                    }
                                    else
                                    {
                                      key.currentState.showSnackBar(SnackBar(
                                        content: Text('Currently we do not deliver at this location!'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 1,milliseconds: 500),
                                      ));
                                    }
                                  });
                                }




                              });








                            }
                          }




                        },
                        child: Text(
                          "Proceed to Pay " + "\u{20B9}"+toPay.toStringAsFixed(2),
                          style: new TextStyle(color: Colors.white),
                        ),

                      ),
                    );
                  },
                );
              }
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
  Widget productCount(int index) {
    return Container(
      child: Expanded(
        flex: 5,
        child: Padding(
          padding:  EdgeInsets.only(bottom:2.0),
          child: StreamBuilder(
            stream: cart.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {

                var quantity,min_order_qty;
                try{
                  List<dynamic> values = snapshot.data.snapshot.value;
                  values.forEach((value){
                    try{
                      if(value!=null)
                        if(value['customer_id'].toString()==customerId.toString() && value['product_id']==cartProducts[index]['product_id'] && value['status']=="1")
                          {
                            quantity=value['quantity'];
                            min_order_qty=value['min_order_qty'];
                          }
                    }
                    catch(e)
                    {

                    }
                  });
                }
                catch(e)
                {
                  Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                  values.forEach((key,value){
                    try{
                      if(value!=null)
                        if(value['customer_id'].toString()==customerId.toString() && value['product_id']==cartProducts[index]['product_id'] && value['status']=="1")
                        {
                          quantity=value['quantity'];
                          min_order_qty=value['min_order_qty'];
                        }
                    }
                    catch(e)
                    {

                    }
                  });
                }


                if (quantity == 0 || quantity == null) {
                  return Container();
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child:
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15.0),
                              ),
                              textColor: Colors.white,

                              padding: const EdgeInsets.all(4.0),
                              onPressed: () async {

                                if ((int.parse(quantity) - 1) == 0) {


                                  cart.once().then(
                                          (DataSnapshot datasnapshot) {
                                        try
                                        {
                                          List<dynamic> values = datasnapshot.value;
                                          for (int i = 0; i < values.length; i++) {
                                            try{
                                              if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                  values[i]['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                                cart.child(i.toString()).remove();


                                              }
                                            }
                                            catch(e)
                                            {

                                            }

                                          }
                                        }
                                        catch(e)
                                        {
                                          Map<dynamic,dynamic> values = datasnapshot.value;
                                          values.forEach((key,value){
                                            try{
                                              if (value['customer_id'].toString() == customerId.toString() &&
                                                  value['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                                cart.child(key.toString()).remove();


                                              }
                                            }
                                            catch(e)
                                            {

                                            }
                                          });

                                        }


                                      }).then((value) => setState((){

                                    toPay;
                                    deliveryCharge;
                                    cartAmt;
                                  }));
                                  setState(() {
                                    this.widget;
                                  });
                                } else {

                                  int x= int.parse(quantity.toString());
                                  int min_order_qty1=int.tryParse(min_order_qty.toString())??1;
                                  x-=min_order_qty1;
                                  updateCart(x,cartProducts[index]['product_id'].toString());
                                  setState(() {
                                    toPay;
                                    deliveryCharge;
                                    cartAmt;
                                  });
                                  // cart.once().then(
                                  //         (DataSnapshot datasnapshot) {
                                  //
                                  //
                                  //       // x--;
                                  //       try
                                  //       {
                                  //         List<dynamic> values = datasnapshot.value;
                                  //         for (int i = 0; i < values.length; i++) {
                                  //           try{
                                  //             if (values[i]['customer_id'].toString() == customerId.toString() &&
                                  //                 values[i]['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                  //               cart.child(i.toString()).update(
                                  //                   {"quantity": x.toString()});
                                  //             }}
                                  //           catch(e)
                                  //           {
                                  //
                                  //
                                  //           }
                                  //         }
                                  //       }
                                  //       catch(e)
                                  //       {
                                  //         Map<dynamic,dynamic> values = datasnapshot.value;
                                  //         values.forEach((key,value){
                                  //           try{
                                  //             if (value['customer_id'].toString() == customerId.toString() &&
                                  //                 value['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                  //               cart.child(key.toString()).update(
                                  //                   {"quantity": x.toString()});
                                  //             }}
                                  //           catch(e)
                                  //           {
                                  //
                                  //
                                  //           }
                                  //         });
                                  //
                                  //       }
                                  //
                                  //     }
                                  // ).then((value) => setState((){
                                  //
                                  //   toPay;
                                  //   deliveryCharge;
                                  //   cartAmt;
                                  // }));
                                }
                                // Fluttertoast.showToast(
                                //     msg:
                                //     "Removed from cart",
                                //     toastLength: Toast
                                //         .LENGTH_SHORT,
                                //     gravity:
                                //     ToastGravity
                                //         .BOTTOM,
                                //     timeInSecForIosWeb:
                                //     1,
                                //     fontSize: 16.0);

                              },
                              child: FittedBox(
                                child:
                                Text(
                                  "-",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              )),
                        ),
                      ),
                      Expanded(
                        child:
                        Container(
                          child: Center(
                              child: Text(quantity)),
                          width: 20.0,
                        ),
                      ),
                      Expanded(
                        child:
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(15.0),
                              ),
                              textColor: Colors.white,

                              padding: const EdgeInsets.all(4.0),
                              onPressed: () async {
                                int x= int.parse(quantity.toString());
                                int min_order_qty1=int.tryParse(min_order_qty.toString())??1;
                                x+=min_order_qty1;
                                updateCart(x,cartProducts[index]['product_id'].toString());
                                setState(() {
                                  toPay;
                                  deliveryCharge;
                                  cartAmt;
                                });



                                // cart.once().then(
                                //         (DataSnapshot datasnapshot) {
                                //       int x= int.parse(quantity.toString());
                                //       int min_order_qty1=int.tryParse(min_order_qty.toString())??1;
                                //       x+=min_order_qty1;
                                //       // x++;
                                //       try
                                //       {
                                //         List<dynamic> values = datasnapshot.value;
                                //         for (int i = 0; i < values.length; i++) {
                                //           try{
                                //             if (values[i]['customer_id'].toString() == customerId.toString() &&
                                //                 values[i]['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                //               cart.child(i.toString()).update(
                                //                   {"quantity": x.toString()});
                                //             }}
                                //           catch(e)
                                //           {
                                //
                                //           }
                                //         }
                                //       }
                                //       catch(e)
                                //       {
                                //
                                //         Map<dynamic,dynamic> values = datasnapshot.value;
                                //         values.forEach((key,value){
                                //           try{
                                //             if (value['customer_id'].toString() == customerId.toString() &&
                                //                 value['product_id'].toString() == cartProducts[index]['product_id'].toString()) {
                                //               cart.child(key.toString()).update(
                                //                   {"quantity": x.toString()});
                                //             }}
                                //           catch(e)
                                //           {
                                //
                                //
                                //           }
                                //         });
                                //       }
                                //
                                //     }
                                // ).then((value) => setState((){}));

                                // Fluttertoast.showToast(
                                //     msg:
                                //     "Added to cart",
                                //     toastLength: Toast
                                //         .LENGTH_SHORT,
                                //     gravity:
                                //     ToastGravity
                                //         .BOTTOM,
                                //     timeInSecForIosWeb:
                                //     1,
                                //     fontSize: 16.0);



                              },
                              child: FittedBox(
                                child:
                                Text(
                                  "+",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              )),
                        ),
                      ),


                    ],
                  );
                }
              }
              else {
                return Padding(
                  padding:
                  const EdgeInsets
                      .only(
                      left: 2.0,
                      right: 2.0,
                      top: 4.0,
                      bottom:
                      4.0),
                  child: RaisedButton(
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            15.0),
                      ),
                      textColor:
                      Colors
                          .white,

                      padding:
                      const EdgeInsets
                          .all(
                          4.0),
                      onPressed:
                          () async {
                        cartLast.once().then(
                                (DataSnapshot datasnapshot){
                              Map<dynamic,dynamic> values= datasnapshot.value;
                              values.forEach((key,value){
                                int newKey=int.parse(key.toString())+1;
                                cart.child(newKey.toString()).set({
                                  "customer_id":customerId,
                                  "date_added":DateTime.now().toIso8601String(),
                                  "image":cartProducts[index]["image"],
                                  "maximum":"1",
                                  "minimum":"1",
                                  "name":cartProducts[index]["name"],
                                  "oldPrice":cartProducts[index]["oldPrice"],
                                  "newPrice":cartProducts[index]["newPrice"],
                                  "product_id":cartProducts[index]["product_id"],
                                  "quantity":"1",
                                  "unit":cartProducts[index]["unit"],
                                  "weight":cartProducts[index]["weight"],
                                  "status":"1"


                                }).then((value) => setState((){
                                  toPay;
                                  deliveryCharge;
                                  cartAmt;
                                }));


                              });
                            }
                        );
                        // Fluttertoast.showToast(
                        //     msg:
                        //     "Added to cart",
                        //     toastLength: Toast
                        //         .LENGTH_SHORT,
                        //     gravity:
                        //     ToastGravity
                        //         .BOTTOM,
                        //     timeInSecForIosWeb:
                        //     1,
                        //     fontSize: 16.0);


                      },
                      child:
                      FittedBox(
                        child: Text(
                          "ADD",
                          style: TextStyle(
                              fontWeight:
                              FontWeight
                                  .bold,
                              fontSize:
                              20),
                        ),
                      )),
                );
              }
            },
          ),
        ),
      ),
    );

  }
  void delete() {




    firebase_address.once().then(
            (DataSnapshot datasnapshot) {
          try
          {
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values!=null && values[i]['customer_id'].toString() == customerId.toString() && values[i]['address_id'].toString() == addressID.toString()) {
                  firebase_address.child(i.toString()).remove();
                  isSet=false;
                }
              }
              catch(e)
              {
              }

            }
          }
          catch(e)
          {
            Map<dynamic,dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values!=null && values[i]['customer_id'].toString() == customerId.toString() && values[i]['address_id'].toString() == addressID.toString()) {
                  firebase_address.child(i.toString()).remove();
                  isSet=false;
                }
              }
              catch(e)
              {
              }

            }
          }

        }).then((value) => setState((){}));

  }

  Future<void> confirm() async {
    await animated_dialog_box.showScaleAlertBox(
        title:Center(child: Text("Delete")) , // IF YOU WANT TO ADD
        context: context,
        firstButton: MaterialButton(
          // OPTIONAL BUTTON
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        secondButton: MaterialButton(
          // FIRST BUTTON IS REQUIRED
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),

          child: Text('Delete'),
          onPressed: () {
            setState(() {
              delete(); //***********************************************************DELETE CALLED
              Navigator.of(context).pop(context);

            });

          },
        ),
        icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
        yourWidget: Container(
          child: Text('Are you sure you want to Delete this address?'),
        ));
  }
}