import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:shrifashionforbusiness/System/AddCountry.dart';
import 'package:shrifashionforbusiness/System/AddStoreLocation.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }
class StoreLocations extends StatefulWidget {
  @override
  _StoreLocationsState createState() => _StoreLocationsState();
}
class _StoreLocationsState extends State<StoreLocations> {
  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=storeLocations.onValue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,

        title: Text('Store Locations',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
                children: [
                  TableRow(children: [
                    Text('Store ID',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.left),
                    Text('Location',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center),
                    Text('Pin',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center),
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
              builder: (context,snapshot){
                if(snapshot.hasData)
                {
                  lists.clear();

                  try{
                    List<dynamic> values  = snapshot.data.snapshot.value;
                    values.forEach((values) {
                      try{
                        lists.add(values);
                      }
                      catch(e){
                      }
                    });
                  }catch(e){

                    Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
                    values.forEach((key,values) {
                      try{
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
                      Status status=lists[index]['status']=="True"?Status.enabled:Status.disabled;


                      try{
                        return InkWell(
                          child: Table(
                              border: TableBorder.all(width:0.2),
                              children: [
                                TableRow(
                                  children: [
                                    SizedBox(
                                      height:30,
                                      child: Text(
                                          lists[index]['store_id'],
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.start),
                                    ),
                                    SizedBox(
                                      height:30,
                                      child: Text(lists[index]['location'],
                                          textScaleFactor: 1.3,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.center),
                                    ),
                                    SizedBox(
                                      height:30,
                                      child: Text(lists[index]['PIN'],
                                          textScaleFactor: 1.3,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.center),
                                    ),
                                    SizedBox(
                                      height:30,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:20.0,right: 20),
                                        child: StoreStatus(status,lists[index]['store_id']),
                                      ),
                                    ),
                                  ],
                                )
                              ]
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

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: ((context)=>AddStoreLocation())));
        },
        tooltip: 'Add country',
        child: Icon(Icons.add),
      ),
    );
  }
}
class StoreStatus extends StatefulWidget {
  bool isSwitched ;
  var store_id;
  StoreStatus(Status status,var store_id)
  {
    this.store_id=store_id;
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
  _StoreStatusState createState() => _StoreStatusState();
}
class _StoreStatusState extends State<StoreStatus> {

  void toggleSwitch(bool value) {

    if(widget.isSwitched == false)
    {
      setState(() {
        widget.isSwitched = true;
        updateStoreLocation();
      });
    }
    else
    {
      setState(() {
        widget.isSwitched = false;
        updateStoreLocation();
      });

    }
  }
  void updateStoreLocation()
  {
    String StoreStatus=widget.isSwitched==true ?"True":"False";

    storeLocations.once().then(
            (DataSnapshot datasnapshot) {

          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['store_id'].toString() == widget.store_id.toString()) {
                  storeLocations.child(i.toString()).update(
                      {
                        "status":StoreStatus.toString(),
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
                if (values['store_id'].toString() == widget.store_id.toString()) {
                  storeLocations.child(key.toString()).update(
                      {
                        "status":StoreStatus.toString(),
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
      activeColor: Theme.of(context).buttonColor,
      activeTrackColor: Colors.green,
      inactiveThumbColor: Colors.red,
      inactiveTrackColor: Colors.grey,
    );
  }
}