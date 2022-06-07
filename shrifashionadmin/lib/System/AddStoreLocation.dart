import 'dart:async';

import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }
class AddStoreLocation extends StatefulWidget {
  @override
  _AddStoreLocationState createState() => _AddStoreLocationState();
}

class _AddStoreLocationState extends State<AddStoreLocation> {
  TextEditingController location=TextEditingController();
  TextEditingController code=TextEditingController();
  TextEditingController symbol=TextEditingController();
  Status status=Status.enabled;
  bool added=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: backColor,
        title: Text('Add a store location',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: ListView(
        children: [
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
              controller: code,
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
                hintText: "Postal code",
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
                Text('Enable')
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
                Text('Disable')
              ],
            ),
          ),



        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(!added)
            {
              added=true;
              addCurrency();
            }


        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
  void addCurrency()
  {
    var countryStatus=status==Status.enabled?"True":"False";
    storeLocationsLast.once().then(
            (DataSnapshot datasnapshot){

          try{
            Map<dynamic,dynamic> values= datasnapshot.value;
            values.forEach((key,value){
              int newKey=int.parse(key.toString())+1;
              int currency_id=newKey+1;
              storeLocations.child(newKey.toString()).set({
                "store_id":currency_id.toString(),
                "location":location.text.toString(),
                "PIN":code.text.toString(),
                "status":countryStatus.toString(),
              });


            });
          }
          catch(e)
          {
            List<dynamic> values= datasnapshot.value;
            int key=0;
            for(int i=0;i<values.length;i++)
            {
              key++;
            }
            int currency_id=key+1;
            storeLocations.child(key.toString()).set({
              "store_id":currency_id.toString(),
              "location":location.text.toString(),
              "PIN":code.text.toString(),
              "status":countryStatus.toString(),

            });
          }

          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
              "New store added",
              toastLength: Toast
                  .LENGTH_SHORT,
              gravity:
              ToastGravity
                  .BOTTOM,
              timeInSecForIosWeb:
              1,
              fontSize: 16.0);


        }
    );
  }
}
