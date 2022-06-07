import 'dart:async';

import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }
class AddCountry extends StatefulWidget {
  @override
  _AddCountryState createState() => _AddCountryState();
}

class _AddCountryState extends State<AddCountry> {
  TextEditingController name=TextEditingController();
  TextEditingController country_id=TextEditingController();
  bool added=false;

  Status status=Status.enabled;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,
        
        title: Text('Add country',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: country_id,
              decoration: new InputDecoration(
                filled: true,
                prefixIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).buttonColor,
                ),
                fillColor: Colors.white,
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide:
                  new BorderSide(color: Theme.of(context).buttonColor,),
                ),
                hintText: "Country ID",
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
              controller: name,
              decoration: new InputDecoration(
                filled: true,
                prefixIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).buttonColor,
                ),
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
          InkWell(
            onTap: (){
              setState(() {
                status=Status.enabled;
              });
            },
            child: Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).buttonColor,
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
                  activeColor: Theme.of(context).buttonColor,
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
              addCountry();
            }
          

        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
  void addCountry()
  {
    var countryStatus=status==Status.enabled?"True":"False";
    countriesLast.once().then(
            (DataSnapshot datasnapshot){

          try{
            Map<dynamic,dynamic> values= datasnapshot.value;
            values.forEach((key,value){
              int newKey=int.parse(key.toString())+1;
              countries.child(newKey.toString()).set({
                "country_id":country_id.text.toString(),
                "name":name.text.toString(),
                "status":countryStatus.toString(),
              });


            });
          }
          catch(e)
          {
            print(e.toString());
            List<dynamic> values= datasnapshot.value;
            int key=0;
            for(int i=0;i<values.length;i++)
              {
                key++;
              }
            countries.child(key.toString()).set({
              "country_id":country_id.text.toString(),
              "name":name.text.toString(),
              "status":countryStatus.toString(),
            });
          }


          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
              "New country added",
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
