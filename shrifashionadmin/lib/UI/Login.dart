import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/UI/HomePage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
TextEditingController password = TextEditingController();
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final key = GlobalKey<ScaffoldState>();
  TextEditingController username = TextEditingController();


  @override
  Widget build(BuildContext context) {
    print("In login");
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:barColor,
        title: Text("Login to continue"),
      ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:120.0,bottom: 50),
                child: Center(
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,

                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20.0,
                          offset: const Offset(5.0, 2.0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        'images/launcher.jpeg',
                        height: MediaQuery.of(context).size.height/6,
                        width: MediaQuery.of(context).size.height/6,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //---------FirstName-----------------
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,

                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10.0,
                                      offset: const Offset(5.0, 2.0),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: username,
                                  decoration: new InputDecoration(
                                    filled: true,

                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: barColor,
                                    ),
                                    //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                                    fillColor: Colors.white,
                                    hoverColor: Colors.red,
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(10.0),
                                      borderSide:
                                      new BorderSide(color: barColor,),
                                    ),
                                    //focusColor:HexColor("#27ab87"),
                                    // isDense: true,
                                    hintText: "Username",
                                    // fillColor: Colors.red,

                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(10.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  //keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                            ),
                            Password()
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),

        ),
    bottomNavigationBar: Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 50),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: barColor,
          elevation: 0.0,
          child: MaterialButton(
            onPressed: () async {
              final PINS = FirebaseDatabase.instance.reference().child("admin");
              PINS.once().then((DataSnapshot snapshot) {

                try
                {
                  Map<dynamic,dynamic> values = snapshot.value;
                  if(values!=null)
                 {
                   if(values[0]['username'].toString().toUpperCase()==username.text.toUpperCase().toString().trim()
                   && values[0]['password'].toString()==password.text)
                     {
                       Navigator.pushReplacement(context,
                           new MaterialPageRoute(builder: (context) => new HomePage()));
                     }
                   else
                     {
                       key.currentState
                           .showSnackBar(
                           SnackBar(
                             content:
                             Text('Access Denied'),
                             backgroundColor:
                             Colors.red,
                             duration: Duration(
                                 seconds:
                                 1,
                                 milliseconds:
                                 500),
                           ));
                     }
                 }
                }
                catch(e)
                {
                  List<dynamic> values = snapshot.value;
                  if(values!=null)
                  {
                    if(values[0]['username'].toString().toUpperCase().trim()==username.text.toUpperCase().toString().trim()
                        && values[0]['password'].toString()==password.text)
                    {
                      Navigator.pushReplacement(context,
                          new MaterialPageRoute(builder: (context) => new HomePage()));
                    }
                    else
                    {
                      key.currentState
                          .showSnackBar(
                          SnackBar(
                            content:
                            Text('Access Denied'),
                            backgroundColor:
                            Colors.red,
                            duration: Duration(
                                seconds:
                                1,
                                milliseconds:
                                500),
                          ));
                    }
                  }
                }

              });

            },
            minWidth: MediaQuery.of(context).size.width,
            child: Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
          ),
        ),
      ),
    ));

  }
}class Password extends StatefulWidget {

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
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,

            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(5.0, 2.0),
              ),
            ],
          ),
          child: TextFormField(
            controller: password,
            decoration: new InputDecoration(
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  FlutterIcons.eye_with_line_ent,
                  color: barColor,
                ),
                onPressed: (){
                  setState(() {
                    isVisible=false;
                  });
                },
              ),

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
            //keyboardType: TextInputType.number,
            style: new TextStyle(
              fontFamily: "Poppins",
            ),
          ),
        ),
      );
    else
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,

            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(5.0, 2.0),
              ),
            ],
          ),
          child: TextFormField(
            controller: password,
            obscureText: true,
            decoration: new InputDecoration(
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: barColor,
                ),
                onPressed: (){
                  setState(() {
                    isVisible=true;
                  });
                },
              ),

              prefixIcon: Icon(
                Icons.vpn_key,
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
            //keyboardType: TextInputType.number,
            style: new TextStyle(
              fontFamily: "Poppins",
            ),
          ),
        ),
      );
  }
}
