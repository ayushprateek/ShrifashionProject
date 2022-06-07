import 'dart:async';
import 'dart:ui';
import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/GetImageUrl.dart';
import 'package:shrifashionforbusiness/Components/HtmlParser.dart';
import 'package:shrifashionforbusiness/Components/PartnerDetails.dart';
import 'package:shrifashionforbusiness/Components/ProductBanners.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:shrifashionforbusiness/Masters/AddProduct.dart';

enum Status { in_stock, out_of_stock }
Status status;
class ProductDetails extends StatefulWidget {
  String product_id,name;
  ProductDetails({this.product_id,this.name});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isSet=false;
  var connection;
  List PinCode=[];
  List<bool> checked=[];
  var postalConnection;
  List lists=[];
  bool isEditing=false;
  String fileName;
  bool hasUploaded=false;
  TextEditingController name=TextEditingController();

  TextEditingController old_price=TextEditingController();
  TextEditingController new_price=TextEditingController();
  TextEditingController description=TextEditingController();
  TextEditingController model=TextEditingController();
  TextEditingController min_order_qty=TextEditingController();
  TextEditingController qty=TextEditingController();
  TextEditingController weight=TextEditingController();
  final ScrollController scroll=ScrollController();
  List<TextEditingController> storeQuantity=[];

