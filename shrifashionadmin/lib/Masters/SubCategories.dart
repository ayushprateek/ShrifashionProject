import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:shrifashionadmin/Components/GetImageUrl.dart';
import 'package:shrifashionadmin/Components/HtmlParser.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:shrifashionadmin/Masters/EditSubCategory.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SubCategories extends StatefulWidget {
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=subCategories.onValue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StickyFooter(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: backColor,
          title: Text('Sub-categories',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // StreamBuilder(
              //   stream: connection,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       lists.clear();
              //
              //       try{
              //         List<dynamic> values  = snapshot.data.snapshot.value;
              //         values.forEach((values) {
              //           try{
              //             if(values!=null)
              //             {
              //               lists.add(values);
              //             }
              //           }
              //           catch(e){
              //           }
              //         });
              //       }catch(e){
              //
              //         Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
              //         values.forEach((key,values) {
              //           try{
              //             if(values!=null)
              //             {
              //               lists.add(values);
              //             }
              //           }
              //           catch(e){
              //           }
              //         });
              //       }
              //
              //
              //       return GridView.builder(
              //         physics: ScrollPhysics(),
              //         itemCount: lists.length,
              //         shrinkWrap: true,
              //         gridDelegate:
              //         new SliverGridDelegateWithFixedCrossAxisCount(
              //             mainAxisSpacing: 3,
              //             crossAxisSpacing: 3,
              //             childAspectRatio: MediaQuery.of(context).size.width
              //                 /MediaQuery.of(context).size.height/0.35,
              //             crossAxisCount: 3),
              //
              //
              //         itemBuilder: (BuildContext context, index) {
              //           var data = snapshot.data;
              //
              //           String str = lists[index]['name'].toString();
              //           int len = str.length;
              //           if (len >= 18) {
              //             str = str.substring(0, 17) + ".";
              //           } else {
              //             str = lists[index]['name'];
              //           }
              //           Widget image;
              //           image=FutureBuilder(
              //             future: imageurl(context, lists[index]["image"],FirebaseStorage.instance),
              //             builder: (context,snap){
              //               if(snap.hasData)
              //               {
              //                 Widget image;
              //                 try{
              //                   image=ClipRRect(
              //                       borderRadius: BorderRadius.circular(15),
              //                       child: Image.network(
              //                           snap.data.image,
              //                           fit: BoxFit.fill,
              //                           width: MediaQuery.of(context).size.width / 10,
              //                           height: MediaQuery.of(context).size.width / 10
              //                       ));
              //                 }
              //                 catch(e){
              //                   image=ClipRRect(
              //                       borderRadius: BorderRadius.circular(15),
              //                       child: Container(
              //                           width: MediaQuery.of(context).size.width / 10,
              //                           height: MediaQuery.of(context).size.width / 10
              //                       )
              //                   );
              //                 }
              //
              //                 return image;
              //               }
              //               return Container(
              //                   width: MediaQuery.of(context).size.width / 10,
              //                   height: MediaQuery.of(context).size.width / 10
              //               );
              //             },
              //
              //           );
              //           image=lists[index]['status']=="True"?image:Center(
              //             child: Stack(
              //               children: [
              //                 //lists[index].image
              //                 Container(
              //                   width: MediaQuery.of(context)
              //                       .size
              //                       .width *
              //                       0.242,
              //                   foregroundDecoration: BoxDecoration(
              //                     color: Colors.grey,
              //                     backgroundBlendMode: BlendMode.saturation,
              //                   ),
              //                   child: image,
              //                 ),
              //                 Padding(
              //                   padding: const EdgeInsets.only(top:40.0,left:15),
              //                   child: Center(
              //                     child: Container(
              //                       color: Colors.red,
              //                       child: FittedBox(
              //                         child: Text("Disabled",style: TextStyle(
              //                             color: Colors.white,
              //                             fontWeight: FontWeight.bold
              //                         ),),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //
              //               ],
              //             ),
              //           );
              //
              //           return Container(
              //             decoration: BoxDecoration(
              //                 border: Border.all(
              //                     width: 1,
              //                     color: Colors.grey[50]
              //                 )),
              //             child: InkWell(
              //               onTap: () {
              //                 Navigator.push(context, MaterialPageRoute(
              //                     builder: ((context)=>EditSubCategory(category_id: lists[index]['category_id'],name: lists[index]['name'],))));
              //               },
              //               child: Padding(
              //                 padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
              //                 child: ClipRRect(
              //                   borderRadius: BorderRadius.circular(15),
              //                   child: Container(
              //                     color: Colors.white,
              //                     child: Column(
              //                       children: [
              //                         Expanded(
              //                           child: image,
              //                           flex: 5, //elevation: 10,
              //                         ),
              //                         Expanded(
              //                           child: Container(
              //                             child: FittedBox(
              //                               fit: BoxFit.scaleDown,
              //                               child: SizedBox(
              //                                 child: Text(
              //                                   customHtmlParser(lists[index]['name']),
              //                                   style: TextStyle(
              //                                       fontSize: 15.0,
              //                                       fontWeight: FontWeight.bold,
              //                                       color: Colors.black),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //
              //                           flex: 1, //elevation: 10,
              //                         )
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           );
              //         },
              //       );
              //     }
              //     return Center(child:CircularProgressIndicator());
              //   },
              // ),
              fetchCategories()

            ],
          ),
        ),

    );
  }
  Widget fetchCategories()
  {
    List lists=[];
    return StreamBuilder(
      stream: categories.onValue,
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


          return ListView.builder(
            physics: ScrollPhysics(),
            itemCount: lists.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) {

              return fetchSubCategories(lists[index]['category_id'],lists[index]['name']);
            },
          );
        }
        return Center(child:CircularProgressIndicator());
      },
    );
  }
  Widget fetchSubCategories(String id,String name)
  {
    List lists=[];
    return StreamBuilder(
      stream: connection,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          lists.clear();

          try{
            List<dynamic> values  = snapshot.data.snapshot.value;
            values.forEach((values) {
              try{
                if(values!=null  && values['parent_id']==id)
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
                if(values!=null  && values['parent_id']==id)
                {
                  lists.add(values);
                }
              }
              catch(e){
              }
            });
          }
          if(lists.isNotEmpty)

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                      child: Text(name.toString().toUpperCase(),style: TextStyle(color: Colors.black,fontFamily: custom_font),)),
                ),
              ),
              GridView.builder(
                physics: ScrollPhysics(),
                itemCount: lists.length,
                shrinkWrap: true,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    childAspectRatio:2* MediaQuery.of(context).size.width
                        /MediaQuery.of(context).size.height/0.8,
                    crossAxisCount: 2),


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
                              0.35,
                          height: MediaQuery.of(context)
                              .size
                              .width *
                              0.35,
                          foregroundDecoration: BoxDecoration(
                            color: Colors.grey,
                            backgroundBlendMode: BlendMode.saturation,
                          ),
                          child: image,
                        ),
                        Positioned(
                          bottom:10,
                          child:  Container(
                            color: Colors.red,
                            width: MediaQuery.of(context)
                                .size
                                .width *
                                0.35,
                            child: FittedBox(
                              child: Text("Disabled",style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),),


                      ],
                    ),
                  );

                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Colors.grey[50]
                        )),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: ((context)=>EditSubCategory(category_id: lists[index]['category_id'],name: lists[index]['name'],))));
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
              ),
              Divider(
                color: Colors.grey,
                height: 10,
              )
            ],
          );
          else
            return Container();
        }
        return Center(child:CircularProgressIndicator());
      },
    );
  }
}


