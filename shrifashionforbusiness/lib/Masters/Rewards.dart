import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Rewards extends StatefulWidget {
  @override
  _RewardsState createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=customerRewards.onValue;
  }
  void update(String customer_id,String points)
  {

    customerRewards.once().then(
            (DataSnapshot datasnapshot) {
          List<dynamic> values = datasnapshot.value;
          for (int i = 0; i < values.length; i++) {
            try{
              if (values[i]['customer_id'].toString() == customer_id) {
                customerRewards.child(i.toString()).update(
                    {
                      'points':points.toString(),
                    });
              }
            }
            catch(e) {
              print(e.toString());
            }

          }
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg:
              "Reward updated",
              toastLength: Toast
                  .LENGTH_SHORT,
              gravity:
              ToastGravity
                  .BOTTOM,
              timeInSecForIosWeb:
              1,
              fontSize: 16.0);
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
        appBar: AppBar(
          elevation: 10.0,
          
          title: Text('Rewards',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
        ),
      body:  ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
                children: [
                  TableRow(children: [
                    Text('Customer ID',
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
                    Text('Rewards',
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
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: lists.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      try{
                        return InkWell(
                          child: Table(
                              border: TableBorder.all(width:0.2),
                              children: [
                                TableRow(children: [
                                  Text(
                                      lists[index]['customer_id'],
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.start),
                                  Text(lists[index]['firstname']+" "+
                                      lists[index]['lastname'],
                                      textScaleFactor: 1.3,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.center),
                                  Text(lists[index]['points'],
                                      textScaleFactor: 1.3,
                                      textAlign: TextAlign.center),
                                ])
                              ]
                          ),
                          onDoubleTap: (){
                            TextEditingController rewards=TextEditingController();
                            rewards.text=lists[index]['points'];
                             animated_dialog_box.showScaleAlertBox(
                                title:Center(child: Text("Update")) , // IF YOU WANT TO ADD
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  color: Theme.of(context).buttonColor,
                                  child: Text('Update'),
                                  onPressed: () {
                                    update(lists[index]['customer_id'],rewards.text);
                                  },
                                ),
                                icon: Icon(Icons.update,color: Theme.of(context).buttonColor,), // IF YOU WANT TO ADD ICON
                                yourWidget: Column(
                                  children: [
                                    Container(
                                      child: Text('Update the rewards of '+lists[index]['firstname']+" "+
                                          lists[index]['lastname'],style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Container(
                                      child: TextField(
                                        controller: rewards,
                                      ),
                                    ),
                                  ],
                                ));
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

    );
  }
}
