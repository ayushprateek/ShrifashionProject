import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:flutter/material.dart';

class FAQs extends StatefulWidget {
  @override
  _FAQsState createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  int i;
  var que=[
    "1-How do I register?",
    "2-Can I add more than one delivery address in an account?",
    "3-Are there any charges for registration?",
    "4-Can I have multiple accounts with same mobile number and email id?",
    "5-Can I have multiple accounts for members in my family with different mobile number and email address but on same delivery address?",
    "6-What are the modes of payment?",
    "7-Is it safe to use my credit/ debit card on shrifashion?",
    "8-Can I cancel my order?",
    "9-Are there any hidden charges that I should know about?",
    "10-What happens if my order arrives when I am not at home?",
    "11-How will the delivery be done?",
    "12-How do I change the delivery info (address to which I want products delivered)?"

  ];
  var ans=[
    "Sign-up By adding your number and verify your account using OTP . Review the Term and Conditions and starting using the application.",
    "Yes, you can add more than one delivery address in your account However, all the items placed will be delivered to one address only. If you want different items delivered to different address you need to places your order separately.",
    "No. Registration on shrifashion is absolutely free.",
    "No, Each email address and phone number can be associated with one shrifashion account only.",
    "Yes you can have can have the same address but the email address and phone number associated with the accounts should be unique.",
    "You can pay for your order on shrifashion.com using the following modes of payment: \na. Cash on delivery (COD)\nb. Credit and debit cards (VISA / Mastercard / Rupay)\n c. UPI (Google pay/Paytm/Phone Pay)\nIf you choose COD as the payment method, you will need to pay our delivery executive in cash at the time of delivery.",
    "Yes it is absolutely safe to use your card on our shrifashion.",
    "No return or cancellation is possible once the order is handed over to the courier person.",
    "No, there is no hidden charges on any product.We follow simple philosophy- What you see is what you pay!",
    "If you are not home when your delivery arrives, our courier will continue to make at least 1-2 further attempts to deliver your order, if it is still unable to deliver your parcel it will be returned back to us any you will get your refund.",
    "We have a team of delivery personnel and a vehicles operating across the city which ensures timely and accurate delivery to our customers.",
    "You can change your delivery address on our application once you log into your account. Click on 'My Account' go to the 'My Address' section to change your delivery address.."

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("FAQs",style: TextStyle(fontFamily: custom_font),),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              title: Text(que[0],),
              children: [
                ListTile(
                  title: new Text(ans[0],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),
            ExpansionTile(
              title: Text(que[1]),
              children: [
                ListTile(
                  title: new Text(ans[1],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),
            ExpansionTile(
              title: Text(que[2]),
              children: [
                ListTile(
                  title: new Text(ans[2],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),
            ExpansionTile(
              title: Text(que[3]),
              children: [
                ListTile(
                  title: new Text(ans[3],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),
            ExpansionTile(
              title: Text(que[4]),
              children: [
                ListTile(
                  title: new Text(ans[4],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),
            ExpansionTile(
              title: Text(que[5]),
              children: [
                ListTile(
                  title: new Text(ans[5],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),
            ExpansionTile(
              title: Text(que[6]),
              children: [
                ListTile(
                  title: new Text(ans[6],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),
            ExpansionTile(
              title: Text(que[7]),
              children: [
                ListTile(
                  title: new Text(ans[7],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),
            ExpansionTile(
              title: Text(que[8]),
              children: [
                ListTile(
                  title: new Text(ans[8],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),
            ExpansionTile(
              title: Text(que[9]),
              children: [
                ListTile(
                  title: new Text(ans[9],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),
            ExpansionTile(
              title: Text(que[10]),
              children: [
                ListTile(
                  title: new Text(ans[10],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),
            ExpansionTile(
              title: Text(que[11]),
              children: [
                ListTile(
                  title: new Text(ans[11],style: TextStyle(color: Colors.grey),),
                ),
              ],
            ),
            Divider( color: Colors.grey,thickness: 0.5,),


          ],
        ),
      ),
    );
  }
}
class FAQsAnswers extends StatefulWidget {
  final String question,answer;

  FAQsAnswers(
      {this.question,
        this.answer});

  @override
  _FAQsAnswersState createState() => _FAQsAnswersState();
}

class _FAQsAnswersState extends State<FAQsAnswers> {
  var cartId, quantity;




  // MaterialColor  = ;


  @override
  Widget build(BuildContext context) {



    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Stack(
        children: <Widget>[
          Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
              color:Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                // Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.question,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.answer,
                    style: TextStyle(
                      fontSize: 20.0,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
