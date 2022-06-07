
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/main.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shrifashion/HomePage.dart';
class ActivateAccount extends StatefulWidget {
  @override
  _ActivateAccountState createState() => _ActivateAccountState();
}

class _ActivateAccountState extends State<ActivateAccount> {
  final customer = FirebaseDatabase.instance.reference().child("customer");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Activate account"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                flex:4,
                child: Image.asset('images/veg_logo3.jpeg',
                  fit: BoxFit.fill,
                  // width: MediaQuery.of(context).size.width/8,
                  // height: MediaQuery.of(context).size.width/8,
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text("Your Account was deactivated, Do you want to activate it?",
                  style: TextStyle(fontFamily: 'Fredoka One',fontSize: 20),)),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                          onPressed: (){
                            customerId=null;
                            customerId=null;
                            localStorage.setString("customerId", null);
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                mobileLogin()), (Route<dynamic> route) => false);
                          },
                        child: Text("Cancel"),
                        color: Colors.white,

                          ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        onPressed: (){
                          customer.once().then(
                                  (DataSnapshot datasnapshot){
                                List values= datasnapshot.value;
                                for(int i=0;i<values.length;i++)
                                {
                                  if(values[i]['customer_id']==customerId.toString())
                                  {
                                    customer.child(i.toString()).update({
                                      "status":"1"
                                    });
                                  }
                                }
                                Navigator.push(context, MaterialPageRoute(builder: ((context)=>Dashboard())));

                              });
                        },
                        child: Text("Activate",style: TextStyle(color: Colors.white,),),

                      ),
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
