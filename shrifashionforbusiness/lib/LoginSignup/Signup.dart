import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/PartnerDetails.dart';
import 'package:shrifashionforbusiness/LoginSignup/LoginPage.dart';
import 'package:shrifashionforbusiness/LoginSignup/OTPPage.dart';
import 'package:shrifashionforbusiness/UI/HomePage.dart';
import 'package:shrifashionforbusiness/main.dart';
import 'package:path/path.dart';
bool clicked=true;
class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}
class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController full_name = TextEditingController();
  TextEditingController store_name = TextEditingController();
  TextEditingController store_address = TextEditingController();
  TextEditingController GST = TextEditingController();
  TextEditingController PIN = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  final partnersLast = FirebaseDatabase.instance.reference().child("partners").limitToLast(1);
  final partners = FirebaseDatabase.instance.reference().child("partners");
  String sex='M';
  String fileName;
  bool hasUploaded=false;
  File _imageFile;
  final picker = ImagePicker();
  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if(pickedFile!=null)
      setState(() {
        _imageFile = File(pickedFile.path);
      });
  }
  Future uploadImageToFirebase(BuildContext context) async {
    if(_imageFile==null){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Please select an image!",
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
      fileName = basename(_imageFile.path);
      print("fileName");
      print(_imageFile.path);
      print(fileName);
      fileName='partners/$fileName';
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print("Done: $value"),
      );
      register(context);

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
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Profile Details',
          style: TextStyle(color: Colors.black,fontFamily: 'Fredoka One'),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new mobileLogin()));
          },
          child: Icon(
            Icons.clear,
            color: Colors.black, // add custom icons also
          ),
        ),
      ),
      body: ListView(
        children: [
          _imageFile != null
              ? Image.file(_imageFile,
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
          )
              :Container(
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
              icon: Icon(Icons.camera_alt,color: Theme.of(context).buttonColor,size: MediaQuery.of(context).size.width,
              ),
              onPressed: (){
                animated_dialog_box.showScaleAlertBox(
                    title:Center(child: Text("Upload"),) , // IF YOU WANT TO ADD
                    context: context,
                    firstButton: MaterialButton(
                      // OPTIONAL BUTTON
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      color: Colors.white,
                      child: Text('Gallery'),
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    ),
                    secondButton: MaterialButton(
                      // FIRST BUTTON IS REQUIRED
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      color: Theme.of(context).buttonColor,
                      child: Text('Camera',style:TextStyle(color: Colors.white)),
                      onPressed: () {
                        pickImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                    ),
                    icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                    yourWidget: Container(
                      child: Text('How you want to upload image?'),
                    ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //---------FirstName-----------------
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: full_name,
                            decoration: new InputDecoration(
                              filled: true,
                              labelText: "Full Name",

                              //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                              fillColor: Colors.white,
                              hoverColor: Colors.red,
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide:
                                new BorderSide(color: Theme.of(context).buttonColor,),
                              ),
                              //focusColor:HexColor("#27ab87"),
                              // isDense: true,
                              hintText: "Full Name",
                              // fillColor: Colors.red,

                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            //keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
//------------LastName-----------------
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: store_name,
                            decoration: new InputDecoration(
                              filled: true,
                              labelText: "Store Name",

                              fillColor: Colors.white,
                              hoverColor: Colors.red,
                              //focusColor:HexColor("#27ab87"),
                              // isDense: true,
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide:
                                new BorderSide(color: Theme.of(context).buttonColor,),
                              ),
                              hintText: "Store Name",
                              // fillColor: Colors.red,

                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
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
                            controller: store_address,
                            maxLines: 5,
                            decoration: new InputDecoration(

                              filled: true,
                              labelText: "Store Address",

                              fillColor: Colors.white,
                              hoverColor: Colors.red,
                              //focusColor:HexColor("#27ab87"),
                              // isDense: true,
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide:
                                new BorderSide(color: Theme.of(context).buttonColor,),
                              ),
                              hintText: "Store Address",
                              // fillColor: Colors.red,

                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
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
                            controller: PIN,
                            maxLines: 5,
                            decoration: new InputDecoration(

                              filled: true,
                              labelText: "PIN Code",

                              fillColor: Colors.white,
                              hoverColor: Colors.red,
                              //focusColor:HexColor("#27ab87"),
                              // isDense: true,
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide:
                                new BorderSide(color: Theme.of(context).buttonColor,),
                              ),
                              hintText: "PIN Code",
                              // fillColor: Colors.red,

                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
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
                            controller: GST,
                            decoration: new InputDecoration(
                              filled: true,
                              labelText: "GST Number",

                              fillColor: Colors.white,
                              hoverColor: Colors.red,
                              //focusColor:HexColor("#27ab87"),
                              // isDense: true,
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide:
                                new BorderSide(color: Theme.of(context).buttonColor,),
                              ),
                              hintText: "GST Number",
                              // fillColor: Colors.red,

                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            //keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
//-----------Email-----------------

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: new InputDecoration(
                              filled: true,
                              labelText: "Email",
                              fillColor: Colors.white,
                              hoverColor: Colors.red,
                              //focusColor:HexColor("#27ab87"),
                              // isDense: true,

                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide:
                                new BorderSide(color: Theme.of(context).buttonColor,),
                              ),
                              hintText: "Email",
                              // fillColor: Colors.red,

                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            //keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:60.0,bottom: 20),
                          child: Text("I am a",
                              style: TextStyle(color: Colors.black,fontFamily: 'Fredoka One')),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(

                                  child:
                                  Radio(
                                    activeColor:  Theme.of(context).buttonColor,
                                    value: 'M',
                                    groupValue: sex ,
                                    onChanged: (value){
                                      setState(() {
                                        sex='M';
                                      });
                                    },

                                  )
                              ),
                              Expanded(
                                  flex:2,
                                  child:
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        sex='M';
                                      });
                                    },
                                    child: ClipRRect(
                                      child: Image.asset('images/male_user.jpeg'),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  )
                              ),


                              Expanded(child:
                              InkWell(
                                onTap: (){

                                },
                                child: Container(),
                              )
                              ),
                              Expanded(

                                  child:
                                  Radio(
                                    activeColor: Theme.of(context).buttonColor,
                                    value: 'F',
                                    groupValue: sex ,
                                    onChanged: (value){
                                      setState(() {
                                        sex='F';
                                      });
                                    },

                                  )
                              ),
                              Expanded(
                                  flex:2,
                                  child:
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        sex='F';
                                      });
                                    },
                                    child: ClipRRect(
                                      child: Image.asset('images/female_user.jpeg'),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),

                      ],
                    )),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 0.0,
            child: MaterialButton(
              color: Theme.of(context).buttonColor,
              onPressed: () async {
                if(PIN.text==""|| PIN.text==null)
                  {
                    Fluttertoast.showToast(msg: "PIN Code cannot be empty");
                  }
                else
                if(full_name.text==""|| full_name.text==null)
                {
                  Fluttertoast.showToast(msg: "Name cannot be empty");
                }
                else
                if(store_name.text==""|| store_name.text==null)
                {
                  Fluttertoast.showToast(msg: "Store Name cannot be empty");
                }
                else
                if(store_address.text==""|| store_address.text==null)
                {
                  Fluttertoast.showToast(msg: "Store Address cannot be empty");
                }
                else
                if(GST.text==""|| GST.text==null)
                {
                  Fluttertoast.showToast(msg: "GST cannot be empty");
                }
                else
                if(_emailTextController.text==""|| _emailTextController.text==null)
                {
                  Fluttertoast.showToast(msg: "Name cannot be empty");
                }
                else
                if(clicked)
                {
                  clicked=false;
                  // await register(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        // backgroundColor: Colors.transparent,
                        content: Container(
                          height: MediaQuery.of(context).size.height/20,
                          width: MediaQuery.of(context).size.width/1.5,

                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),

                      );
                    },
                  );
                  uploadImageToFirebase(context);
                  // await createReward();

                }
              },
              minWidth: MediaQuery.of(context).size.width,
              child: Text(
                "Register",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void register(BuildContext context) async {
    if(localStorage.get('guest_id')!=null)
    {
      //ITS IS A GUEST ACCOUNT
      PartnerDetails.partner_id = localStorage.get('guest_id');
      localStorage.setString("partner_id", PartnerDetails.partner_id);
      localStorage.setString("guest_id", null);
      FirebaseDatabase.instance.reference().child("partners")
          .orderByChild("partner_id").equalTo(PartnerDetails.partner_id)
          .once().then((DataSnapshot snapshot) {
        try
        {
          Map<dynamic,dynamic> values = snapshot.value;
          values.forEach((key,values) {
            FirebaseDatabase.instance.reference().child("partners").child(key.toString()).update(
                {
                  "email":_emailTextController.text.toString(),
                  "sex":sex.toString(),
                  "firstname":full_name.text.toString(),
                  "lastname":store_name.text.toString(),
                  "language_id":"1",
                  "telephone":PartnerDetails.mobile.toString(),
                });

          });
        }
        catch(e)
        {
          List<dynamic> values = snapshot.value;
          for(int i=0;i<values.length;i++)
          {
            FirebaseDatabase.instance.reference().child("partners").child(i.toString()).update(
                {
                  "email":_emailTextController.text.toString(),
                  "sex":sex.toString(),
                  "firstname":full_name.text.toString(),
                  "lastname":store_name.text.toString(),
                  "language_id":"1",
                  "telephone":PartnerDetails.mobile.toString(),
                });
          }
        }

      });







      String str="Welcome and thank you for registering at shrifashion!\n\nYour account has now been created and you can log in by using your email address and password by visiting our website or at the following URL:<br><br> https://shrifashion.com/index.php?route=account/login <br><br> Upon logging in, you will be able to access other services including reviewing past orders, printing invoices and editing your account information.<br><br>Thanks,<br>shrifashion.";
      //sendEmail(_emailTextController.text, "shrifashion", "Hi", "Greetings", str);



    }
    else
    {
      try {
        PartnerDetails.name=full_name.text;
        PartnerDetails.store_name=store_name.text;
        PartnerDetails.store_address=store_address.text;
        PartnerDetails.email=_emailTextController.text.toString();

        // email=_emailTextController.text;
        partnersLast.once().then(
                (DataSnapshot datasnapshot){
              Map<dynamic,dynamic> values= datasnapshot.value;
              values.forEach((key,value){
                PartnerDetails.partner_id=key.toString();
                PartnerDetails.store_id="SHRI"+PartnerDetails.partner_id;
                PartnerDetails.image_name=fileName.toString();

                int newKey=int.parse(key.toString())+1;
                partners.child(newKey.toString()).set({
                  "partner_id":PartnerDetails.partner_id.toString(),
                  "image":fileName.toString(),
                  "store_id":PartnerDetails.store_id,
                  "date_added":DateTime.now().toIso8601String(),
                  "PIN":PIN.text.toString(),
                  "email":_emailTextController.text.toString(),
                  "sex":sex.toString(),
                  "name":full_name.text.toString(),
                  "store_address":store_address.text.toString(),
                  "store_name":store_name.text.toString(),
                  "GST":GST.text.toString(),
                  "status":"Pending",
                  "telephone":PartnerDetails.mobile.toString(),
                });
                localStorage.setString("partner_id", PartnerDetails.partner_id.toString());
              });
              String str="Welcome and thank you for registering at shrifashion!\n\nYour account has now been created and you can log in by using your email address and password by visiting our website or at the following URL:<br><br> https://shrifashion.com/index.php?route=account/login <br><br> Upon logging in, you will be able to access other services including reviewing past orders, printing invoices and editing your account information.<br><br>Thanks,<br>shrifashion.";
              //sendEmail(_emailTextController.text, "shrifashion", "Hi", "Greetings", str);
              //createCoupon();
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  HomePage()), (Route<dynamic> route) => false);
            }
        );
      } catch (e) {
        print(e.toString());
      }
    }
  }
  // Future<void> createCoupon()async {
  //   final coupon = FirebaseDatabase.instance.reference().child("coupons");
  //   final couponLast = FirebaseDatabase.instance.reference().child("coupons").limitToLast(1);
  //   final coupon_master = FirebaseDatabase.instance.reference().child("coupon_master");
  //   final coupon_master_last = FirebaseDatabase.instance.reference().child("coupon_master").limitToLast(1);
  //   String  shareCode="VEG-A0"+customerId.toString();
  //   coupon_master_last.once().then(
  //           (DataSnapshot datasnapshot){
  //         Map<dynamic,dynamic> values= datasnapshot.value;
  //         values.forEach((key,value){
  //           couponId = key.toString();
  //           int newKey=int.parse(key.toString())+1;
  //           coupon_master.child(newKey.toString()).set({
  //             "code":shareCode.toString().trim(),
  //             "coupon_id":couponId,
  //             "date_end":DateTime.parse("2050-01-01").toIso8601String(),
  //             "date_start":DateTime.now().toIso8601String(),
  //             "discount":"85",
  //             "name":"Referral Discount",
  //             "status":"False",
  //             "total":"0.0000",
  //             "type":"F",
  //             "uses_total":"1"
  //           });
  //         });
  //       }
  //   );
  //
  //   couponLast.once().then(
  //           (DataSnapshot datasnapshot){
  //         Map<dynamic,dynamic> values= datasnapshot.value;
  //         values.forEach((key,value){
  //           int newKey=int.parse(key.toString())+1;
  //           coupon.child(newKey.toString()).set({
  //             "category_id":"0",
  //             "code":shareCode.toString().trim(),
  //             "coupon_id":couponId,
  //             "date_end":DateTime.parse("2050-01-01").toIso8601String(),
  //             "date_start":DateTime.now().toIso8601String(),
  //             "discount":"85",
  //             "name":"Referral Discount",
  //             "product_id":"0",
  //             "status":"False",
  //             "total":"0.0000",
  //             "type":"F",
  //             "uses_total":"1"
  //           });
  //         });
  //       }
  //   );
  //
  //
  // }
  // Future<void> createReward(){
  //   final coupon = FirebaseDatabase.instance.reference().child("customer_rewards");
  //   final couponLast = FirebaseDatabase.instance.reference().child("customer_rewards").limitToLast(1);
  //   couponLast.once().then(
  //           (DataSnapshot datasnapshot){
  //         Map<dynamic,dynamic> values= datasnapshot.value;
  //         values.forEach((key,value){
  //           couponId = key.toString();
  //           int newKey=int.parse(key.toString())+1;
  //           coupon.child(newKey.toString()).set({
  //             "customer_id":customerId.toString(),
  //             "firstname":_fnameTextController.text.toString(),
  //             "lastname":_lnameTextController.text.toString(),
  //             "points":"0"
  //           });
  //         });
  //       }
  //   );
  // }

}
