import 'package:flutter/material.dart';
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


  } catch (e) {


  }

  return Url(image: url);
}