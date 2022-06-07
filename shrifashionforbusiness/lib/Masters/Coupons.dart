import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/HtmlParser.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:shrifashionforbusiness/Masters/AddCoupon.dart';
import 'package:shrifashionforbusiness/Masters/EditCoupon.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Coupons extends StatefulWidget {
  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=coupons.onValue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
        appBar: AppBar(
          elevation: 10.0,
          
          title: Text('Coupons',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
        ),
      body:  StreamBuilder(
        stream: connection,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            lists.clear();

            try{
              List<dynamic> values  = snapshot.data.snapshot.value;
              values.forEach((values) {
                try{
                  if(values!=null)
                  {
                    lists.add(values);
                  }
                }
                catch(e){
                }
              });
            }catch(e){

              Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
              values.forEach((key,values) {
                try{
                  if( values!=null )
                  {
                    lists.add(values);
                  }
                }
                catch(e){
                }
              });
            }
            return GridView.builder(
              physics: ScrollPhysics(),
              itemCount: lists.length,
              shrinkWrap: true,
              gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 1,
                  childAspectRatio: MediaQuery.of(context).size.width
                      /MediaQuery.of(context).size.height/0.5,
                  crossAxisCount: 2),
              itemBuilder: (BuildContext context, index) {
                var data = snapshot.data;
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(

                          border: Border.all(
                              width: 5,
                              color: Colors.grey[50]
                          )),

                      child: InkWell(
                        onTap: () {

                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Theme.of(context).buttonColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10.0,
                                    offset: const Offset(5.0, 2.0),
                                  ),
                                ],
                              ),
                              child:  Column(
                                children: [
                                  Expanded(
                                    child: Container(),
                                    flex: 5, //elevation: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: SizedBox(
                                          child: Text(
                                            customHtmlParser(lists[index]['code']),
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),

                                    flex: 1, //elevation: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 1, right: 10,
                        child: IconButton(
                          icon: Icon(Icons.edit,color: Colors.white,),
                        onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context)=>
                                    EditCoupon(
                                      coupon_id: lists[index]['coupon_id'],
                                      name: lists[index]['code'],
                                    ))));
                        },
                        )),
                  ],
                );


              },
            );
          }
          return Center(child:CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: ((context)=>AddCoupon())));
        },
        tooltip: 'Add coupon',
        child: Icon(Icons.add),
      ),
    );
  }


}
