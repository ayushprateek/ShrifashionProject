import 'dart:async';

import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }
class PostalCodes extends StatefulWidget {
  @override
  _PostalCodesState createState() => _PostalCodesState();
}

class _PostalCodesState extends State<PostalCodes> {
  var connection;
  List lists=[];
  bool added=false;
  TextEditingController address=TextEditingController();
  TextEditingController code=TextEditingController();
  @override
  void initState()
  {
    connection=postalCodes.onValue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StickyFooter(),
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: backColor,
          title: Text('Postal codes',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
        ),
      body:  ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
                columnWidths: {
                  0: FixedColumnWidth(3*MediaQuery.of(context).size.width/4),
                  1: FixedColumnWidth(MediaQuery.of(context).size.width/4)
                },
                children: [
                  TableRow(children: [
                    Text('PIN',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.left),
                    Text('Status',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center),
                  ])
                ]
            ),
          ),
          StreamBuilder(
            stream: connection,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                lists.clear();

                try{
                  List<dynamic> values  = snapshot.data.snapshot.value;
                  values.forEach((values) {
                    try{
                      if(values!=null)
                      lists.add(values);
                    }
                    catch(e){
                    }
                  });
                }catch(e){

                  Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
                  values.forEach((key,values) {
                    try{
                      if(values!=null)
                      lists.add(values);
                    }
                    catch(e){
                    }
                  });
                }
                if(lists.isNotEmpty)
                  {
                    return ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount: lists.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        Status status=lists[index]['status']=="True"?Status.enabled:Status.disabled;


                        return Container(
                          decoration: BoxDecoration(

                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey[50]
                              )),

                          // height: MediaQuery.of(context).size.height/10,
                          child: InkWell(
                            onDoubleTap: ()  {

                              animated_dialog_box.showScaleAlertBox(
                                  title:Center(child: Text("Delete a postal code")) , // IF YOU WANT TO ADD
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
                                    color: barColor,
                                    child: Text('Remove'),
                                    onPressed: () {
                                      removePostalCode(lists[index]['PIN'].toString());
                                    },
                                  ),
                                  icon: Icon(Icons.delete_forever,color: Colors.red,), // IF YOU WANT TO ADD ICON
                                  yourWidget: Text("Are you sure you want to remove "+lists[index]['PIN'] +" forever?")
                              );
                            },
                            child: Table(
                                border: TableBorder.all(width:0.2),
                                columnWidths: {
                                  0: FixedColumnWidth(3*MediaQuery.of(context).size.width/4),
                                  1: FixedColumnWidth(MediaQuery.of(context).size.width/4)
                                },
                                children: [
                                  TableRow(
                                      children: [
                                    Text(
                                        lists[index]['PIN'],
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.start),
                                    Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:15.0,right: 15.0),
                                          child: PostalCodeStatus(status,lists[index]['PIN']),
                                        ),
                                      width: MediaQuery.of(context).size.width/4,
                                    )
                                  ],
                                  )
                                ]
                            ),
                          ),
                        );

                      },
                    );
                  }
                else
                  {
                    return Container();
                  }



              }
              return Center(child:CircularProgressIndicator());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(!added)
            {
              added=true;
              await animated_dialog_box.showScaleAlertBox(
                  title:Center(child: Text("Add a postal code")) , // IF YOU WANT TO ADD
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
                    color: barColor,
                    child: Text('Update'),
                    onPressed: () {
                      addPostalCode();
                    },
                  ),
                  icon: Icon(Icons.edit,color: Colors.red,), // IF YOU WANT TO ADD ICON
                  yourWidget: Container(
                    child: Column(
                      children: [
                        TextField(
                          controller: code,
                          decoration: InputDecoration(
                              hintText: 'Postal code'
                          ),
                        ),
                        Text(""),
                      ],
                    ),
                  ));
            }


        },
        tooltip: 'Add PIN code',
        child: Icon(Icons.add),
      ),
    );
  }
  void addPostalCode()
  {
    postalCodesLast.once().then(
            (DataSnapshot datasnapshot){
          Map<dynamic,dynamic> values= datasnapshot.value;
          values.forEach((key,value){
            int newKey=int.parse(key.toString())+1;
            postalCodes.child(newKey.toString()).set({
              "PIN":code.text.toString(),
              "status":"True"
            });


          });
          code.clear();
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
              "New postal code added",
              toastLength: Toast
                  .LENGTH_SHORT,
              gravity:
              ToastGravity
                  .BOTTOM,
              timeInSecForIosWeb:
              1,
              fontSize: 16.0);
        }
    );
  }
  void removePostalCode(String postalCode)
  {
    postalCodes.once().then(
            (DataSnapshot datasnapshot) {
          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['PIN'].toString() == postalCode.toString()) {
                  postalCodes.child(i.toString()).remove();
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
                if(value!=null)
                  if (value['PIN'].toString() == postalCode.toString()) {
                    postalCodes.child(key.toString()).remove();
                  }
              }
              catch(e)
              {
              }
            });
          }
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
              "Postal code removed successfully",
              toastLength: Toast
                  .LENGTH_SHORT,
              gravity:
              ToastGravity
                  .BOTTOM,
              timeInSecForIosWeb:
              1,
              fontSize: 16.0);

        }).then((value) => setState((){}));
  }
}

