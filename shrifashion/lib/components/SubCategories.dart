
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shrifashion/AllCategories.dart';
import 'package:shrifashion/categories/ThirdScreen.dart';
import 'package:shrifashion/components/Color.dart';
class SubCategories extends StatefulWidget {
  var categoryId;
  SubCategories(this.categoryId);
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {

  List lists=[];
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
  @override
  Widget build(BuildContext context) {
    final subCategory = FirebaseDatabase.instance.reference().child("categorysub_final").orderByChild("parent_id").equalTo(widget.categoryId);
    return StreamBuilder(
        stream: subCategory.onValue,
        builder: (context, snapshot)  {
          print(snapshot.connectionState);
          if (snapshot.hasData) {
            lists.clear();
            try{
              List<dynamic> values = snapshot.data.snapshot.value;
              if(values!=null)
                values.forEach((values) {
                   if(values!=null && values['status']=="True")
                  lists.add(values);
                });
            }
            catch(e)
            {
              Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
              if(values!=null)
                values.forEach((key,values) {
                  if(values!=null && values['status']=="True")
                  lists.add(values);
                });
            }

            if(lists.isNotEmpty)
              return Container(

                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      height: MediaQuery.of(context).size.height / 15,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              "Shop by Category",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GridView.builder(
                      physics: ScrollPhysics(),
                      itemCount: lists.length,

                      //snapshot.data.length,
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        // childAspectRatio: 2/4
                      ),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {

                        var data;
                        data = snapshot.data;

                        String str =lists[index]['name'].toString();
                        Widget image=Container(
                          // width: MediaQuery.of(context)
                          //     .size
                          //     .width /
                          //     2.5,
                        );
                        var link;
                        image= FutureBuilder(
                            future: imageurl(context, lists[index]["image"], FirebaseStorage.instance),
                            builder: (context,snap){
                              Widget image=Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    2.5,
                              );
                              if(snap.hasData)
                              {
                                link=snap.data.image;

                                try{
                                  image=Image.network(
                                    snap.data.image,
                                    fit: BoxFit.fill,
                                    // width: MediaQuery.of(context)
                                    //     .size
                                    //     .width /
                                    //     2.5,
                                  );
                                }
                                catch(e)
                                {
                                  image=Container(
                                    // width: MediaQuery.of(context)
                                    //     .size
                                    //     .width /
                                    //     2.5,
                                  );
                                }
                                return image;
                              }
                              else
                              {
                                return Container(
                                  // width: MediaQuery.of(context)
                                  //     .size
                                  //     .width /
                                  //     2.5,
                                );
                              }
                            }
                        );
                        return Container(

                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15)),
                            ),
                            child: InkWell(
                              onTap: () {


                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            ThirdScreen(
                                                lists[index]['category_id'],
                                                lists[index]['name'])));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: image,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0,
                                                bottom: 5.0,
                                                right: 15.0),
                                            child: Text(
                                              _parseHtmlString(str),

                                              style: TextStyle(
                                                  fontSize: 12.0,
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
                        );

                        // Text(snapshot.data[index].name,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),);
                      },
                    ),
                  ],
                ),
              );
            else
              return
                Container();
          }
          else
          {
            return Center(child: CircularProgressIndicator(),);
          }
        }

    );
  }
}
