import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shrifashion/AllCategories.dart';
import 'package:shrifashion/categories/ThirdScreen.dart';
import 'package:shrifashion/components/Color.dart';
class Essentials extends StatefulWidget {
  var id, name;
  Essentials(var id,var name){
    this.id=id;
    this.name=name;
  }
  @override
  _EssentialsState createState() => _EssentialsState();
}

class _EssentialsState extends State<Essentials> {
  final subCategory = FirebaseDatabase.instance.reference().child("categorysub_final");
  var future_subCategory;
  List lists3=[];
  @override
  void initState() {
    super.initState();
    future_subCategory=subCategory.onValue;
  }
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: future_subCategory,
        builder: (context, snapshot)  {
          if (snapshot.hasData) {
            lists3.clear();
            try
            {
              List<dynamic> values = snapshot.data.snapshot.value;
              values.forEach((values) {
                try
                {
                  if(values['status']=="True" && values['category_id']==widget.id)
                    lists3.add(values);
                }
                catch(e)
                {

                }
              });
              if(lists3.isEmpty)
              {
                values.forEach((values) {
                  try{
                    if(values['status']=="True" && values['parent_id']==widget.id)
                      lists3.add(values);
                  }
                  catch(e)
                  {

                  }
                });
              }
            }
            catch(e)
          {
            Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
            values.forEach((key,values) {
              try{
                if(values['status']=="True" && values['category_id']==widget.id)
                  lists3.add(values);
              }
              catch(e)
              {

              }

            });
            if(lists3.isEmpty)
            {

              values.forEach((key,values) {
                try{
                  if(values['status']=="True" && values['parent_id']==widget.id)
                    lists3.add(values);
                }
                catch(e)
                {

                }

              });
            }
          }






            if(lists3.isNotEmpty)
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      height: MediaQuery.of(context).size.height / 15,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    GridView.builder(
                      physics: ScrollPhysics(),
                      itemCount: lists3.length,

                      //snapshot.data.length,
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {

                        var data;
                        data = snapshot.data;
                        String str =lists3[index]['name'].toString();
                        Widget image=Container();
                        if(lists3[index]["image"]!=null && lists3[index]["image"]!="")
                        {
                          image=FutureBuilder(
                            future: imageurl(context, lists3[index]["image"],FirebaseStorage.instance),
                            builder: (context,snap){
                              if(snap.hasData)
                              {


                                try{
                                  return Image.network(
                                    snap.data.image,
                                    fit: BoxFit.fill,
                                  );
                                }
                                catch(e){
                                  return Container();
                                }

                              }
                              else
                              {
                                return Container();
                              }
                            },

                          );

                        }

                        return Container(
                          color: Colors.white,
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
                                                lists3[index]['category_id'],
                                                lists3[index]['name'])));
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
