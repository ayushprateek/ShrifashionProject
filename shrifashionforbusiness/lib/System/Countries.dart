import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:shrifashionforbusiness/System/AddCountry.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }
class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=countries.onValue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,

        title: Text('Countries',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
                columnWidths: {
                  0: FixedColumnWidth(3*MediaQuery.of(context).size.width/8),
                  1: FixedColumnWidth(3*MediaQuery.of(context).size.width/8),

                  2: FixedColumnWidth(MediaQuery.of(context).size.width/4),

                },
                children: [
                  TableRow(children: [
                    Text('Country ID',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.left),
                    Text('Name',
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
                              columnWidths: {
                                0: FixedColumnWidth(3*MediaQuery.of(context).size.width/8),
                                1: FixedColumnWidth(3*MediaQuery.of(context).size.width/8),

                                2: FixedColumnWidth(MediaQuery.of(context).size.width/4),

                              },
                              border: TableBorder.all(width:0.2),
                              children: [
                                TableRow(
                                    children: [
                                  SizedBox(
                                    height:30,
                                    child: Text(
                                        lists[index]['country_id'],
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.start),
                                  ),
                                      SizedBox(
                                        height:30,
                                    child: Text(lists[index]['name'],
                                        textScaleFactor: 1.3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.center),
                                  ),
                                      SizedBox(
                                        height:30,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:17.0,right: 17),
                                      child: CountryStatus(status, lists[index]['country_id']),
                                    ),
                                  ),
                                ],
                                )
                              ]
                          ),
                          onDoubleTap: (){
                          },
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
          Navigator.push(context, MaterialPageRoute(builder: ((context)=>AddCountry())));
        },
        tooltip: 'Add country',
        child: Icon(Icons.add),
      ),
    );
  }

}
class CountryStatus extends StatefulWidget {
  bool isSwitched ;
  var country_id;
  CountryStatus(Status status,var country_id)
  {
    this.country_id=country_id;
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
  _CountryStatusState createState() => _CountryStatusState();
}
class _CountryStatusState extends State<CountryStatus> {

  void toggleSwitch(bool value) {

    if(widget.isSwitched == false)
    {
      setState(() {
        widget.isSwitched = true;
        updatePostalCode();
      });
    }
    else
    {
      setState(() {
        widget.isSwitched = false;
        updatePostalCode();
      });

    }
  }
  void updatePostalCode()
  {
    String countryStatus=widget.isSwitched==true ?"True":"False";

    countries.once().then(
            (DataSnapshot datasnapshot) {

          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['country_id'].toString() == widget.country_id.toString()) {
                  countries.child(i.toString()).update(
                      {
                        "status":countryStatus.toString(),
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
                if (values['country_id'].toString() == widget.country_id.toString()) {
                  countries.child(key.toString()).update(
                      {
                        "status":countryStatus.toString(),
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