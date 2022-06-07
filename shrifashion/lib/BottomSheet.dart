import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/mobileLogin.dart';
enum Page {Description}
class Bottomsheet extends StatefulWidget {
  String unit,
      title,
      image,
      imageName,
      oldPrice,
      newPrice,
      description,
      product_id,
      model,
      weight,
      location,
      tag,
      categoryId,stock_status_id,stock_status,manufacturer;
  Bottomsheet(String unit,String title,String imageName,String image,String oldPrice,String newPrice,
      String description,String product_id,String model,String weight,String location,String tag,String categotyId,
      String stock_status_id,String stock_status,String manufacturer
      )
  {
    this.unit=unit;
    this.title=title;
    this.image=image;
    this.imageName=imageName;
    this.oldPrice=oldPrice;
    this.newPrice=newPrice;
    this.description=description;
    this.product_id=product_id;
    this.model=model;
    this.weight=weight;
    this.location=location;
    this.tag=tag;
    this.categoryId=categotyId;
    this.stock_status_id=stock_status_id;
    this.stock_status=stock_status;
    this.manufacturer=manufacturer;
  }
  @override
  _BottomsheetState createState() => _BottomsheetState();
}
class _BottomsheetState extends State<Bottomsheet> {
  var cartId, quantity;
  final cart = FirebaseDatabase.instance.reference().child("cart");
  final cartLast = FirebaseDatabase.instance.reference().child("cart").limitToLast(1);

  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  Page _selectedPage = Page.Description;
  