class PostalCodeStatus extends StatefulWidget {
  bool isSwitched ;
  var PIN;
  PostalCodeStatus(Status status,var PIN)
  {
    this.PIN=PIN;
    if(status==Status.enabled)
      {
        isSwitched=true;
      }
    else
      {
        isSwitched=false;
      }
  }
  @override
  _PostalCodeStatusState createState() => _PostalCodeStatusState();
}
class _PostalCodeStatusState extends State<PostalCodeStatus> {

  void toggleSwitch(bool value) {

    if(widget.isSwitched == false)
    {
      animated_dialog_box.showScaleAlertBox(
          title:Center(child: Text("Delete")) , // IF YOU WANT TO ADD
          context: context,
          firstButton: MaterialButton(
            // OPTIONAL BUTTON
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            color: Colors.white,
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          secondButton: MaterialButton(
            // FIRST BUTTON IS REQUIRED
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            color: barColor,
            child: Text('Yes',style: TextStyle(color: Colors.white),),
            onPressed: () {
              setState(() {
                widget.isSwitched = true;
                updatePostalCode();
              });
              Navigator.of(context).pop();
            },
          ),
          icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
          yourWidget: Container(
            child: Text('Turn this postalcode on?'),
          ));

    }
    else
    {
      animated_dialog_box.showScaleAlertBox(
          title:Center(child: Text("Delete")) , // IF YOU WANT TO ADD
          context: context,
          firstButton: MaterialButton(
            // OPTIONAL BUTTON
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            color: Colors.white,
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          secondButton: MaterialButton(
            // FIRST BUTTON IS REQUIRED
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            color: barColor,
            child: Text('Yes',style: TextStyle(color: Colors.white),),
            onPressed: () {
              setState(() {
                widget.isSwitched = false;
                updatePostalCode();
              });
              Navigator.of(context).pop();
            },
          ),
          icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
          yourWidget: Container(
            child: Text('Turn this postalcode off?'),
          ));


    }
  }
  void updatePostalCode()
  {
    String postalStatus=widget.isSwitched==true ?"True":"False";

    postalCodes.once().then(
            (DataSnapshot datasnapshot) {

          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['PIN'].toString() == widget.PIN.toString()) {
                  postalCodes.child(i.toString()).update(
                      {
                        "status":postalStatus.toString(),
                      });
                }
              }
              catch(e) {
                print(e.toString());
              }

            }
          }
          catch(e)
          {
            Map<dynamic,dynamic> values = datasnapshot.value;
            values.forEach((key, value) {
              try{
                if (values['PIN'].toString() == widget.PIN.toString()) {
                  postalCodes.child(key.toString()).update(
                      {
                        "status":postalStatus.toString(),
                      });
                }
              }
              catch(e) {
              }
            });

          }
        });


  }
  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: toggleSwitch,
      value: widget.isSwitched,
      activeColor: barColor,
      activeTrackColor: Colors.green,
      inactiveThumbColor: Colors.red,
      inactiveTrackColor: Colors.grey,
    );
  }
}


