import 'package:shrifashion/MyAddress.dart';

import 'package:shrifashion/StickyFooter.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../mobileLogin.dart';
import 'package:shrifashion/OrderIds.dart';
import 'package:firebase_database/firebase_database.dart';
class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}
class _MyAccountState extends State<MyAccount> {
  final customer = FirebaseDatabase.instance.reference().child("customer");
  List lists=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title:  Text(
        "My Account",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,
            fontFamily: custom_font,
          color: Theme.of(context).buttonColor
        ),
      ),
      ),
      body: ListView(
        children: [
          // Container(
          //   height: 50,
          //   width: MediaQuery.of(context).size.width,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Center(
          //         child: FittedBox(
          //       child: Text(
          //         "My Account",
          //         style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,
          //         fontFamily: custom_font
          //         ),
          //       ),
          //     )),
          //   ),
          // ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 3,
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2.0,
                    offset: const Offset(5.0, 2.0),
                  ),
                ],
              ),
              margin: EdgeInsets.only(left: 8, top: 8, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder(
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

                            return GestureDetector(
                              child: new CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 8,
                                backgroundColor: Colors.grey,
                                child: ClipRRect(
                                  child: lists[0]['sex']=='F'?
                                  Image.asset('images/female_user.jpeg'):
                                  Image.asset('images/male_user.jpeg'),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            );
                          }

                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder(
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
                                    (MediaQuery.of(context).size.height / 6),
                              ),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, index) {

                                return Container(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            lists[index]
                                                    ['firstname']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +
                                                lists[index]
                                                    ['lastname']
                                                    .toString()
                                                    .toUpperCase(),
                                            style: TextStyle(
                                                color:Theme.of(context).buttonColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            child: Text(
                                                lists[index]['email'].toString(),
                                                style: TextStyle(
                                                    color:Theme.of(context).buttonColor,
                                                    fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(

                                              lists[index]
                                                      ['telephone']
                                                      .toString(),
                                              style: TextStyle(
                                                  color:Theme.of(context).buttonColor,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //),
                                );
                              },
                            );
                          }

                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                    flex: 2,
                  ),
                ],
              )),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new OrderIds()));
            },
            child: ListTile(
              title: Text('My Orders'),
              leading: Icon(Icons.markunread_mailbox,),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          InkWell(
            onTap: () {

              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Cart())).then((value) => setState((){}));
            },
            child: ListTile(
              title: Text('My Cart'),
              leading: Icon(FlutterIcons.cart_mco, ),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          InkWell(
            onTap: () {

              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new MyAddress())).then((value) => setState((){}));
            },
            child: ListTile(
              title: Text('My Address'),
              leading: Icon(Icons.location_on,),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          localStorage.get('guest_id')==null?
          InkWell(
            onTap: () async {
              await animated_dialog_box.showScaleAlertBox(
                  title:Center(child: Text("Logout"),) , // IF YOU WANT TO ADD
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

              child: Text('Logout',style:TextStyle(color: Colors.white)),
              onPressed: () {
              customerId=null;
              localStorage.setString("customerId", null);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              mobileLogin()), (Route<dynamic> route) => false);
              },
              ),
                  icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                  yourWidget: Container(
                    child: Text('Are you sure you want to log out?'),
                  ));

            },
            child: ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.exit_to_app),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ):
          InkWell(
            onTap: () async {
              customerId=null;
              localStorage.setString("customerId", null);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  mobileLogin()), (Route<dynamic> route) => false);
            },
            child: ListTile(
              title: Text('Login/Signup'),
              leading: Icon(Icons.exit_to_app,),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          // InkWell(
          //   onTap: () async {
          //     await animated_dialog_box.showScaleAlertBox(
          //         title:Center(child: Text("Deactivate account")) , // IF YOU WANT TO ADD
          //         context: context,
          //         firstButton: MaterialButton(
          //           // OPTIONAL BUTTON
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(40),
          //           ),
          //           color: Colors.white,
          //           child: Text('Cancel'),
          //           onPressed: () {
          //             Navigator.of(context).pop();
          //           },
          //         ),
          //         secondButton: MaterialButton(
          //           // FIRST BUTTON IS REQUIRED
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(40),
          //           ),
          //
          //           child: Text('Deactivate'),
          //           onPressed: () async {
          //             await deactivateAccount();
          //
          //             Navigator.push(
          //               context,
          //               new MaterialPageRoute(
          //                   builder: (context) => new mobileLogin()),);
          //
          //           },
          //         ),
          //         icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
          //         yourWidget: Container(
          //           child: Text('Are you sure you want Deactivate Account?'),
          //         ));
          //
          //
          //
          //
          //
          //
          //   },
          //   child: ListTile(
          //     title: Text('Deactivate Account'),
          //     leading: Icon(Icons.delete_forever, ),
          //     trailing: Icon(Icons.keyboard_arrow_right),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: StickyFooter(),
    );
  }
  Future<void> deactivateAccount() async {
    // String url = "https://shrifashion.com/prod/deactivateAccount.php";
    //
    // final response = await http.post(url,body: {
    //   "customerId":customerId
    // });
    //
    // //final response = await http.get(url);
    // String str = response.body;
    // str = str.trim();
    // str = str.substring(
    //     1,
    //     str.length -
    //         1);
    // print(response.body);

    customer.once().then(
            (DataSnapshot datasnapshot){
          List values= datasnapshot.value;
          for(int i=0;i<values.length;i++)
            {
              if(values[i]['customer_id']==customerId.toString())
              {
                customer.child(i.toString()).update({
                  "status":"0"
                });
              }
            }
          customerId=null;
          localStorage.setString("customerId", null);
            });




    Navigator.pop(context);
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new mobileLogin()));

  }
}
