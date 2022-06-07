import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shrifashion/Service/DatabaseConnections.dart';
import 'package:url_launcher/url_launcher.dart';
class AboutUs extends StatefulWidget {


  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String mobile,website;
  @override
  void initState() {
    admin.once().then((snapshot){
      try
      {
        Map<dynamic,dynamic> values=snapshot.value;
        if(values!=null)
          values.forEach((key, value) {
            if(value!=null)
            {
              mobile="+91"+value['mobile'];
              website=value['website'];
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
              mobile="+91"+value['mobile'];
              website=value['website'];
            }
          });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text(
          "About Shrifashion",
          style: TextStyle(

              color: Colors.black
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color:Colors.black),
          onPressed: (){
            Navigator.pop(context);
          },

        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder(
                future: admin.once(),
                builder: (context,snapshot){
                  if(!snapshot.hasData)
                    return Container();
                  var data=snapshot.data.value;
                  return Container(

                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text:'About Us\n\n',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,

                                    //decoration: TextDecoration.underline
                                  ),
                                  /* recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // open desired screen
                              }*/
                                ),
                                // TextSpan(
                                //     text: "Shrifashion is an Ecomerce Fashion app made by shrisolutions.com.Shri Solutions is a formidable initiative entitled to provide ERP & software solutions to the business and manufacturing industry. It brings them comprehensive feasibilities for a new-aged business epoch. Our business services for various verticals enable our customers to automate their trading operations.Our agenda is to secure our clients' businesses with end-to-end software solutions regardless of company size and type in various industry cubbyholes. Customer satisfaction is the prime objective of our establishment that highly mobilises our energies and team spirits. .\n\n",
                                //     style: TextStyle(color: Colors.black,
                                //       fontSize: 15,
                                //       //fontWeight: FontWeight.bold
                                //     )
                                // ),
                                TextSpan(
                                    text: data[0]['description'],
                                    style: TextStyle(color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold
                                    )
                                ),









                              ]
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                                "Email Us: ",
                                style: TextStyle(color: Colors.black,
                                  fontSize: 15,
                                  //fontWeight: FontWeight.bold
                                )
                            ),
                            TextButton(
                              onPressed:()async{
                                if (await canLaunch("mailto:${data[0]['email']}")) {
                                  await launch("mailto:${data[0]['email']}");
                                } else {
                                  throw 'Could not open ${data[0]['email']}}';
                                }
                              },
                              child: Text(
                                  data[0]['email'],
                                  style: TextStyle(color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: 15,
                                    //fontWeight: FontWeight.bold
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );

                }),

            // Divider(
            //   thickness: 1,
            //   color:Colors.black,
            // ),
            // Container(
            //   color:Colors.white,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Table(
            //       border: TableBorder.all(width: 0.4),
            //
            //       defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            //
            //       columnWidths: {
            //         0: FlexColumnWidth(2),
            //         1: FlexColumnWidth(7),
            //         2: FlexColumnWidth(7),
            //       },
            //       children: [
            //         TableRow(
            //             children: [
            //               Container(
            //                 child: Icon(FlutterIcons.dot_single_ent),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("CIN/LLPIN/FCRN  :",
            //                     style: TextStyle(
            //
            //                         color: Colors.black
            //                     ),
            //                   ),
            //                 ),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("U72900DL2021PTC389744",
            //                     style: TextStyle(
            //
            //                         color: Colors.grey
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]
            //         ),
            //
            //         TableRow(
            //             children: [
            //               Container(
            //                 child: Icon(FlutterIcons.dot_single_ent),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Company Legal Name  :",
            //                     style: TextStyle(
            //
            //                         color: Colors.black
            //                     ),
            //                   ),
            //                 ),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("FYNDORA PRIVATE LIMITED",
            //                     style: TextStyle(
            //
            //                         color: Colors.grey
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]
            //         ),
            //         TableRow(
            //             children: [
            //               Container(
            //                 child: Icon(FlutterIcons.dot_single_ent),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("ROC Code  :",
            //                     style: TextStyle(
            //
            //                         color: Colors.black
            //                     ),
            //                   ),
            //                 ),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("RoC-Delhi",
            //                     style: TextStyle(
            //
            //                         color: Colors.grey
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]
            //         ),
            //         TableRow(
            //             children: [
            //               Container(
            //                 child: Icon(FlutterIcons.dot_single_ent),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Company No.  :",
            //                     style: TextStyle(
            //
            //                         color: Colors.black
            //                     ),
            //                   ),
            //                 ),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("389744",
            //                     style: TextStyle(
            //
            //                         color: Colors.grey
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]
            //         ),
            //         TableRow(
            //             children: [
            //               Container(
            //                 child: Icon(FlutterIcons.dot_single_ent),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Company Category  :",
            //                     style: TextStyle(
            //
            //                         color: Colors.black
            //                     ),
            //                   ),
            //                 ),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Company limited by Shares",
            //                     style: TextStyle(
            //
            //                         color: Colors.grey
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]
            //         ),
            //         TableRow(
            //             children: [
            //               Container(
            //                 child: Icon(FlutterIcons.dot_single_ent),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Company Sub Category  :",
            //                     style: TextStyle(
            //
            //                         color: Colors.black
            //                     ),
            //                   ),
            //                 ),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Non-govt company",
            //                     style: TextStyle(
            //
            //                         color: Colors.grey
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]
            //         ),
            //         TableRow(
            //             children: [
            //               Container(
            //                 child: Icon(FlutterIcons.dot_single_ent),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Company Class  :",
            //                     style: TextStyle(
            //
            //                         color: Colors.black
            //                     ),
            //                   ),
            //                 ),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Private",
            //                     style: TextStyle(
            //
            //                         color: Colors.grey
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]
            //         ),
            //         TableRow(
            //             children: [
            //               Container(
            //                 child: Icon(FlutterIcons.dot_single_ent),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Authorised Capital  :",
            //                     style: TextStyle(
            //
            //                         color: Colors.black
            //                     ),
            //                   ),
            //                 ),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("\u20b910.00 lakh",
            //                     style: TextStyle(
            //
            //                         color: Colors.grey
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]
            //         ),
            //         TableRow(
            //             children: [
            //               Container(
            //                 child: Icon(FlutterIcons.dot_single_ent),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Paid up Capital  :",
            //                     style: TextStyle(
            //
            //                         color: Colors.black
            //                     ),
            //                   ),
            //                 ),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("\u20b90.10 lakh",
            //                     style: TextStyle(
            //
            //                         color: Colors.grey
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]
            //         ),
            //         TableRow(
            //             children: [
            //               Container(
            //                 child: Icon(FlutterIcons.dot_single_ent),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Incorporation Date  :",
            //                     style: TextStyle(
            //
            //                         color: Colors.black
            //                     ),
            //                   ),
            //                 ),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("11 Nov,2021",
            //                     style: TextStyle(
            //
            //                         color: Colors.grey
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]
            //         ),
            //         TableRow(
            //             children: [
            //               Container(
            //                 child: Icon(FlutterIcons.dot_single_ent),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Industry  :",
            //                     style: TextStyle(
            //
            //                         color: Colors.black
            //                     ),
            //                   ),
            //                 ),
            //
            //               ),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Text("Computer And Related Activities",
            //                     style: TextStyle(
            //
            //                         color: Colors.grey
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ]
            //         ),
            //
            //
            //       ],
            //     ),
            //   ),
            // ),

          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: MediaQuery.of(context).size.height/5,
      //   width: MediaQuery.of(context).size.width,
      //   color:Colors.black,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Container(
      //         child: Text("Contact us",
      //           style: TextStyle(
      //
      //             color: Colors.white,
      //             fontSize: 20,
      //
      //           ),
      //         ),
      //
      //       ),
      //       Padding(
      //         padding:  EdgeInsets.only(top:20.0,),
      //         child: Row(
      //             children: [
      //               Expanded(
      //                 child: Container(),
      //               ),
      //               Expanded(
      //                 flex: 4,
      //                 child: InkWell(
      //                   onTap: (){
      //
      //                     makePhoneCall(mobile);
      //                   },
      //                   child: Column(
      //                     children: [
      //                       Icon(FlutterIcons.phone_call_fea,
      //                         color: Colors.white,
      //                         size: 30,
      //                       ),
      //                       Container(
      //                         child: Text("Call",
      //                           style: TextStyle(
      //
      //                             color: Colors.white,
      //
      //                           ),
      //                         ),
      //
      //                       ),
      //                     ],
      //                   ),
      //
      //                 ),
      //               ),
      //               Expanded(
      //                 flex: 4,
      //                 child: InkWell(
      //                   onTap: (){
      //                     customLaunchURL(website);
      //                   },
      //                   child: Column(
      //                     children: [
      //                       Container(
      //                         child: Icon(FlutterIcons.globe_faw5s,
      //                           color: Colors.white,
      //                           size: 30,
      //                         ),
      //
      //                       ),
      //                       Container(
      //                         child: Text("Website",
      //                           style: TextStyle(
      //
      //                             color: Colors.white,
      //
      //                           ),
      //                         ),
      //
      //                       ),
      //                     ],
      //                   ),
      //
      //                 ),
      //               ),
      //               Expanded(
      //                 flex: 4,
      //                 child: InkWell(
      //                   onTap: (){
      //                     customLaunchWhatsappL(context);
      //                   },
      //                   child: Column(
      //                     children: [
      //                       Container(
      //                         child: Icon(FlutterIcons.whatsapp_faw,
      //                           color: Colors.white,
      //                           size: 30,
      //                         ),
      //
      //                       ),
      //                       Container(
      //                         child: Text("Whatsapp",
      //                           style: TextStyle(
      //
      //                             color: Colors.white,
      //
      //                           ),
      //                         ),
      //
      //                       ),
      //                     ],
      //                   ),
      //
      //                 ),
      //               ),
      //               Expanded(
      //                 child: Container(),
      //               ),
      //
      //
      //             ]
      //         ),
      //       ),
      //
      //     ],
      //   ),
      // ),
    );
  }
  // customLaunchURL(String url)async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  // customLaunchWhatsappL(BuildContext context)async {
  //   var whatsapp =mobile;
  //   var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=Hello,\nI am ${PartnerDetails.name}\nMy Customer ID is : ${PartnerDetails.partner_id}\n";
  //   var whatappURL_ios ="https://wa.me/$whatsapp?text=Hello,\nI am ${PartnerDetails.name}\nMy Customer ID is : ${PartnerDetails.partner_id}\n";
  //   if(Platform.isIOS){
  //     // for iOS phone only
  //     if( await canLaunch(whatappURL_ios)){
  //       await launch(whatappURL_ios, forceSafariVC: false);
  //     }else{
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: new Text("whatsapp no installed")));
  //     }
  //   }else{
  //     // android , web
  //     if( await canLaunch(whatsappURl_android)){
  //       await launch(whatsappURl_android);
  //     }else{
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: new Text("whatsapp no installed")));
  //     }
  //   }
  // }
  // makePhoneCall(String mobile_number) async {
  //   var url = 'tel:'+mobile_number;
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}




