
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefundPolicy extends StatefulWidget {
  @override
  _RefundPolicyState createState() => _RefundPolicyState();
}

class _RefundPolicyState extends State<RefundPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refunds and Cancellation Policy",style: TextStyle(fontFamily: custom_font),),

      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text:'Cancellation by Site / Customer\n\n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //decoration: TextDecoration.underline
                        ),
                      ),
                      TextSpan(
                          text: 'You as a customer can cancel your order anytime up to the cut-off time of the slot that you have got placed an order by calling our customer service. In such a case we are going to refund any payments already made by you for the order. If we suspect any fraudulent transaction by any customer or any transaction which defies the terms & conditions of using the web site, we at our sole discretion could cancel such orders. We are going to maintain a negative list of all fraudulent transactions and customers and would deny access to them or cancel any orders placed by them.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Return & Refunds\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'We have a "no questions asked return and refund policy" which entitles all our members to return the goods at the time of delivery if thanks to some reason they are not satisfied with the standard or freshness of the goods. We are going to take the returned product back with us and issue a credit note for the worth of the return products which is able to be credited to your account on the positioning. This will be accustomed pay your subsequent shopping bills.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'The goods returned should not be used and shall be in the same condition quality and nature which was at the time of delivery with all original sealed packaging and labels intact. The goods returned shall match the original volume and packaging. The return request shall be made within 7 days of the date of delivery. Any return or refund request made after expiry of 7 days, shrifashion or M&M Agrotech shall not be obligated or liable to honor the same. Any request made shall be made from the account on the shrifashion App or via email to customer care of M&M Agrotech. Any oral return / refund request made shall not be entertained. \n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'You Agree and Confirm\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      TextSpan(
                          text: '1. You may provide authentic and true information altogether instances where such information is requested of you.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '2. You authorize shrifashion to contact you for any transactional purposes associated with your order/account.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '3. That you simply are accessing the services available on this Site and transacting at your sole risk and are using your best and prudent judgment before moving into any transaction through this Site.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '4. That the address at which delivery of the merchandise ordered by you is to be made are going to be correct and proper all told respects.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '5. That within the event that a non-delivery occurs on account of a blunder by you (i.e. wrong name or address or the other wrong information) any extra cost for redelivery shall be claimed from you.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '6. That you just will use the services provided by the location, its affiliates, consultants and contracted companies, for lawful purposes only and adjust to all applicable laws and regulations while using and transacting on the location.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '7. That before placing an order you may check the merchandise description carefully. By placing an order for a product you conform to be bound by the conditions of sale included within the description of item.\n\n',
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



