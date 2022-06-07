import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UpdateProd extends StatefulWidget {
  @override
  _UpdateProdState createState() => _UpdateProdState();
}

class _UpdateProdState extends State<UpdateProd> {
  final products = FirebaseDatabase.instance.reference().child("search");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: RaisedButton(
                child: Text("Delete"),
                onPressed: (){
                  //70,64,72,68,71
                  products.once().then(
                          (DataSnapshot datasnapshot) {
                        List<dynamic> values = datasnapshot.value;
                        for (int i = 0; i < values.length; i++) {
                          try{
                            if (values[i]['category_id'] =="68") {
                              products.child(i.toString()).update({
                                "parent_id":"59"
                              });
                            }
                          }
                          catch(e)
                          {
                            print(e.toString());
                          }

                        }
                        print("Done");
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
