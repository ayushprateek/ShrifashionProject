import 'dart:async';

import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Components/DataBaseConnections.dart';
import 'package:shrifashionadmin/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }
class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController firstName=TextEditingController();
  TextEditingController lastName=TextEditingController();
  TextEditingController username=TextEditingController();
  TextEditingController password=TextEditingController();
  Status status=Status.enabled;
  bool added=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: backColor,
        title: Text('Add a user',style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: firstName,
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
                hintText: "First Name",
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
              controller: lastName,
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
                hintText: "Last name",
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
              controller: username,
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
                hintText: "Username",
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
              controller: password,
              obscureText: true,
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
                hintText: "Password",
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(),
                ),
              ),
              //keyboardType: TextInputType.visiblePassword,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
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
                  groupValue: status ,
                  onChanged: (value){

                  },

                ),
                Text('Enable')
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
                Text('Disable')
              ],
            ),
          ),



        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(!added)
            {
              added=true;
              addUser();
            }


        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
  void addUser()
  {

    usersLast.once().then(
            (DataSnapshot datasnapshot){

          try{
            Map<dynamic,dynamic> values= datasnapshot.value;
            values.forEach((key,value){
              int newKey=int.parse(key.toString())+1;
              int user_id=newKey+1;
              users.child(newKey.toString()).set({
                "user_id":user_id.toString(),
                "first_name":firstName.text.toString(),
                "last_name":lastName.text.toString(),
                "username":username.text.toString(),
                "password":password.text.toString(),
                "status":status==Status.enabled?"True":"False",
              });


            });
          }
          catch(e)
          {
            List<dynamic> values= datasnapshot.value;
            int key=0;
            for(int i=0;i<values.length;i++)
            {
              key++;
            }
            int user_id=key+1;
            users.child(key.toString()).set({
              "user_id":user_id.toString(),
              "first_name":firstName.text.toString(),
              "last_name":lastName.text.toString(),
              "username":username.text.toString(),
              "password":password.text.toString(),
              "status":status==Status.enabled?"True":"False",
            });
          }

          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
              "New user added",
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
    // usersLast.once().then(
    //         (DataSnapshot datasnapshot){
    //       Map<dynamic,dynamic> values= datasnapshot.value;
    //       values.forEach((key,value){
    //         int newKey=int.parse(key.toString())+1;
    //         users.child(newKey.toString()).set({
    //           "user_id":newKey.toString(),
    //           "first_name":firstName.text.toString(),
    //           "last_name":lastName.text.toString(),
    //           "username":username.text.toString(),
    //           "password":password.text.toString(),
    //           "status":status==Status.enabled?"True":"False",
    //
    //
    //         });
    //
    //
    //       });
    //       Navigator.pop(context);
    //       Fluttertoast.showToast(
    //           msg:
    //           "New category created",
    //           toastLength: Toast
    //               .LENGTH_SHORT,
    //           gravity:
    //           ToastGravity
    //               .BOTTOM,
    //           timeInSecForIosWeb:
    //           1,
    //           fontSize: 16.0);
    //
    //
    //     }
    // );
  }
}
