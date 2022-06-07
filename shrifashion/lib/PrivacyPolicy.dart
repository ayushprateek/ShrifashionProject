import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          elevation: 0.1,
          title: Text('Privacy Policy',style: TextStyle(fontFamily: custom_font),),

          ),
      body:  SingleChildScrollView(
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text:'Privacy Policy\n\n',
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
                          text: 'Welcome! Thank you for visiting our page. shrifashion cares for your privacy. So it’s important for you to understand that how we protect your privacy and to an extent how we use your personal information under the jurisdiction of permitted laws. Please read on our privacy policy(s) and just in case you need further assistance please contact us.Welcome! Thank you for visiting our page. shrifashion cares for your privacy. So it’s important for you to understand that how we protect your privacy and to an extent how we use your personal information under the jurisdiction of permitted laws. Please read on our privacy policy(s) and just in case you need further assistance please contact us.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),

                      TextSpan(text:'Personal information\n\n',
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
                          text: 'Personal information includes which identifies you as a private i.e. your name, postal address, signaling (both landline & mobile), e-mail address, MasterCard number, Visa, American Express or any other credit / Debit card  or other payment account number including the three or four digit validation code for your MasterCard, VISA, American Express (AMEX) card or any other credit card which you willingly provide to us or when your employer provides any such information to shrifashion. By using shrifashion’s website and its related interactive sites and/or other online platform like blog, social media links of shrifashion via Facebook & Twitter and/or its mobile application(s) you accept and conform to allow us to use your personal information provided by you. \n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),




                      TextSpan(text:'What information is, or maybe, collected from you?\n\n',
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
                          text: 'We and our third party service providers may additionally use cookies and other similar technologies to raised serve you with more customized service and facilitate your use of our website & our related interactive sites and/or other online platform like blog, social media links of shrifashion via Facebook & Twitter and/or its mobile application(s).\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),




                      TextSpan(text:'How is the information used?\n\n',
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
                          text: 'The Internet Protocol addresses (IP Addresses) are of the computers that you simply are using. Your IP Address is automatically configured to the pc that you just are using by your Internet Service Provider (ISP). This information is employed by us & in some cases by the third party vendors for the aim of assessing your use of our website, results regarding our website activity and internet usage. By using our website & our related interactive sites and/or other online platform like blog, social media links of shrifashion via Facebook & Twitter and/or its mobile application(s) you comply with allow us to use this information..\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),



                      TextSpan(text:'With whom your information will be shared?\n\n',
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
                          text: 'The personal information that we collect from you & that which you provide us either through our website or our related interactive sites and/or other online platform like blog, social media links of shrifashion via Facebook & Twitter and/or its mobile application(s) is employed to process your order and to manage your account.\n In the view of processing your order we may send your information to credit reference and fraud deterrence agencies.\nPlease note that the food review/suggestion/feedback that you simply provide to participating restaurants associated with their food taste/quality/service/quantity/  or any such other suggestive comments associated with the participating restaurant’s/ eating outlet it is solely at your risk. Under no circumstance will shrifashion be accountable for it.\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),



                      TextSpan(text:'How do we protect your information?\n\n',
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
                          text: 'To protect against the loss, misuse, unauthorized access, damage and alteration of the knowledge under its control, it has appropriate and reasonable security measures and safeguards, in compliance with applicable laws for instance, Servers are accessible only to authorized personnel and your information is shared with the authorized personnel on a requirement to understand basis to complete the transaction and to produce the services requested by you. Although it will endeavor to safeguard the confidentiality of your personally identifiable information, transmissions made by means of the net cannot be made absolutely secure. By using this Site, you agree that it will not have any liability for disclosure of your information because of errors in transmission or unauthorized acts of third parties. By using this Site or providing information, you agree (i) that we will communicate with you electronically regarding security, privacy, and administrative issues referring to your use of the Site; and (ii) that we are able to take adequate physical, managerial, and technical safeguards to preserve the integrity and security of your data till the time you employ the location or the services provided by the location (directly or indirectly).\n\n',
                          style: TextStyle(color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),


                      TextSpan(text:'Contact Information\n\n',
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
                          text: 'M & M AGROTECH\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: '101, Balaram Dubey SRA, Mograpada, Jadunath Mishra Chowk,   Andheri(E),Mumbai 400069\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Contact No. :+91 7208999922/ +91 7208999933  \n',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: 'Email Id: customercare@shrifashion.com\n',
                          style: TextStyle(
                            color: Colors.black,
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
