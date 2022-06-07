import 'package:shrifashion/CartIcon.dart';
import 'package:shrifashion/CustomDrawer.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:shrifashion/components/Font.dart';

import 'package:shrifashion/editAddress.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:shrifashion/Address.dart';
import 'package:shrifashion/Navbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'BottomSheet.dart';
import 'components/Color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
int numOfAddress=0;
class MyAddress extends StatefulWidget {
  @override
  _MyAddressState createState() => _MyAddressState();
}
class _MyAddressState extends State<MyAddress> {
  var addressID;
  final address = FirebaseDatabase.instance.reference().child("address");
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  var future_address;
  List lists=[];

  @override
  void initState() {
    super.initState();
    future_address=address.once();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        //elevation: 0.1,
        title: Text('My Address',style: TextStyle(fontFamily: custom_font,color: Colors.black),),
        leading:  IconButton(
            icon: new Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            }),

        actions: <Widget>[
          CartCount()
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              onTap: () {
                if(numOfAddress<4)
                  {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new NewAddress(false))).then((value) => setState((){}));
                  }
                else
                  {
                    Fluttertoast.showToast(
                        msg:
                        "You can not add more that 4 addresses",
                        toastLength: Toast
                            .LENGTH_SHORT,
                        gravity:
                        ToastGravity
                            .BOTTOM,
                        timeInSecForIosWeb:
                        1,
                        fontSize: 16.0);

                  }

              },
              child: ListTile(
                title: Text(
                  'Add a New address',
                  style: TextStyle(color: Theme.of(context).buttonColor,),
                ),
                leading: Icon(Icons.add, ),
              ),
            ),
          ),
          Container(
            //color: Colors.white,
            height: 25.0,
            width: MediaQuery.of(context).size.width,
            child: Text(""),
          ),
          Container(

            child: StreamBuilder(
              stream: address.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  numOfAddress=0;
                  lists.clear();

                  try
                  {
                    List<dynamic> values = snapshot.data.snapshot.value;
                    values.forEach((values) {
                      try{
                        if(values['customer_id']==customerId.toString()  )
                        {
                          lists.add(values);
                          numOfAddress++;
                        }




                      }
                      catch(e)
                      {
                      }
                    });
                  }
                  catch(e)
                {
                  Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                  values.forEach((key,values) {
                    try{
                      if(values['customer_id']==customerId.toString()  )
                      {
                        lists.add(values);
                        numOfAddress++;
                      }




                    }
                    catch(e)
                    {
                    }
                  });
                }


                  return ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: lists.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {

                      return Container(
                        height: MediaQuery.of(context).size.height/7,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(Consts.padding),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: const Offset(5.0, 2.0),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(left: 15.0, right: 15.0,bottom:10),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [

                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 8.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            lists[index]
                                            ['company']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 10.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: [
                                          Text(
                                            lists[index]
                                            ['flat']
                                                .toString()
                                                .toUpperCase() +
                                                " " +
                                                lists[index]
                                                ['society']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +
                                                lists[index]
                                                ['lane']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +lists[index]
                                            ['landmark']
                                                .toString()
                                                .toUpperCase() +
                                                " " +
                                                lists[index]
                                                ['address_1']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +
                                                lists[index]
                                                ['city']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +
                                                lists[index]
                                                ['state']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +
                                                lists[index]
                                                ['country']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +
                                                lists[index]['postcode'].toString(),
                                            maxLines: 3,
                                            style: TextStyle(
                                                color: Colors.grey, fontSize: 12),
                                          ),
                                          Container(
                                            height: 5,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              flex: 8,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0,right: 2.0,top: 3.0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child:OutlineButton(
                                          borderSide: BorderSide( color: Colors.transparent),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                15.0),
                                          ),
                                          textColor: Colors.white,
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(2.0),
                                          onPressed: () async {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) => new editAddress(
                                                        lists[index]['first_name'],
                                                        lists[index]['last_name'],
                                                        lists[index]['address_id'],
                                                        lists[index]['customer_id'],
                                                        lists[index]['flat'],

                                                        lists[index]['society'],
                                                        lists[index]['company'],
                                                        lists[index]['address_1'],
                                                        lists[index]['address_2'],

                                                        lists[index]['postcode'],
                                                        lists[index]['country'],
                                                        lists[index]['state'],
                                                        lists[index]['city'],
                                                      lists[index]['lane'],
                                                        lists[index]['landmark']
                                                    ))).then((value) => setState((){}));
                                          },
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: new Text(
                                              "Edit",
                                              style: TextStyle(color: Theme.of(context).buttonColor),
                                            ),
                                          )),
                                      /*RaisedButton(
                                        child: FittedBox(child: Text('Edit')),
                                        onPressed: () {
                                        },
                                      ),*/
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0,right: 2.0,bottom: 2.0),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child:OutlineButton(
                                          borderSide: BorderSide( color: Colors.transparent),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                15.0),
                                          ),
                                          textColor: Colors.white,
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(0.0),
                                          onPressed: () async {

                                            addressID = lists[index]['address_id'];
                                            setState(() {
                                              confirm();
                                            });

                                          },
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: new Text(
                                              "Delete",
                                              style: TextStyle(color: Theme.of(context).buttonColor),
                                            ),
                                          )),
                                      /*RaisedButton(
                                        child: FittedBox(child: Text('Edit')),
                                        onPressed: () {
                                        },
                                      ),*/
                                    ),
                                  ),

                                ],
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else
                {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void delete() {





    address.once().then(
            (DataSnapshot datasnapshot) {
              try
              {
                List<dynamic> values = datasnapshot.value;
                for (int i = 0; i < values.length; i++) {
                  try{
                    if (values[i]['customer_id'].toString() == customerId.toString() && values[i]['address_id'].toString() == addressID.toString()) {
                      address.child(i.toString()).remove();


                    }
                  }
                  catch(e)
                  {

                  }

                }
              }
              catch(e)
              {
                Map<dynamic,dynamic> values = datasnapshot.value;
                values.forEach((key,value){
                  try{
                    if (value['customer_id'].toString() == customerId.toString() && value['address_id'].toString() == addressID.toString()) {
                      address.child(key.toString()).remove();


                    }
                  }
                  catch(e)
                  {

                  }
                });
              }

        }).then((value) => setState((){}));

  }

  Future<void> confirm() async {
    await animated_dialog_box.showScaleAlertBox(
        title:Center(child: Text("Delete")) , // IF YOU WANT TO ADD
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

          child: Text('Delete'),
          onPressed: () {
            setState(() {
              delete(); //***********************************************************DELETE CALLED
              Navigator.of(context).pop(context);

            });

          },
        ),
        icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
        yourWidget: Container(
          child: Text('Are you sure you want to Delete this address?'),
        ));
  }
}
