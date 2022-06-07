import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:shrifashionforbusiness/UI/CustomerInfo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
enum Status { enabled, disabled }
class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=customers.onValue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: StickyFooter(),
        appBar: AppBar(
          elevation: 10.0,

          title: Text('Customers',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
        ),
        body: ListView(
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
                      Text('Mobile',
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

                    return ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount: lists.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        var firstName=lists[index]['firstname']==null?"":lists[index]['firstname'];
                        var lastName=lists[index]['lastname']==null?"":lists[index]['lastname'];
                        Status status=lists[index]['status']=="True"?Status.enabled:Status.disabled;
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
                                    Text(firstName.toString().toUpperCase()+" "+
                                        lastName.toString().toUpperCase(),
                                        textScaleFactor: 1.3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.center),
                                    Text(lists[index]['telephone'],
                                        textScaleFactor: 1.3,
                                        textAlign: TextAlign.center),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomerStatus(status,lists[index]['customer_id']),
                                    )
                                  ])
                                ]
                            ),
                            onDoubleTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: ((context)=>CustomerInfo(customer_id: lists[index]['customer_id'],customer_name: firstName.toString().toUpperCase()+" "+
                                  lastName.toString().toUpperCase(),))));
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
        )
    );
  }
}

class CustomerStatus extends StatefulWidget {
  bool isSwitched ;
  var customer_id;
  CustomerStatus(Status status,var customer_id)
  {
    this.customer_id=customer_id;
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
  _CustomerStatusState createState() => _CustomerStatusState();
}
class _CustomerStatusState extends State<CustomerStatus> {

  void toggleSwitch(bool value) {

    if(widget.isSwitched == false)
    {
      setState(() {
        widget.isSwitched = true;
        updateCustomerStatus();
      });
    }
    else
    {
      setState(() {
        widget.isSwitched = false;
        updateCustomerStatus();
      });

    }
  }
  void updateCustomerStatus()
  {
    String customerStatus=widget.isSwitched==true ?"True":"False";

    customers.once().then(
            (DataSnapshot datasnapshot) {

          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['customer_id'].toString() == widget.customer_id.toString()) {
                  customers.child(i.toString()).update(
                      {
                        "status":customerStatus.toString(),
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
                if (values['customer_id'].toString() == widget.customer_id.toString()) {
                  customers.child(key.toString()).update(
                      {
                        "status":customerStatus.toString(),
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
