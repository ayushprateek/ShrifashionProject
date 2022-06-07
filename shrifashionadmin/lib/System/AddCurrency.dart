import 'dart:async';

import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }
class AddCurrency extends StatefulWidget {
  @override
  _AddCurrencyState createState() => _AddCurrencyState();
}

class _AddCurrencyState extends State<AddCurrency> {
  TextEditingController name=TextEditingController();
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
        title: Text('Add a currency',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: ListView(
        children: [
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
                hintText: "Code",
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
              controller: symbol,
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
                hintText: "Symbol",
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
    var currencyStatus=status==Status.enabled?"True":"False";
    currenciesLast.once().then(
            (DataSnapshot datasnapshot){

          try{
            Map<dynamic,dynamic> values= datasnapshot.value;
            values.forEach((key,value){
              int newKey=int.parse(key.toString())+1;
              int currency_id=newKey+1;
              currencies.child(newKey.toString()).set({
                "currency_id":currency_id.toString(),
                "name":name.text.toString(),
                "code":code.text.toString(),
                "symbol":symbol.text.toString(),
                "status":currencyStatus.toString(),

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
            currencies.child(key.toString()).set({
              "currency_id":currency_id.toString(),
              "name":name.text.toString(),
              "code":code.text.toString(),
              "symbol":symbol.text.toString(),
              "status":currencyStatus.toString(),
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
