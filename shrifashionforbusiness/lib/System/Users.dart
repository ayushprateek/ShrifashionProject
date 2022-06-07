import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:shrifashionforbusiness/System/AddCountry.dart';
import 'package:shrifashionforbusiness/System/AddStoreLocation.dart';
import 'package:shrifashionforbusiness/System/AddUser.dart';
import 'package:shrifashionforbusiness/System/EditUser.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}
class _UsersState extends State<Users> {
  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=users.onValue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,

        title: Text('Users',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
                children: [
                  TableRow(children: [
                    Text('User ID',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.left),
                    Text('First name',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center),
                    Text('Last name',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center),
                    Text('Username',
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
                      var status=lists[index]['status']=="True"?"Enabled":"Disabled";


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
                                          lists[index]['user_id'],
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.start),
                                    ),
                                    SizedBox(
                                      height:30,
                                      child: Text(
                                          lists[index]['first_name'],
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.start),
                                    ),
                                    SizedBox(
                                      height:30,
                                      child: Text(
                                          lists[index]['last_name'],
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.start),
                                    ),
                                    SizedBox(
                                      height:30,
                                      child: Text(
                                          lists[index]['username'],
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.start),
                                    ),
                                    SizedBox(
                                      height:30,
                                      child: Text(
                                          status,
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.start),
                                    ),

                                  ],
                                )
                              ]
                          ),
                          onDoubleTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: ((context)=>EditUser(user_id:lists[index]['user_id'],name:lists[index]['first_name']))));

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
          Navigator.push(context, MaterialPageRoute(builder: ((context)=>AddUser())));
        },
        tooltip: 'Add country',
        child: Icon(Icons.add),
      ),
    );
  }
}