  bool enabled=true;
  final option = FirebaseDatabase.instance.reference().child("option");
  String dropdownValue;
  List<String> listNames=[];
  List lists=[];
  bool isSet=false;
  @override
  Widget build(BuildContext context) {
    //
    var active=Theme.of(context).buttonColor;
    var notActive = Theme.of(context).buttonColor;
    String _unit = double.parse(widget.weight).toStringAsFixed(0).toString() + " " + widget.unit;


    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: Consts.avatarRadius + Consts.padding,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _parseHtmlString(widget.title),
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                //OPTIONS WILL BE HERE

                BottomSheetsOptions(unit:_unit,
                  new_price:widget.newPrice,
                  old_price:widget.oldPrice,
                  product_id:widget.product_id,
                  stock_status_id: widget.stock_status_id,

                  image_name: widget.imageName,
                  title: widget.title,
                  product_unit: widget.unit,
                  weight: widget.weight,
                  category_id: widget.categoryId,
                  stock_status: widget.stock_status,
                  manufacturer: widget.manufacturer,

                ),

                SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Description',
                      style: TextStyle(
                          color:_selectedPage==Page.Description?active:notActive,
                          fontSize: 16
                      ),
                      textAlign: TextAlign.left,),
                  ),
                ),
                _loadScreen(),
                Container(
                  height: MediaQuery.of(context).size.height/5,
                  color:Colors.white,child: Text(""),),
              ],
            ),
          ),
          Positioned(
            //left: Consts.padding,
            //right: Consts.padding,
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * .3,
                  width: MediaQuery.of(context).size.width * .3,
                  child: Text(""),
                ),
                widget.stock_status_id!='7'?
                Container(
                  height: MediaQuery.of(context).size.width / 2.5,
                  width: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(
                        width: 1,
                        color: Colors.white
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                  child: widget.image==""|| widget.image==null? Padding(
                    padding:  EdgeInsets.all(MediaQuery.of(context).size.width/15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(),
                    ),
                  ):
                  Padding(
                    padding:  EdgeInsets.all(MediaQuery.of(context).size.width/15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Container(
                            foregroundDecoration: BoxDecoration(
                              color: Colors.grey,
                              backgroundBlendMode: BlendMode.saturation,
                            ),
                            child: Image.network(widget.image,
                              fit: BoxFit.fill,),
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
                ):
                Container(
                  height: MediaQuery.of(context).size.width / 2.5,
                  width: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(
                        width: 1,
                        color: Colors.white
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                  child: widget.image==""|| widget.image==null? Padding(
                    padding:  EdgeInsets.all(MediaQuery.of(context).size.width/15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(),
                    ),
                  ):
                  Padding(
                    padding:  EdgeInsets.all(MediaQuery.of(context).size.width/15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(widget.image,
                        fit: BoxFit.fill,),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width * .3,
                  width: MediaQuery.of(context).size.width * .3,
                  child: Text(""),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
  Widget _loadScreen(){
    switch(_selectedPage){
      case Page.Description:
        return Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3.5,

          child:
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:  EdgeInsets.only(bottom:40.0),
                child: Container(
                  color: Colors.white,
                  child: new Text(_parseHtmlString(widget.description),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              );
            },
          ),
        );
        break;
    }
  }
}
class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
class BottomSheetsOptions extends StatefulWidget {
  var unit,new_price,old_price,product_id,stock_status_id,
      image_name,title,product_unit,weight,category_id,stock_status,manufacturer;
  BottomSheetsOptions({this.unit,this.new_price,this.old_price,this.product_id,this.stock_status_id,
    this.image_name,this.title,this.product_unit,this.weight,this.category_id,this.stock_status,this.manufacturer
  }
      );
  @override
  _BottomSheetsOptionsState createState() => _BottomSheetsOptionsState();
}
class _BottomSheetsOptionsState extends State<BottomSheetsOptions> {
  var product_option_id="0",product_option_value_id="0";
  bool enabled=true;
  final cart = FirebaseDatabase.instance.reference().child("cart");
  final cartLast = FirebaseDatabase.instance.reference().child("cart").limitToLast(1);
  final cart2 = FirebaseDatabase.instance.reference().child("cart").orderByChild("customer_id").equalTo(customerId);
  final option = FirebaseDatabase.instance.reference().child("option");
  String dropdownValue;
  List<String> listNames=[];
  List lists=[];
  bool isSet=false;
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: option.onValue,
        builder: (context,snapshot){
          if(snapshot.hasData)
          {
            listNames.clear();
            List<dynamic> values = snapshot.data.snapshot.value;
            if(values!=null)
            values.forEach((values) {
              if(values!=null && values['product_id']==widget.product_id)
              {
                if(values['name']==widget.unit)
                {
                  widget.new_price=values['price'];
                  widget.old_price=values['weight'];
                  product_option_id=values['product_option_id'];
                  product_option_value_id=values['product_option_value_id'];
                }
                listNames.add(values['name']);
              }
            });
            if(listNames.isEmpty)
            {
              return  Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        widget.new_price!=null && widget.new_price!="0"?
                        Expanded(
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(right:8.0),
                              child: Text(
                                "Rs " + widget.new_price,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.orange
                                ),
                              ),
                            ),
                          ),
                        ):Text(""),
                        Text("  "),
                        widget.new_price==null || widget.new_price=="0" && widget.old_price!=null?Expanded(
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(right:8.0),
                              child: Text(
                                "Rs " + widget.old_price,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.orange
                                ),
                              ),
                            ),
                          ),
                        ):
                        widget.old_price!=null? Expanded(
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(right:8.0),
                              child: Text(
                                "Rs " + widget.old_price,
                                style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ):Text(""),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 0.0,
                          child:Text(
                            widget.unit,
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    flex: 3,
                  ),
                  widget.stock_status_id!='7'?
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 30,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        textColor: Colors.white,
                        color:Colors.grey,
                        padding: const EdgeInsets.all(8.0),
                        onPressed: () async {

                        },
                        child: FittedBox(
                          child: Text(
                            "Add",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ):
                  Expanded(
                    flex: 3,
                    child: StreamBuilder(
                      stream: cart2.onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var quantity='0';
                          try{
                            List<dynamic> values = snapshot.data.snapshot.value;
                            if(values!=null)
                            values.forEach((values) {
                              try{
                                if(values!=null &&values['customer_id'].toString()==customerId.toString() &&
                                    values['product_id'].toString()==widget.product_id.toString() )
                                {
                                  quantity=values['quantity'];

                                }

                              }
                              catch(e){

                              }
                            });
                          }
                          catch(e)
                          {
                            Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                            if(values!=null)
                            values.forEach((key,values) {
                              try{
                                if(values!=null &&values['customer_id'].toString()==customerId.toString() &&
                                    values['product_id'].toString()==widget.product_id.toString() )
                                {
                                  quantity=values['quantity'];

                                }

                              }
                              catch(e){

                              }
                            });
                          }





                          if (quantity == '0' || quantity==null) {
                            return SizedBox(
                              height: 30,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                textColor: Colors.white,
                                
                                padding: const EdgeInsets.all(8.0),
                                onPressed: () async {
                                  if(enabled)
                                  {
                                    enabled=false;
                                    cartLast.once().then((DataSnapshot datasnapshot){
                                      Map<dynamic,dynamic> values= datasnapshot.value;
                                      values.forEach((key,value){
                                        int newKey=int.parse(key.toString())+1;
                                        cart.child(newKey.toString()).set({
                                          "customer_id":customerId,
                                          "date_added":DateTime.now().toIso8601String(),
                                          "image":widget.image_name,
                                          "maximum":"1",
                                          "minimum":"1",
                                          "name":widget.title,
                                          "oldPrice":widget.old_price,
                                          "newPrice":widget.new_price,
                                          "product_id":widget.product_id,
                                          "quantity":"1",
                                          "unit":widget.product_unit,
                                          "weight":widget.weight,
                                          "status":"1",
                                          "stock_status_id": widget.stock_status_id,
                                          "stock_status":widget.stock_status,
                                          "category_id": widget.category_id,
                                          "option_name":widget.unit,
                                          "product_option_id":product_option_id,
                                          "product_option_value_id":product_option_value_id,
                                          "manufacturer":widget.manufacturer,

                                        }).then((value) => setState((){}));


                                      });
                                    }
                                    );
                                  }





                                  Fluttertoast.showToast(
                                      msg:
                                      "Added to cart",
                                      toastLength: Toast
                                          .LENGTH_SHORT,
                                      gravity:
                                      ToastGravity
                                          .BOTTOM,
                                      timeInSecForIosWeb:
                                      1,
                                      fontSize: 16.0);

                                },
                                child: FittedBox(
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            enabled=true;
                            return Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 30,
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                        ),
                                        textColor: Colors.white,
                                        
                                        padding: const EdgeInsets.all(8.0),
                                        onPressed: () async {
                                          if ((int.parse(quantity) - 1) == 0) {
                                            cart.once().then(
                                                    (DataSnapshot datasnapshot) {
                                                  try
                                                  {
                                                    List<dynamic> values = datasnapshot.value;
                                                    for (int i = 0; i < values.length; i++) {
                                                      try{
                                                        if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                            values[i]['product_id'].toString() == widget.product_id.toString()) {
                                                          cart.child(i.toString()).remove();
                                                        }
                                                      }
                                                      catch(e)
                                                      {
                                                      }

                                                    }
                                                  }
                                                  catch(e)
                                                  {

                                                    Map<dynamic,dynamic> values = datasnapshot.value;
                                                    values.forEach((key,value){
                                                      try{
                                                        if(value!=null)
                                                          if (value['customer_id'].toString() == customerId.toString() &&
                                                              value['product_id'].toString() == widget.product_id.toString()) {
                                                            cart.child(key.toString()).remove();
                                                          }
                                                      }
                                                      catch(e)
                                                      {
                                                        print(e.toString());
                                                      }
                                                    });
                                                  }


                                                }).then((value) => setState((){}));

                                          }
                                          else {
                                            cart.once().then(
                                                    (DataSnapshot datasnapshot) {
                                                  int x= int.parse(quantity.toString());
                                                  x--;
                                                  try
                                                  {
                                                    Map<dynamic,dynamic> values = datasnapshot.value;
                                                    values.forEach((key, value) {
                                                      try{
                                                        if (values[key]['customer_id'].toString() == customerId.toString() &&
                                                            values[key]['product_id'].toString() == widget.product_id.toString()) {
                                                          cart.child(key.toString()).update(
                                                              {"quantity": x.toString()});
                                                        }}
                                                      catch(e)
                                                      {


                                                      }
                                                    });

                                                  }
                                                  catch(e)
                                                  {
                                                    List<dynamic> values = datasnapshot.value;
                                                    for (int i = 0; i < values.length; i++) {
                                                      try{
                                                        if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                            values[i]['product_id'].toString() == widget.product_id.toString()) {
                                                          cart.child(i.toString()).update(
                                                              {"quantity": x.toString()});
                                                        }}
                                                      catch(e)
                                                      {


                                                      }
                                                    }
                                                  }

                                                }
                                            ).then((value) => setState((){}));

                                          }
                                          Fluttertoast.showToast(
                                              msg:
                                              "Removed from cart",
                                              toastLength: Toast
                                                  .LENGTH_SHORT,
                                              gravity:
                                              ToastGravity
                                                  .BOTTOM,
                                              timeInSecForIosWeb:
                                              1,
                                              fontSize: 16.0);
                                        },
                                        child: FittedBox(
                                          child: Text(
                                            "-",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        )),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Center(
                                        child:
                                        Text(quantity)),
                                    width: 20.0,
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 30,
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                        ),
                                        textColor: Colors.white,
                                        
                                        padding: const EdgeInsets.all(8.0),
                                        onPressed: () async {



                                          cart.once().then(
                                                  (DataSnapshot datasnapshot) {
                                                int x= int.parse(quantity.toString());
                                                x++;
                                                try
                                                {
                                                  Map<dynamic,dynamic> values = datasnapshot.value;
                                                  values.forEach((key, value) {
                                                    try{
                                                      if (values[key]['customer_id'].toString() == customerId.toString() &&
                                                          values[key]['product_id'].toString() == widget.product_id.toString()) {
                                                        cart.child(key.toString()).update(
                                                            {"quantity": x.toString()});
                                                      }}
                                                    catch(e)
                                                    {

                                                    }
                                                  });

                                                }
                                                catch(e)
                                                {
                                                  List<dynamic> values = datasnapshot.value;
                                                  for (int i = 0; i < values.length; i++) {
                                                    try{
                                                      if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                          values[i]['product_id'].toString() == widget.product_id.toString()) {
                                                        cart.child(i.toString()).update(
                                                            {"quantity": x.toString()});
                                                      }}
                                                    catch(e)
                                                    {

                                                    }
                                                  }
                                                }

                                              }
                                          ).then((value) => setState((){}));
                                          Fluttertoast.showToast(
                                              msg:
                                              "Added to cart",
                                              toastLength: Toast
                                                  .LENGTH_SHORT,
                                              gravity:
                                              ToastGravity
                                                  .BOTTOM,
                                              timeInSecForIosWeb:
                                              1,
                                              fontSize: 16.0);


                                        },
                                        child: FittedBox(
                                          child: Text(
                                            "+",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            );
                          }
                        } else {
                          return SizedBox(
                            height: 30,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              textColor: Colors.white,
                              
                              padding: const EdgeInsets.all(8.0),
                              onPressed: () async {
                                if(enabled)
                                {
                                  enabled=false;
                                  cartLast.once().then((DataSnapshot datasnapshot){
                                    Map<dynamic,dynamic> values= datasnapshot.value;
                                    values.forEach((key,value){
                                      int newKey=int.parse(key.toString())+1;
                                      cart.child(newKey.toString()).set({
                                        "customer_id":customerId,
                                        "date_added":DateTime.now().toIso8601String(),
                                        "image":widget.image_name,
                                        "maximum":"1",
                                        "minimum":"1",
                                        "name":widget.title,
                                        "oldPrice":widget.old_price,
                                        "newPrice":widget.new_price,
                                        "product_id":widget.product_id,
                                        "quantity":"1",
                                        "unit":widget.product_unit,
                                        "weight":widget.weight,
                                        "status":"1",
                                        "stock_status_id": widget.stock_status_id,
                                        "stock_status":widget.stock_status,
                                        "category_id": widget.category_id,
                                        "option_name":widget.unit,
                                        "product_option_id":product_option_id,
                                        "product_option_value_id":product_option_value_id,
                                        "manufacturer":widget.manufacturer,

                                      }).then((value) => setState((){}));


                                    });
                                  }
                                  );
                                }



                                Fluttertoast.showToast(
                                    msg:
                                    "Added to cart",
                                    toastLength: Toast
                                        .LENGTH_SHORT,
                                    gravity:
                                    ToastGravity
                                        .BOTTOM,
                                    timeInSecForIosWeb:
                                    1,
                                    fontSize: 16.0);

                              },
                              child: FittedBox(
                                child: Text(
                                  "Add",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              );
            }
            if(!isSet)
            {
              isSet=true;
              dropdownValue=listNames[0];
            }
            return  Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      widget.new_price!=null && widget.new_price!="0"?
                      Expanded(
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: Text(
                              "Rs " + double.parse(widget.new_price).toStringAsFixed(0),
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange
                              ),
                            ),
                          ),
                        ),
                      ):Text(""),
                      Text("  "),
                      widget.new_price==null || widget.new_price=="0.0000" && widget.old_price!=null?Expanded(
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: Text(
                              "Rs " + double.parse(widget.old_price).toStringAsFixed(0),
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange
                              ),
                            ),
                          ),
                        ),
                      ):
                      widget.old_price!=null? Expanded(
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: Text(
                              "Rs " + double.parse(widget.old_price).toStringAsFixed(0),
                              style: TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ):Text(""),
                    ],
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child:SizedBox(
                        height: 28,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              border: Border.all(color: Theme.of(context).buttonColor)),
                          child: Material(
                              color: Colors.white.withOpacity(0.8),
                              elevation: 0.0,
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                icon: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).buttonColor,
                                        borderRadius: BorderRadius.circular(2.0),
                                        border: Border.all(color:  Theme.of(context).buttonColor)),
                                    child: Icon(Icons.arrow_drop_down_sharp,color: Colors.white,)),
                                underline: Container(),
                                isExpanded: true,

                                onChanged: (newValue) {
                                  var price,unit;
                                  values.forEach((values) {
                                    if(values['product_id']==widget.product_id && values['name']==newValue)
                                    {
                                      price=values['price'];
                                      unit=values['name'];
                                    }
                                  });
                                  setState(() {
                                    widget.new_price=price;
                                    widget.unit=unit;
                                    dropdownValue = newValue;
                                  });
                                },
                                items: listNames
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(value,
                                          style: TextStyle(
                                            fontSize: 14,
                                          )),
                                    ),
                                  );
                                }).toList(),
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                widget.stock_status_id!='7'?
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 30,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      textColor: Colors.white,
                      color:Colors.grey,
                      padding: const EdgeInsets.all(8.0),
                      onPressed: () async {

                      },
                      child: FittedBox(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ):
                Expanded(
                  flex: 3,
                  child: StreamBuilder(
                    stream: cart2.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var quantity='0';
                        try{
                          List<dynamic> values = snapshot.data.snapshot.value;
                          if(values!=null)
                            values.forEach((values) {
                              try{
                                if(values!=null &&values['customer_id'].toString()==customerId.toString() &&
                                    values['product_id'].toString()==widget.product_id.toString() && values['status']=="1")
                                {
                                  quantity=values['quantity'];

                                }

                              }
                              catch(e){

                              }
                            });
                        }
                        catch(e)
                        {
                          Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                          if(values!=null)
                            values.forEach((key,values) {
                              try{
                                if(values!=null &&values['customer_id'].toString()==customerId.toString() &&
                                    values['product_id'].toString()==widget.product_id.toString() && values['status']=="1")
                                {
                                  quantity=values['quantity'];

                                }

                              }
                              catch(e){

                              }
                            });
                        }





                        if (quantity == '0' || quantity==null) {
                          return SizedBox(
                            height: 30,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              textColor: Colors.white,
                              color: Theme.of(context).buttonColor,
                              padding: const EdgeInsets.all(8.0),
                              onPressed: () async {
                                if(enabled)
                                {
                                  enabled=false;
                                  cartLast.once().then((DataSnapshot datasnapshot){
                                    Map<dynamic,dynamic> values= datasnapshot.value;
                                    values.forEach((key,value){
                                      int newKey=int.parse(key.toString())+1;
                                      cart.child(newKey.toString()).set({
                                        "customer_id":customerId,
                                        "date_added":DateTime.now().toIso8601String(),
                                        "image":widget.image_name,
                                        "maximum":"1",
                                        "minimum":"1",
                                        "name":widget.title,
                                        "oldPrice":widget.old_price,
                                        "newPrice":widget.new_price,
                                        "product_id":widget.product_id,
                                        "quantity":"1",
                                        "unit":widget.product_unit,
                                        "weight":widget.weight,
                                        "status":"1",
                                        "stock_status_id": widget.stock_status_id,
                                        "stock_status":widget.stock_status,
                                        "category_id": widget.category_id,
                                        "option_name":widget.unit,
                                        "product_option_id":product_option_id,
                                        "product_option_value_id":product_option_value_id,
                                        "manufacturer":widget.manufacturer,

                                      }).then((value) => setState((){}));


                                    });
                                  }
                                  );
                                }





                                Fluttertoast.showToast(
                                    msg:
                                    "Added to cart",
                                    toastLength: Toast
                                        .LENGTH_SHORT,
                                    gravity:
                                    ToastGravity
                                        .BOTTOM,
                                    timeInSecForIosWeb:
                                    1,
                                    fontSize: 16.0);

                              },
                              child: FittedBox(
                                child: Text(
                                  "Add",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          );
                        } else {
                          enabled=true;
                          return Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      textColor: Colors.white,
                                      color:  Theme.of(context).buttonColor,
                                      padding: const EdgeInsets.all(8.0),
                                      onPressed: () async {
                                        if ((int.parse(quantity) - 1) == 0) {
                                          cart.once().then(
                                                  (DataSnapshot datasnapshot) {
                                                try
                                                {
                                                  List<dynamic> values = datasnapshot.value;
                                                  for (int i = 0; i < values.length; i++) {
                                                    try{
                                                      if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                          values[i]['product_id'].toString() == widget.product_id.toString()) {
                                                        cart.child(i.toString()).remove();
                                                      }
                                                    }
                                                    catch(e)
                                                    {
                                                    }

                                                  }
                                                }
                                                catch(e)
                                                {

                                                  Map<dynamic,dynamic> values = datasnapshot.value;
                                                  values.forEach((key,value){
                                                    try{
                                                      if(value!=null)
                                                        if (value['customer_id'].toString() == customerId.toString() &&
                                                            value['product_id'].toString() == widget.product_id.toString()) {
                                                          cart.child(key.toString()).remove();
                                                        }
                                                    }
                                                    catch(e)
                                                    {
                                                      print(e.toString());
                                                    }
                                                  });
                                                }


                                              }).then((value) => setState((){}));

                                        }
                                        else {
                                          cart.once().then(
                                                  (DataSnapshot datasnapshot) {
                                                int x= int.parse(quantity.toString());
                                                x--;
                                                try
                                                {
                                                  Map<dynamic,dynamic> values = datasnapshot.value;
                                                  values.forEach((key, value) {
                                                    try{
                                                      if (values[key]['customer_id'].toString() == customerId.toString() &&
                                                          values[key]['product_id'].toString() == widget.product_id.toString()) {
                                                        cart.child(key.toString()).update(
                                                            {"quantity": x.toString()});
                                                      }}
                                                    catch(e)
                                                    {


                                                    }
                                                  });

                                                }
                                                catch(e)
                                                {
                                                  List<dynamic> values = datasnapshot.value;
                                                  for (int i = 0; i < values.length; i++) {
                                                    try{
                                                      if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                          values[i]['product_id'].toString() == widget.product_id.toString()) {
                                                        cart.child(i.toString()).update(
                                                            {"quantity": x.toString()});
                                                      }}
                                                    catch(e)
                                                    {


                                                    }
                                                  }
                                                }

                                              }
                                          ).then((value) => setState((){}));

                                        }
                                        Fluttertoast.showToast(
                                            msg:
                                            "Removed from cart",
                                            toastLength: Toast
                                                .LENGTH_SHORT,
                                            gravity:
                                            ToastGravity
                                                .BOTTOM,
                                            timeInSecForIosWeb:
                                            1,
                                            fontSize: 16.0);
                                      },
                                      child: FittedBox(
                                        child: Text(
                                          "-",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                      child:
                                      Text(quantity)),
                                  width: 20.0,
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      textColor: Colors.white,
                                      color:  Theme.of(context).buttonColor,
                                      padding: const EdgeInsets.all(8.0),
                                      onPressed: () async {



                                        cart.once().then(
                                                (DataSnapshot datasnapshot) {
                                              int x= int.parse(quantity.toString());
                                              x++;
                                              try
                                              {
                                                Map<dynamic,dynamic> values = datasnapshot.value;
                                                values.forEach((key, value) {
                                                  try{
                                                    if (values[key]['customer_id'].toString() == customerId.toString() &&
                                                        values[key]['product_id'].toString() == widget.product_id.toString()) {
                                                      cart.child(key.toString()).update(
                                                          {"quantity": x.toString()});
                                                    }}
                                                  catch(e)
                                                  {

                                                  }
                                                });

                                              }
                                              catch(e)
                                              {
                                                List<dynamic> values = datasnapshot.value;
                                                for (int i = 0; i < values.length; i++) {
                                                  try{
                                                    if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                        values[i]['product_id'].toString() == widget.product_id.toString()) {
                                                      cart.child(i.toString()).update(
                                                          {"quantity": x.toString()});
                                                    }}
                                                  catch(e)
                                                  {

                                                  }
                                                }
                                              }

                                            }
                                        ).then((value) => setState((){}));
                                        Fluttertoast.showToast(
                                            msg:
                                            "Added to cart",
                                            toastLength: Toast
                                                .LENGTH_SHORT,
                                            gravity:
                                            ToastGravity
                                                .BOTTOM,
                                            timeInSecForIosWeb:
                                            1,
                                            fontSize: 16.0);


                                      },
                                      child: FittedBox(
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return SizedBox(
                          height: 30,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            textColor: Colors.white,
                            color: Theme.of(context).buttonColor,
                            padding: const EdgeInsets.all(8.0),
                            onPressed: () async {
                              if(enabled)
                              {
                                enabled=false;
                                cartLast.once().then((DataSnapshot datasnapshot){
                                  Map<dynamic,dynamic> values= datasnapshot.value;
                                  values.forEach((key,value){
                                    int newKey=int.parse(key.toString())+1;
                                    cart.child(newKey.toString()).set({
                                      "customer_id":customerId,
                                      "date_added":DateTime.now().toIso8601String(),
                                      "image":widget.image_name,
                                      "maximum":"1",
                                      "minimum":"1",
                                      "name":widget.title,
                                      "oldPrice":widget.old_price,
                                      "newPrice":widget.new_price,
                                      "product_id":widget.product_id,
                                      "quantity":"1",
                                      "unit":widget.product_unit,
                                      "weight":widget.weight,
                                      "status":"1",
                                      "stock_status_id": widget.stock_status_id,
                                      "stock_status":widget.stock_status,
                                      "category_id": widget.category_id,
                                      "option_name":widget.unit,
                                      "product_option_id":product_option_id,
                                      "product_option_value_id":product_option_value_id,
                                      "manufacturer":widget.manufacturer,

                                    }).then((value) => setState((){}));


                                  });
                                }
                                );
                              }



                              Fluttertoast.showToast(
                                  msg:
                                  "Added to cart",
                                  toastLength: Toast
                                      .LENGTH_SHORT,
                                  gravity:
                                  ToastGravity
                                      .BOTTOM,
                                  timeInSecForIosWeb:
                                  1,
                                  fontSize: 16.0);

                            },
                            child: FittedBox(
                              child: Text(
                                "Add",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            );
          }
          return  Row(
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    widget.new_price!=null && widget.new_price!="0"?
                    Expanded(
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: Text(
                            "Rs " + widget.new_price,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange
                            ),
                          ),
                        ),
                      ),
                    ):Text(""),
                    Text("  "),
                    widget.new_price==null || widget.new_price=="0" && widget.old_price!=null?Expanded(
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: Text(
                            "Rs " + widget.old_price,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange
                            ),
                          ),
                        ),
                      ),
                    ):
                    widget.old_price!=null? Expanded(
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: Text(
                            "Rs " + widget.old_price,
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ):Text(""),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 0.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.white.withOpacity(0.8),
                      elevation: 0.0,
                      child:Text(
                        widget.unit,
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                flex: 3,
              ),
              widget.stock_status_id!='7'?
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 30,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    textColor: Colors.white,
                    color:Colors.grey,
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () async {

                    },
                    child: FittedBox(
                      child: Text(
                        "Add",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ):
              Expanded(
                flex: 3,
                child:  StreamBuilder(
                  stream: cart2.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var quantity='0';
                      try{
                        List<dynamic> values = snapshot.data.snapshot.value;
                        if(values!=null)
                          values.forEach((values) {
                            try{
                              if(values!=null &&values['customer_id'].toString()==customerId.toString() &&
                                  values['product_id'].toString()==widget.product_id.toString() && values['status']=="1")
                              {
                                quantity=values['quantity'];

                              }

                            }
                            catch(e){

                            }
                          });
                      }
                      catch(e)
                      {
                        Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
                        if(values!=null)
                          values.forEach((key,values) {
                            try{
                              if(values!=null &&values['customer_id'].toString()==customerId.toString() &&
                                  values['product_id'].toString()==widget.product_id.toString() && values['status']=="1")
                              {
                                quantity=values['quantity'];

                              }

                            }
                            catch(e){

                            }
                          });
                      }





                      if (quantity == '0' || quantity==null) {
                        return SizedBox(
                          height: 30,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            textColor: Colors.white,
                            color: Theme.of(context).buttonColor,
                            padding: const EdgeInsets.all(8.0),
                            onPressed: () async {
                              if(enabled)
                              {
                                enabled=false;
                                cartLast.once().then((DataSnapshot datasnapshot){
                                  Map<dynamic,dynamic> values= datasnapshot.value;
                                  values.forEach((key,value){
                                    int newKey=int.parse(key.toString())+1;
                                    cart.child(newKey.toString()).set({
                                      "customer_id":customerId,
                                      "date_added":DateTime.now().toIso8601String(),
                                      "image":widget.image_name,
                                      "maximum":"1",
                                      "minimum":"1",
                                      "name":widget.title,
                                      "oldPrice":widget.old_price,
                                      "newPrice":widget.new_price,
                                      "product_id":widget.product_id,
                                      "quantity":"1",
                                      "unit":widget.product_unit,
                                      "weight":widget.weight,
                                      "status":"1",
                                      "stock_status_id": widget.stock_status_id,
                                      "stock_status":widget.stock_status,
                                      "category_id": widget.category_id,
                                      "option_name":widget.unit,
                                      "product_option_id":product_option_id,
                                      "product_option_value_id":product_option_value_id,
                                      "manufacturer":widget.manufacturer,

                                    }).then((value) => setState((){}));


                                  });
                                }
                                );
                              }





                              Fluttertoast.showToast(
                                  msg:
                                  "Added to cart",
                                  toastLength: Toast
                                      .LENGTH_SHORT,
                                  gravity:
                                  ToastGravity
                                      .BOTTOM,
                                  timeInSecForIosWeb:
                                  1,
                                  fontSize: 16.0);

                            },
                            child: FittedBox(
                              child: Text(
                                "Add",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        );
                      } else {
                        enabled=true;
                        return Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 30,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                    textColor: Colors.white,
                                    color:  Theme.of(context).buttonColor,
                                    padding: const EdgeInsets.all(8.0),
                                    onPressed: () async {
                                      if ((int.parse(quantity) - 1) == 0) {
                                        cart.once().then(
                                                (DataSnapshot datasnapshot) {
                                              try
                                              {
                                                List<dynamic> values = datasnapshot.value;
                                                for (int i = 0; i < values.length; i++) {
                                                  try{
                                                    if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                        values[i]['product_id'].toString() == widget.product_id.toString()) {
                                                      cart.child(i.toString()).remove();
                                                    }
                                                  }
                                                  catch(e)
                                                  {
                                                  }

                                                }
                                              }
                                              catch(e)
                                              {

                                                Map<dynamic,dynamic> values = datasnapshot.value;
                                                values.forEach((key,value){
                                                  try{
                                                    if(value!=null)
                                                      if (value['customer_id'].toString() == customerId.toString() &&
                                                          value['product_id'].toString() == widget.product_id.toString()) {
                                                        cart.child(key.toString()).remove();
                                                      }
                                                  }
                                                  catch(e)
                                                  {
                                                    print(e.toString());
                                                  }
                                                });
                                              }


                                            }).then((value) => setState((){}));

                                      }
                                      else {
                                        cart.once().then(
                                                (DataSnapshot datasnapshot) {
                                              int x= int.parse(quantity.toString());
                                              x--;
                                              try
                                              {
                                                Map<dynamic,dynamic> values = datasnapshot.value;
                                                values.forEach((key, value) {
                                                  try{
                                                    if (values[key]['customer_id'].toString() == customerId.toString() &&
                                                        values[key]['product_id'].toString() == widget.product_id.toString()) {
                                                      cart.child(key.toString()).update(
                                                          {"quantity": x.toString()});
                                                    }}
                                                  catch(e)
                                                  {


                                                  }
                                                });

                                              }
                                              catch(e)
                                              {
                                                List<dynamic> values = datasnapshot.value;
                                                for (int i = 0; i < values.length; i++) {
                                                  try{
                                                    if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                        values[i]['product_id'].toString() == widget.product_id.toString()) {
                                                      cart.child(i.toString()).update(
                                                          {"quantity": x.toString()});
                                                    }}
                                                  catch(e)
                                                  {


                                                  }
                                                }
                                              }

                                            }
                                        ).then((value) => setState((){}));

                                      }
                                      Fluttertoast.showToast(
                                          msg:
                                          "Removed from cart",
                                          toastLength: Toast
                                              .LENGTH_SHORT,
                                          gravity:
                                          ToastGravity
                                              .BOTTOM,
                                          timeInSecForIosWeb:
                                          1,
                                          fontSize: 16.0);
                                    },
                                    child: FittedBox(
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                    child:
                                    Text(quantity)),
                                width: 20.0,
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 30,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                    textColor: Colors.white,
                                    color:  Theme.of(context).buttonColor,
                                    padding: const EdgeInsets.all(8.0),
                                    onPressed: () async {



                                      cart.once().then(
                                              (DataSnapshot datasnapshot) {
                                            int x= int.parse(quantity.toString());
                                            x++;
                                            try
                                            {
                                              Map<dynamic,dynamic> values = datasnapshot.value;
                                              values.forEach((key, value) {
                                                try{
                                                  if (values[key]['customer_id'].toString() == customerId.toString() &&
                                                      values[key]['product_id'].toString() == widget.product_id.toString()) {
                                                    cart.child(key.toString()).update(
                                                        {"quantity": x.toString()});
                                                  }}
                                                catch(e)
                                                {

                                                }
                                              });

                                            }
                                            catch(e)
                                            {
                                              List<dynamic> values = datasnapshot.value;
                                              for (int i = 0; i < values.length; i++) {
                                                try{
                                                  if (values[i]['customer_id'].toString() == customerId.toString() &&
                                                      values[i]['product_id'].toString() == widget.product_id.toString()) {
                                                    cart.child(i.toString()).update(
                                                        {"quantity": x.toString()});
                                                  }}
                                                catch(e)
                                                {

                                                }
                                              }
                                            }

                                          }
                                      ).then((value) => setState((){}));
                                      Fluttertoast.showToast(
                                          msg:
                                          "Added to cart",
                                          toastLength: Toast
                                              .LENGTH_SHORT,
                                          gravity:
                                          ToastGravity
                                              .BOTTOM,
                                          timeInSecForIosWeb:
                                          1,
                                          fontSize: 16.0);


                                    },
                                    child: FittedBox(
                                      child: Text(
                                        "+",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        );
                      }
                    } else {
                      return SizedBox(
                        height: 30,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).buttonColor,
                          padding: const EdgeInsets.all(8.0),
                          onPressed: () async {
                            if(enabled)
                            {
                              enabled=false;
                              cartLast.once().then((DataSnapshot datasnapshot){
                                Map<dynamic,dynamic> values= datasnapshot.value;
                                values.forEach((key,value){
                                  int newKey=int.parse(key.toString())+1;
                                  cart.child(newKey.toString()).set({
                                    "customer_id":customerId,
                                    "date_added":DateTime.now().toIso8601String(),
                                    "image":widget.image_name,
                                    "maximum":"1",
                                    "minimum":"1",
                                    "name":widget.title,
                                    "oldPrice":widget.old_price,
                                    "newPrice":widget.new_price,
                                    "product_id":widget.product_id,
                                    "quantity":"1",
                                    "unit":widget.product_unit,
                                    "weight":widget.weight,
                                    "status":"1",
                                    "stock_status_id": widget.stock_status_id,
                                    "stock_status":widget.stock_status,
                                    "category_id": widget.category_id,
                                    "option_name":widget.unit,
                                    "product_option_id":product_option_id,
                                    "product_option_value_id":product_option_value_id,
                                    "manufacturer":widget.manufacturer,

                                  }).then((value) => setState((){}));


                                });
                              }
                              );
                            }



                            Fluttertoast.showToast(
                                msg:
                                "Added to cart",
                                toastLength: Toast
                                    .LENGTH_SHORT,
                                gravity:
                                ToastGravity
                                    .BOTTOM,
                                timeInSecForIosWeb:
                                1,
                                fontSize: 16.0);

                          },
                          child: FittedBox(
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          );
        });
  }
}
