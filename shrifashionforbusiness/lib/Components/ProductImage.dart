import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/GetImageUrl.dart';
import 'package:path/path.dart';
class ProductImage extends StatefulWidget {
  String prod_image_id,name;
  ProductImage(String prod_image_id,String name)
  {
    this.prod_image_id=prod_image_id;
    this.name=name;
  }
  @override
  _ProductImageState createState() => _ProductImageState();
}
class _ProductImageState extends State<ProductImage> {
  List lists=[];
  final banners = FirebaseDatabase.instance.reference().child("prod_images");
  File _imageFile;
  String fileName;
  bool hasUploaded=false;
  final picker = ImagePicker();
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null)
      setState(() {
        _imageFile = File(pickedFile.path);
      });
  }
  Future uploadImageToFirebase(BuildContext context) async {

     if(_imageFile==null){
      hasUploaded=false;
      update(context);
    }
    else
    {
      fileName = basename(_imageFile.path);
      print("fileName");
      print(_imageFile.path);
      print(fileName);
      fileName='product/$fileName';
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print("Done: $value"),
      );
      update(context);

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
  void update(context)
  {
    final search = FirebaseDatabase.instance.reference().child("prod_images");
    search.once().then(
            (DataSnapshot datasnapshot) {
          List<dynamic> values = datasnapshot.value;
          for (int i = 0; i < values.length; i++) {
            try{
              if (values[i]['prod_image_id'].toString() == widget.prod_image_id.toString()) {
                search.child(i.toString()).update(
                    {

                      "image":fileName.toString(),

                    });
              }
            }
            catch(e) {
              print(e.toString());
            }

          }
          Fluttertoast.showToast(
              msg:
              "Image updated",
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
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,

        title: Text(widget.name,style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // IMAGE

            StreamBuilder(
              stream: banners.orderByChild("prod_image_id").equalTo(widget.prod_image_id).onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  lists.clear();

                  try{
                    List<dynamic> values  = snapshot.data.snapshot.value;
                    if(values!=null)
                      values.forEach((values) {
                        try{
                          if(values!=null)
                            lists.add(values);
                        }
                        catch(e){
                        }
                      });
                  }catch(e){

                    Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
                    if(values!=null)
                      values.forEach((key,values) {
                        try{
                          if(values!=null)
                            lists.add(values);
                        }
                        catch(e){
                        }
                      });
                  }
                  if(lists.isNotEmpty)
                  {
                    if(_imageFile==null)
                      fileName=lists[0]["image"];
                    Widget image;
                    image=FutureBuilder(
                      future: imageurl(context, lists[0]["image"],FirebaseStorage.instance),
                      builder: (context,snap){
                        if(snap.hasData)
                        {
                          Widget image;
                          try{
                            image=ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                    snap.data.image,
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width / 3,
                                    height: MediaQuery.of(context).size.width / 3
                                ));
                          }
                          catch(e){
                            image=ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    height: MediaQuery.of(context).size.width / 3
                                )
                            );
                          }

                          return image;
                        }
                        return Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3
                        );
                      },

                    );

                    return Column(
                      children: [
                        _imageFile != null
                            ? Image.file(_imageFile,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/3,
                        )
                            : Container(
                          decoration: new BoxDecoration(color: Colors.white),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: image,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height/3,

                              ),
                              Positioned(
                                top: 15, right: 15, //give the values according to your requirement
                                child: Container(
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
                                    icon: Icon(Icons.camera_alt,color: Theme.of(context).buttonColor,size: 35,
                                    ),
                                    onPressed:pickImage,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  else
                  {
                    return Column(
                      children: [
                        Container(
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
                            //onPressed: pickImage,
                          ),
                        ),
                      ],
                    );
                  }

                }
                return Center(child:CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()   {

          if(!hasUploaded)
          {
            /*
              * 1. convert
              * 2. upload images to storage
              * 3. add product and get product id
              * 4. add images to database
              * */
            hasUploaded=true;
            if(_imageFile==null)
              Navigator.pop(context);
            else
              uploadImageToFirebase(context);

            // uploadImageToFirebase(context);
            // imagesAssets.forEach((asset) async {
            //   File file=await getImageFileFromAssets(asset);
            //   imageFiles.add(file);
            // });
            // imageFiles.forEach((image) async {
            //   await uploadImage(image);
            // });

           // uploadImage(context);

          }




        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
}
