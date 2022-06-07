import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/CustomDrawer.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final key = GlobalKey<ScaffoldState>();
  List lists=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        leading:  IconButton(
            icon: new Icon(Icons.menu,color: Colors.black,),
            onPressed: () => key.currentState.openDrawer()),
        elevation: 10.0,
        backgroundColor: backColor,
        title: Text(app_name,style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Text("Our Top 10 customers",style: TextStyle(color: Colors.black,fontFamily: custom_font),),
              ),
            ),
            StreamBuilder(
              stream: order_ids.onValue,
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
                  for(int i=0;i<lists.length;i++)
                  {
                    for(int j=0;j<lists.length-1;j++)
                    {
                      if(double.parse(lists[j]['total'].toString())<double.parse(lists[j+1]['total'].toString()))
                      {
                        double temp=double.parse(lists[j]['total'].toString());
                        lists[j]['total']=double.parse(lists[j+1]['total'].toString());
                        lists[j+1]['total']=temp;
                      }
                    }
                  }
                  return GridView.builder(
                    physics: ScrollPhysics(),
                    itemCount: 10,
                    shrinkWrap: true,
                    gridDelegate:
                    new SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: MediaQuery.of(context).size.width
                            /MediaQuery.of(context).size.height/0.5,
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, index) {


                      return Container(
                        decoration: BoxDecoration(

                            border: Border.all(
                                width: 5,
                                color: Colors.grey[50]
                            )),

                        // height: MediaQuery.of(context).size.height/10,
                        child: InkWell(
                          onTap: () {

                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              decoration: new BoxDecoration(
                                color: backColor,
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
                                    child: Container(

                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Container()
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(lists[index]['shipping_firstname']),
                                        Text(lists[index]['shipping_lastname']),
                                      ],
                                    ),
                                    flex: 4, //elevation: 10,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FittedBox(
                                        child: Text("\u{20B9}"+double.parse(lists[index]['total'].toString()).toStringAsFixed(2),
                                          style: TextStyle(color: barColor,fontSize: 15.0,
                                            fontWeight: FontWeight.bold,),
                                        ),
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: SizedBox(
                                          child: FittedBox(
                                            child: Text(
                                              lists[index]['order_id'],
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: barColor),
                                            ),
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
                      );
                    },
                  );
                }
                return Center(child:CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
