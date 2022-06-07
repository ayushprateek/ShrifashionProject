import 'dart:async';
import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path/path.dart';
TextEditingController category_id=TextEditingController();
enum Status { enabled, disabled }
List<String> unitList=[];
List categoryList=[];
String category;
List<String> categoryNameList=[];

List postalList=[];
String postal;
List<String> postalNameList=[];
class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}
class _AddProductState extends State<AddProduct> {
  TextEditingController name=TextEditingController();
  TextEditingController quantity=TextEditingController();

  TextEditingController description=TextEditingController();


  TextEditingController manufacturer=TextEditingController();
  TextEditingController model=TextEditingController();
  TextEditingController new_price=TextEditingController();
  TextEditingController old_price=TextEditingController();
  TextEditingController weight=TextEditingController();
  List<TextEditingController> storeQuantity=[];
  List<TextEditingController> storeLocation=[];
  List PinCode=[];
  List<bool> checked=[];
  var postalConnection;
  String fileName;
  bool hasUploaded=false;
  Status status=Status.enabled;
  String unit = 'g';
  List<Asset> imagesAssets = <Asset>[];
  List<File> imageFiles = <File>[];
  List<String> fillePath=<String>[];
  String _error = 'No Error Dectected';
  File _imageFile;
  final picker = ImagePicker();
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

