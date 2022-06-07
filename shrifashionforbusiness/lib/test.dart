import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path/path.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
class CustomPickMultipleImages extends StatefulWidget {
  @override
  _CustomPickMultipleImagesState createState() => _CustomPickMultipleImagesState();
}

class _CustomPickMultipleImagesState extends State<CustomPickMultipleImages> {


  @override
  void initState() {
    super.initState();
  }
  void shareImage(String imageUrl) async {
    final response = await get(imageUrl);
    final bytes = response.bodyBytes;
    final Directory temp = await getTemporaryDirectory();
    final File imageFile = File('${temp.path}/tempImage.png');
    imageFile.writeAsBytesSync(response.bodyBytes);
    FlutterShare.shareFile(title: "Test",filePath: '${temp.path}/tempImage.png', text: 'Test Description',);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Pick multiple image'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Share"),
          onPressed: (){
            //shareImage("https://shuchibusiness.in/assets/images/img-05.jpg");
            shareImage("https://shrisolutions.com/uploads/about_01.jpg");
          },
        ),
      ),
    );
  }

}