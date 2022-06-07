import 'dart:async';

import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }

class AddCoupon extends StatefulWidget {
  @override
  _AddCouponState createState() => _AddCouponState();
}

class _AddCouponState extends State<AddCoupon> {
  TextEditingController couponCode=TextEditingController();
  TextEditingController descripiion=TextEditingController();
  TextEditingController dateStart=TextEditingController();
  TextEditingController dateEnd=TextEditingController();
  TextEditingController discount=TextEditingController();
  TextEditingController total=TextEditingController();
  TextEditingController max_discount=TextEditingController();
  Status status=Status.enabled;
  String type = 'Fixed amount';
  bool added=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,
        
        title: Text('Add coupon',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: couponCode,
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
                hintText: "Coupon code",
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
              controller: descripiion,
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
              controller: dateStart,
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
                hintText: "Date start (YYYY-MM-DD)",
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
              controller: dateEnd,
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
                hintText: "Date end (YYYY-MM-DD)",
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
              controller: discount,
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
                hintText: "Discount",
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
                    child: Text('Type :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: type,
                    icon: const Icon(Icons.arrow_drop_down_sharp),
                    //iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        type = newValue;
                      });
                    },
                    items: <String>['Fixed amount', 'Percentage']
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: total,
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
                hintText: "Min cart value",
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
              controller: max_discount,
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
                hintText: "Maximum discount",
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
                    setState(() {
                      status=Status.disabled;
                    });
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

          bool hasExceptionArose=false;
          if(!added)
            {
              added=true;
              try
              {
                DateTime.parse(dateStart.text.toString());
              }
              catch(e)
              {
                hasExceptionArose=true;
                added=false;
                Fluttertoast.showToast(
                    msg:
                    "Invalid Date Start Format",
                    toastLength: Toast
                        .LENGTH_SHORT,
                    gravity:
                    ToastGravity
                        .BOTTOM,
                    timeInSecForIosWeb:
                    1,
                    fontSize: 16.0);
              }
              try
              {
                DateTime.parse(dateEnd.text.toString());
              }
              catch(e)
              {
                hasExceptionArose=true;
                added=false;
                Fluttertoast.showToast(
                    msg:
                    "Invalid Date End Format",
                    toastLength: Toast
                        .LENGTH_SHORT,
                    gravity:
                    ToastGravity
                        .BOTTOM,
                    timeInSecForIosWeb:
                    1,
                    fontSize: 16.0);
              }



              if(!hasExceptionArose)
                addCoupon();
            }



        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }

  void addCoupon()
  {
    String couponStatus=status==Status.enabled ?"True":"False";
    String couponType=type == 'Fixed amount' ?"F":"P";
    couponsLast.once().then(
            (DataSnapshot datasnapshot){
          Map<dynamic,dynamic> values= datasnapshot.value;
          values.forEach((key,value){
            int newKey=int.parse(key.toString())+1;
            coupons.child(newKey.toString()).set({
              "code":couponCode.text.toString(),
              "coupon_id":newKey.toString(),
              "date_end":dateEnd.text.toString(),
              "date_start":dateStart.text.toString(),
              "discount":discount.text.toString(),
              "name":descripiion.text.toString(),
              "status":couponStatus.toString(),
              "total":total.text.toString(),
              "type":couponType.toString(),
              "uses_total":1.toString(),
              "max_discount":max_discount.text.toString(),
            });


          });

          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
              "New coupon added",
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
