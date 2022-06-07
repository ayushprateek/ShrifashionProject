import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:shrifashionforbusiness/UI/EditAddress.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';

class CustomerInfo extends StatefulWidget {
  String customer_id,customer_name;
  CustomerInfo({this.customer_id,this.customer_name});
  @override
  _CustomerInfoState createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  var connection;
  var getAddress;
  List lists=[];
  List addressList=[];
  var addressID;
  @override
  void initState()
  {
    connection=customers.onValue;
    getAddress=address.onValue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: StickyFooter(),
        appBar: AppBar(
          elevation: 10.0,
          
          title: Text(widget.customer_name,style: TextStyle(color: Colors.black,fontFamily: custom_font),),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom:8.0,top:8.0,left: 15.0),
              child: Container(
                child: Text("Customer Basic Info",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            StreamBuilder(
                stream: connection,
                builder: (context,snapshot){
                  if(snapshot.hasData)
                  {
                    lists.clear();

                    try{
                      List<dynamic> values  = snapshot.data.snapshot.value;
                      values.forEach((values) {
                        try{
                          if(values['customer_id']==widget.customer_id)
                          lists.add(values);
                        }
                        catch(e){
                        }
                      });
                    }catch(e){

                      Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
                      values.forEach((key,values) {
                        try{
                          if(values['customer_id']==widget.customer_id)
                          lists.add(values);
                        }
                        catch(e){
                        }
                      });
                    }
                    return ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount: lists.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        var firstName=lists[index]['firstname']==null?"":lists[index]['firstname'];
                        var lastName=lists[index]['lastname']==null?"":lists[index]['lastname'];
                        try{
                          return Container(
                            height: MediaQuery.of(context).size.height/8,
                            margin: EdgeInsets.only(left: 15.0, right: 15.0,bottom:10),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0,
                                  offset: const Offset(5.0, 2.0),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Table(
                                      border: TableBorder.all(width:0.2),
                                      children: [
                                        TableRow(children: [
                                          Text(
                                              'Customer ID',
                                              textScaleFactor: 1.2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                              textAlign: TextAlign.start),
                                          Text(
                                              lists[index]['customer_id'],
                                              textScaleFactor: 1.2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                              textAlign: TextAlign.center),
                                        ]),
                                        TableRow(children: [
                                          Text(
                                              'Customer Name',
                                              textScaleFactor: 1.2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                              textAlign: TextAlign.start),
                                          Text(firstName.toString().toUpperCase()+" "+
                                              lastName.toString().toUpperCase(),
                                              textScaleFactor: 1.2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                              textAlign: TextAlign.center),
                                        ]),
                                        TableRow(children: [
                                          Text(
                                              'Customer Mobile',
                                              textScaleFactor: 1.2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                              textAlign: TextAlign.start),
                                          Text(lists[index]['telephone'],
                                              textScaleFactor: 1.2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                              textAlign: TextAlign.center),
                                        ]),

                                      ]
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        catch(e)
                        {
                          return Container();
                        }

                      },
                    );
                  }

                  else
                    return Center(child: CircularProgressIndicator(),);


                }),
            Padding(
              padding: const EdgeInsets.only(bottom:8.0,top:8.0,left: 15.0),
              child: Container(
                child: Text("Customer Address",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

            StreamBuilder(
              stream: getAddress,
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  addressList.clear();
                  try
                  {
                    List<dynamic> values = snapshot.data.snapshot.value;
                    values.forEach((values) {
                      try{
                        if(values['customer_id']==widget.customer_id.toString()  )
                        {
                          addressList.add(values);
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
                        if(values['customer_id']==widget.customer_id.toString()  )
                        {
                          addressList.add(values);
                        }




                      }
                      catch(e)
                      {
                      }
                    });
                  }


                  return ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: addressList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {

                      return Container(
                        height: MediaQuery.of(context).size.height/7,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16.0),
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
                                            addressList[index]
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
                                            addressList[index]
                                            ['flat']
                                                .toString()
                                                .toUpperCase() +
                                                " " +
                                                addressList[index]
                                                ['society']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +
                                                addressList[index]
                                                ['lane']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +addressList[index]
                                            ['landmark']
                                                .toString()
                                                .toUpperCase() +
                                                " " +
                                                addressList[index]
                                                ['address_1']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +
                                                addressList[index]
                                                ['city']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +
                                                addressList[index]
                                                ['state']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +
                                                addressList[index]
                                                ['country']
                                                    .toString()
                                                    .toUpperCase() +
                                                " " +
                                                addressList[index]['postcode'].toString(),
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
                                                    builder: (context) => new EditAddress(
                                                        addressList[index]['first_name'],
                                                        addressList[index]['last_name'],
                                                        addressList[index]['address_id'],
                                                        addressList[index]['customer_id'],
                                                        addressList[index]['flat'],

                                                        addressList[index]['society'],
                                                        addressList[index]['company'],
                                                        addressList[index]['address_1'],
                                                        addressList[index]['address_2'],

                                                        addressList[index]['postcode'],
                                                        addressList[index]['country'],
                                                        addressList[index]['state'],
                                                        addressList[index]['city'],
                                                        addressList[index]['lane'],
                                                        addressList[index]['landmark']
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

                                            addressID = addressList[index]['address_id'];
                                            animated_dialog_box.showScaleAlertBox(
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
                                                  color: Theme.of(context).buttonColor,
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
            )

          ],
        )
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
                if (values[i]['customer_id'].toString() == EditAddress.customer_id.toString() && values[i]['address_id'].toString() == addressID.toString()) {
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
                if (value['customer_id'].toString() == EditAddress.customer_id.toString() && value['address_id'].toString() == addressID.toString()) {
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
}
