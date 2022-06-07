import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path/path.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
class CustomPickMultipleImages extends StatefulWidget {
  @override
  _CustomPickMultipleImagesState createState() => _CustomPickMultipleImagesState();
}

class _CustomPickMultipleImagesState extends State<CustomPickMultipleImages> {
  List<Asset> imagesAssets = <Asset>[];
  List<File> imageFiles = <File>[];
  List<String> fillePath=<String>[];
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }
  Widget buildGridView() {
    // print("Path ="+images[0].name);
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(imagesAssets.length, (index) {
        Asset asset = imagesAssets[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
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

  Future uploadImage(File _imageFile) async {
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
        "Image Uploaded",
        toastLength: Toast
            .LENGTH_SHORT,
        gravity:
        ToastGravity
            .BOTTOM,
        timeInSecForIosWeb:
        1,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Pick multiple image'),
      ),
      body: Column(
        children: <Widget>[
          Center(child: Text('Error: $_error')),
          ElevatedButton(
            child: Text("Pick images"),
            onPressed: loadAssets,
          ),

          Expanded(
            child: buildGridView(),
          ),
          ElevatedButton(
            child: Text("Upload"),
            onPressed: (){
              //Convert asset to file
              imagesAssets.forEach((asset) async {
                File file=await getImageFileFromAssets(asset);
                imageFiles.add(file);
              });
              imageFiles.forEach((image) async {
                await uploadImage(image);
              });
              addProduct();
            },
          ),
        ],
      ),
    );
  }
  void addProduct()
  {
    //prod_image_id
    final search = FirebaseDatabase.instance.reference().child("prod_images");
    int product_id;
    search.limitToLast(1).once().then(
            (DataSnapshot datasnapshot){
          Map<dynamic,dynamic> values= datasnapshot.value;
          values.forEach((key,value){
            int newKey=int.parse(key.toString())+1;
            for(int i=0;i<fillePath.length;i++,newKey++)
              {

                product_id=100+newKey;
                search.child(newKey.toString()).set({
                  "prod_image_id":product_id.toString(),
                  "product_id":"5".toString(),
                  "image":fillePath[i],

                });

              }

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


        }
    );
  }
}