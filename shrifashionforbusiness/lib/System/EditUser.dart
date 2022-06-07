import 'dart:async';

import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/DataBaseConnections.dart';
import 'package:shrifashionforbusiness/Components/StickyFooter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
enum Status { enabled, disabled }
Status status;
TextEditingController password=TextEditingController();

class EditUser extends StatefulWidget {
  var user_id,name;
  EditUser({this.user_id,this.name});
  @override
  _EditUserState createState() => _EditUserState();
}
class _EditUserState extends State<EditUser> {
  TextEditingController firstName=TextEditingController();
  TextEditingController lastName=TextEditingController();
  TextEditingController username=TextEditingController();
  bool added=true;



  var connection;
  List lists=[];
  @override
  void initState()
  {
    connection=users.onValue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,
        
        title: Text(widget.name,style: TextStyle(color: Colors.black,fontFamily: custom_font),),
      ),
      body: StreamBuilder(
        stream: connection,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            lists.clear();

            try{
              List<dynamic> values  = snapshot.data.snapshot.value;
              values.forEach((values) {
                try{
                  if(values!=null && values['user_id']==widget.user_id)
                  {
                    lists.add(values);
                  }
                }
                catch(e){
                }
              });
            }catch(e){

              Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
              values.forEach((key,values) {
                try{
                  if( values!=null && values['user_id']==widget.user_id )
                  {
                    lists.add(values);
                  }
                }
                catch(e){
                }
              });
            }

            status=lists[0]['status']=="True"?Status.enabled:Status.disabled;
            firstName.text=lists[0]['first_name'];
            lastName.text=lists[0]['last_name'];
            username.text=lists[0]['username'];
            password.text=lists[0]['password'];




            return ListView.builder(
              physics: ScrollPhysics(),
              itemCount: lists.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index) {
                var data = snapshot.data;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: firstName,
                        decoration: new InputDecoration(
                          filled: true,

                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).buttonColor,
                          ),
                          fillColor: Colors.white,
                          hoverColor: Colors.red,
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide:
                            new BorderSide(color: Theme.of(context).buttonColor,),
                          ),
                          hintText: "First name",
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
                            color: Theme.of(context).buttonColor,
                          ),
                          fillColor: Colors.white,
                          hoverColor: Colors.red,
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide:
                            new BorderSide(color: Theme.of(context).buttonColor,),
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
                            color: Theme.of(context).buttonColor,
                          ),
                          fillColor: Colors.white,
                          hoverColor: Colors.red,
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide:
                            new BorderSide(color: Theme.of(context).buttonColor,),
                          ),
                          hintText: "User name",
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
                    Password(),
                    UserStatus(status: status,),


                  ],
                );


              },
            );
          }
          return Center(child:CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(!added)
            {
              added=true;
              updateUser();
            }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }

  void updateUser()
  {
    String userStatus=status==Status.enabled ?"True":"False";

    users.once().then(
            (DataSnapshot datasnapshot) {

          try{
            List<dynamic> values = datasnapshot.value;
            for (int i = 0; i < values.length; i++) {
              try{
                if (values[i]['user_id'].toString() == widget.user_id.toString()) {
                  users.child(i.toString()).update(
                      {
                        "first_name":firstName.text.toString(),
                        "last_name":lastName.text.toString(),
                        "username":username.text.toString(),
                        "password":password.text.toString(),
                        "status":userStatus.toString(),
                      });
                }
              }
              catch(e) {
                print(e.toString());
              }

            }
          }
          catch(e)
          {
            Map<dynamic,dynamic> values = datasnapshot.value;
            values.forEach((key, value) {
              try{
                if (values['user_id'].toString() == widget.user_id.toString()) {
                  users.child(key.toString()).update(
                      {
                        "first_name":firstName.text.toString(),
                        "last_name":lastName.text.toString(),
                        "username":username.text.toString(),
                        "password":password.text.toString(),
                        "status":userStatus.toString(),
                      });
                }
              }
              catch(e) {
                print(e.toString());
              }
            });

          }

          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
              "User updated",
              toastLength: Toast
                  .LENGTH_SHORT,
              gravity:
              ToastGravity
                  .BOTTOM,
              timeInSecForIosWeb:
              1,
              fontSize: 16.0);
        });


  }

}
class UserStatus extends StatefulWidget {
  Status status;
  UserStatus({this.status});
  @override
  _UserStatusState createState() => _UserStatusState();
}

class _UserStatusState extends State<UserStatus> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            setState(() {
              status=Status.enabled;
            });
          },
          child: Row(
            children: [
              Radio(
                activeColor: Theme.of(context).buttonColor,
                value: Status.enabled,
                groupValue: status ,
                onChanged: (value){
                  setState(() {
                    status=Status.disabled;
                  });
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
                activeColor: Theme.of(context).buttonColor,
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
    );
  }
}


class Password extends StatefulWidget {

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {

  bool isVisible=false;
  @override
  Widget build(BuildContext context) {
    if(isVisible)
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: password,
        decoration: new InputDecoration(
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              FlutterIcons.eye_with_line_ent,
              color: Theme.of(context).buttonColor,
            ),
            onPressed: (){
              setState(() {
                isVisible=false;
              });
            },
          ),

          prefixIcon: Icon(
            Icons.person,
            color: Theme.of(context).buttonColor,
          ),
          fillColor: Colors.white,
          hoverColor: Colors.red,
          focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
            borderSide:
            new BorderSide(color: Theme.of(context).buttonColor,),
          ),
          hintText: "Password",
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
    );
    else
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: password,
          obscureText: true,
          decoration: new InputDecoration(
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: Theme.of(context).buttonColor,
              ),
              onPressed: (){
                setState(() {
                  isVisible=true;
                });
              },
            ),

            prefixIcon: Icon(
              Icons.person,
              color: Theme.of(context).buttonColor,
            ),
            fillColor: Colors.white,
            hoverColor: Colors.red,
            focusedBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide:
              new BorderSide(color: Theme.of(context).buttonColor,),
            ),
            hintText: "Password",
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
      );
  }
}