  List<TextEditingController> storeLocation=[];
  bool hasUpdated=false;
  String unit = 'g';
  File _imageFile;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        
        title: Text(widget.name,style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            //IMAGE

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
            //             if(values['product_id']==widget.product_id)
            //               lists.add(values);
            //           }
            //           catch(e){
            //           }
            //         });
            //       }catch(e){
            //
            //         Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
            //         values.forEach((key,values) {
            //           try{
            //             if(values['product_id']==widget.product_id)
            //               lists.add(values);
            //           }
            //           catch(e){
            //           }
            //         });
            //       }
            //       if(lists.isNotEmpty)
            //         {
            //           if(_imageFile==null)
            //             fileName=lists[0]["image"];
            //           Widget image;
            //           image=FutureBuilder(
            //             future: imageurl(context, lists[0]["image"],FirebaseStorage.instance),
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
            //                           width: MediaQuery.of(context).size.width / 3,
            //                           height: MediaQuery.of(context).size.width / 3
            //                       ));
            //                 }
            //                 catch(e){
            //                   image=ClipRRect(
            //                       borderRadius: BorderRadius.circular(15),
            //                       child: Container(
            //                           width: MediaQuery.of(context).size.width / 3,
            //                           height: MediaQuery.of(context).size.width / 3
            //                       )
            //                   );
            //                 }
            //
            //                 return image;
            //               }
            //               return Container(
            //                   width: MediaQuery.of(context).size.width / 3,
            //                   height: MediaQuery.of(context).size.width / 3
            //               );
            //             },
            //
            //           );
            //
            //           return Column(
            //             children: [
            //               _imageFile != null
            //                   ? Image.file(_imageFile,
            //                 width: MediaQuery.of(context).size.width,
            //                 height: MediaQuery.of(context).size.height/3,
            //               )
            //                   : Container(
            //                 decoration: new BoxDecoration(color: Colors.white),
            //                 child: Stack(
            //                   children: <Widget>[
            //                     Container(
            //                       child: image,
            //                       width: MediaQuery.of(context).size.width,
            //                       height: MediaQuery.of(context).size.height/3,
            //
            //                     ),
            //                     Positioned(
            //                       top: 15, right: 15, //give the values according to your requirement
            //                       child: Container(
            //                         decoration: new BoxDecoration(
            //                           color: Colors.white,
            //                           shape: BoxShape.rectangle,
            //                           boxShadow: [
            //                             BoxShadow(
            //                               color: Colors.black26,
            //                               blurRadius: 10.0,
            //                               offset: const Offset(5.0, 2.0),
            //                             ),
            //                           ],
            //                         ),
            //                         child: IconButton(
            //                           icon: Icon(Icons.camera_alt,color: Theme.of(context).buttonColor,size: 35,
            //                           ),
            //                           onPressed:pickImage,
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           );
            //         }
            //       else
            //         {
            //           return Column(
            //             children: [
            //               Container(
            //                 decoration: new BoxDecoration(
            //                   color: Colors.white,
            //                   shape: BoxShape.rectangle,
            //                   boxShadow: [
            //                     BoxShadow(
            //                       color: Colors.black26,
            //                       blurRadius: 10.0,
            //                       offset: const Offset(5.0, 2.0),
            //                     ),
            //                   ],
            //                 ),
            //                 child: IconButton(
            //                   iconSize: MediaQuery.of(context).size.width,
            //                   icon: Icon(Icons.camera_alt,color: Theme.of(context).buttonColor,size: MediaQuery.of(context).size.width,
            //                   ),
            //                   //onPressed: pickImage,
            //                 ),
            //               ),
            //             ],
            //           );
            //         }
            //
            //     }
            //     return Center(child:CircularProgressIndicator());
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductBanners(widget.product_id,widget.name),
            ),


            StreamBuilder(
              stream: connection,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  lists.clear();
                  storeLocation.clear();
                  storeQuantity.clear();

                  try{
                    List<dynamic> values  = snapshot.data.snapshot.value;
                    values.forEach((values) {
                      try{
                        if(values['product_id']==widget.product_id)
                          lists.add(values);
                      }
                      catch(e){
                      }
                    });
                  }catch(e){
                    Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
                    values.forEach((key,values) {
                      try{
                        if(values['product_id']==widget.product_id)
                          lists.add(values);
                      }
                      catch(e){
                      }
                    });
                  }
                  if(lists.isNotEmpty)
                    {
                      if(!isSet)
                        {
                          isSet=true;
                          model.text=lists[0]['model'];
                          weight.text=customHtmlParser(lists[0]['weight']);
                          unit=customHtmlParser(lists[0]['unit']);
                        }
                      if(!isEditing)
                      {
                        if(lists[0]['old_price']!=null && lists[0]['old_price']!="")
                          {

                            old_price.text=double.parse(lists[0]['old_price']).toStringAsFixed(2);
                            lists[0]['new_price']!=null?
                            new_price.text=double.parse(lists[0]['new_price']).toStringAsFixed(2):"";
                          }
                        else
                          {
                            new_price.text=double.parse(lists[0]['new_price']).toStringAsFixed(2);
                          }
                        name.text=customHtmlParser(lists[0]['name']);
                        min_order_qty.text=customHtmlParser(lists[0]['min_order_qty']);



                        description.text=customHtmlParser(lists[0]['description']);
                        qty.text=lists[0]['quantity']==null||lists[0]['quantity']==""?"0":lists[0]['quantity'];
                        status=lists[0]['stock_status_id']!="7"?Status.out_of_stock:Status.in_stock;
                      }
                      return ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount: lists.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          return Column(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: name,

                                        decoration: new InputDecoration(
                                          filled: true,
                                          labelText:"Name",


                                          fillColor: Colors.white,
                                          hoverColor: Colors.red,

                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide:
                                            new BorderSide(color: Theme.of(context).buttonColor,),
                                          ),
                                          hintText: "Name",

                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                        //keyboardType: TextInputType.number,
                                        style: new TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: new_price,
                                        decoration: new InputDecoration(
                                          filled: true,
                                          labelText:"New Price",


                                          fillColor: Colors.white,
                                          hoverColor: Colors.red,
                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide:
                                            new BorderSide(color: Theme.of(context).buttonColor,),
                                          ),
                                          hintText: "New Price",
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        style: new TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: old_price,
                                        decoration: new InputDecoration(
                                          filled: true,
                                          labelText:"Old Price",

                                          fillColor: Colors.white,
                                          hoverColor: Colors.red,
                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide:
                                            new BorderSide(color: Theme.of(context).buttonColor,),
                                          ),
                                          hintText: "Old Price",
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        style: new TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Text('Category :',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: FittedBox(
                                              child: DropdownButton<String>(
                                                value: category,
                                                icon: const Icon(Icons.arrow_drop_down_sharp),
                                                elevation: 16,
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    category = newValue;
                                                    for(int i=0;i<categoryList.length;i++)
                                                    {
                                                      if(categoryList[i]['name']==newValue)
                                                      {
                                                        category_id.text=categoryList[i]['category_id'];
                                                      }
                                                    }
                                                  });
                                                },
                                                items: categoryNameList
                                                    .map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Description :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: Colors.black
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: model,
                                        decoration: new InputDecoration(
                                          filled: true,

                                          labelText: "Model",
                                          fillColor: Colors.white,
                                          hoverColor: Colors.red,
                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide:
                                            new BorderSide(color: Theme.of(context).buttonColor,),
                                          ),
                                          hintText: "Model",
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                        //keyboardType: TextInputType.number,
                                        style: new TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        maxLines: 10,
                                        controller: description,
                                        decoration: new InputDecoration(
                                          filled: true,
                                          labelText:"Description",

                                          fillColor: Colors.white,
                                          hoverColor: Colors.red,
                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide:
                                            new BorderSide(color: Theme.of(context).buttonColor,),
                                          ),
                                          hintText: "Description",
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                        //keyboardType: TextInputType.number,
                                        style: new TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Quantity :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: Colors.black
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: qty,
                                        decoration: new InputDecoration(
                                          filled: true,
                                          labelText:"Quantity",
                                          fillColor: Colors.white,
                                          hoverColor: Colors.red,
                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide:
                                            new BorderSide(color: Theme.of(context).buttonColor,),
                                          ),
                                          hintText: "Quantity",
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                        //keyboardType: TextInputType.number,
                                        style: new TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: min_order_qty,
                                        decoration: new InputDecoration(
                                          filled: true,
                                          labelText:"Minimum Order Quantity",
                                          fillColor: Colors.white,
                                          hoverColor: Colors.red,
                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide:
                                            new BorderSide(color: Theme.of(context).buttonColor,),
                                          ),
                                          hintText: "Minimum Order Quantity",
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                        //keyboardType: TextInputType.number,
                                        style: new TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: weight,
                                        decoration: new InputDecoration(
                                          filled: true,
                                          labelText: "Weight",
                                          fillColor: Colors.white,
                                          hoverColor: Colors.red,
                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide:
                                            new BorderSide(color: Theme.of(context).buttonColor,),
                                          ),
                                          hintText: "Weight",
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(10.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        style: new TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Text('Unit :',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: DropdownButton<String>(
                                              value: unit,
                                              icon: const Icon(Icons.arrow_drop_down_sharp),
                                              //iconSize: 24,
                                              elevation: 16,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  unit = newValue;
                                                });
                                              },
                                              items: unitList
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ProductStatus(status: status,),
                                  ],
                                ),
                              ),
                            ],
                          );


                        },
                      );
                    }
                  else
                    {
                      return Container();
                    }

                }
                return Center(child:CircularProgressIndicator());
              },
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              margin: EdgeInsets.only(
                  left: 8, top: 8, right: 8, bottom: 10),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                onPressed: () {

                  animated_dialog_box.showScaleAlertBox(
                      title:Center(child: Text("Delete")) , // IF YOU WANT TO ADD
                      context: context,
                      firstButton: MaterialButton(
                        // OPTIONAL BUTTON
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: Colors.white,
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      secondButton: MaterialButton(
                        // FIRST BUTTON IS REQUIRED
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: Colors.red,
                        child: Text('Delete',style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          delete(context); //***********************************************************DELETE CALLED

                        },
                      ),
                      icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                      yourWidget: Container(
                        child: Text('Are you sure you want to Delete this product?'),
                      ));

                },
                child: Text(
                  "Delete this product",
                  style: new TextStyle(color: Colors.white),
                ),
                color: Colors.red,
              ),
            )


          ],
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: (){
          if(!hasUploaded)
          {
            partners.orderByChild("partner_id")
                .equalTo(PartnerDetails.partner_id)
                .once().then((snapshot) {
              String status;
              try
              {
                Map<dynamic,dynamic> values=snapshot.value;
                if(values!=null)
                  values.forEach((key, value) {
                    if(value!=null)
                      status=value['status'];
                  });
              }
              catch(e)
              {
                List<dynamic> values=snapshot.value;
                if(values!=null)
                  values.forEach(( value) {
                    if(value!=null)
                      status=value['status'];
                  });
              }
              if(status!="Approved")
              {
                Fluttertoast.showToast(msg: "The status of your profile is $status");
              }
              else
              {
                hasUploaded=true;
                uploadImageToFirebase(context);
              }
            });




          }


        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
  void delete(BuildContext context)
  {
    search.orderByChild("product_id").equalTo(widget.product_id).once().then(
            (DataSnapshot datasnapshot) {
              try{
                List<dynamic> values = datasnapshot.value;
                if(values!=null)
                for (int i = 0; i < values.length; i++) {
                  try{
                    if (values[i]!=null && values[i]['product_id'].toString() == widget.product_id) {
                      search.child(i.toString()).remove();

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
                values.forEach((key, value) {
                  if (value!=null && value['product_id'].toString() == widget.product_id)
                    search.child(key).remove();

                  });

                }
              prod_images.orderByChild("product_id").equalTo(widget.product_id).once().then(
                      (DataSnapshot datasnapshot) {
                    try{
                      List<dynamic> values = datasnapshot.value;
                      if(values!=null)
                        for (int i = 0; i < values.length; i++) {
                          try{
                            if (values[i]!=null && values[i]['product_id'].toString() == widget.product_id) {
                              prod_images.child(i.toString()).remove();

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
                      values.forEach((key, value) {
                        if (value!=null && value['product_id'].toString() == widget.product_id)
                          prod_images.child(key).remove();

                      });

                    }
                    Navigator.of(context).pop(context);

                  }

              );

              }

        );

  }
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null)
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }
  Future uploadImageToFirebase(BuildContext context) async {

    if(name.text==null || name.text==""){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Name cannot be empty!",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }
    else if(!_isNumeric(new_price.text)){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "New price should be a number !",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }

    else if(_imageFile==null){
      hasUploaded=false;
      update(context);
    }
    else
    {

      fileName = basename(_imageFile.path);
      print("fileName");
      print(_imageFile.path);
      print(fileName);
      fileName='product/$fileName';
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print("Done: $value"),
      );
      update(context);

      Fluttertoast.showToast(
          msg:
          "Image Uploaded",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
      setState(() {
        _imageFile=null;
      });
    }



  }
  void update(context)
  {
    isEditing=false;
    String stock_status,stock_status_id;
    stock_status=status==Status.out_of_stock?"Out Of Stock":"In Stock";
    stock_status_id=status==Status.out_of_stock?"6":"7";
    search.once().then(
            (DataSnapshot datasnapshot) {
          List<dynamic> values = datasnapshot.value;
          for (int i = 0; i < values.length; i++) {
            try{
              if (values[i]['product_id'].toString() == widget.product_id.toString()) {
                search.child(i.toString()).update(
                    {

                      'min_order_qty':min_order_qty.text.toString(),
                      'name':name.text.toString(),
                      "parent_id":category_id.text,
                      'old_price':old_price.text.toString(),
                      'new_price':new_price.text.toString(),
                      'description':description.text.toString(),
                      "quantity":qty.text.toString(),
                      "stock_status":stock_status.toString(),
                      "stock_status_id":stock_status_id.toString(),
                      "model":model.text.toString(),
                      "unit":unit.toString(),
                      "weight":weight.text.toString(),

                    });
              }
            }
            catch(e) {
              print(e.toString());
            }

          }
          manage_stock.once().then(
                  (DataSnapshot datasnapshot){
                    try
                    {
                      List<dynamic> values= datasnapshot.value;
                      for(int i=0;i<values.length;i++)
                        {
                          if(values[i]['product_id']==widget.product_id)
                          {
                            manage_stock.child(i.toString()).update({
                              "product_name":name.text.toString(),
                              "quantity":qty.text.toString(),
                              "stock_status":stock_status.toString(),
                              "stock_status_id":stock_status_id.toString(),
                            });
                          }
                        }

                    }
                    catch(e)
                    {
                      Map<dynamic,dynamic> values= datasnapshot.value;
                      values.forEach((key,value){

                        if(value['product_id']==widget.product_id)
                        {
                          manage_stock.child(key.toString()).update({
                            "product_name":name.text.toString(),
                            "quantity":qty.text.toString(),
                            "stock_status":stock_status.toString(),
                            "stock_status_id":stock_status_id.toString(),
                          });
                        }
                      });
                    }


                Fluttertoast.showToast(
                    msg:
                    "Product updated",
                    toastLength: Toast
                        .LENGTH_SHORT,
                    gravity:
                    ToastGravity
                        .BOTTOM,
                    timeInSecForIosWeb:
                    1,
                    fontSize: 16.0);
                Timer(
                    Duration(seconds: 1,),
                        (){
                      Navigator.pop(context);
                    });
              }
          );


        });
  }
  @override
  void initState()
  {
    postalConnection=postalCodes.onValue;
    connection=search.onValue;
  }


}
class ProductStatus extends StatefulWidget {
  Status status;
  ProductStatus({this.status});
  @override
  _ProductStatusState createState() => _ProductStatusState();
}

class _ProductStatusState extends State<ProductStatus> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            if(status!=Status.in_stock)
            animated_dialog_box.showScaleAlertBox(
                title:Center(child: Text("Delete")) , // IF YOU WANT TO ADD
                context: context,
                firstButton: MaterialButton(
                  // OPTIONAL BUTTON
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Colors.white,
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                secondButton: MaterialButton(
                  // FIRST BUTTON IS REQUIRED
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Theme.of(context).buttonColor,
                  child: Text('Yes',style: TextStyle(color: Colors.white),),
                  onPressed: () {

                    setState(() {
                      status=Status.in_stock;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                yourWidget: Container(
                  child: Text('Change the Status to In Stock?',),
                ));

          },
          child: Row(
            children: [
              Radio(
                activeColor: Theme.of(context).buttonColor,
                value: Status.in_stock,
                groupValue: status ,
                onChanged: (value){
                },
              ),
              Text('In Stock')
            ],
          ),
        ),
        InkWell(
          onTap: (){
            if(status!=Status.out_of_stock)
            animated_dialog_box.showScaleAlertBox(
                title:Center(child: Text("Delete")) , // IF YOU WANT TO ADD
                context: context,
                firstButton: MaterialButton(
                  // OPTIONAL BUTTON
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Colors.white,
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                secondButton: MaterialButton(
                  // FIRST BUTTON IS REQUIRED
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Theme.of(context).buttonColor,
                  child: Text('Yes',style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    setState(() {

                      status=Status.out_of_stock;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                yourWidget: Container(
                  child: Text('Change the Status to Out of Stock?'),
                ));
            // setState(() {
            //
            //   status=Status.out_of_stock;
            // });
          },
          child: Row(
            children: [
              Radio(
                activeColor: Theme.of(context).buttonColor,
                value: Status.out_of_stock,
                groupValue: status ,
                onChanged: (value){
                },
              ),
              Text('Out Of Stock')
            ],
          ),
        ),
      ],
    );
  }
}
