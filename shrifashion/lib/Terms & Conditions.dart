import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & Conditions",style: TextStyle(fontFamily: custom_font),),

      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text:'Terms and Conditions\n\n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //decoration: TextDecoration.underline
                        ),
                        /* recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // open desired screen
                            }*/
                      ),

                      TextSpan(
                          text: 'M & M AGROTECH  is the licensed owner of the brand shrifashion and therefore the website shrifashion.com (”The Site”). As a visitor to the Site/ Customer you are advised to please read the Term & Conditions carefully. By accessing the services provided by the positioning you conform to the terms provided during this Terms & Conditions document.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),

                      TextSpan(text:'Personal Information:-\n\n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //decoration: TextDecoration.underline
                        ),
                        /* recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // open desired screen
                            }*/
                      ),
                      TextSpan(
                          text: 'As a part of the registration process on the positioning, It may collect the subsequent personally identifiable information about you: Name including first and family name, alternate email address, mobile number and speak to details, code, Demographic profile (like your age, gender, occupation, education, address etc.) and data about the pages on the positioning you visit/access, the links you click on the positioning, the quantity of times you access the page and any such browsing information.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),




                      TextSpan(text:'The name  shrifashion is owned by M & M AGROTECH . It holds a FSSAI license no. : 21520029000130\n\n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,

                          //decoration: TextDecoration.underline
                        ),
                        /* recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // open desired screen
                            }*/
                      ),
                      TextSpan(
                          text: 'It is strongly recommended that you just read and understand these ‘Terms of Use’ carefully, as by accessing this site , you conform to be bound by the identical and acknowledge that it constitutes an agreement between you and therefore the Company (hereinafter the “User Agreement”). If you are do not trust this User Agreement, you must not use or access for any purpose whatsoever.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),

                      TextSpan(
                          text: 'You have any clarifications regarding the Terms of Use, please do not hesitate to contact us at customercare@shrifashion.com.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Eligibility\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Services of the positioning would be available to only select geographies in India. Persons who are "incompetent to contract" within the meaning of the Indian Contract Act, 1872 including un-discharged insolvents etc. do not seem to be eligible to use the positioning. If you are a minor i.e. under the age of 18 years but a minimum of 13 years old you will use the positioning only under the supervision of a parent or fiduciary who agrees to be bound by these Terms of Use. If your age is below 18 years your parents or legal guardians can transact on behalf of you if they are registered users. you are prohibited from purchasing any material which is for adult consumption and also the sale of which to minors is prohibited.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),

                      TextSpan(
                          text: 'License & Site access\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                            //fontWeight: FontWeight.bold
                          )
                      ),



                      TextSpan(
                          text: 'Services of the positioning would be available to only select geographies in India. Persons who are "incompetent to contract" within the meaning of the Indian Contract Act, 1872 including un-discharged insolvents etc. do not seem to be eligible to use the positioning. If you are a minor i.e. under the age of 18 years but a minimum of 13 years old you will use the positioning only under the supervision of a parent or fiduciary who agrees to be bound by these Terms of Use. If your age is below 18 years your parents or legal guardians can transact on behalf of you if they are registered users. you are prohibited from purchasing any material which is for adult consumption and also the sale of which to minors is prohibited.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Account & Registration Obligations\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'All shoppers should register and login for putting orders on the location. you have got to state your account and registration details current and proper for communications associated with your purchases from the location. By agreeing to the terms and conditions, the consumer agrees to receive promotional communication and newsletters upon registration. The customer can cop out either by unsubscribing in "My Account" or by contacting the customer service\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Pricing\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                      ),


                      TextSpan(
                          text: 'All the products listed on the page will be sold at MRP unless otherwise specified. The prices mentioned at the time of ordering will be the prices charged on the date of the delivery. Although prices of most of the products do not fluctuate on a daily basis but some of the commodities and fresh food prices do change on a daily basis. In case the prices are higher or lower on the date of delivery not additional charges will be collected or refunded as the case may be at the time of the delivery of the order\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Cancellation by Site / Customer\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'You as a customer can cancel your order anytime up to the cut-off time of the slot that you have got placed an order by calling our customer service. In such a case we are going to refund any payments already made by you for the order. If we suspect any fraudulent transaction by any customer or any transaction which defies the terms & conditions of using the web site, we at our sole discretion could cancel such orders. We are going to maintain a negative list of all fraudulent transactions and customers and would deny access to them or cancel any orders placed by them.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Return & Refunds\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                      ),




                      TextSpan(
                          text: 'We have a "no questions asked return and refund policy" which entitles all our members to return the goods at the time of delivery if thanks to some reason they are not satisfied with the standard or freshness of the goods. We are going to take the returned product back with us and issue a credit note for the worth of the return products which is able to be credited to your account on the positioning. This will be accustomed pay your subsequent shopping bills.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'The goods returned should not be used and shall be in the same condition quality and nature which was at the time of delivery with all original sealed packaging and labels intact. The goods returned shall match the original volume and packaging. The return request shall be made within 7 days of the date of delivery. Any return or refund request made after expiry of 7 days, shrifashion or M&M Agrotech shall not be obligated or liable to honor the same. Any request made shall be made from the account on the shrifashion App or via email to customer care of M&M Agrotech. Any oral return / refund request made shall not be entertained.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'You Agree and Confirm\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
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
                      TextSpan(
                          text: 'You may not use the Site for any of the following purposes:\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '1. Disseminating any unlawful, harassing, libelous, abusive, threatening, harmful, vulgar, obscene, or otherwise objectionable material.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '2. Transmitting material that encourages conduct that constitutes a criminal offence or leads to civil liability or otherwise breaches any relevant laws, regulations or code of practice.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '3. Gaining unauthorized access to other computer systems.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '4. Interfering with the use of other person or enjoyment of the location.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '5. Breaching any applicable laws.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '6. Interfering or disrupting networks or websites connected to the positioning.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '7. Making, transmitting or storing electronic copies of materials protected by copyright without the permission of the owner.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Objectionable Material \n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'You understand that by using this Site or any services provided on the positioning, you will encounter content that will be deemed by some to be offensive, indecent, or objectionable, which content may or might not be identified in and of itself. You comply with use the location and any service at your sole risk which to the fullest extent permitted under applicable law, shrifashion and its affiliates shall do not have any liability to you for content which will be deemed offensive, indecent, or objectionable to you.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Termination\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'This User Agreement is effective unless and until terminated by either you will terminate this User Agreement at any time, providing you discontinue to any extent further use of this Site. It may terminate this User Agreement at any time and should do so immediately out of the blue, and accordingly deny you access to the location, Such termination are going to be with none liability. Upon any termination of the User Agreement by either you, want to promptly destroy all materials downloaded or otherwise obtained from this Site, similarly as all copies of such materials, whether made under the User Agreement or otherwise. Any such termination of the User Agreement shall not cancel your obligation to buy the merchandise already ordered from the web site or affect any liability which will have arisen under the User Agreement.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '\n\n',
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
