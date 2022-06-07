import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/GetImageUrl.dart';
import 'package:shrifashionforbusiness/Components/HtmlParser.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:shrifashionforbusiness/Masters/AddCategory.dart';
import 'package:shrifashionforbusiness/Masters/AddSubCategory.dart';
import 'package:shrifashionforbusiness/Masters/EditCategory.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=categories.onValue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
        appBar: AppBar(
          elevation: 10.0,
          
          title: Text('Categories',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
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
                    if(values!=null)
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
                    crossAxisSpacing: 3,
                    childAspectRatio: MediaQuery.of(context).size.width
                        /MediaQuery.of(context).size.height/0.35,
                    crossAxisCount: 3),


                itemBuilder: (BuildContext context, index) {
                  var data = snapshot.data;

                  String str = lists[index]['name'].toString();
                  int len = str.length;
                  if (len >= 18) {
                    str = str.substring(0, 17) + ".";
                  } else {
                    str = lists[index]['name'];
                  }
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
                                  width: MediaQuery.of(context).size.width / 10,
                                  height: MediaQuery.of(context).size.width / 10
                              ));
                        }
                        catch(e){
                          image=ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                  width: MediaQuery.of(context).size.width / 10,
                                  height: MediaQuery.of(context).size.width / 10
                              )
                          );
                        }

                        return image;
                      }
                      return Container(
                          width: MediaQuery.of(context).size.width / 10,
                          height: MediaQuery.of(context).size.width / 10
                      );
                    },

                  );
                  image=lists[index]['status']=="True"?image:Center(
                    child: Stack(
                      children: [
                        //lists[index].image
                        Container(
                          width: MediaQuery.of(context)
                              .size
                              .width *
                              0.242,
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
                                child: Text("Disabled",style: TextStyle(
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
                            width: 1,
                            color: Colors.grey[50]
                        )),

                    // height: MediaQuery.of(context).size.height/10,
                    child: InkWell(
                      onTap: () {

                        animated_dialog_box.showScaleAlertBox(
                            //title:Center(child: Text("Sub-category")) , // IF YOU WANT TO ADD
                            context: context,
                            firstButton: MaterialButton(
                              // OPTIONAL BUTTON
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              color: Colors.white,
                              child: Text('Edit this category'),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: ((context)=>EditCategory(
                                            category_id:lists[index]['category_id'],
                                            name:customHtmlParser(lists[index]['name'])))));

                              },
                            ),
                            secondButton: MaterialButton(
                              // FIRST BUTTON IS REQUIRED
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              color: Theme.of(context).buttonColor,
                              child: Text('Add a sub-category',style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: ((context)=>AddSubCategory(category_id:lists[index]['category_id'],category_name: lists[index]['name'],))));

                              },
                            ),
                            icon: Icon(Icons.add,color: Colors.red,), // IF YOU WANT TO ADD ICON
                            yourWidget: Text("Add a sub-category to "+customHtmlParser(lists[index]['name']))
                        );





                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Expanded(
                                  child: image,
                                  flex: 5, //elevation: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: SizedBox(
                                        child: Text(
                                          customHtmlParser(lists[index]['name']),
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
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
                  );
                },
              );
            }
            return Center(child:CircularProgressIndicator());
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          Navigator.push(context, MaterialPageRoute(builder: ((context)=>AddCategory())));
        },
        tooltip: 'Add Category',
        child: Icon(Icons.add),
      ),
    );
  }
}


