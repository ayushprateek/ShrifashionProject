import 'package:shrifashion/categories/SecondScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
List Banners_DISCOUNT=[];


List ShopByCategory=[];

class categoryData
{


  List lists=[];
  final banners = FirebaseDatabase.instance.reference().child("category");
  void readCategoryData() {
    ShopByCategory.clear();

    banners.once().then((DataSnapshot snapshot) {


      List<dynamic> values = snapshot.value;
      lists.clear();

      values.forEach((values) {
        if(values['status']=="True")
        lists.add(values);
      });


      for (int i = 0; i < lists.length; i++) {
        String name = lists[i]["name"];
        String image = lists[i]["image"]; //IMAGE NAME
        String categoryID = lists[i]["category_id"];

        try {
          if (image != null)
            ImageUrl( image,name,categoryID);

        } catch (e) {}
      }
    });
  }

  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;

  var imagepath_;

  Future<dynamic> ImageUrl( String image,String name,String categoryId) async {
    var url;
    try {
      url = await FirebaseStorage.instance.ref().child(image).getDownloadURL();
    } catch (e) {}



    imagepath_ = url;

    try {
      if (imagepath_!=null){
          ShopByCategory .add(
              catData(
                name: name,
                image: imagepath_,
                categoryId: categoryId
              )
          );
      }



    } catch (e) {}

    return url;
  }
}

class catData{

  String name;
  String image;
  String categoryId;

  catData( {
    this.name,
    this.image,
    this.categoryId

});
}











