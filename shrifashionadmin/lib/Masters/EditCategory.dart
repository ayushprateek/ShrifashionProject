import 'dart:async';

import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:shrifashionadmin/Components/GetImageUrl.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
enum Status { enabled, disabled }
Status status;
class EditCategory extends StatefulWidget {
  var category_id,name;
  EditCategory({this.category_id,this.name});
  @override
  _EditCategoryState createState() => _EditCategoryState();
}
class _EditCategoryState extends State<EditCategory> {
  TextEditingController name=TextEditingController();
  File _imageFile;
  final picker = ImagePicker();
  String fileName;
  bool hasUploaded=false;
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null)
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }
  Future uploadImageToFirebase(BuildContext context) async {

    if(name.text==null || name.text==""){
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
      updateCategory(context);
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
      updateCategory(context);

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


  var connection;
  List lists=[];
  List imagelists=[];
  @override
  void initState()
  {
    connection=categories.onValue;
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
      body: ListView(
        children: [
          StreamBuilder(
            stream: connection,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                imagelists.clear();

                try{
                  List<dynamic> values  = snapshot.data.snapshot.value;
                  values.forEach((values) {
                    try{
                      if(values!=null && values['category_id']==widget.category_id)
                      {
                        imagelists.add(values);
                      }
                    }
                    catch(e){
                    }
                  });
                }catch(e){

                  Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
                  values.forEach((key,values) {
                    try{
                      if( values!=null && values['category_id']==widget.category_id )
                      {
                        imagelists.add(values);
                      }
                    }
                    catch(e){
                    }
                  });
                }
                if(_imageFile==null)
                  fileName=imagelists[0]["image"];
                Widget image;
                image=FutureBuilder(
                  future: imageurl(context, imagelists[0]["image"],FirebaseStorage.instance),
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
                                width: MediaQuery.of(context).size.width ,
                                height: MediaQuery.of(context).size.width
                            ));
                      }
                      catch(e){
                        image=IconButton(
                          iconSize: MediaQuery.of(context).size.width,
                          icon: Icon(Icons.camera_alt,color: barColor,size: MediaQuery.of(context).size.width,
                          ),
                          onPressed: (){
                          },
                        );
                      }

                      return image;
                    }
                    return IconButton(
                      iconSize: MediaQuery.of(context).size.width,
                      icon: Icon(Icons.camera_alt,color: barColor,size: MediaQuery.of(context).size.width,
                      ),
                      onPressed: (){
                      },
                    );
                  },

                );
                image=imagelists[0]['status']=="True"?image:Center(
                  child: Stack(
                    children: [
                      //lists[index].image
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width ,
                        foregroundDecoration: BoxDecoration(
                          color: Colors.grey,
                          backgroundBlendMode: BlendMode.saturation,
                        ),
                        child: image,
                      ),
                      Positioned(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width/4,
                            color:Colors.red,
                            child: Center(
                              child: Text(
                                "Category disabled",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),),
                            ),),
                        bottom: 0,
                      )

                    ],
                  ),
                );

                return Column(
                  children: [
                    _imageFile != null
                        ? Image.file(_imageFile,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/3,
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
                      child: Stack(
                        children: [
                          image,
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
                                icon: Icon(Icons.camera_alt,color: barColor,size: 35,
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
              return Container(
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
                  icon: Icon(Icons.camera_alt,color: barColor,size: MediaQuery.of(context).size.width,
                  ),
                  onPressed: (){
                  },
                ),
              );
            },
          ),

          StreamBuilder(
            stream: connection,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                lists.clear();

                try{
                  List<dynamic> values  = snapshot.data.snapshot.value;
                  values.forEach((values) {
                    try{
                      if(values!=null && values['category_id']==widget.category_id)
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
                      if( values!=null && values['category_id']==widget.category_id )
                      {
                        lists.add(values);
                      }
                    }
                    catch(e){
                    }
                  });
                }
                name.text=lists[0]['name'];
                 status=lists[0]['status']=="True"?Status.enabled:Status.disabled;




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


                        CategoryStatus(status: status,),




                      ],
                    );


                  },
                );
              }
              return Center(child:CircularProgressIndicator());
            },
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
  void updateCategory(context)
  {
    String categoryStatus=status==Status.enabled ?"True":"False";


    categories.once().then(
            (DataSnapshot datasnapshot) {
          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['category_id'].toString() == widget.category_id.toString()) {
                  categories.child(i.toString()).update(
                      {
                        "name":name.text.toString(),
                        "status":categoryStatus.toString(),
                        "image":fileName.toString()
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
                if (values['category_id'].toString() == widget.category_id.toString()) {
                  categories.child(key.toString()).update(
                      {
                        "name":name.text.toString(),
                        "status":categoryStatus.toString(),
                        "image":fileName.toString()
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
              "Category updated",
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

}














class CategoryStatus extends StatefulWidget {
  Status status;
  CategoryStatus({this.status});
  @override
  _CategoryStatusState createState() => _CategoryStatusState();
}

class _CategoryStatusState extends State<CategoryStatus> {
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
                    child: Text('Enable this category?'),
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
                    child: Text('Disable this category?'),
                  ));
            // setState(() {
            //
            //   status=Status.disabled;
            // });
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

