import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class RequestDataUsingAPI extends StatefulWidget {
  @override
  _RequestDataUsingAPIState createState() => _RequestDataUsingAPIState();
}
class _RequestDataUsingAPIState extends State<RequestDataUsingAPI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Data Using REST API"),
      ),
      body: Center(
        child: Row(
          children: [
            RaisedButton(
              onPressed: (){
                getData();
              },
              child: Text("Get Data"),
            ),
            RaisedButton(
              onPressed: (){
                putData();
              },
              child: Text("Put Data"),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> getData()async{
    var res=await http.get("https://shrifashion-ca414-default-rtdb.firebaseio.com/test.json");
    print(res.body);
  }
  Future<void> putData()async{
    int id=3;
    var res=await http.patch("https://shrifashion-ca414-default-rtdb.firebaseio.com/test/$id.json",
      body: json.encode({
        "title": "tests",
        "description": "newProduct.description",
        "imageUrl": "newProduct.imageUrl",
        "price": "newProduct.price",
      })
    );
    print(res.body);
  }
}
