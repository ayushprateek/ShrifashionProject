

import 'package:shrifashion/BottomSheet.dart';
import 'package:shrifashion/CartIcon.dart';
import 'package:shrifashion/components/Font.dart';

import 'package:shrifashion/mobileLogin.dart';
import 'package:flutter/material.dart';


import 'package:shrifashion/Order.dart';

import 'components/Color.dart';

import 'package:firebase_database/firebase_database.dart';
class OrderIds extends StatefulWidget {
  @override
  _OrderIdsState createState() => _OrderIdsState();
}

class _OrderIdsState extends State<OrderIds> {

  final key = GlobalKey<ScaffoldState>();
  final order_ids = FirebaseDatabase.instance.reference().child("order_ids");
  List lists=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: new AppBar(
        //elevation: 0.1,
        title: Text('My Orders',style: TextStyle(fontFamily: custom_font,color: Colors.black,),),
        leading:  IconButton(
            icon: new Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        actions: <Widget>[
          CartCount()

        ],
        //actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: order_ids.onValue,
              builder: (context, snapshot) {
                List<dynamic> values ;
                lists.clear();
                try{
                  values = snapshot.data.snapshot.value;
                  values.forEach((values) {
                    try{
                      if(values['customer_id']==customerId.toString())
                      {
                        lists.add(values);

                      }
                    }
                    catch(e){
                    }
                  });
                }catch(e){

                }
                for(int i=0;i<lists.length;i++)
                  {
                    for(int j=0;j<lists.length-1;j++)
                      {
                        if(int.parse(lists[j]['order_id'])<int.parse(lists[j+1]['order_id']))
                          {
                            var temp=lists[j];
                            lists[j]=lists[j+1];
                            lists[j+1]=temp;
                          }
                      }
                  }


                if (lists.isNotEmpty) {
                  return GridView.builder(
                    physics: ScrollPhysics(),
                    itemCount: lists.length,
                    scrollDirection: Axis.vertical,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 8),
                    ),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {


                      return Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(Consts.padding),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 13.0,
                              offset: const Offset(5.0, 2.0),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(left: 8, top: 8, right: 8),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: ((context)=>Order(lists[index]['order_id'],lists[index]['date_added'],lists[index]['orderStatus']))
                              )).then((value) => setState((){}));
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: FittedBox(
                                      fit:BoxFit.scaleDown,
                                      child: Text(lists[index]['order_id'], style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),

                                      ),
                                    ),
                                  ),
                                  flex: 1, //elevation: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(lists[index]['date_added']),
                                  ),
                                  flex: 2, //elevation: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                        fit:BoxFit.scaleDown,
                                        child: Text(lists[index]['orderStatus'])),
                                  ),
                                  flex: 2, //elevation: 10,
                                ),



                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_forward_ios),
                                  ),

                                  flex: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                        //),
                      );
                    },
                  );
                } else {
                  return Container();

                }
              },
            ),
            Container(
              height: 20,
              child:Text("")
            )
          ],
        ),
      ),

    );
  }
}
