
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrifashionforbusiness/Components/PartnerDetails.dart';
import 'package:shrifashionforbusiness/LoginSignup/LoginPage.dart';
enum SingingCharacter { Home, Office, Other }
class AddressBottomSheet extends StatefulWidget {
  static String address,postalCode,customerAddress,city,state,country;
  AddressBottomSheet(String address,String postalCode,String customerAddress,String city,String state,String country)
  {
    AddressBottomSheet.address=address;
    AddressBottomSheet.postalCode=postalCode;
    AddressBottomSheet.customerAddress=customerAddress;
    AddressBottomSheet.city=city;
    AddressBottomSheet.state=state;
    AddressBottomSheet.country=country;
  }
  @override
  _AddressBottomSheetState createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {

  SingingCharacter _character = SingingCharacter.Home;
  TextEditingController _location = TextEditingController(text: AddressBottomSheet.address);
  TextEditingController _flatDetails = TextEditingController();
  TextEditingController _society = TextEditingController();
  TextEditingController _pincode = TextEditingController(text: AddressBottomSheet.postalCode);
  TextEditingController _completeAddress = TextEditingController();
  TextEditingController lane = TextEditingController();
  TextEditingController landmark = TextEditingController();

  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();

  final _bottomFormKey = GlobalKey<FormState>();
  final address = FirebaseDatabase.instance.reference().child("address");
  final addressLast = FirebaseDatabase.instance.reference().child("address").limitToLast(1);
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  void sendaddress() async {

    var x;
    if(_character==SingingCharacter.Home)
    {
      x="Home";
    }
    else
    if(_character==SingingCharacter.Office)
    {
      x="Office";
    }
    else
    {
      x="Other";
    }
    addressLast.once().then(
            (DataSnapshot datasnapshot){
          Map<dynamic,dynamic> values= datasnapshot.value;
          values.forEach((key,value){
            int newKey=int.parse(key.toString())+1;
            address.child(newKey.toString()).set({
              "first_name":first_name.text.toString(),
              "last_name":last_name.text.toString(),
              "country":AddressBottomSheet.country,
              "state":AddressBottomSheet.state,
              "address_1": AddressBottomSheet.customerAddress,
              "address_id":newKey.toString(),
              "city":AddressBottomSheet.city,
              "company":x.toString(),
              "partner_id":PartnerDetails.partner_id,
              "flat":_flatDetails.text.toString(),
              "postcode":AddressBottomSheet.postalCode,
              "society":_society.text.toString(),
              "lane":lane.text.toString(),
              "landmark":landmark.text.toString(),
              "status":"1"
            });
          });
        }
    );





  }


  @override
  Widget build(BuildContext context) {

    var _width = MediaQuery.of(context).size.width;
    return Container(
        child: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              Container(
                height: (MediaQuery.of(context).size.height)/1.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    new Padding(
                      padding: new EdgeInsets.only(left:12.0,top:10),
                      child: Text("Address Details"),
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child:new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Radio(
                                    activeColor: Theme.of(context).buttonColor,
                                    value: SingingCharacter.Home,
                                    groupValue: _character,
                                    onChanged: (SingingCharacter value) {
                                      print("HHHH");
                                      setState(() {
                                        _character = value;
                                      });
                                    },
                                  ),
                                  new Text(
                                    'Home',

                                  ),
                                  new Radio(
                                    activeColor: Theme.of(context).buttonColor,
                                    value: SingingCharacter.Office,
                                    groupValue: _character,

                                    onChanged: (SingingCharacter value) {
                                      print("HHHH");
                                      setState(() {
                                        _character = value;
                                      });
                                    },
                                  ),
                                  new Text(
                                    'Office',
                                  ),
                                  new Radio(
                                    activeColor: Theme.of(context).buttonColor,
                                    value: SingingCharacter.Other,
                                    groupValue: _character,
                                    onChanged: (SingingCharacter value) {
                                      setState(() {
                                        _character = value;
                                      });
                                    },
                                  ),
                                  new Text(
                                    'Other',
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: form(_width))





                          ]
                      ),
                    ),
                  ],
                ),
              ),


            ]
        )
    );
  }

  Widget form( var _width) {
    var _height = MediaQuery.of(context).size.height;
    return Container(
      child: Form(
        key: _bottomFormKey,
        child: SingleChildScrollView(
          // physics: ClampingScrollPhysics(),
          child: Column(
            children: [

              Padding(
                padding:
                const EdgeInsets
                    .only(left:8.0,right: 8.0,bottom: 8),
                child: FlatButton(
                  color: Colors
                      .lightBlue,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color:Theme.of(context).buttonColor,
                          width: 1)),
                  //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets
                            .only(
                            bottom:
                            8.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon:
                              Icon(
                                Icons
                                    .location_on,

                              ),
                            ),
                            Flexible(
                                child:
                                Text(
                                  _location
                                      .text,
                                  maxLines:
                                  2,style: TextStyle(color: Colors.black),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left:8.0,right:8.0),
                child: Container(
                  height: _height/ 15,
                  child: TextFormField(


                    controller: _pincode,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left:8.0,right:8.0),
                      filled: true,
                      // prefixText: '  +91 |  ',
                      //prefixIcon: Text('    +91 |  ',style: TextStyle(fontSize: 17,),),
                      //  prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 23),
                      // Icon(Icons.phone_android, color: HexColor("#27ab87"),),
                      fillColor: Colors.white,
                      hoverColor: Colors.red,
                      //focusColor:HexColor("#27ab87"),
                      // isDense: true,
                      hintText: "Pincode",
                      // fillColor: Colors.red,
                      focusedBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color:Theme.of(context).buttonColor

                        ),
                      ) ,
                      //labelStyle: TextStyle(color: HexColor("#27ab87")),

                      enabledBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color:Theme.of(context).buttonColor

                        ),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.number,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  /* Padding(
                                padding:  EdgeInsets.only(left:_height/50,bottom: _height/60),
                                child: Padding(
                                  padding: EdgeInsets.only(top:_height/50,bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child:

                                  /*TextFormField(
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(10),
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: _mobileTextController,
                                    decoration: InputDecoration.collapsed(
//hintText:" Enter 10 digit mobile number ",
                                    ),
                                  ),*/
                                ),
                              ),*/
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left:8.0,right:8.0),
                child: Container(
                  height: _height/ 15,
                  child: TextFormField(


                    controller: first_name,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left:8.0,right:8.0),
                      filled: true,
                      // prefixText: '  +91 |  ',
                      //prefixIcon: Text('    +91 |  ',style: TextStyle(fontSize: 17,),),
                      //  prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 23),
                      // Icon(Icons.phone_android, color: HexColor("#27ab87"),),
                      fillColor: Colors.white,
                      hoverColor: Colors.red,
                      //focusColor:HexColor("#27ab87"),
                      // isDense: true,
                      hintText: "First name",
                      // fillColor: Colors.red,
                      focusedBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color:Theme.of(context).buttonColor

                        ),
                      ) ,
                      //labelStyle: TextStyle(color: HexColor("#27ab87")),

                      enabledBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color:Theme.of(context).buttonColor

                        ),
                      ),
                      //fillColor: Colors.green
                    ),

                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  /* Padding(
                                padding:  EdgeInsets.only(left:_height/50,bottom: _height/60),
                                child: Padding(
                                  padding: EdgeInsets.only(top:_height/50,bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child:

                                  /*TextFormField(
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(10),
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: _mobileTextController,
                                    decoration: InputDecoration.collapsed(
//hintText:" Enter 10 digit mobile number ",
                                    ),
                                  ),*/
                                ),
                              ),*/
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0,right:8.0),
                child: Container(
                  height: _height/ 15,
                  child: TextFormField(


                    controller: last_name,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left:8.0,right:8.0),
                      filled: true,
                      // prefixText: '  +91 |  ',
                      //prefixIcon: Text('    +91 |  ',style: TextStyle(fontSize: 17,),),
                      //  prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 23),
                      // Icon(Icons.phone_android, color: HexColor("#27ab87"),),
                      fillColor: Colors.white,
                      hoverColor: Colors.red,
                      //focusColor:HexColor("#27ab87"),
                      // isDense: true,
                      hintText: "Last name",
                      // fillColor: Colors.red,
                      focusedBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color:Theme.of(context).buttonColor

                        ),
                      ) ,
                      //labelStyle: TextStyle(color: HexColor("#27ab87")),

                      enabledBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color:Theme.of(context).buttonColor

                        ),
                      ),
                      //fillColor: Colors.green
                    ),

                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  /* Padding(
                                padding:  EdgeInsets.only(left:_height/50,bottom: _height/60),
                                child: Padding(
                                  padding: EdgeInsets.only(top:_height/50,bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child:

                                  /*TextFormField(
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(10),
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: _mobileTextController,
                                    decoration: InputDecoration.collapsed(
//hintText:" Enter 10 digit mobile number ",
                                    ),
                                  ),*/
                                ),
                              ),*/
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0,right:8.0),
                child: Container(

                  /*decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(0.8),
                                  border: Border.all(color: Colors.red)),*/

                  height: _height/ 15,
                  child: TextFormField(


                    controller: _flatDetails,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left:8.0,right:8.0),
                      filled: true,
                      // prefixText: '  +91 |  ',
                      //prefixIcon: Text('    +91 |  ',style: TextStyle(fontSize: 17,),),
                      //  prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 23),
                      // Icon(Icons.phone_android, color: HexColor("#27ab87"),),
                      fillColor: Colors.white,
                      hoverColor: Colors.red,
                      //focusColor:HexColor("#27ab87"),
                      // isDense: true,
                      hintText: "Flat Details",
                      // fillColor: Colors.red,
                      focusedBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color:Theme.of(context).buttonColor

                        ),
                      ) ,
                      //labelStyle: TextStyle(color: HexColor("#27ab87")),

                      enabledBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color:Theme.of(context).buttonColor

                        ),
                      ),
                      //fillColor: Colors.green
                    ),

                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0,right:8.0),
                child: Container(

                  /*decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(0.8),
                                  border: Border.all(color: Colors.red)),*/

                  height: _height/ 15,
                  child: TextFormField(


                    controller: _society,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left:8.0,right:8.0),
                      filled: true,

                      fillColor: Colors.white,
                      hoverColor: Colors.red,
                      //focusColor:HexColor("#27ab87"),
                      // isDense: true,
                      hintText: "Society/ House Villa Name*",
                      // fillColor: Colors.red,
                      focusedBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color:Theme.of(context).buttonColor
                        ),
                      ) ,


                      enabledBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color:Theme.of(context).buttonColor

                        ),
                      ),
                      //fillColor: Colors.green
                    ),

                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),

                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left:8.0,right:8.0),
                child: Container(

                  /*decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(0.8),
                                  border: Border.all(color: Colors.red)),*/

                  height: _height/ 15,
                  child: TextFormField(


                    controller: lane,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left:8.0,right:8.0),
                      filled: true,

                      fillColor: Colors.white,
                      hoverColor: Colors.red,
                      //focusColor:HexColor("#27ab87"),
                      // isDense: true,
                      hintText: "Lane",
                      // fillColor: Colors.red,
                      focusedBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color: Theme.of(context).buttonColor
                        ),
                      ) ,


                      enabledBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color: Theme.of(context).buttonColor

                        ),
                      ),
                      //fillColor: Colors.green
                    ),

                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0,right:8.0),
                child: Container(

                  /*decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(0.8),
                                  border: Border.all(color: Colors.red)),*/

                  height: _height/ 15,
                  child: TextFormField(


                    controller: landmark,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left:8.0,right:8.0),
                      filled: true,

                      fillColor: Colors.white,
                      hoverColor: Colors.red,
                      //focusColor:HexColor("#27ab87"),
                      // isDense: true,
                      hintText: "Landmark",
                      // fillColor: Colors.red,
                      focusedBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color: Theme.of(context).buttonColor
                        ),
                      ) ,
                      enabledBorder: new OutlineInputBorder(

                        // borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(
                            color: Theme.of(context).buttonColor

                        ),
                      ),
                      //fillColor: Colors.green
                    ),

                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),

                ),
              ),



              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  width: _width/2.5,

                  child: Padding(
                    padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom+150),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color:  Theme.of(context).buttonColor,
                      onPressed: () async {
                        //AddressBottomSheet.customerAddress+=" "+_flatDetails.text+" "+_society.text;
                        AddressBottomSheet.postalCode=_pincode.text;
                        await sendaddress();


                        Navigator.pop(context);

                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 100,
                color: Colors.white,
              ),
            ],
          ),
        ),

      ),
    );
  }
}


