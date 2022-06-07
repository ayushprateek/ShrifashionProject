import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:shrifashionadmin/Components/GetImageUrl.dart';
import 'package:shrifashionadmin/Components/HtmlParser.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:shrifashionadmin/Masters/AddProduct.dart';
import 'package:shrifashionadmin/Masters/ProductDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}
class _ProductsState extends State<Products> {
  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=search.onValue;
    unitList.clear();
    unitConnection.once().then((DataSnapshot snapshot) {
      try
      {
        List<dynamic> values = snapshot.value;
        values.forEach((values) {
          unitList.add(values['unit']);
        });
      }
      catch(e)
      {
        print(e.toString());
        Map<dynamic,dynamic> values = snapshot.value;
        values.forEach((key,value) {
          unitList.add(value['unit']);
        });
      }
    });
    categoryNameList.clear();
    categoryList.clear();
    categories.once().then((DataSnapshot snapshot) {
      List<dynamic> values = snapshot.value;
      values.forEach((values) {
        try{
          if(values['status']=="True")
          {
            category=values['name'];
            category_id.text=values['category_id'];
            categoryNameList.add(values['name']);
            categoryList.add(values);
          }
        }
        catch(e)
        {

        }
      });
    });
    subCategories.once().then((DataSnapshot snapshot) {
      List<dynamic> values = snapshot.value;
      values.forEach((values) {
        try{
          if(values['status']=="True")
          {
            category=values['name'];
            category_id.text=values['category_id'];
            categoryNameList.add(values['name']);
            categoryList.add(values);
          }
        }
        catch(e)
        {

        }


      });
    });
    postalNameList.clear();
    postalList.clear();
    postalCodes.once().then((DataSnapshot snapshot) {
      try
      {
        List<dynamic> values = snapshot.value;
        values.forEach((values) {
          try{
            if(values['status']=="True")
            {
              postal=values['PIN'];
              postalNameList.add(values['PIN']);
              postalList.add(values);
            }
          }
          catch(e)
          {

          }

        });
      }
      catch(e)
      {
        Map<dynamic,dynamic> values = snapshot.value;

        values.forEach((key,values) {
          try{
            if(values['status']=="True")
            {
              postal=values['PIN'];
              postalNameList.add(values['PIN']);
              postalList.add(values);
            }
          }
          catch(e)
          {

          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StickyFooter(),
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: backColor,
          title: Text('Products',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
        ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
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
                      return GridView.builder(
                        physics: ScrollPhysics(),
                        itemCount: lists.length<100?lists.length:100,
                        shrinkWrap: true,
                        gridDelegate:
                        new SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: MediaQuery.of(context).size.width
                                /MediaQuery.of(context).size.height/0.5,
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, index) {
                          index=lists.length-(index+1);

                          Widget image;
                          image=FutureBuilder(
                            future: imageurl(context, lists[index]["image"],FirebaseStorage.instance),
                            builder: (context,snap){
                              if(snap.hasData)
                              {
                                Widget image;
                                try{
                                  image=ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                          snap.data.image,
                                          fit: BoxFit.fill,
                                          width: MediaQuery.of(context).size.width / 3,
                                          height: MediaQuery.of(context).size.width / 3
                                      ));
                                }
                                catch(e){
                                  image=ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                          width: MediaQuery.of(context).size.width / 3,
                                          height: MediaQuery.of(context).size.width / 3
                                      )
                                  );
                                }

                                return image;
                              }
                              return Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: MediaQuery.of(context).size.width / 3
                              );
                            },

                          );
                          image=lists[index]['stock_status_id']=="7"?image:Center(
                            child: Stack(
                              children: [
                                //lists[index].image
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: MediaQuery.of(context).size.width / 3,
                                  foregroundDecoration: BoxDecoration(
                                    color: Colors.grey,
                                    backgroundBlendMode: BlendMode.saturation,
                                  ),
                                  child: image,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:40.0,left:15),
                                  child: Center(
                                    child: Container(
                                      color: Colors.red,
                                      child: FittedBox(
                                        child: Text(lists[index]['stock_status'],style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          );


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
                                              child: IconButton(
                                                icon: Icon(Icons.edit,color: barColor,),
                                                onPressed: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>ProductDetails(product_id: lists[index]['product_id'],name: lists[index]['name'],))));
                                                },

                                              )),
                                        ),
                                      ),

                                      Expanded(
                                        child: image,
                                        flex: 4, //elevation: 10,
                                      ),
                                      Expanded(
                                        child: lists[index]['old_price']!=null && lists[index]['old_price']!=""?
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(children: [
                                            Expanded(
                                                child: FittedBox(
                                                  child: Text("\u{20B9}"+double.parse(lists[index]['new_price']).toStringAsFixed(2),
                                                    style: TextStyle(color: barColor,fontSize: 15.0,
                                                      fontWeight: FontWeight.bold,),
                                                  ),
                                                )),
                                            Expanded(
                                                child: FittedBox(
                                                  child: Text("\u{20B9}"+double.parse(lists[index]['old_price']).toStringAsFixed(2),
                                                    style: TextStyle(color: barColor,fontSize: 15.0,
                                                      fontWeight: FontWeight.bold,),),
                                                ))
                                          ],),
                                        ):
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: FittedBox(
                                                    child: Text("\u{20B9}"+double.parse(lists[index]['new_price']).toStringAsFixed(2),
                                                      style: TextStyle(color: barColor,
                                                        fontSize: 15.0,
                                                        fontWeight: FontWeight.bold,),
                                                    ),
                                                  ))
                                            ],
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
                                                  customHtmlParser(lists[index]['name']),
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
                  return Container();

                }
                return Center(child:CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: ((context)=>AddProduct())));
        },
        tooltip: 'Add PIN code',
        child: Icon(Icons.add),
      ),
    );
  }
}
