import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:shrifashionadmin/System/AddCurrency.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }
class Currencies extends StatefulWidget {
  @override
  _CurrenciesState createState() => _CurrenciesState();
}

class _CurrenciesState extends State<Currencies> {
  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=currencies.onValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: backColor,
        title: Text('Currencies',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
                children: [
                  TableRow(children: [
                    Text('Currency ID',
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
                    Text('Code',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center),
                    Text('Symbol',
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
                                TableRow(children: [
                                  Text(
                                      lists[index]['currency_id'],
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.start),
                                  Text(lists[index]['name'],
                                      textScaleFactor: 1.3,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.center),
                                  Text(lists[index]['code'],
                                      textScaleFactor: 1.3,
                                      textAlign: TextAlign.center),
                                  Text(lists[index]['symbol'],
                                      textScaleFactor: 1.3,
                                      textAlign: TextAlign.center),
                                  CurrencyStatus(status,lists[index]['currency_id'])
                                ])
                              ]
                          ),
                          onDoubleTap: (){
                            // animated_dialog_box.showScaleAlertBox(
                            //     title:Center(child: Text("Delete a currency")) , // IF YOU WANT TO ADD
                            //     context: context,
                            //     firstButton: MaterialButton(
                            //       // OPTIONAL BUTTON
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(40),
                            //       ),
                            //       color: Colors.white,
                            //       child: Text('Cancel'),
                            //       onPressed: () {
                            //         Navigator.of(context).pop();
                            //       },
                            //     ),
                            //     secondButton: MaterialButton(
                            //       // FIRST BUTTON IS REQUIRED
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(40),
                            //       ),
                            //       color: barColor,
                            //       child: Text('Remove'),
                            //       onPressed: () {
                            //         removeCurrency(lists[index]['currency_id'].toString());
                            //       },
                            //     ),
                            //     icon: Icon(Icons.delete_forever,color: Colors.red,), // IF YOU WANT TO ADD ICON
                            //     yourWidget: Text("Are you sure you want to remove "+lists[index]['name'] +" forever?")
                            // );
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
          Navigator.push(context, MaterialPageRoute(builder: ((context)=>AddCurrency())));
        },
        tooltip: 'Save',
        child: Icon(Icons.add),
      ),
    );
  }
  void removeCurrency(String currency_id)
  {
    currencies.once().then(
            (DataSnapshot datasnapshot) {
          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['currency_id'].toString() == currency_id.toString()) {
                  currencies.child(i.toString()).remove();
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
                  if (value['currency_id'].toString() == currency_id.toString()) {
                    currencies.child(key.toString()).remove();
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
              "Currency removed successfully",
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

class CurrencyStatus extends StatefulWidget {
  bool isSwitched ;
  var currency_id;
  CurrencyStatus(Status status,var currency_id)
  {
    this.currency_id=currency_id;
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
  _CurrencyStatusState createState() => _CurrencyStatusState();
}
class _CurrencyStatusState extends State<CurrencyStatus> {

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
    String currencyStatus=widget.isSwitched==true ?"True":"False";

    currencies.once().then(
            (DataSnapshot datasnapshot) {

          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['currency_id'].toString() == widget.currency_id.toString()) {
                  currencies.child(i.toString()).update(
                      {
                        "status":currencyStatus.toString(),
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
                if (values['currency_id'].toString() == widget.currency_id.toString()) {
                  currencies.child(key.toString()).update(
                      {
                        "status":currencyStatus.toString(),
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
