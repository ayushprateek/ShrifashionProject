import 'dart:async';

import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }
List<String> unitList=[];
class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController name=TextEditingController();
  TextEditingController category_id=TextEditingController();
  TextEditingController description=TextEditingController();

  TextEditingController location=TextEditingController();
  TextEditingController manufacturer=TextEditingController();
  TextEditingController model=TextEditingController();
  TextEditingController new_price=TextEditingController();
  TextEditingController old_price=TextEditingController();
  //TextEditingController unit=TextEditingController();
  TextEditingController weight=TextEditingController();

  Status status=Status.enabled;

  String unit = 'g';

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: backColor,
        title: Text('Add Product',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: ListView(
        children: [
          Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(5.0, 2.0),
                ),
              ],
            ),
            child: IconButton(
              iconSize: MediaQuery.of(context).size.width,
              icon: Icon(Icons.camera_alt,color: barColor,size: MediaQuery.of(context).size.width,
              ),
              onPressed: (){
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: name,
              decoration: new InputDecoration(
                filled: true,

                prefixIcon: Icon(
                  Icons.person,
                  color: barColor,
                ),
                fillColor: Colors.white,
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide:
                  new BorderSide(color: barColor,),
                ),
                hintText: "Product Name",
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
              controller: category_id,
              decoration: new InputDecoration(
                filled: true,

                prefixIcon: Icon(
                  Icons.person,
                  color: barColor,
                ),
                fillColor: Colors.white,
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide:
                  new BorderSide(color: barColor,),
                ),
                hintText: "Category id",
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
              controller: description,
              decoration: new InputDecoration(
                filled: true,

                prefixIcon: Icon(
                  Icons.person,
                  color: barColor,
                ),
                fillColor: Colors.white,
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide:
                  new BorderSide(color: barColor,),
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
            child: TextFormField(
              controller: location,
              decoration: new InputDecoration(
                filled: true,

                prefixIcon: Icon(
                  Icons.person,
                  color: barColor,
                ),
                fillColor: Colors.white,
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide:
                  new BorderSide(color: barColor,),
                ),
                hintText: "Location",
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
              controller: manufacturer,
              decoration: new InputDecoration(
                filled: true,

                prefixIcon: Icon(
                  Icons.person,
                  color: barColor,
                ),
                fillColor: Colors.white,
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide:
                  new BorderSide(color: barColor,),
                ),
                hintText: "Manufacturer",
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
              controller: model,
              decoration: new InputDecoration(
                filled: true,

                prefixIcon: Icon(
                  Icons.person,
                  color: barColor,
                ),
                fillColor: Colors.white,
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide:
                  new BorderSide(color: barColor,),
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
              controller: new_price,
              decoration: new InputDecoration(
                filled: true,

                prefixIcon: Icon(
                  Icons.person,
                  color: barColor,
                ),
                fillColor: Colors.white,
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide:
                  new BorderSide(color: barColor,),
                ),
                hintText: "New price",
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
              controller: old_price,
              decoration: new InputDecoration(
                filled: true,

                prefixIcon: Icon(
                  Icons.person,
                  color: barColor,
                ),
                fillColor: Colors.white,
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide:
                  new BorderSide(color: barColor,),
                ),
                hintText: "Old price",
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

                prefixIcon: Icon(
                  Icons.person,
                  color: barColor,
                ),
                fillColor: Colors.white,
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide:
                  new BorderSide(color: barColor,),
                ),
                hintText: "Weight",
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


          InkWell(
            onTap: (){
              setState(() {
                status=Status.enabled;
              });
            },
            child: Row(
              children: [
                Radio(
                  activeColor: barColor,
                  value: Status.enabled,
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
              setState(() {
                status=Status.disabled;
              });
            },
            child: Row(
              children: [
                Radio(
                  activeColor: barColor,
                  value: Status.disabled,
                  groupValue: status ,
                  onChanged: (value){
                  },
                ),
                Text('Out of stock')
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addProduct();

        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
  void addProduct()
  {
    String imageName="name.jpeg";
    searchLast.once().then(
            (DataSnapshot datasnapshot){
          Map<dynamic,dynamic> values= datasnapshot.value;
          values.forEach((key,value){
            int newKey=int.parse(key.toString())+1;
            search.child(newKey.toString()).set({
              "name":name.text.toString(),
              "category_id":63.toString(),
              "description":description.text.toString(),
              "loaction":location.text.toString(),
              "manufacturer":manufacturer.text.toString(),
              "model":model.text.toString(),
              "new_price":new_price.text.toString(),
              "old_price":old_price.text.toString(),
              "unit":unit.toString(),
              "weight":old_price.text.toString(),
              "image":"product/"+imageName.toString(),
              "parent_id":100.toString(),
              "stock_status":"In Stock",
              "stock_status_id":"7",
            });


          });
          Fluttertoast.showToast(
              msg:
              "New category created",
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
  }
}
