
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ShippingAndDeliveryInfo extends StatefulWidget {
  @override
  _ShippingAndDeliveryInfoState createState() => _ShippingAndDeliveryInfoState();
}

class _ShippingAndDeliveryInfoState extends State<ShippingAndDeliveryInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shipping & Delivery Information",style: TextStyle(fontFamily: custom_font),),

      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [


            Container(
              padding: EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    children: <TextSpan>[

                      TextSpan(text:'1. SHIPPING\n\n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //decoration: TextDecoration.underline
                        ),
                      ),
                      TextSpan(
                          text: 'Most of the orders placed through us are shipped within 3 business days. You will be updated the shipping details through e-mail on the email i.d provided with us. There are no Shipping charges levied on the users for orders above Rs.600/- (Rupees Six Hundred Only), the charges for orders below the above-mentioned value, shipping charges will be specified on the basis of the delivery location, order value and items. For orders within the city of Mumbai the minimal order value is Rs.99/- (Rupees Ninety-Nine Only). shrifashion reserves the right to levy shipping charges from time to time depending on the factors mentioned above and any on-going offers.',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'All orders placed on shrifashion.com will be home-delivered\n\n',
                          style: TextStyle(color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                          )
                      ),
                      TextSpan(
                          text: '2. PAYMENT\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Payment is required to be made at the time of placing the order. We accept convenient modes of payment such as, net banking, MasterCard, and visa. However, we do not accept cash on delivery as a mode of payment for your orders. \n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'DELIVERY OF THE PRODUCT- ESTIMATED TIME OF DELIVERY AND MODE OF DELIVERY \n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      TextSpan(
                          text: 'The estimated time of delivery is within 2-3 working days for all orders. We process all deliveries through shrifashion  Own Delivery Service.  we will get in touch with you and try to work out a convenient alternate delivery location that is serviced by our Delivery partners\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '3. ONLINE TRACKING\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      TextSpan(
                          text: 'All www.shrifashion.com items are delivered through  shrifashion  Own Delivery partners who will provide you with a tracking ID for your order, which shall be mailed to you on the e-mail i.d you have provided us.  With the help of the mailed tracking I.D you can track your delivery on the respective websites of our Delivery partners. You can also see the tracking number in your order history panel in your account when you log in. \n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}

