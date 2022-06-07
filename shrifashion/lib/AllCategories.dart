import 'package:shrifashion/AllTab/EssentalFoodItems.dart';

import 'package:shrifashion/AllTab/Essentials.dart';

import 'package:shrifashion/categories/HomeBanner1.dart';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:firebase_database/firebase_database.dart';


class AllTab extends StatefulWidget {
  @override
  _AllTabState createState() => _AllTabState();
}
class _AllTabState extends State<AllTab> {
  final category = FirebaseDatabase.instance.reference().child("category");
  final subCategory = FirebaseDatabase.instance.reference().child("categorysub_final");
  var future_subCategory;
  List lists=[];
  List lists2=[];
  List lists3=[];
  @override
  void initState() {
    super.initState();
    future_subCategory=subCategory.onValue;
  }
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: HomeBanner("HOME BANNER 1"),
            ),
             EssentialFoodItems(),
            Essentials("100","Home Care"),
            Essentials("101","Personal Care"),
            Essentials("102","Essential Packed Food"),
            Essentials("103","Other Food Items"),
          ],
        ),
      ),
    );
  }
}
class Url
{
  var image;
  Url({
    this.image
  });
}
Future<Url> imageurl(BuildContext context, var image,var instance) async {
  var url;
  try {
    url = await instance.ref().child(image).getDownloadURL();
    //url_ =  await url  .getDownloadURL();
  } catch (e) {
  }
  return Url(image: url);
}