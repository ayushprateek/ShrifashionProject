import 'dart:convert';
import 'package:shrifashion/CartIcon.dart';
import 'package:shrifashion/Service/CartInsert.dart';

import 'package:shrifashion/StickyFooter.dart';
import 'package:shrifashion/components/Color.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shrifashion/components/Font.dart';

import '../BottomSheet.dart';
import '../SearchItemsQuantity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
String query1;

class SearchedItems extends StatefulWidget {
  SearchedItems(String query) {
    query1 = query;
  }
  @override
  _SearchedItemsState createState() => _SearchedItemsState();
}
class _SearchedItemsState extends State<SearchedItems> {
  final products = FirebaseDatabase.instance.reference().child("search");
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  List searchedList=[];
  var cartId,productId,quantity;

  final key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StickyFooter(),
      key: key,
      appBar: AppBar(
        leading:  IconButton(
            icon: new Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            }),
        actions: <Widget>[
          CartCount()
        ],
        title: Text(query1,style: TextStyle(fontFamily: custom_font,color: Colors.black),),

      ),
      body: SearchItemsQuantity(query1),
    );
  }
}


