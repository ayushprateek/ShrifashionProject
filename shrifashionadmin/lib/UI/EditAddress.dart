
import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;



import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
enum SingingCharacter { Home, Office, Other }
class EditAddress extends StatefulWidget {
  
  static String first_name;
  static String last_name;
  static String editAddress_address_id;

  static String customer_id;
  static String flat;
  static String society;
  static String editAddress_company;
  static String editAddress_address_1;
  static String editAddress_address_2;
  static String editAddress_postcode;
  static String editAddress_Country;
  static String editAddress_State;
  static String editAddress_City;
  static String lane;
  static String landmark;

  EditAddress(
      var first_name,
      var last_name,
      var editAddress_address_id,

      var editAddress_customer_id,
      var flat,
      var society,
      var editAddress_company,
      var editAddress_address_1,
      var editAddress_address_2,
      var editAddress_postcode,
      var editAddress_Country,
      var editAddress_State,
      var editAddress_City,
      var lane,
      var landmark

      ){
    //editAddress.deliveryAddress=deliveryAddress;

    EditAddress.first_name=first_name;
    EditAddress.editAddress_address_id=editAddress_address_id;
    EditAddress.customer_id=editAddress_customer_id;
    EditAddress.flat=flat;
    EditAddress.society=society;
    EditAddress.editAddress_company=editAddress_company;
    EditAddress.editAddress_address_1=editAddress_address_1;
    EditAddress.editAddress_address_2=editAddress_address_2;
    EditAddress.editAddress_postcode=editAddress_postcode;
    EditAddress.editAddress_Country=editAddress_Country;
    EditAddress.editAddress_State=editAddress_State;
    EditAddress.editAddress_City=editAddress_City;
    EditAddress.lane=lane;
    EditAddress.landmark=landmark;

  }

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final address = FirebaseDatabase.instance.reference().child("address");
  final addressLast = FirebaseDatabase.instance.reference().child("address").limitToLast(1);
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  //String _state = "State *";
  String _state=EditAddress.editAddress_State;
  String _country = EditAddress.editAddress_Country;
  final _formKey = GlobalKey<FormState>();
  SingingCharacter _character = EditAddress.editAddress_company == "Home"
      ? SingingCharacter.Home
      :
  EditAddress.editAddress_company == "Office"
      ? SingingCharacter.Office
      : SingingCharacter.Other;
  TextEditingController _pincodeTextController = TextEditingController(
      text: EditAddress.editAddress_postcode);

  TextEditingController first_name = TextEditingController(
      text: EditAddress.first_name);
  TextEditingController last_name = TextEditingController(
      text: EditAddress.last_name);

  TextEditingController _cityTextController = TextEditingController(
      text: EditAddress.editAddress_City);

  TextEditingController _flat = TextEditingController(text: EditAddress.flat);

  TextEditingController _society = TextEditingController(
      text: EditAddress.society);

  //TextEditingController _stateTextController = TextEditingController();

  TextEditingController _addresssTextController = TextEditingController(
      text: EditAddress.editAddress_address_1);
  TextEditingController _companyTextController = TextEditingController(
      text: EditAddress.editAddress_company);

  TextEditingController lane = TextEditingController(
      text: EditAddress.lane);
  TextEditingController landmark = TextEditingController(
      text: EditAddress.landmark);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StickyFooter(),
      appBar: AppBar(

        title: Text('Edit address',style:TextStyle(fontFamily: custom_font,color: Colors.black)),
        leading:  IconButton(
            icon: new Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            }),
        backgroundColor: backColor,
        actions: <Widget>[
          //CartCount()
        ],
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

                        Container(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Radio(
                                activeColor: barColor,
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
                                activeColor: barColor,
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
                                activeColor: barColor,
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
                                controller: first_name,
                                decoration: InputDecoration(
                                  hintText: "First name",
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
                                controller: last_name,
                                decoration: InputDecoration(
                                  hintText: "Last name",
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
                                  hintText: "Flat Details",
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

                        //---------FullName-----------------


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
                                  hintText: "Lane",
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
                                controller: landmark,
                                decoration: InputDecoration(
                                  hintText: "Landmark",
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
                                  hintText: "Address",
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
                                controller: _pincodeTextController,
                                decoration: InputDecoration(
                                  hintText: "Pincode",
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
                                  hintText: "City",
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
                            color: barColor.withOpacity(0.8),
                            elevation: 0.0,
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  edit();
                                });
                              },
                              minWidth: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
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

  Future<void> edit() async {
    if (_state == "State *" || _country == "Country *" ) {
      Fluttertoast.showToast(
          msg:
          "State or country can't be empty",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }
    else {
      print("Sending address in DB");
      print(_state);
      print(_country);
      var x;
      if (_character == SingingCharacter.Home) {
        x = "Home";
      }
      else if (_character == SingingCharacter.Office) {
        x = "Office";
      }
      else {
        x = "Other";
      }
      address.once().then(
              (DataSnapshot datasnapshot) {


            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['customer_id'].toString() == EditAddress.customer_id.toString() && values[i]['address_id'].toString() == EditAddress.editAddress_address_id.toString()) {
                  address.child(i.toString()).update(
                      {
                        "first_name":first_name.text.toString(),
                        "last_name":last_name.text.toString(),
                        "country":_country.toString(),
                        "state":_state.toString(),
                        "address_1": _addresssTextController.text,
                        "city":_cityTextController.text,
                        "company":x.toString(),
                        "customer_id":EditAddress.customer_id,
                        "flat":_flat.text.toString(),
                        "postcode":_pincodeTextController.text,
                        "society":_society.text.toString(),
                        "lane":lane.text.toString(),
                        "landmark":landmark.text.toString()
                      });
                }}
              catch(e)
              {

              }
            }
          }
      ).then((value) => setState((){}));
      Fluttertoast.showToast(
          msg:
          "Address saved",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);



      Navigator.of(context).pop(context);
    }
  }
}