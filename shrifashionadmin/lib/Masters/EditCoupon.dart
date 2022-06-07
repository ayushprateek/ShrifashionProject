import 'dart:async';

import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }
Status status;
String type = 'Fixed amount';
class EditCoupon extends StatefulWidget {
  var coupon_id,name;
  EditCoupon({this.coupon_id,this.name});
  @override
  _EditCouponState createState() => _EditCouponState();
}
class _EditCouponState extends State<EditCoupon> {
  TextEditingController couponCode=TextEditingController();
  TextEditingController descripiion=TextEditingController();
  TextEditingController dateStart=TextEditingController();
  TextEditingController dateEnd=TextEditingController();
  TextEditingController discount=TextEditingController();
  TextEditingController total=TextEditingController();
  TextEditingController max_discount=TextEditingController();
  bool updated=false;


  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=coupons.onValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: backColor,
        title: Text(widget.name,style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: StreamBuilder(
        stream: connection,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            lists.clear();

            try{
              List<dynamic> values  = snapshot.data.snapshot.value;
              values.forEach((values) {
                try{
                  if(values!=null && values['coupon_id']==widget.coupon_id)
                  {
                    lists.add(values);
                  }
                }
                catch(e){
                }
              });
            }catch(e){

              Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
              values.forEach((key,values) {
                try{
                  if( values!=null && values['coupon_id']==widget.coupon_id )
                  {
                    lists.add(values);
                  }
                }
                catch(e){
                }
              });
            }
            if(lists.isNotEmpty)
              {
                couponCode.text=lists[0]['code'];
                descripiion.text=lists[0]['name'];
                dateStart.text=lists[0]['date_start'];
                dateEnd.text=lists[0]['date_end'];
                discount.text=lists[0]['discount'];
                total.text=lists[0]['total'];
                type=lists[0]['type']=="F"?'Fixed amount':'Percentage';
                status=lists[0]['status']=="True"?Status.enabled:Status.disabled;
                max_discount.text=lists[0]['max_discount']==null?"0":lists[0]['max_discount'];




                return ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: lists.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    var data = snapshot.data;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: couponCode,
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
                            controller: dateStart,
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
                                color: barColor,
                              ),
                              fillColor: Colors.white,
                              hoverColor: Colors.red,
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide:
                                new BorderSide(color: barColor,),
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
                                color: barColor,
                              ),
                              fillColor: Colors.white,
                              hoverColor: Colors.red,
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide:
                                new BorderSide(color: barColor,),
                              ),
                              hintText: "Discount",
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
                          child:CouponType(type: type,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: total,
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
                              hintText: "Min cart value",
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
                            controller: max_discount,
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
                              hintText: "Maximum discount",
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
                        CouponStatus(status: status,),




                        Container(
                          height: MediaQuery.of(context).size.height / 17,
                          width: MediaQuery.of(context).size.width ,
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
                            onPressed: () async {
                              await animated_dialog_box.showScaleAlertBox(
                                title:Center(child: Text("Add a postal code")) , // IF YOU WANT TO ADD
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
                                  child: Text('Delete'),
                                  onPressed: () {
                                    removeCoupon();
                                  },
                                ),
                                icon: Icon(Icons.delete_forever,color: Colors.red,), // IF YOU WANT TO ADD ICON
                                yourWidget: Text('Are you sure you want to delete '+widget.name+" forever?"),
                              );
                            },
                            child: Text(
                              "Delete this coupon",
                              style: new TextStyle(color: Colors.white),
                            ),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    );


                  },
                );
              }
            return Container();

          }
          return Center(child:CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          bool hasExceptionArose=false;
          if(!updated)
          {
            try
            {
              DateTime.parse(dateStart.text.toString());
            }
            catch(e)
            {
              hasExceptionArose=true;
              updated=false;
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
              updated=false;
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
              updateCoupon();
          }



        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }

  void updateCoupon()
  {
    String couponStatus=status==Status.enabled ?"True":"False";
    String couponType=type == 'Fixed amount' ?"F":"P";

    coupons.once().then(
            (DataSnapshot datasnapshot) {

          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['coupon_id'].toString() == widget.coupon_id.toString()) {
                  coupons.child(i.toString()).update(
                      {
                        "code":couponCode.text.toString(),
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
                }
              }
              catch(e) {
                print(e.toString());
              }

            }
          }
          catch(e)
              {
                Map<dynamic,dynamic> values = datasnapshot.value;
                values.forEach((key, value) {
                  try{
                    if (values['coupon_id'].toString() == widget.coupon_id.toString()) {
                      coupons.child(key.toString()).update(
                          {
                            "code":couponCode.text.toString(),
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
                    }
                  }
                  catch(e) {
                    print(e.toString());
                  }
                });

              }

          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
              "Coupon updated",
              toastLength: Toast
                  .LENGTH_SHORT,
              gravity:
              ToastGravity
                  .BOTTOM,
              timeInSecForIosWeb:
              1,
              fontSize: 16.0);
        });


  }
  void removeCoupon()
  {
    coupons.once().then(
            (DataSnapshot datasnapshot) {
          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['coupon_id'].toString() == widget.coupon_id.toString()) {
                  coupons.child(i.toString()).remove();
                }
              }
              catch(e)
              {
                print(e.toString());
              }

            }
          }
          catch(e)
          {
            Map<dynamic,dynamic> values = datasnapshot.value;

            values.forEach((key,value){

              try{
                if(value!=null)
                  if (value['PIN'].toString() == widget.coupon_id.toString()) {
                    coupons.child(key.toString()).remove();
                  }
              }
              catch(e)
              {
              }
            });
          }
          Navigator.pop(context);
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
              "Coupon removed successfully",
              toastLength: Toast
                  .LENGTH_SHORT,
              gravity:
              ToastGravity
                  .BOTTOM,
              timeInSecForIosWeb:
              1,
              fontSize: 16.0);

        }).then((value) => setState((){}));
  }
}





class CouponType extends StatefulWidget {
  var type;
  CouponType({this.type});
  @override
  _CouponTypeState createState() => _CouponTypeState();
}

class _CouponTypeState extends State<CouponType> {
  @override
  Widget build(BuildContext context) {
    return  Row(
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
    );
  }
}








class CouponStatus extends StatefulWidget {
  Status status;
  CouponStatus({this.status});
  @override
  _CouponStatusState createState() => _CouponStatusState();
}

class _CouponStatusState extends State<CouponStatus> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            if(status!=Status.enabled)
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
                    color: barColor,
                    child: Text('Yes',style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      setState(() {
                        status=Status.enabled;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                  yourWidget: Container(
                    child: Text('Enable this coupon?'),
                  ));
            // setState(() {
            //   status=Status.enabled;
            // });
          },
          child: Row(
            children: [
              Radio(
                activeColor: barColor,
                value: Status.enabled,
                groupValue: status ,
                onChanged: (value){
                  setState(() {
                    status=Status.disabled;
                  });
                },

              ),
              Text('Enable')
            ],
          ),
        ),
        InkWell(
          onTap: (){
            if(status!=Status.disabled)
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
                    color: barColor,
                    child: Text('Yes',style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      setState(() {
                        status=Status.disabled;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                  yourWidget: Container(
                    child: Text('Disable this coupon?'),
                  ));
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
    );
  }
}