    if(
    name.text==null || name.text==""
    ){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Name is mandatory!",
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
    if(

        description.text==null || description.text==""
    ){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Description is mandatory!",
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
    if(
        postal==null || postal==""
    ){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Location is mandatory!",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }
    else if(!_isNumeric(weight.text)){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Weight should be a number !",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }
    else if(!_isNumeric(new_price.text)){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "New price should be a number !",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }
    else if(old_price.text!=""&& old_price.text!=null&&!_isNumeric(old_price.text)){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Old price should be a number !",
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
    else if(status==Status.enabled){
      if(quantity.text==null || quantity.text=="")
        {
          hasUploaded=false;
          Fluttertoast.showToast(
              msg:
              "Please add the quantity",
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

        fileName='product/$fileName';
        StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        taskSnapshot.ref.getDownloadURL().then(
              (value) => print("Done: $value"),
        );
        addProduct(context);
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




  }

  //--------------- MILTIPLE IMAGES -------------------------
  Widget buildGridView() {
    if(imagesAssets.length==0)
      return Container(
        height: 0,
        width: 0,
      );
    // print("Path ="+images[0].name);
    return Container(
      height: 350,
      child: ListView.builder(
        physics: ScrollPhysics(),
      itemCount: imagesAssets.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context,index){
        Asset asset = imagesAssets[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      },
      ),
    );
  }
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: imagesAssets,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      imagesAssets = resultList;
      _error = error;
    });
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
    File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  Future uploadImage(BuildContext context) async {
    if(
    name.text==null || name.text==""
    ){

      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Name is mandatory!",
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
    if(

    description.text==null || description.text==""
    ){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Description is mandatory!",
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
    if(
    postal==null || postal==""
    ){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Location is mandatory!",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }
    else if(!_isNumeric(weight.text)){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Weight should be a number !",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }
    else if(!_isNumeric(new_price.text)){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "New price should be a number !",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }
    else if(old_price.text!=""&& old_price.text!=null&&!_isNumeric(old_price.text)){
      hasUploaded=false;
      Fluttertoast.showToast(
          msg:
          "Old price should be a number !",
          toastLength: Toast
              .LENGTH_SHORT,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          fontSize: 16.0);
    }
    else if(imagesAssets.length==0){
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
    else if(status==Status.enabled){
      if(quantity.text==null || quantity.text=="")
      {
        hasUploaded=false;
        Fluttertoast.showToast(
            msg:
            "Please add the quantity",
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
        for(int i=0;i<=imagesAssets.length;i++)
        {
          if(i==imagesAssets.length)
          {
            addProduct(context);
            return;
          }

          File _imageFile=await getImageFileFromAssets(imagesAssets[i]);
          // imageFiles.add(file);
          // File _imageFile=imageFiles[index];
          String fileName = basename(_imageFile.path);
          fileName='prod_images/$fileName';
          fillePath.add(fileName);
          StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
          StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          taskSnapshot.ref.getDownloadURL().then(
                (value) => print("Done: $value"),
          );

          Fluttertoast.showToast(
              msg:
              "Image ${i+1} Uploaded",
              toastLength: Toast
                  .LENGTH_SHORT,
              gravity:
              ToastGravity
                  .BOTTOM,
              timeInSecForIosWeb:
              1,
              fontSize: 16.0);
          // uploadImage(index+1);
        }
      }

    }


    // if(index==imageFiles.length)
    //   {
    //     //addProduct(context);
    //   }
    // else
    //   {
    //     // File _imageFile=imageFiles[index];
    //     // String fileName = basename(_imageFile.path);
    //     // fileName='prod_images/$fileName';
    //     // fillePath.add(fileName);
    //     // StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    //     // StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    //     // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    //     // taskSnapshot.ref.getDownloadURL().then(
    //     //       (value) => print("Done: $value"),
    //     // );
    //     //
    //     // Fluttertoast.showToast(
    //     //     msg:
    //     //     "Image Uploaded",
    //     //     toastLength: Toast
    //     //         .LENGTH_SHORT,
    //     //     gravity:
    //     //     ToastGravity
    //     //         .BOTTOM,
    //     //     timeInSecForIosWeb:
    //     //     1,
    //     //     fontSize: 16.0);
    //     // uploadImage(index+1);
    //   }
    // imageFiles.forEach((image) async {
    //   await uploadImage(image);
    // });

  }
  //--------------- MILTIPLE IMAGES -------------------------
  @override
  void initState() {
    super.initState();
    postalConnection=postalCodes.onValue;
    storeQuantity.clear();
    storeLocation.clear();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: backColor,
        title: Text('Add Product',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   decoration: new BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.rectangle,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black26,
            //         blurRadius: 10.0,
            //         offset: const Offset(5.0, 2.0),
            //       ),
            //     ],
            //   ),
            //   child: _imageFile != null
            //       ? Image.file(_imageFile,
            //     height: MediaQuery.of(context).size.width,
            //     width: MediaQuery.of(context).size.width,
            //   )
            //       : IconButton(
            //     iconSize: MediaQuery.of(context).size.width,
            //     icon: Icon(Icons.camera_alt,color: barColor,size: MediaQuery.of(context).size.width,
            //     ),
            //     onPressed: pickImage,
            //   ),
            // ),
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: IconButton(
                    icon: Icon(Icons.add_a_photo,
                      size: 50,
                      color: barColor,
                    ),
                    onPressed: loadAssets,
                  ),
                ),
                buildGridView(),
              ],
            ),
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
                  hintText: "Product Name",
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
            //CATEGORY
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text('Category :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      child: DropdownButton<String>(
                        value: category,
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        elevation: 16,
                        onChanged: (String newValue) {
                          setState(() {
                            category = newValue;
                            for(int i=0;i<categoryList.length;i++)
                              {
                                if(categoryList[i]['name']==newValue)
                                  {
                                    category_id.text=categoryList[i]['category_id'];
                                  }
                              }
                          });
                        },
                        items: categoryNameList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            //QUANTITY
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: quantity,
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
                  hintText: "Quantity",
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

            //DESCRIOPTION
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: description,
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




            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Container(
            //           child: Text('Location :',
            //             style: TextStyle(fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //
            //       ),
            //       Expanded(
            //         child: DropdownButton<String>(
            //           value: postal,
            //           icon: Icon(Icons.arrow_drop_down_sharp,),
            //           elevation: 16,
            //           onChanged: (String newValue) {
            //             setState(() {
            //               postal = newValue;
            //             });
            //           },
            //           items: postalNameList
            //               .map<DropdownMenuItem<String>>((String value) {
            //             return DropdownMenuItem<String>(
            //               value: value,
            //               child: Text(value),
            //             );
            //           }).toList(),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            //MANUFACTURER
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     controller: manufacturer,
            //     decoration: new InputDecoration(
            //       filled: true,
            //
            //       prefixIcon: Icon(
            //         Icons.person,
            //         color: barColor,
            //       ),
            //       fillColor: Colors.white,
            //       hoverColor: Colors.red,
            //       focusedBorder: new OutlineInputBorder(
            //         borderRadius: new BorderRadius.circular(10.0),
            //         borderSide:
            //         new BorderSide(color: barColor,),
            //       ),
            //       hintText: "Manufacturer",
            //       border: new OutlineInputBorder(
            //         borderRadius: new BorderRadius.circular(10.0),
            //         borderSide: new BorderSide(),
            //       ),
            //     ),
            //     //keyboardType: TextInputType.number,
            //     style: new TextStyle(
            //       fontFamily: "Poppins",
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: model,
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
                  hintText: "Model",
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
                controller: new_price,
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
                  hintText: "New price",
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
                controller: old_price,
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
                  hintText: "Old price",
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
                controller: weight,
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
                  hintText: "Weight",
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
                      child: Text('Unit :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: unit,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      //iconSize: 24,
                      elevation: 16,
                      onChanged: (String newValue) {
                        setState(() {
                          unit = newValue;
                        });
                      },
                      items: unitList
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
            InkWell(
              onTap: (){
                setState(() {
                  status=Status.enabled;
                });
              },
              child: Row(
                children: [
                  Radio(
                    activeColor: barColor,
                    value: Status.enabled,
                    groupValue: status,
                    onChanged: (value){
                    },

                  ),
                  Text('In Stock')
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
                    activeColor: barColor,
                    value: Status.disabled,
                    groupValue: status ,
                    onChanged: (value){
                    },
                  ),
                  Text('Out of stock')
                ],
              ),
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
              // uploadImageToFirebase(context);
              // imagesAssets.forEach((asset) async {
              //   File file=await getImageFileFromAssets(asset);
              //   imageFiles.add(file);
              // });
              // imageFiles.forEach((image) async {
              //   await uploadImage(image);
              // });

               uploadImage(context);

            }




        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
  void addProductImages(var product_id)
  {
    //prod_image_id
    final search = FirebaseDatabase.instance.reference().child("prod_images");
    int prod_image_id;
    search.limitToLast(1).once().then(
            (DataSnapshot datasnapshot){
          Map<dynamic,dynamic> values= datasnapshot.value;
          values.forEach((key,value){
            int newKey=int.parse(key.toString())+1;
            for(int i=0;i<fillePath.length;i++,newKey++)
            {

              prod_image_id=100+newKey;
              search.child(newKey.toString()).set({
                "prod_image_id":prod_image_id.toString(),
                "product_id":product_id.toString(),
                "image":fillePath[i],

              });

            }
          });
          // Fluttertoast.showToast(
          //     msg:
          //     "New product created",
          //     toastLength: Toast
          //         .LENGTH_SHORT,
          //     gravity:
          //     ToastGravity
          //         .BOTTOM,
          //     timeInSecForIosWeb:
          //     1,
          //     fontSize: 16.0);

        }
    );
  }
  void addProduct(context)
  {
    int product_id;
    String product_status= status==Status.enabled?"In Stock":"Out of Stock";
    String product_status_id= status==Status.enabled?"7":"6";
    searchLast.once().then(
            (DataSnapshot datasnapshot){
          Map<dynamic,dynamic> values= datasnapshot.value;
          values.forEach((key,value){
            int newKey=int.parse(key.toString())+1;
             product_id=100+newKey;
            search.child(newKey.toString()).set({
              "store_id":"1".toString(),
              "store_name":"Shrifashion".toString(),
              "product_id":product_id.toString(),
              "name":name.text.toString(),
              "quantity":quantity.text,
              "parent_id":category_id.text,
              "description":description.text.toString(),
              "model":model.text.toString(),
              "new_price":new_price.text,
              "old_price":old_price.text,
              "unit":unit.toString(),
              "weight":weight.text.toString(),
              "image":fillePath[0].toString(),
              "stock_status":product_status,
              "stock_status_id":product_status_id,
            });
          });
          addProductImages(product_id);
          manage_stock_last.once().then(
                  (DataSnapshot datasnapshot){
                Map<dynamic,dynamic> values= datasnapshot.value;
                values.forEach((key,value){
                  int newKey=int.parse(key.toString())+1;
                  manage_stock.child(newKey.toString()).set({
                    "product_id":product_id.toString(),
                    "store_id":"1".toString(),
                    "store_name":"Shrifashion".toString(),
                    "product_name":name.text.toString(),
                    "quantity":quantity.text,
                    "stock_status":product_status,
                    "stock_status_id":product_status_id,
                  });
                });

                Fluttertoast.showToast(
                    msg:
                    "New product created",
                    toastLength: Toast
                        .LENGTH_SHORT,
                    gravity:
                    ToastGravity
                        .BOTTOM,
                    timeInSecForIosWeb:
                    1,
                    fontSize: 16.0);
                Navigator.pop(context);
                Timer(
                    Duration(seconds: 1,),
                        (){

                      Navigator.pop(context);
                    });
              }
          );

        }
    );
  }
}
