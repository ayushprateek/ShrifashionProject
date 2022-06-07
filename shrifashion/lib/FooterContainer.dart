import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shrifashion/BottomSheet.dart';
import 'package:shrifashion/FooterOptions.dart';
import 'package:shrifashion/ImageURL.dart';
import 'package:shrifashion/pages/ProductDetails.dart';
class FooterContainer extends StatefulWidget {
  var unit ,name,image,old_price,new_price,description,min_order_qty,
      product_id,model,weight,location,tag,category_id,stock_status_id,stock_status,
      maximun,minimun,manufacturer,quantity;
  FooterContainer({
    this.min_order_qty, this.unit,this.name,this.image,this.old_price,this.new_price,
    this.description,this.product_id,this.model,this.weight,
    this.location,this.tag,this.category_id,this.stock_status_id,this.stock_status,
    this.manufacturer,this.quantity,this.maximun,this.minimun
  });
  @override
  _FooterContainerState createState() => _FooterContainerState();
}

class _FooterContainerState extends State<FooterContainer> {
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
  @override
  Widget build(BuildContext context) {


    Widget image=Container(
      width: MediaQuery.of(context)
          .size
          .width /
          2,
    );
    var link;
    image= FutureBuilder(
        future: imageurl(context, widget.image, FirebaseStorage.instance),
        builder: (context,snap){
          Widget image=Container(
            width: MediaQuery.of(context)
                .size
                .width /
                2,
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
                    2,
              );
            }
            catch(e)
            {
              image=Container(
                width: MediaQuery.of(context)
                    .size
                    .width /
                    2,
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
                  2,
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
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(widget.product_id,widget.name)));
            // showModalBottomSheet(
            //   context: context,
            //   backgroundColor: Colors.transparent,
            //   builder: (BuildContext context) => FractionallySizedBox(
            //     heightFactor: 1.6,
            //     child: Bottomsheet(
            //         widget.unit,
            //         widget.name,
            //         widget.image,
            //         link,
            //         double.parse(widget.old_price).toStringAsFixed(0),
            //         widget.new_price!=null?double.parse(widget.new_price).toStringAsFixed(0) :null,
            //         widget.description,
            //         widget.product_id,
            //         widget.model,
            //         double.parse(widget.weight).toStringAsFixed(0) ,
            //         widget.location,
            //         widget.tag,
            //         widget.category_id,
            //         widget.stock_status_id,
            //         widget.stock_status_id, widget.manufacturer
            //     ),
            //   ),
            // ).then((value) => setState(() {}));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context)
                            .size
                            .width *
                            0.2,

                        child: Center(
                          child: Stack(
                            children: [
                              //lists[index].image
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
                      ),
                      flex: 5, //elevation: 10,
                    ),
                    Expanded(
                      child: Container(
                        width:
                        MediaQuery.of(context).size.width /
                            2.2,
                        child: SizedBox(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.0,
                                right: 2.0,
                                top: 4.0,
                                bottom: 4.0),
                            child: Text(
                              _parseHtmlString(widget.name),
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),

                    ),
                    Expanded(
                      child: Container(
                        width:
                        MediaQuery.of(context).size.width /
                            2,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                _unit),
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                    widget.new_price!=null && widget.new_price!="0.0000"?Expanded(
                      child: Container(
                        width:
                        MediaQuery.of(context).size.width /
                            2,
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 8.0),
                                  child: Align(
                                    alignment:
                                    Alignment.topLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
                                        style: TextStyle(
                                            color:
                                            Colors.orange,
                                            fontWeight:
                                            FontWeight
                                                .bold),
                                      ),
                                    ),
                                  ),
                                ),
                                flex: 1),
                            Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 0.0),
                                  child: Align(
                                    alignment:
                                    Alignment.topLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "\u{20B9}${double.parse(widget.old_price).toStringAsFixed(0)}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            decoration:
                                            TextDecoration
                                                .lineThrough),
                                      ),
                                    ),
                                  ),
                                ),
                                flex: 1),
                          ],
                        ),
                      ),

                      flex: 1, //elevation: 10,
                    ):
                    Expanded(
                      child: Container(
                        width:
                        MediaQuery.of(context).size.width /
                            2,
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 8.0),
                                  child: Align(
                                    alignment:
                                    Alignment.topLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "\u{20B9}${double.parse(widget.old_price).toStringAsFixed(0)}",
                                        style: TextStyle(
                                            color:
                                            Colors.orange,
                                            fontWeight:
                                            FontWeight
                                                .bold),
                                      ),
                                    ),
                                  ),
                                ),
                                flex: 1),

                          ],
                        ),
                      ),

                      flex: 1, //elevation: 10,
                    ),

                    Expanded(
                        flex: 1,
                        child:Padding(
                            padding: EdgeInsets.only(right:4),
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

                    ),
                    Expanded(
                      child: Text(""),
                      flex: 0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    else
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
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(widget.product_id,widget.name)));

          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context)
                            .size
                            .width *
                            0.2,

                        child: Center(
                          child: image,
                        ),
                      ),
                      flex: 5, //elevation: 10,
                    ),
                    Expanded(
                      child: Container(
                        width:
                        MediaQuery.of(context).size.width /
                            2.2,
                        child: SizedBox(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.0,
                                right: 2.0,
                                top: 4.0,
                                bottom: 2.0),
                            child: Text(
                              _parseHtmlString(widget.name),
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // OPTIONS WILL BE HERE
                    Expanded(
                      flex: 3,
                      child: FooterOptions(
                        unit:_unit,
                        min_order_qty: widget.min_order_qty,
                        product_id: widget.product_id,
                        new_price: widget.new_price,
                        old_price: widget.old_price,
                        product_unit: widget.unit,
                        image: widget.image,
                        name: widget.name,
                        weight: widget.weight,
                        stock_status_id: widget.stock_status_id,
                        stock_status: widget.stock_status,
                        category_id: widget.category_id,
                        manufacturer: widget.manufacturer,
                      ),
                    ),

                    Expanded(
                      child: Text(""),
                      flex: 0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
