import 'dart:async';

import 'package:shrifashion/CartIcon.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import '../mobileLogin.dart';
import 'Cart.dart';

import 'package:firebase_database/firebase_database.dart';
var coupon_code="0000";
class Coupon extends StatefulWidget {
  static String couponApplied;
  @override
  _CouponState createState() => _CouponState();
}
class _CouponState extends State<Coupon> {
  List lists=[];
  TextEditingController couponCode=TextEditingController();
  final couponTable = FirebaseDatabase.instance.reference().child("coupons_master");
  final couponCalculation=FirebaseDatabase.instance.reference().child("coupons");
  final couponHistory = FirebaseDatabase.instance.reference().child("coupon_history");
  bool isCouponUsed=false,hasApplied=false;
  final key = GlobalKey<ScaffoldState>();
  List couponUsedList=[];
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  @override
  void initState(){
    couponHistory.once().then((DataSnapshot snapshot) {
      List<dynamic> values = snapshot.value;
      values.forEach((values) {
        if (values['customer_id']==customerId.toString())
        {
          couponUsedList.add(values['coupon_id']);
        }
      });});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: new AppBar(
        //elevation: 0.1,
        title: Text('Apply Coupon/Referral code',style: TextStyle(fontFamily: custom_font,
        color: Colors.black),),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              height: MediaQuery.of(context).size.height/15,
              child: Padding(
                padding:  EdgeInsets.only(left:8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:11.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height/ 15,
                            width:  MediaQuery.of(context).size.width/1.5,
                            child: TextFormField(
                              controller: couponCode,
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.only(left:8.0),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Enter coupon code",
                                focusedBorder: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color:Theme.of(context).buttonColor

                                  ),
                                ) ,
                                enabledBorder: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color:Theme.of(context).buttonColor

                                  ),
                                ),
                                //fillColor: Colors.green
                              ),
                              style: new TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),

                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left:5.0,right: 17.0,bottom: 11.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height/ 15,
                              width:  MediaQuery.of(context).size.width/0.5,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: OutlineButton(
                                    borderSide: BorderSide( color: Colors.transparent),
                                    child: FittedBox(
                                      child: Text(

                                        "Apply",
                                        style: TextStyle(color: Colors.orange,fontSize: 17,),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),

                                    onPressed: () async {
                                      if(!hasApplied)
                                      {
                                        hasApplied=true;
                                        double sum=0.0;
                                        bool isProductCoupon=false;
                                        List couponList=[];
                                        couponTable.once().then((DataSnapshot snapshot) {
                                          List<dynamic> values = snapshot.value;
                                          values.forEach((values) {

                                            for(int i=0;i<productId.length;i++)
                                              if (values!=null &&values['code']==couponCode.text.toString())
                                              {
                                                couponList.add(values);
                                              }
                                          });
                                          if(couponList.isNotEmpty)
                                          {
                                            couponId=couponList[0]['coupon_id'];
                                            couponCalculation.once().then((DataSnapshot snapshot) {
                                              try
                                              {
                                                List<dynamic> values = snapshot.value;
                                                values.forEach((values) {

                                                  if (values!=null&&values['coupon_id']==couponList[0]['coupon_id'] )
                                                  {
                                                    if(values["product_id"]!="0")
                                                    {
                                                      isProductCoupon=true;
                                                    }
                                                    for(int i=0;i<productId.length;i++)
                                                      if( values["product_id"]==productId[i])
                                                      {
                                                        couponProductId.add(values["product_id"]);

                                                        double price=double.parse(productPrice[i])*double.parse(productQuantity[i]);
                                                        sum+=price;
                                                        print(sum);
                                                      }

                                                  }

                                                  if (values!=null&&values['coupon_id']==couponList[0]['coupon_id'] )
                                                  {
                                                    if(values["category_id"]!="0")
                                                    {
                                                      isProductCoupon=true;
                                                    }
                                                    for(int i=0;i<categoryId.length;i++)
                                                    {
                                                      if( values["category_id"]==categoryId[i])
                                                      {
                                                        couponCategoryId.add(values["category_id"]);
                                                        double price=double.parse(productPrice[i])*double.parse(productQuantity[i]);
                                                        sum+=price;
                                                        print(sum);
                                                      }


                                                    }

                                                  }
                                                });
                                              }
                                              catch(e)
                                              {
                                                List<dynamic> values = snapshot.value;
                                                values.forEach((values) {

                                                  if (values!=null&&values['coupon_id']==couponList[0]['coupon_id'] )
                                                  {
                                                    if(values["product_id"]!="0")
                                                    {
                                                      isProductCoupon=true;
                                                    }
                                                    for(int i=0;i<productId.length;i++)
                                                      if( values["product_id"]==productId[i])
                                                      {
                                                        couponProductId.add(values["product_id"]);

                                                        double price=double.parse(productPrice[i])*double.parse(productQuantity[i]);
                                                        sum+=price;
                                                        print(sum);
                                                      }

                                                  }

                                                  if (values!=null&&values['coupon_id']==couponList[0]['coupon_id'] )
                                                  {
                                                    if(values["category_id"]!="0")
                                                    {
                                                      isProductCoupon=true;
                                                    }
                                                    for(int i=0;i<categoryId.length;i++)
                                                    {
                                                      if( values["category_id"]==categoryId[i])
                                                      {
                                                        couponCategoryId.add(values["category_id"]);
                                                        double price=double.parse(productPrice[i])*double.parse(productQuantity[i]);
                                                        sum+=price;
                                                        print(sum);
                                                      }


                                                    }

                                                  }
                                                });
                                              }

                                              if(couponCode.text==("VEG-A0"+customerId.toString()))
                                              {
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "You cannot use your own coupon",
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
                                                if(couponCode.text.toString().startsWith("ECO-A0"))
                                                {
                                                  //IT IS A REFFERAL CODE
                                                  //CHECK IF IF ALREADY USED
                                                  List couponHistoryList=[];
                                                  final couponHistory = FirebaseDatabase.instance.reference().child("coupons_history");
                                                  couponHistory.once().then((DataSnapshot snapshot) {
                                                    List<dynamic> values = snapshot.value;
                                                    values.forEach((values) {
                                                      if (values['customer_id']==customerId.toString() && values['coupon_id']==couponId.toString())
                                                      {
                                                        couponHistoryList.add(values);
                                                      }

                                                    });
                                                    if(couponHistoryList.isEmpty)
                                                    {
                                                      isCouponUsed=false;
                                                    }
                                                    else
                                                    {
                                                      isCouponUsed=true;
                                                    }
                                                  });
                                                }
                                                if(!isCouponUsed)
                                                {
                                                  double total;

                                                  try{
                                                    total=double.parse(couponList[0]['total']);
                                                    couponTotal=total;
                                                    if(cartAmt<total)
                                                    {
                                                      hasApplied=false;
                                                      double difference=total-cartAmt;
                                                      Fluttertoast.showToast(
                                                          msg:
                                                          "Add items of \u{20B9}$difference to use this coupon code",
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
                                                      bool hasExpired=false;
                                                      double d=double.parse(couponList[0]['discount']);
                                                      var per=d.toStringAsFixed(0);
                                                      try{
                                                        if(DateTime.now().compareTo(DateTime.parse(couponList[0]['date_start']))>=0
                                                            &&
                                                            DateTime.now().compareTo(DateTime.parse(couponList[0]['date_end']))<=0)
                                                        {
                                                          // COUPON NOT EXPIRED

                                                          if(couponList[0]['type']=='P')
                                                          {
                                                            max_discount=double.parse(couponList[0]['max_discount']);
                                                            couponDiscount=couponList[0]['discount'];
                                                            couponType='P';
                                                            if(sum!=0.0)
                                                            {
                                                              //PRODUCT DISCOUNT COUPON

                                                              coupon=couponList[0]['code'];
                                                              double disc=(double.parse(couponList[0]['discount'])/100)*sum;
                                                              if(disc>max_discount)
                                                              {
                                                                disc=max_discount;
                                                              }
                                                              discount=disc;
                                                              toPay-=disc;
                                                              couponDescription="Flat $per% off";

                                                            }
                                                            else
                                                            {
                                                              if(!isProductCoupon)
                                                              {
                                                                coupon=couponList[0]['code'];
                                                                couponDiscount=couponList[0]['discount'];
                                                                double disc=(double.parse(couponList[0]['discount'])/100)*cartAmt;
                                                                if(disc>max_discount)
                                                                {
                                                                  disc=max_discount;
                                                                }
                                                                discount=disc;
                                                                toPay-=disc;
                                                                couponDescription="Flat $per% off";
                                                                print("After coupon"+toPay.toString());
                                                              }
                                                              else
                                                              {
                                                                hasApplied=false;
                                                                key.currentState.showSnackBar(SnackBar(
                                                                  content: Text('No related products in cart'),
                                                                  backgroundColor: Colors.red,
                                                                  duration: Duration(seconds: 1,milliseconds: 500),
                                                                ));
                                                              }

                                                            }
                                                          }
                                                          else
                                                          if(couponList[0]['type']=='F')
                                                          {
                                                            couponType='F';
                                                            coupon=couponList[0]['code'];
                                                            couponDiscount=couponList[0]['discount'];
                                                            double disc=double.parse(couponList[0]['discount']);
                                                            discount=disc;
                                                            print(disc.toString());
                                                            toPay=toPay-disc;
                                                            couponDescription="Flat \u{20B9}$per off";
                                                            print("After coupon"+toPay.toString());
                                                          }

                                                          setState(() {
                                                            toPay;


                                                            print(coupon);
                                                          });
                                                          coupon_code=couponList[0]['code'];


                                                        }
                                                        else{
                                                          hasExpired=true;
                                                          hasApplied=false;

                                                          key.currentState.showSnackBar(SnackBar(
                                                            content: Text('Coupon has expired!'),
                                                            backgroundColor: Colors.red,
                                                            duration: Duration(seconds: 1,milliseconds: 500),
                                                          ));

                                                        }



                                                        if(!hasExpired && hasApplied)
                                                        {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext context){
                                                                return AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.all(Radius.circular(26.0))),
                                                                  contentPadding: EdgeInsets.only(top: 10.0),
                                                                  // title: Text("Alert Dialog"),
                                                                  content: Container(
                                                                    height: MediaQuery.of(context).size.height/4,
                                                                    // decoration: new BoxDecoration(
                                                                    //   shape: BoxShape.rectangle,
                                                                    //   borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                                                    // ),
                                                                    child: Center(child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(15),
                                                                        child: Image.asset("images/CouponSuccess.png")),),) , //
                                                                );
                                                              }
                                                          );
                                                          Timer(
                                                              Duration(seconds: 3),
                                                                  () {

                                                                Navigator.pop(context);
                                                                Navigator.pop(context);
                                                                return  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Cart()));
                                                              });


                                                        }


                                                      }
                                                      catch(e)
                                                      {
                                                        hasApplied=false;
                                                        print(e.toString());
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            "Invalid Coupon Code",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                            ToastGravity
                                                                .BOTTOM,
                                                            timeInSecForIosWeb:
                                                            1,
                                                            fontSize: 16.0);
                                                      }
                                                    }
                                                  }catch(e)
                                                  {
                                                    hasApplied=false;
                                                    print(e.toString());
                                                    Fluttertoast.showToast(
                                                        msg:
                                                        "Invalid Coupon Code",
                                                        toastLength: Toast
                                                            .LENGTH_SHORT,
                                                        gravity:
                                                        ToastGravity
                                                            .BOTTOM,
                                                        timeInSecForIosWeb:
                                                        1,
                                                        fontSize: 16.0);
                                                  }


                                                }
                                                else
                                                {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                      "Referral code already used",
                                                      toastLength: Toast
                                                          .LENGTH_SHORT,
                                                      gravity:
                                                      ToastGravity
                                                          .BOTTOM,
                                                      timeInSecForIosWeb:
                                                      1,
                                                      fontSize: 16.0);
                                                }





                                              }
                                            });





                                          }
                                          else
                                          {
                                            hasApplied=false;

                                            Fluttertoast.showToast(
                                                msg:
                                                "Invalid Coupon Code",
                                                toastLength: Toast
                                                    .LENGTH_SHORT,
                                                gravity:
                                                ToastGravity
                                                    .BOTTOM,
                                                timeInSecForIosWeb:
                                                1,
                                                fontSize: 16.0);
                                          }
                                        });


                                      }

                                    },
                                  )
                              ),
                            ),
                          ),
                          flex: 3,
                        ),
                      ],
                    )
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0),
              height: MediaQuery.of(context).size.height/19,
              child: Padding(
                padding:  EdgeInsets.only(left:8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Available Promo Codes",style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).buttonColor
                  ),),
                ),
              ),
            ),
            Container(
              child: StreamBuilder(
                stream: couponTable.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    lists.clear();

                    try{
                      List<dynamic> values = snapshot.data.snapshot.value;
                      values.forEach((values) {
                        try{
                          if(values['status']=='True')
                          {
                            bool isUsed=false;
                            for(int i=0;i<couponUsedList.length;i++)
                            {
                              if(values['coupon_id']==couponUsedList[i].toString())
                              {
                                isUsed=true;
                              }
                            }
                            if(!isUsed)
                              lists.add(values);
                          }

                        }
                        catch(e){
                        }
                      });
                    }catch(e){
                      Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                      values.forEach((key,values) {
                        try{
                          if(values['status']=='True')
                          {
                            bool isUsed=false;
                            for(int i=0;i<couponUsedList.length;i++)
                            {
                              if(values['coupon_id']==couponUsedList[i].toString())
                              {
                                isUsed=true;
                              }
                            }
                            if(!isUsed)
                              lists.add(values);
                          }

                        }
                        catch(e){
                        }
                      });
                    }

                    return GridView.builder(
                      physics: ScrollPhysics(),
                      itemCount: lists.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 6.5),
                      ),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
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
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [

                                    Expanded(
                                      flex:13,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:10.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 12.0, right: 8.0, top: 4.0),
                                            child: FDottedLine(
                                              strokeWidth:1.0,
                                              dottedLength:10.0,
                                              space:2.0,
                                              color:Theme.of(context).buttonColor,
                                              child: Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: FittedBox(
                                                    child: Text(  lists[index]['code'].toString().toUpperCase(),style: TextStyle(fontSize: 17, color: Colors.grey),)
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex:30,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 22.0, ),
                                        child: Align(child:
                                        Text(_parseHtmlString(lists[index]['name'],),
                                          maxLines: 4,
                                          style: TextStyle(fontSize: 13),
                                        ),
                                          alignment: Alignment.topLeft,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                flex: 8,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Align(
                                      alignment: Alignment.center,

                                      child: OutlineButton(
                                        borderSide: BorderSide( color: Colors.transparent),

                                        child: FittedBox(
                                          child: Text(

                                            "Apply",
                                            style: TextStyle(color: Colors.orange,fontSize: 17,),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),

                                        onPressed: () async {
                                          if(!hasApplied)
                                          {
                                            couponId=lists[index]['coupon_id'];
                                            couponProductId.clear();
                                            couponCategoryId.clear();
                                            hasApplied=true;
                                            double sum=0.0;
                                            bool isProductCoupon=false;
                                            couponCalculation.once().then((DataSnapshot snapshot) {
                                              try
                                              {
                                                Map<dynamic,dynamic> values = snapshot.value;
                                                values.forEach((key,values) {
                                                  try
                                                  {
                                                    if (values!=null&&values['coupon_id']==lists[index]['coupon_id'] )
                                                    {
                                                      if(values["product_id"]!="0")
                                                      {
                                                        isProductCoupon=true;
                                                      }
                                                      for(int i=0;i<productId.length;i++)
                                                        if(values["product_id"]==productId[i])
                                                        {
                                                          couponProductId.add(values["product_id"]);
                                                          isProductCoupon=true;
                                                          double price=double.parse(productPrice[i])*double.parse(productQuantity[i]);
                                                          sum+=price;
                                                          print(sum);
                                                        }

                                                    }
                                                  }
                                                  catch(e)
                                                  {
                                                    print(e.toString());
                                                  }
                                                  try
                                                  {
                                                    if (values!=null&&values['coupon_id']==lists[index]['coupon_id'] )
                                                    {
                                                      if(values["category_id"]!="0")
                                                      {
                                                        isProductCoupon=true;
                                                      }
                                                      for(int i=0;i<categoryId.length;i++)
                                                      {
                                                        if(values["category_id"]==categoryId[i])
                                                        {
                                                          couponCategoryId.add(values["category_id"]);
                                                          double price=double.parse(productPrice[i])*double.parse(productQuantity[i]);
                                                          sum+=price;
                                                          print(sum);
                                                        }

                                                      }


                                                    }
                                                  }
                                                  catch(e)
                                                  {

                                                  }




                                                });
                                              }
                                              catch(e)
                                              {
                                                List<dynamic> values = snapshot.value;

                                                values.forEach((values) {
                                                  if (values!=null && values['coupon_id']==lists[index]['coupon_id'] )
                                                  {
                                                    if(values["product_id"]!="0")
                                                    {
                                                      isProductCoupon=true;
                                                    }
                                                    for(int i=0;i<productId.length;i++)
                                                      if(values["product_id"]==productId[i])
                                                      {
                                                        couponProductId.add(values["product_id"]);
                                                        isProductCoupon=true;
                                                        double price=double.parse(productPrice[i])*double.parse(productQuantity[i]);
                                                        sum+=price;
                                                        print(sum);
                                                      }

                                                  }


                                                  if (values!=null && values['coupon_id']==lists[index]['coupon_id'] )
                                                  {
                                                    if(values["category_id"]!="0")
                                                    {
                                                      isProductCoupon=true;
                                                    }
                                                    for(int i=0;i<categoryId.length;i++)
                                                    {
                                                      if(values["category_id"]==categoryId[i])
                                                      {
                                                        couponCategoryId.add(values["category_id"]);
                                                        double price=double.parse(productPrice[i])*double.parse(productQuantity[i]);
                                                        sum+=price;
                                                        print(sum);
                                                      }

                                                    }


                                                  }
                                                });
                                              }


                                              double total=double.parse(lists[index]['total']);
                                              couponTotal=total;
                                              if(cartAmt<total)
                                              {
                                                hasApplied=false;
                                                double difference=total-cartAmt;
                                                key.currentState.showSnackBar(SnackBar(
                                                  content: Text('add items of \u{20B9}$difference to use this coupon'),
                                                  backgroundColor: Colors.red,
                                                  duration: Duration(seconds: 1,milliseconds: 500),
                                                ));
                                              }
                                              else
                                              {
                                                bool hasExpired=false;
                                                double d=double.parse(  lists[index]['discount']);
                                                var per=d.toStringAsFixed(0);
                                                if(DateTime.now().compareTo(DateTime.parse(lists[index]['date_start']))>=0
                                                    &&
                                                    DateTime.now().compareTo(DateTime.parse(lists[index]['date_end']))<=0)
                                                {
                                                  print(DateTime.now());
                                                  print(DateTime.parse(lists[index]['date_start']));
                                                  print(" not Expired");
                                                  if(lists[index]['type']=='P')
                                                  {
                                                    couponType='P';
                                                    couponDiscount=lists[index]['discount'];
                                                     max_discount=lists[index]['max_discount']!=null?double.parse(lists[index]['max_discount']):0;
                                                    if(sum!=0.0)
                                                    {
                                                      //PRODUCT DISCOUNT COUPON
                                                      double disc=(double.parse(lists[index]['discount'])/100)*sum;
                                                      print("Disc=$disc");
                                                      if(max_discount!=0 && disc>max_discount)
                                                        {
                                                          disc=max_discount;
                                                        }
                                                      discount=disc;
                                                      toPay-=disc;
                                                      couponDescription="Flat $per% off";
                                                      coupon=lists[index]['code'];

                                                    }
                                                    else{
                                                      if(!isProductCoupon)
                                                      {
                                                        coupon=lists[index]['code'];
                                                        double disc=(double.parse(lists[index]['discount'])/100)*cartAmt;
                                                        if(max_discount!=0 && disc>max_discount)
                                                        {
                                                          disc=max_discount;
                                                        }
                                                        discount=disc;
                                                        toPay-=disc;
                                                        couponDescription="Flat $per% off";
                                                        print("After coupon"+toPay.toString());
                                                      }
                                                      else
                                                      {
                                                        hasApplied=false;
                                                        key.currentState.showSnackBar(SnackBar(
                                                          content: Text('No related products in cart'),
                                                          backgroundColor: Colors.red,
                                                          duration: Duration(seconds: 1,milliseconds: 500),
                                                        ));
                                                      }
                                                    }
                                                  }
                                                  else
                                                  if(lists[index]['type']=='F')
                                                  {
                                                    coupon=lists[index]['code'];
                                                    couponType='F';
                                                    couponDiscount=lists[index]['discount'];
                                                    double disc=double.parse(lists[index]['discount']);
                                                    discount=disc;
                                                    print(disc.toString());
                                                    toPay=toPay-disc;
                                                    couponDescription="Flat \u{20B9}$per off";
                                                    print("After coupon"+toPay.toString());
                                                  }
                                                  setState(()
                                                  {
                                                    toPay;

                                                    print(coupon);
                                                  });
                                                  coupon_code=lists[index]['code'];
                                                }
                                                else{
                                                  hasExpired=true;
                                                  hasApplied=false;
                                                  key.currentState.showSnackBar(SnackBar(
                                                    content: Text('Coupon has expired!'),
                                                    backgroundColor: Colors.red,
                                                    duration: Duration(seconds: 1,milliseconds: 500),
                                                  ));

                                                }
                                                if(!hasExpired && hasApplied)
                                                {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context){
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(26.0))),
                                                          contentPadding: EdgeInsets.only(top: 10.0),
                                                          content: Container(
                                                            height: MediaQuery.of(context).size.height/4,
                                                            child: Center(child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(15),
                                                                child: Image.asset("images/CouponSuccess.png")),),) , //
                                                        );
                                                      }
                                                  );
                                                  Timer(
                                                      Duration(seconds: 3),
                                                          () {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        return  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Cart()));
                                                      });
                                                }
                                              }


                                            });

                                          }

                                        },
                                      )
                                  ),
                                ),
                                flex: 3,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {

                    return Container();
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


}
