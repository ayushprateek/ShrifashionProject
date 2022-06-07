import 'package:shrifashion/components/Font.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:shrifashion/MyAddress.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;


import 'components/Color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
enum SingingCharacter { Home, Office, Other }
class NewAddress extends StatefulWidget {
  static bool deliveryAddress;
  NewAddress(bool deliveryDetails)
  {
    NewAddress.deliveryAddress=deliveryDetails;
  }
  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {

  final address = FirebaseDatabase.instance.reference().child("address");
  final addressLast = FirebaseDatabase.instance.reference().child("address").limitToLast(1);
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  String _state = "State *";
  String _country="Country *";
  final _formKey = GlobalKey<FormState>();
  TextEditingController _pincodeTextController = TextEditingController();
  TextEditingController _cityTextController = TextEditingController();
  SingingCharacter _character=SingingCharacter.Home;

  TextEditingController _flat = TextEditingController();
  TextEditingController _society = TextEditingController();
  TextEditingController _addresssTextController = TextEditingController();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController lane = TextEditingController();
  TextEditingController landmark = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text('Add a new address',style: TextStyle(fontFamily: custom_font),),


      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 8.0, right: 8.0, bottom: 0.0),
                          child: Text(
                            "Add Address",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),

                        //---------FullName-----------------

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
                                activeColor:Theme.of(context).buttonColor,
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
                                activeColor:Theme.of(context).buttonColor,
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

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: firstName,
                                decoration: InputDecoration(
                                  hintText:"First Name *",
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: lastName,
                                decoration: InputDecoration(
                                  hintText:"Last Name",
                                ),
                              ),
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: _flat,
                                decoration: InputDecoration(
                                  hintText:"Flat Details",
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: _society,
                                decoration: InputDecoration(
                                  hintText: "Society",
                                ),
                              ),
                            ),
                          ),
                        ),
                        // LANE
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: lane,
                                decoration: InputDecoration(
                                  labelText: "Lane",
                                ),
                              ),
                            ),
                          ),
                        ),
                        //LANDMARK
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: landmark,
                                decoration: InputDecoration(
                                  labelText: "Landmark",
                                ),
                              ),
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: _addresssTextController,
                                decoration: InputDecoration(
                                  labelText: "Address *",
                                ),
                              ),
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                //keyboardType:,
                                controller: _pincodeTextController,
                                decoration: InputDecoration(
                                  labelText: "Pincode *",
                                ),
                              ),
                            ),
                          ),
                        ),
                        //--------Email-----------------------


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: _cityTextController,
                                decoration: InputDecoration(
                                  labelText: "City *",
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 8.0, right: 8.0, bottom: 8.0),
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: new DropdownButton<String>(
                              isExpanded: true,
                              hint: Text(_state),
                              items: <String>[
                                'Andhra Pradesh',
                                'Arunachal Pradesh',
                                'Assam',
                                'Bihar',
                                'Chhattisgarh',
                                'Goa',
                                'Gujarat',
                                'Haryana',
                                'Himachal Pradesh',
                                'Jharkhand',
                                'Karnataka',
                                'Kerala',
                                'Madhya Pradesh',
                                'Maharashtra',
                                'Manipur',
                                'Meghalaya',
                                'Mizoram',
                                'Nagaland',
                                'Odisha',
                                'Punjab',
                                'Rajasthan',
                                'Sikkim',
                                'Tamil Nadu',
                                'Telangana',
                                'Tripura',
                                'Uttar Pradesh',
                                'Uttarakhand',
                                'West Bengal',
                              ].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String val) {
                                setState(() {
                                  _state = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 8.0, right: 8.0, bottom: 8.0),
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: new DropdownButton<String>(
                              isExpanded: true,
                              hint: Text(_country),
                              items: <String>[
                                'India',
                              ].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String val) {
                                setState(() {
                                  _country = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Theme.of(context).buttonColor.withOpacity(0.8),
                            elevation: 0.0,
                            child: MaterialButton(
                              onPressed: () {
                                sendaddress();
                                if(NewAddress.deliveryAddress)
                                  {
                                    Navigator.pop(context);


                                  }
                                else
                                  {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context,
                                        new MaterialPageRoute(builder: (context) => new MyAddress()));
                                  }


                              },
                              minWidth: MediaQuery.of(context).size.width,
                              child: Text(
                                "Save",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
  void sendaddress() async {

    if (_state == "State *" || _country == "Country *" || firstName.text.toString()==null || firstName.text.toString()==""
    || _pincodeTextController.text.toString()==null || _pincodeTextController.text.toString()==""
    ) {
      Fluttertoast.showToast(
          msg:
          "State,First Name,PIN or country can't be empty",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }
    else
      {
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
                  "country":_country.toString(),
                  "state":_state.toString(),
                  "address_1": _addresssTextController.text,
                  "address_id":newKey.toString(),
                  "city":_cityTextController.text,
                  "company":x.toString(),
                  "customer_id":customerId,
                  "first_name":firstName.text.toString(),
                  "flat":_flat.text.toString(),
                  "last_name":lastName.text.toString(),
                  "postcode":_pincodeTextController.text,
                  "society":_society.text.toString(),
                  "lane":lane.text.toString(),
                  "landmark":landmark.text.toString(),
                  "status":"1"

                });


              });
            }
        );
        Fluttertoast.showToast(
            msg:
            "Address added",
            toastLength: Toast
                .LENGTH_SHORT,
            gravity:
            ToastGravity
                .BOTTOM,
            timeInSecForIosWeb:
            1,
            fontSize: 16.0);




      }

    }

}
