import 'dart:convert';
import 'package:shrifashion/SendEmail.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:http/http.dart' as http ;
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:shrifashion/pages/coupon.dart';
import 'OrderPlaced.dart';

import 'ShikharPayment.dart';
import 'components/Color.dart';
import 'mobileLogin.dart';
import 'mobileOTP.dart';
import 'package:firebase_database/firebase_database.dart';
var paymentCode;
bool hasOrdered=false;

enum SingingCharacter { razorpay, cashOnDelivery }
class Payment extends StatefulWidget {
  Payment({Key key}) : super(key: key);
  @override
  _PaymentState createState() => _PaymentState();
}
class _PaymentState extends State<Payment> {
  SingingCharacter _character = SingingCharacter.cashOnDelivery;
  final key=GlobalKey<ScaffoldState>();
  var options;
  final address = FirebaseDatabase.instance.reference().child("address");
  final customer = FirebaseDatabase.instance.reference().child("customer");
  bool hasRedeemed=false;

  double points=0.0;

  @override
  void initState()
  {
    address.once().then((DataSnapshot snapshot) {

      List<dynamic> select = snapshot.value;


      select.forEach((values) {
        try{
          if(values['address_id'].toString()==shippingAddressId.toString())
          {
            company=values['company'];
            state=values['state'];
            address_1=values['address_1'];
            address_id=values['address_id'];
            city=values['city'];
            country=values['country'];
            customer_id=values['customer_id'];
            postcode=values['postcode'];
            society=values['society'];
            flat=values['flat'];
            address_1=address_1+" "+values['lane']+" Near: "+values['landmark'];
          }
        }
        catch(e)
        {
        }
      });
    });

    customer.once().then((DataSnapshot snapshot) {

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
    });


  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: new AppBar(
        elevation: 0.1,
        title: Text('Payment Options',style: TextStyle(fontFamily: 'Source Sans Pro'),),

        //actions: <Widget>[],
      ),
      body: ListView(

        children: <Widget>[
          // FutureBuilder(
          //   future: fetchRewards(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       if(!hasRedeemed)
          //        points=double.parse(snapshot.data[0].points);
          //       if(points==0.0)
          //       {
          //         return Container();
          //       }
          //       else
          //         if(hasRedeemed && points!=0.0)
          //           {
          //             return Container(
          //               height:MediaQuery.of(context).size.height * .12,
          //               child: Row(
          //                 children: [
          //                   Expanded(
          //                     flex: 3,
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Align(
          //                         alignment: Alignment.centerLeft,
          //                         child: Column(
          //                           children: [
          //                             Padding(
          //                               padding: const EdgeInsets.only(left:4.0),
          //                               child: Align(
          //                                 alignment: Alignment.centerLeft,
          //                                 child: Text(
          //                                   "Total Store Credit Available",
          //                                   style: TextStyle(
          //                                       color: Colors.black,
          //                                       fontWeight: FontWeight.bold,
          //                                       fontSize: 17.0),
          //                                 ),
          //                               ),
          //                             ),
          //                             Padding(
          //                               padding: const EdgeInsets.all(4.0),
          //                               child: Align(
          //                                 alignment: Alignment.centerLeft,
          //                                 child: Text(
          //                                   "\u{20B9}"+points.toStringAsFixed(0),
          //                                   style: TextStyle(
          //                                       color: Colors.black,
          //                                       fontWeight: FontWeight.bold,
          //                                       fontSize: 20.0),
          //                                 ),
          //                               ),
          //                             ),
          //
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                     flex: 2,
          //                     child: Column(
          //                       children: [
          //                         Expanded(
          //                           flex: 1,
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Material(
          //                               borderRadius: BorderRadius.circular(10.0),
          //                               color: barColor,
          //                               elevation: 0.0,
          //                               child: MaterialButton(
          //                                 onPressed: () async {
          //                                   if(!hasRedeemed)
          //                                   {
          //                                     hasRedeemed=true;
          //                                     if(toPay>points)
          //                                     {
          //                                       setState(() {
          //                                         toPay=toPay-points;
          //                                         points=0.0;
          //                                         // rewardUpdate("0");
          //                                       });
          //                                     }
          //                                     else
          //                                     {
          //                                       setState(() {
          //                                         points=points-toPay;
          //                                         toPay=0;
          //                                         // rewardUpdate(points);
          //                                       });
          //                                       print("Points= $points");
          //                                     }
          //                                   }
          //
          //
          //
          //
          //
          //
          //                                 },
          //                                 minWidth: MediaQuery.of(context).size.width,
          //                                 child: Text(
          //                                   "Redeem",
          //                                   textAlign: TextAlign.center,
          //                                   style: TextStyle(
          //                                       color: Colors.white,
          //                                       fontWeight: FontWeight.bold,
          //                                       fontSize: 20.0),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                         Expanded(child: Container())
          //                       ],
          //                     ),
          //                   ),
          //
          //                 ],
          //               ),
          //             );
          //           }
          //         else
          //           {
          //             return Container(
          //               height:MediaQuery.of(context).size.height * .12,
          //               child: Row(
          //                 children: [
          //                   Expanded(
          //                     flex: 3,
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Align(
          //                         alignment: Alignment.centerLeft,
          //                         child: Column(
          //                           children: [
          //                             Padding(
          //                               padding: const EdgeInsets.only(left:4.0),
          //                               child: Align(
          //                                 alignment: Alignment.centerLeft,
          //                                 child: Text(
          //                                   "Total Store Credit Available",
          //                                   style: TextStyle(
          //                                       color: Colors.black,
          //                                       fontWeight: FontWeight.bold,
          //                                       fontSize: 17.0),
          //                                 ),
          //                               ),
          //                             ),
          //                             Padding(
          //                               padding: const EdgeInsets.all(4.0),
          //                               child: Align(
          //                                 alignment: Alignment.centerLeft,
          //                                 child: Text(
          //                                   "\u{20B9}"+snapshot.data[0].points,
          //                                   style: TextStyle(
          //                                       color: Colors.black,
          //                                       fontWeight: FontWeight.bold,
          //                                       fontSize: 20.0),
          //                                 ),
          //                               ),
          //                             ),
          //
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                     flex: 2,
          //                     child: Column(
          //                       children: [
          //                         Expanded(
          //                           flex: 1,
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Material(
          //                               borderRadius: BorderRadius.circular(10.0),
          //                               color: barColor,
          //                               elevation: 0.0,
          //                               child: MaterialButton(
          //                                 onPressed: () async {
          //                                   if(!hasRedeemed)
          //                                   {
          //                                     hasRedeemed=true;
          //                                     if(toPay>points)
          //                                     {
          //                                       setState(() {
          //                                         toPay=toPay-points;
          //                                         points=0.0;
          //                                         // rewardUpdate("0");
          //                                       });
          //                                     }
          //                                     else
          //                                     {
          //                                       setState(() {
          //                                         points=points-toPay;
          //                                         toPay=0;
          //                                         // rewardUpdate(points);
          //                                       });
          //                                       print("Points= $points");
          //                                     }
          //                                   }
          //
          //
          //
          //
          //
          //
          //                                 },
          //                                 minWidth: MediaQuery.of(context).size.width,
          //                                 child: Text(
          //                                   "Redeem",
          //                                   textAlign: TextAlign.center,
          //                                   style: TextStyle(
          //                                       color: Colors.white,
          //                                       fontWeight: FontWeight.bold,
          //                                       fontSize: 20.0),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                         Expanded(child: Container())
          //                       ],
          //                     ),
          //                   ),
          //
          //                 ],
          //               ),
          //             );
          //           }
          //
          //     } else {
          //       return Container();
          //     }
          //   },
          // ),
          ListTile(
            title: const Text('Cash on Delivery'),
            leading: Radio(
              value: SingingCharacter.cashOnDelivery,
              groupValue: _character,
              onChanged: (SingingCharacter value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Razorpay'),
            leading: Radio(
              value: SingingCharacter.razorpay,
              groupValue: _character,
              onChanged: (SingingCharacter value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[

            Expanded(
              flex:3,
              child: ListTile(
                title: new Text("Total Amount:"),
                subtitle: Text(
                    "\u{20B9}${toPay}"),
              ),
            ),
            Expanded(
              flex:2,
              child: Padding(
                padding: const EdgeInsets.only(right:10.0,top: 5,bottom: 5),
                child: Material(
                  borderRadius: BorderRadius.circular(15.0),

                  child: MaterialButton(

                    onPressed: () async
                    {
                      rewardUpdate(points);
                      paymentCode=_character;
                      if(_character==SingingCharacter.razorpay) {
                        paymentCode='razorpay';


                        try{
                          print("open checkout");
                          CheckRazor();
                        }
                        catch(e)
                        {

                        }
                      }else
                      {
                        paymentCode='cod';
                      }
                      print("Payment");
                      print(paymentCode);
                      if( paymentCode=='cod')
                      {
                        await sendCartOrder();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderPlaced()));
                      }
                      else{
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>CheckRazor()));
                      }
                    },
                    child: Text(
                      "Continue..",
                      style: new TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
void sendCartOrderProduct(var orderId) async{
  var url = "https://shrifashion.co.in/prod/orderProduct.php";

  for(int i=0;i<productQuantity.length;i++)
  {
    var data ={
      "productId":productId[i].toString(),
      "quantity":productQuantity[i].toString(),
      "orderId":orderId.toString()
    };

    var res;
    try{
      res = await http.post(url,body:data);
      print("Json=");
      print(res.body);



    }catch(e){

      print("Exception");
      print(e.toString());
    }
  }




}

void sendCartOrder() async{
  if(!hasOrdered)
  {
    List l=[];
    var orderId;
    paymentCode=paymentCode==null?'razorpay':paymentCode;
    hasOrdered=true;
    print(fname.toString());

    final order_ids_last = FirebaseDatabase.instance.reference().child("order_ids").limitToLast(1);
    final order_ids = FirebaseDatabase.instance.reference().child("order_ids");
    final cart = FirebaseDatabase.instance.reference().child("cart");
    final orders_last = FirebaseDatabase.instance.reference().child("orders").limitToLast(1);
    final orders = FirebaseDatabase.instance.reference().child("orders");
    try
    {
      order_ids_last.once().then(
              (DataSnapshot datasnapshot){
            Map<dynamic,dynamic> values= datasnapshot.value;
            print(values.length);
            values.forEach((key,value){
              int newKey=int.parse(key.toString())+1;
              orderId=newKey+1;
              order_ids.child(newKey.toString()).set({
                "numOfProducts":numOfProducts.toString(),
                "coupon":coupon_code!="0000"?coupon_code.toString():null,
                "customer_id":customerId.toString(),
                "date_added":DateTime.now().toIso8601String(),
                "discount":discount.toString(),
                "orderStatus":"Pending",
                "order_id":orderId.toString(),
                "payment_code":paymentCode.toString(),
                "productCost":cartAmt.toString(),
                "shipping_address_1":address_1.toString(),
                "shipping_city":city.toString(),
                "shipping_company":company.toString(),
                "shipping_country":country.toString(),
                "shipping_firstname":fname.toString(),
                'shipping_flat':flat.toString(),
                "shipping_lastname":lname==null?" ":lname.toString(),
                "shipping_postcode":postcode.toString(),
                "shipping_society":society.toString(),
                "shipping_zone":state.toString(),
                "total":toPay.toString(),
                "store_credit":hasRedeemed?amtRedeemed.toString():null,
                'delivery_charge':deliveryCharge.toString()
              });

              cart.once().then(
                      (DataSnapshot datasnapshot) {
                        try
                        {
                          List<dynamic> values = datasnapshot.value;
                          for (int i = 0; i < values.length; i++) {
                            try{
                              if (values[i]['customer_id'].toString() == customerId.toString()
                              ) {
                                l.add(values[i]);

                              }
                            }
                            catch(e)
                            {
                              print(e.toString());
                            }

                          }
                        }
                        catch(e)
                        {
                          Map<dynamic,dynamic> values = datasnapshot.value;
                          values.forEach((key, value) {
                            try{
                              if (value['customer_id'].toString() == customerId.toString()
                              ) {
                                l.add(value);

                              }
                            }
                            catch(e)
                            {
                              print(e.toString());
                            }
                          });
                        }
                    for (int i = 0; i < l.length; i++)
                      {
                        String SP=l[i]['newPrice']==null?l[i]['oldPrice']:l[i]['newPrice'];
                        String img=l[i]['image'];
                        String name=l[i]['name'];
                        String qty=l[i]['quantity'];
                        orders_last.once().then(
                                (DataSnapshot datasnapshot){
                              Map<dynamic,dynamic> values= datasnapshot.value;
                              print(values.length);
                              values.forEach((key,value){
                                int newKey=int.parse(key.toString())+(i+1);
                                //orderId=newKey+1;
                                orders.child(newKey.toString()).set({

                                  "SellingPrice":SP.toString(),
                                  "image":img.toString(),
                                  "name":name.toString(),
                                  "orderStatus":"Pending",
                                  "order_id":orderId.toString(),
                                  "quantity":qty.toString(),


                                });
                                newKey++;
                              });
                            }
                        );
                      }
                  });


            });
            // SEND EMAIL
            try{

              String bill="<tr><td>Sub Total</td><td>$cartAmt</td></tr>";

              if(coupon!="Apply Coupon/Referral code")
              {
                bill+="<tr><td>Coupon Code</td><td>$discount</td></tr>";
              }
              if(hasRedeemed)
              {
                bill+="<tr><td>Store Credit</td><td>$amtRedeemed</td></tr>";
              }
              bill+="<tr><td>Delivery Charge</td><td>$deliveryCharge</td></tr>";
              bill+="<tr><td>Total</td><td>$toPay</td></tr>";
              String table="<table>$bill </table>";
              orderId=orderId.toString();
              sendEmail(email,"shrifashion","ORDER#$orderId","Thank you for your purchase!","Hi $fname, we're getting your order ready to be shipped. We will notify you when it has been sent.<br><h1>Order Summary</h1><br>$orderSummaryTable<br> Bill Details <br> $table <br><h2>Customer information</h2><br><h3>Shipping Address</h3><br> $fname $lname<br>$company<br>$flat<br>$address_1<br>$society<br>$city<br>$postcode<br>$state<br>$country <br><br>Thanks,<br>shrifashion.");
              sendEmailToAdmin("ORDER#$orderId","An order has been placed!","Hi, An order has been placed at shrifashion.<br><h1>Order Summary</h1><br>$orderSummaryTable<br> Bill Details <br> $table <br><h2>Customer information</h2><br><h3>Shipping Address</h3><br> $fname $lname<br>$company<br>$flat<br>$address_1<br>$society<br>$city<br>$postcode<br>$state<br>$country <br><br>Thanks,<br>shrifashion.");
              //IF COUPON IS USED THEN UPDATE COUPON HISTORY IN FIREBASE
              final couponHistoryLast = FirebaseDatabase.instance.reference().child("coupon_history").limitToLast(1);
              final couponHistory = FirebaseDatabase.instance.reference().child("coupon_history");
              if(coupon!="Apply Coupon/Referral code")
                couponHistoryLast.once().then(
                        (DataSnapshot datasnapshot){
                      Map<dynamic,dynamic> values= datasnapshot.value;
                      print(values.length);
                      values.forEach((key,value){
                        int newKey=int.parse(key.toString())+1;
                        couponHistory.child(newKey.toString()).set({
                          "customer_id":customerId,
                          "date_added":DateTime.now().toIso8601String(),
                          "amount":discount.toString(),
                          "coupon_id":couponId.toString(),
                          "order_id":orderId.toString(),
                        });
                      });
                    }
                );
              coupon="Apply Coupon/Referral code";
            }catch(e){
              print("Exception");
              print(e.toString());
            }

          }
      );
    }
    catch(e)
  {
    print(e.toString());
  }




  }
}
void rewardUpdate(var points)
{

  final rewards = FirebaseDatabase.instance.reference().child("customer_rewards");
  rewards.once().then(
          (DataSnapshot datasnapshot) {
        List<dynamic> values = datasnapshot.value;
        for (int i = 0; i < values.length; i++) {
          try{
            if (values[i]['customer_id'].toString() == customerId.toString() ) {
              rewards.child(i.toString()).update(
                  {"points": points.toString()});


            }
          }
          catch(e)
          {

          }

        }

      });
}

