import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shrifashion/BottomSheet.dart';
import 'package:shrifashion/FooterContainer.dart';
import 'package:shrifashion/categories/ThirdScreen.dart';
import 'package:shrifashion/components/Color.dart';

class Footer extends StatefulWidget {
  var parent_id,name;
  Footer({this.parent_id,this.name});
  @override
  _FooterState createState() => _FooterState();
}
class _FooterState extends State<Footer> {
  List spiceList=[];
  @override
  Widget build(BuildContext context) {
    final products = FirebaseDatabase.instance.reference().child("search").orderByChild("parent_id").equalTo(widget.parent_id);
    return StreamBuilder(
      stream: products.onValue,
      builder: (context,snapshot){
        if(snapshot.hasData)
        {
          spiceList.clear();
          try
          {
            Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
            if(values!=null)
            values.forEach((key,values) {
              if(values!=null)
                spiceList.add(values);
            });
          }
          catch(e)
        {
          List<dynamic> values = snapshot.data.snapshot.value;
          if(values!=null)
          values.forEach((values) {
            if(values!=null)
              spiceList.add(values);
          });
        }

          if(spiceList.isNotEmpty)
          {
            return Container(

              height: MediaQuery.of(context).size.height / 3,
                decoration: new BoxDecoration(
                  color: Colors.purple,
                  gradient: new LinearGradient(
                    colors: [ Theme.of(context).buttonColor,Theme.of(context).scaffoldBackgroundColor],
                  ),),
              child: ListView.builder(
                physics: ScrollPhysics(),
                itemCount: 7,
                padding: EdgeInsets.only(left: 15),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index) {
                  var manufacturer;
                  try
                  {
                    manufacturer=spiceList[index]['store_name']==null?'Shrifashion':spiceList[index]['store_name'];
                  }
                  catch(e)
                  {
                    manufacturer='Shrifashion';
                  }
                  int newIndex=index;

                  try{

                    if(newIndex==6)
                    {
                      return Container(
                        margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(Consts.padding),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: const Offset(5.0, 2.0),
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width / 2,
                        child: InkWell(
                          onTap: () {

                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        ThirdScreen(widget.parent_id, widget.name)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Align(
                                        alignment:Alignment.bottomCenter,
                                        child:IconButton(
                                          icon: Icon(Icons.arrow_forward),
                                        )
                                    ),
                                    //elevation: 10,
                                  ),
                                  Expanded(
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child:Text("View All",style: TextStyle(color: Colors.grey))
                                    ),
                                    //elevation: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return FooterContainer(
                      min_order_qty:spiceList[newIndex]['min_order_qty'],
                      unit: spiceList[newIndex]['unit'],
                      name: spiceList[newIndex]['name'],
                      image: spiceList[newIndex]['image'],
                      old_price: spiceList[newIndex]['old_price'],
                      new_price: spiceList[newIndex]['new_price'],
                      description: spiceList[newIndex]['description'],
                      product_id: spiceList[newIndex]['product_id'],
                      model: spiceList[newIndex]['model'],
                      weight: spiceList[newIndex]['weight'],
                      location: spiceList[newIndex]['location'],
                      tag: spiceList[newIndex]['tag'],
                      category_id: spiceList[newIndex]['category_id'],
                      stock_status: spiceList[newIndex]['stock_status'],
                      stock_status_id: spiceList[newIndex]['stock_status_id'],
                      manufacturer: manufacturer,
                      maximun: spiceList[newIndex]['maximun'],
                      minimun: spiceList[newIndex]['minimun'],
                      quantity: spiceList[newIndex]['quantity'],
                    );



                  }
                  catch(e){
                    return Container();
                  }
                },
              ),
            );
          }

          return Container(
            height: MediaQuery.of(context).size.height / 3,
            child: ListView.builder(
              physics: ScrollPhysics(),
              itemCount: 1,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(Consts.padding),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(5.0, 2.0),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width / 2.4,
                  child: InkWell(
                    onTap: () {
                      //ReadSubCategoryBanners("FRUITS");
                      // Navigator.push(
                      //     context,
                      //     new MaterialPageRoute(
                      //         builder: (context) =>
                      //             SubCategory("60", "SPICES")));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          children: [
                            Expanded(
                              child: Align(
                                  alignment:Alignment.bottomCenter,
                                  child:IconButton(
                                    icon: Icon(Icons.arrow_forward),
                                  )
                              ),
                              //elevation: 10,
                            ),
                            Expanded(
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child:Text("View All",style: TextStyle(color: Colors.grey))
                              ),
                              //elevation: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: ListView.builder(
            physics: ScrollPhysics(),
            itemCount: 1,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) {
              return Container(
                margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(Consts.padding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(5.0, 2.0),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width / 2.4,
                child: InkWell(
                  onTap: () {
                    //ReadSubCategoryBanners("FRUITS");
                    // Navigator.push(
                    //     context,
                    //     new MaterialPageRoute(
                    //         builder: (context) =>
                    //             SubCategory("60", "SPICES")));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Column(
                        children: [
                          Expanded(
                            child: Align(
                                alignment:Alignment.bottomCenter,
                                child:IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                )
                            ),
                            //elevation: 10,
                          ),
                          Expanded(
                            child: Align(
                                alignment: Alignment.topCenter,
                                child:Text("View All",style: TextStyle(color: Colors.grey))
                            ),
                            //elevation: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
