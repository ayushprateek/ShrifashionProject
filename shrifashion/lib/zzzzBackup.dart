
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shrifashion/BottomSheet.dart';
import 'package:shrifashion/ImageURL.dart';
import 'package:shrifashion/components/FetchOptions.dart';
class ProductContainer extends StatefulWidget {
  var unit ,name,image,old_price,new_price,description,
      product_id,model,weight,location,tag,category_id,stock_status_id,stock_status,
      maximun,minimun,manufacturer,quantity,min_order_qty;
  ProductContainer({
    this.unit,this.name,this.image,this.old_price,this.new_price,
    this.description,this.product_id,this.model,this.weight,
    this.location,this.tag,this.category_id,this.stock_status_id,this.stock_status,
    this.manufacturer,this.quantity,this.maximun,this.minimun,this.min_order_qty
  });
  @override
  _ProductContainerState createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  @override
  Widget build(BuildContext context) {
    Widget image=Container(
      width: MediaQuery.of(context)
          .size
          .width /
          2.5,



    );
    var link;
    image= FutureBuilder(
        future: imageurl(context, widget.image, FirebaseStorage.instance),
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
                width: MediaQuery.of(context)
                    .size
                    .width /
                    2.5,
              );
            }
            catch(e)
            {
              image=Container(
                width: MediaQuery.of(context)
                    .size
                    .width /
                    2.5,
              );
            }
            return image;
          }
          else
          {
            return Container(
              width: MediaQuery.of(context)
                  .size
                  .width /
                  2.5,
            );
          }
        }
    );



    var _unit=double.parse(widget.weight)
        .toStringAsFixed(0) +
        " "+widget.unit;
    if(widget.stock_status_id!="7")
    {
      //OUT OF STOCK
      return Container(
        height: MediaQuery.of(context).size.height/5,
        margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
        decoration: new BoxDecoration(
          color: Colors.white,
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

        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: () {},
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        showModalBottomSheet(context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) => FractionallySizedBox(
                            heightFactor: 1.6,
                            child:Bottomsheet(
                                widget.unit,
                                widget.name,
                                widget.image,
                                link,
                                double.parse(widget.old_price).toStringAsFixed(0),
                                widget.new_price!=null?double.parse(widget.new_price).toStringAsFixed(0) :null,
                                widget.description,
                                widget.product_id,
                                widget.model,
                                double.parse(widget.weight).toStringAsFixed(0) ,
                                widget.location,
                                widget.tag,
                                widget.category_id,
                                widget.stock_status_id,
                                widget.stock_status,
                                widget.manufacturer
                            ),
                          ),);
                      },
                      child: Stack(
                        children: [
                          Container(
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
                                  child: Text(widget.stock_status,style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    flex: 2, //elevation: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, top: 2),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.manufacturer,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                )),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.name
                                    .toString(),
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                            ),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0),
                                  child: Align(
                                    alignment:
                                    Alignment.centerLeft,
                                    child: Material(
                                        color: Colors.white
                                            .withOpacity(0.8),
                                        elevation: 0.0,
                                        child: Text(
                                          _unit,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight
                                                  .bold),
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(""),
                              )
                            ],
                          ),
                          flex: 1,
                        ),

                        Expanded(
                          child: Row(
                            children: [
                              widget.new_price!=null && widget.new_price!="0.0000"?
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(
                                            left: 8.0),
                                        child: FittedBox(
                                          child: Text(
                                            "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors
                                                    .orange,
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(
                                            left: 8.0),
                                        child: FittedBox(
                                          child: Text(
                                            "\u{20B9}${double.parse(widget.old_price).toStringAsFixed(0)}",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors
                                                    .grey,
                                                decoration:
                                                TextDecoration
                                                    .lineThrough),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container())
                                  ],
                                ),
                              ):
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:
                                  const EdgeInsets
                                      .only(
                                      left: 8.0,right: 8),
                                  child: FittedBox(
                                    child: Text(
                                      "\u{20B9}${double.parse(widget.old_price).toStringAsFixed(0)}",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors
                                              .orange,
                                          fontWeight:
                                          FontWeight
                                              .bold),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                  flex: 4,
                                  child:Padding(
                                      padding: EdgeInsets.only(right:8),
                                      child:RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),

                                          ),
                                          textColor: Colors.white,
                                          color: Colors.grey,
                                          // padding:
                                          // const EdgeInsets.all(4.0),
                                          onPressed: () async {},
                                          child:  FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                "Add",
                                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                                              ))))

                              )
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, top: 2),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '',
                                )),
                          ),
                          flex: 1,
                        ),

                      ],
                    ),

                    flex: 3, //elevation: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    else
    {
      return Container(
        height: MediaQuery.of(context).size.height/5,
        margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
        decoration: new BoxDecoration(
          color: Colors.white,
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

        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: () {},
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        showModalBottomSheet(context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) => FractionallySizedBox(
                            heightFactor: 1.6,
                            child:Bottomsheet(
                                widget.unit,
                                widget.name,
                                widget.image,
                                link,
                                double.parse(widget.old_price).toStringAsFixed(0),
                                widget.new_price!=null?double.parse(widget.new_price).toStringAsFixed(0) :null,
                                widget.description,
                                widget.product_id,
                                widget.model,
                                double.parse(widget.weight).toStringAsFixed(0) ,
                                widget.location,
                                widget.tag,
                                widget.category_id,
                                widget.stock_status_id,
                                widget.stock_status,
                                widget.manufacturer
                            ),
                          ),);
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: image,
                          ),
                        ],
                      ),
                    ),
                    flex: 2, //elevation: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:  EdgeInsets.only(left:8.0,top: 2),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.manufacturer,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                )),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(left: 8.0,right: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.name.toString(),
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                        // Expanded(
                        //   child: FetchOptions(widget.unit,_unit,widget.product_id,widget.quantity,
                        //       widget.image,widget.maximun,widget.minimun,
                        //       widget.name,widget.old_price,widget.new_price,
                        //       widget.weight,widget.stock_status_id,
                        //       widget.stock_status,widget.category_id,widget.manufacturer,widget.min_order_qty),
                        //   flex: 8,
                        // ),
                        Expanded(
                          child: Container(),
                        ),






                      ],
                    ),

                    flex: 3, //elevation: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

  }
}
/*Widget avce(){
    return Wrap(
      spacing: 8,
      children: List.generate(_choicesList.length, (index) {
        return ChoiceChip(
          labelPadding: EdgeInsets.all(2.0),
          label: Text(
            _choicesList[index],
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.white, fontSize: 14),
          ),
          selected: defaultChoiceIndex == index,
          selectedColor: Theme.of(context).buttonColor,
          onSelected: (value) {
            setState(() {
              defaultChoiceIndex = value ? index : defaultChoiceIndex;
            });
          },
// backgroundColor: color,
          elevation: 1,

        );
      }),
    );
  }*/

/* int defaultChoiceIndex;
List<String> _choicesList = ['All', 'Pending', 'Accepted'];

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultChoiceIndex = 0;
  }

    Wrap(
      spacing: 8,
      children: List.generate(_choicesList.length, (index) {
        return ChoiceChip(
          labelPadding: EdgeInsets.all(2.0),
          label: Text(
            _choicesList[index],
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Colors.white, fontSize: 14),
          ),
          selected: defaultChoiceIndex == index,
          selectedColor: Colors.deepPurple,
          onSelected: (value) {
            setState(() {
              defaultChoiceIndex = value ? index : defaultChoiceIndex;
            });
          },
          // backgroundColor: color,
          elevation: 1,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.widthMultiplier * 4),
        );
      }),
    );*/