
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrifashion/AboutUs.dart';
import 'package:shrifashion/ImageURL.dart';
import 'package:shrifashion/PrivacyPolicy.dart';
import 'package:shrifashion/RefundPolicy.dart';
import 'package:shrifashion/Service/DatabaseConnections.dart';

import 'package:shrifashion/Shipping%20&%20Delivery%20Info.dart';
import 'package:shrifashion/Terms%20&%20Conditions.dart';
import 'package:shrifashion/ReadCtegoryData.dart';
import 'package:shrifashion/categories/SecondScreen.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'package:shrifashion/pages/Referral.dart';
import 'package:shrifashion/whyeco.dart';
import 'package:html/parser.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:shrifashion/pages/MyAccount.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';


import 'Service/FAQs.dart';

import 'categories/ThirdScreen.dart';

import 'components/Color.dart';


import 'package:firebase_database/firebase_database.dart';
class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final customer = FirebaseDatabase.instance.reference().child("customer");
  final category = FirebaseDatabase.instance.reference().child("category").orderByChild("status").equalTo("True");
  List randomProducts=[];
  List lists=[];
  List lists2=[];
  var future_subCategory;
  final subCategory = FirebaseDatabase.instance.reference().child("categorysub_final");
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
  @override
  void initState()
  {
    future_subCategory=subCategory.once();
  }

  @override
  Widget build(BuildContext context) {


    return

        //-------Drawer----------------
      Drawer(
          child: new ListView(
            children: <Widget>[
              StreamBuilder(
                stream: customer.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    lists.clear();
                    try
                    {
                      Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                      values.forEach((key,values) {
                        try{
                          if(values['customer_id'].toString()==customerId.toString())
                          {
                            lists.add(values);
                          }
                        }
                        catch(e)
                        {}

                      });
                    }
                    catch(e)
                  {
                    List<dynamic> values = snapshot.data.snapshot.value;
                    values.forEach((values) {
                      try{
                        if(values['customer_id'].toString()==customerId.toString())
                        {
                          lists.add(values);
                        }
                      }
                      catch(e)
                      {}

                    });
                  }


                    return GridView.builder(
                      physics: ScrollPhysics(),
                      itemCount: lists.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: MediaQuery.of(context)
                            .size
                            .width /
                            (MediaQuery.of(context).size.height / 3.5),
                      ),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {

                        return new UserAccountsDrawerHeader(
                          accountName: Text( lists[index]
                              ['firstname']
                              .toString()
                              .toUpperCase() +
                              " " +
                              lists[index]
                                  ['lastname']
                                  .toString()
                                  .toUpperCase(),
                            style: TextStyle(
                                color:Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          accountEmail: Text( lists[index]['email'].toString(),
                              style: TextStyle(
                                color:Theme.of(context).buttonColor,
                                  fontWeight: FontWeight.bold)),
                          currentAccountPicture: GestureDetector(
                            child: new CircleAvatar(
                              child:ClipRRect(
                                child: lists[index]['sex']=='F'?
                                Image.asset('images/female_user.jpeg'):
                                Image.asset('images/male_user.jpeg'),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          decoration: new BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Referral()));
                },
                child: ListTile(
                  title: Text('Refer & Earn'),
                  leading: Icon(FlutterIcons.user_friends_faw5s,),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
             ExpansionTile(
               title: Text("Categories"),
               leading: Icon(FlutterIcons.buffer_mco),
               children: [
                 StreamBuilder(
                     stream: category.onValue,
                     builder: (context, snapshot)  {

                       if (snapshot.hasData) {
                         lists2.clear();
                         try
                         {
                           Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                           if(values!=null)
                             values.forEach((key,values) {
                               if(values!=null)
                                 try{
                                   lists2.add(values);
                                 }
                                 catch(e)
                                 {

                                 }

                             });
                         }
                         catch(e)
                         {
                           List<dynamic> values = snapshot.data.snapshot.value;
                           if(values!=null)
                             values.forEach((values) {
                               if(values!=null)
                                 try{
                                   lists2.add(values);
                                 }
                                 catch(e)
                                 {

                                 }

                             });
                         }

                         if(lists2.isNotEmpty)
                           return ListView.builder(
                               itemCount: lists2.length,
                               physics: ScrollPhysics(),
                               scrollDirection: Axis.vertical,
                               shrinkWrap: true,
                               itemBuilder: (BuildContext context, int index) {
                                 final subCategory = FirebaseDatabase.instance.reference().child("categorysub_final").orderByChild("parent_id").equalTo(lists2[index]['category_id']);
                                 Widget image;
                                 image=FutureBuilder(
                                     future: imageurl(context, lists2[index]['image'], FirebaseStorage.instance),
                                     builder: (context,snap){
                                       Widget image=Container();
                                       if(snap.hasData)
                                       {

                                         try{
                                           image=Image.network(
                                             snap.data.image,
                                             fit: BoxFit.fill,
                                           );
                                         }
                                         catch(e)
                                         {
                                           image=Container();
                                         }
                                         return image;
                                       }
                                       else
                                       {
                                         return Container();
                                       }
                                     }
                                 );
                                 return ExpansionTile(
                                   leading: Container(
                                     width: MediaQuery.of(context).size.width / 10,
                                     height: MediaQuery.of(context).size.width / 10,
                                     child: image,
                                   ),
                                   title: new Text(_parseHtmlString(lists2[index]['name'])),
                                   children: [
                                     FutureBuilder(
                                         future: FirebaseDatabase.instance.reference().child("categorysub_final").orderByChild("parent_id").equalTo(lists2[index]['category_id']).once(),
                                         builder: (context, snapshot)  {
                                           if (snapshot.hasData) {
                                             lists.clear();
                                             try
                                             {
                                               List<dynamic> values = snapshot.data.value;
                                               if(values!=null)
                                                 values.forEach((values) {
                                                   if(values!=null && values['status']=="True")
                                                     lists.add(values);
                                                 });
                                             }
                                             catch(e)
                                             {
                                               Map<dynamic,dynamic> values = snapshot.data.value;
                                               if(values!=null )
                                                 values.forEach((key,values) {
                                                   if(values!=null && values['status']=="True")
                                                     lists.add(values);
                                                 });
                                             }

                                             if(lists.isNotEmpty)
                                             {
                                               return ListView.builder(
                                                 physics: NeverScrollableScrollPhysics(),
                                                 itemCount: lists.length,
                                                 scrollDirection: Axis.vertical,
                                                 shrinkWrap: true,
                                                 itemBuilder: (BuildContext context, index) {

                                                   return FutureBuilder(
                                                     future: imageurl(context, lists[index]["image"],FirebaseStorage.instance),
                                                     builder: (context,snap){
                                                       if(snap.hasData)
                                                       {
                                                         Widget image;
                                                         try{
                                                           image=ClipRRect(
                                                               borderRadius: BorderRadius.circular(15),
                                                               child: Image.network(
                                                                   snap.data.image,
                                                                   fit: BoxFit.fill,
                                                                   width: MediaQuery.of(context).size.width / 10,
                                                                   height: MediaQuery.of(context).size.width / 10
                                                               ));
                                                         }
                                                         catch(e){
                                                           image=ClipRRect(
                                                               borderRadius: BorderRadius.circular(15),
                                                               child: Container(
                                                                   width: MediaQuery.of(context).size.width / 10,
                                                                   height: MediaQuery.of(context).size.width / 10
                                                               )
                                                           );
                                                         }
                                                         return  ListTile(
                                                           leading:Container(
                                                             width: MediaQuery.of(context).size.width / 10,
                                                             height: MediaQuery.of(context).size.width / 10,
                                                             child: image,
                                                           ),
                                                           title: new Text(_parseHtmlString(lists[index]['name'])),
                                                           trailing: Icon(Icons.keyboard_arrow_right),
                                                           onTap: () {
                                                             Navigator.push(
                                                                 context,
                                                                 new MaterialPageRoute(
                                                                     builder: (context) => ThirdScreen(
                                                                         lists[index]['category_id'],
                                                                         lists[index]['name'])));
                                                           },
                                                         );
                                                       }
                                                       else
                                                       {
                                                         return  ListTile(
                                                           leading:Container(
                                                               width: MediaQuery.of(context).size.width / 10,
                                                               height: MediaQuery.of(context).size.width / 10,
                                                               child:image
                                                           ),
                                                           title: new Text(_parseHtmlString(lists[index]['name'])),
                                                           trailing: Icon(Icons.keyboard_arrow_right),
                                                           onTap: () {
                                                             Navigator.push(
                                                                 context,
                                                                 new MaterialPageRoute(
                                                                     builder: (context) => SecondScreen(
                                                                         lists[index]['category_id'],
                                                                         lists[index]['name'])));
                                                           },
                                                         );
                                                       }
                                                     },

                                                   );
                                                 },
                                               );
                                             }
                                             else
                                             {
                                               return  ListTile(
                                                 leading: Container(
                                                   width: MediaQuery.of(context).size.width / 10,
                                                   height: MediaQuery.of(context).size.width / 10,
                                                   child: image,

                                                 ),
                                                 title: new Text(_parseHtmlString(lists2[index]['name'])),
                                                 trailing: Icon(Icons.keyboard_arrow_right),
                                                 onTap: () {
                                                   Navigator.push(
                                                       context,
                                                       new MaterialPageRoute(
                                                           builder: (context) => ThirdScreen(
                                                               lists2[index]['category_id'],
                                                               lists2[index]['name'])));
                                                 },
                                               );
                                             }





                                           }
                                           else
                                           {
                                             return CircularProgressIndicator();
                                           }
                                         }

                                     ),

                                   ],
                                 );
                               }
                           );
                         else
                           return
                             Container();
                       }
                       else
                       {
                         return Center(child: CircularProgressIndicator(),);
                       }
                     }

                 ),

               ],
             ),

              InkWell(
                onTap: () {

                  Navigator.pop(context);
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => new Cart()));

                },
                child: ListTile(
                  title: Text('My Cart'),
                  leading: Icon(FlutterIcons.cart_mco,),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),


              InkWell(
                onTap: () {

                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => new MyAccount())).then((value) => setState((){}));

                },
                child: ListTile(
                  title: Text('My account'),
                  leading: Icon(Icons.person,),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),

              Divider(),
            /*  InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text('Buy Gift Card'),
                  //trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),*/
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>FAQs()));
                 },
                child: ListTile(
                  title: Text('FAQ'),
                  //trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         new MaterialPageRoute(
              //             builder: (context) =>WhyEco()));
              //   },
              //   child: ListTile(
              //     title: Text('Why organic?'),
              //     //trailing: Icon(Icons.keyboard_arrow_right),
              //   ),
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>AboutUs()));
                },
                child: ListTile(
                  title: Text('About Us'),
                  //  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
              InkWell(
                onTap: () {
                  //give
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>ShippingAndDeliveryInfo()));

                },
                child: ListTile(
                  title: Text('Shipping & Delivery information'),
                  //  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),

              InkWell(
                onTap: () {
                  String privacy_policy;
                  admin.once().then((snapshot){
                    try
                    {
                      Map<dynamic,dynamic> values=snapshot.value;
                      if(values!=null)
                        values.forEach((key, value) {
                          if(value!=null)
                          {
                            privacy_policy=value['privacy_policy'];

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
                            privacy_policy=value['privacy_policy'];
                          }
                        });
                    }
                    customLaunchURL(privacy_policy);
                  });
                },
                child: ListTile(
                  title: Text('Privacy Policy'),
                  //trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),

              InkWell(
                onTap: () {
                  String terms;
                  admin.once().then((snapshot){
                    try
                    {
                      Map<dynamic,dynamic> values=snapshot.value;
                      if(values!=null)
                        values.forEach((key, value) {
                          if(value!=null)
                          {
                            terms=value['terms_and_conditions'];

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
                            terms=value['terms_and_conditions'];
                          }
                        });
                    }
                    customLaunchURL(terms);
                  });
                  // Navigator.push(
                  //     context,
                  //     new MaterialPageRoute(
                  //         builder: (context) =>Terms()));
                },
                child: ListTile(
                  title: Text('Terms & Conditions'),
                  //  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
              InkWell(
                onTap: () {
                  //give
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>RefundPolicy()));
                },
                child: ListTile(
                  title: Text('Refunds and Cancelation policy'),
                  //  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),


            ],
          ),



    );
  }
customLaunchURL(String url)async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
}
