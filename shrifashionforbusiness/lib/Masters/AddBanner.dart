import 'dart:async';

import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
enum Status { enabled, disabled }
class AddBanner extends StatefulWidget {
  @override
  _AddBannerState createState() => _AddBannerState();
}
class _AddBannerState extends State<AddBanner> {
  TextEditingController title=TextEditingController();
  Status status=Status.enabled;
  String fileName;
  bool hasUploaded=false;

  File _imageFile;
  final picker = ImagePicker();
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null)
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
  Future uploadImageToFirebase(BuildContext context) async {

    if(title.text==null || title.text==""){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Name cannot be empty!",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }
    else if(_imageFile==null){
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
      fileName='banners/$fileName';
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print("Done: $value"),
      );
      addBanner(context);

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
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,
        
        title: Text('Add banner',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
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
              onPressed: pickImage,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: title,
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
                hintText: "Banner title",
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
          if(!hasUploaded)
            {
              hasUploaded=true;
              uploadImageToFirebase(context);
            }



        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
  void addBanner(context)
  {
    String imageName="name.jpeg";
    bannersLast.once().then(
            (DataSnapshot datasnapshot){
          Map<dynamic,dynamic> values= datasnapshot.value;
          values.forEach((key,value){
            int newKey=int.parse(key.toString())+1;
            int banner_id=newKey+1;
            banners.child(newKey.toString()).set({
              "banner_id":banner_id.toString(),
              "image":fileName.toString(),
              "title":title.text.toString(),
              "status":status==Status.enabled?"True":"False",


            });


          });
          Fluttertoast.showToast(
              msg:
              "New banner added",
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
