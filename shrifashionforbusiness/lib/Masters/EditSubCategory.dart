import 'dart:async';
import 'dart:io';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:path/path.dart';

import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/GetImageUrl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
enum Status { enabled, disabled }
Status status;
class EditSubCategory extends StatefulWidget {
  var category_id,name;
  EditSubCategory({this.category_id,this.name});
  @override
  _EditSubCategoryState createState() => _EditSubCategoryState();
}
class _EditSubCategoryState extends State<EditSubCategory> {
  TextEditingController name=TextEditingController();
bool hasUpdated=false;

  var connection;
  List lists=[];
  List imagelists=[];
  File _imageFile;
  final picker = ImagePicker();
  String fileName;
  @override
  void initState()
  {
    connection=subCategories.onValue;
  }
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null)
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,
        
        title: Text(widget.name,style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: ListView(
        children: [
          //IMAGE
          StreamBuilder(
            stream: connection,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                imagelists.clear();

                try{
                  List<dynamic> values  = snapshot.data.snapshot.value;
                  values.forEach((values) {
                    try{
                      if(values!=null && values['category_id']==widget.category_id && values['name']==widget.name )
                      {
                        print(values['name']);
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
                      if( values!=null && values['category_id']==widget.category_id  && values['name']==widget.name)
                      {
                        print(values['name']);
                        imagelists.add(values);
                      }
                    }
                    catch(e){
                    }
                  });
                }
                Widget image;
                if(imagelists.isNotEmpty)
                  {
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
                              icon: Icon(Icons.camera_alt,color: Theme.of(context).buttonColor,size: MediaQuery.of(context).size.width,
                              ),
                              onPressed: (){
                              },
                            );
                          }

                          return image;
                        }
                        return IconButton(
                          iconSize: MediaQuery.of(context).size.width,
                          icon: Icon(Icons.camera_alt,color: Theme.of(context).buttonColor,size: MediaQuery.of(context).size.width,
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
                    icon: Icon(Icons.camera_alt,color: Theme.of(context).buttonColor,size: MediaQuery.of(context).size.width,
                    ),
                    onPressed: (){
                    },
                  ),
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
                  icon: Icon(Icons.camera_alt,color: Theme.of(context).buttonColor,size: MediaQuery.of(context).size.width,
                  ),
                  onPressed: (){
                  },
                ),
              );
            },
          ),




          //DETAILS
          StreamBuilder(
            stream: connection,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                lists.clear();

                try{
                  List<dynamic> values  = snapshot.data.snapshot.value;
                  values.forEach((values) {
                    try{
                      if(values!=null && values['category_id']==widget.category_id  && values['name']==widget.name)
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
                      if( values!=null && values['category_id']==widget.category_id  && values['name']==widget.name)
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
                    var parent_name=lists[0]['parent_name'];
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
                              padding: const EdgeInsets.only(left: 8.0,right: 8,top:15,bottom: 15),
                              child: Container(
                                height:MediaQuery.of(context).size.height/13,
                                decoration: BoxDecoration(

                                    border: Border.all(

                                        width: 1.0),   // Set border width
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)), // Set rounded corner radius

                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Text("Main Category :",style: new TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 17
                                          ),),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(parent_name,style: new TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 17
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: name,
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




                            SubCategoryStatus(status: status,),




                          ],
                        );


                      },
                    );


                  }





              }
              return Center(child:CircularProgressIndicator());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(!hasUpdated)
          {
            hasUpdated=true;
            uploadImageToFirebase(context);
          }
          

        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
  Future uploadImageToFirebase(BuildContext context) async {
    if(name.text==null || name.text==""){
      hasUpdated=false;
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
      hasUpdated=false;
      updateSubCategory(context);
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
      updateSubCategory(context);

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

  void updateSubCategory(BuildContext context)
  {
    String categoryStatus=status==Status.enabled ?"True":"False";


    subCategories.once().then(
            (DataSnapshot datasnapshot) {

          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['category_id'].toString() == widget.category_id.toString() && values[i]['name']==widget.name) {
                  subCategories.child(i.toString()).update(
                      {
                        "name":name.text.toString(),
                        "status":categoryStatus.toString(),
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
                if (values['category_id'].toString() == widget.category_id.toString() && values['name']==widget.name) {
                  categories.child(key.toString()).update(
                      {
                        "name":name.text.toString(),
                        "status":categoryStatus.toString(),
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
              "Sub-Category updated",
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














class SubCategoryStatus extends StatefulWidget {
  Status status;
  SubCategoryStatus({this.status});
  @override
  _SubCategoryStatusState createState() => _SubCategoryStatusState();
}

class _SubCategoryStatusState extends State<SubCategoryStatus> {
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
                    color: Theme.of(context).buttonColor,
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
                    child: Text('Enable this sub-category?'),
                  ));

          },
          child: Row(
            children: [
              Radio(
                activeColor: Theme.of(context).buttonColor,
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
                    color: Theme.of(context).buttonColor,
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
                    child: Text('Disable this sub-category?'),
                  ));
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
    );
  }
}

