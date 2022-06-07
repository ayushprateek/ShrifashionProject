
import 'package:hexcolor/hexcolor.dart';
import 'package:shrifashion/components/Color.dart';
import 'package:shrifashion/components/category.dart';
import 'package:shrifashion/mobileLogin.dart';
import 'package:shrifashion/navbar.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:shrifashion/pages/Referral.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shrifashion/HomePage.dart';
import 'package:shrifashion/main.dart';
class StickyFooter extends StatefulWidget {
  @override
  _StickyFooterState createState() => _StickyFooterState();
}

class _StickyFooterState extends State<StickyFooter> {
  final cart = FirebaseDatabase.instance.reference().child("cart");
  final product = FirebaseDatabase.instance.reference().child("search");
  int numOfCartItems=0;
   double saved=0;
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      child: StreamBuilder(
        stream: cart.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            numOfCartItems=0;
            cartAmt=0.0;
            saved=0;
            try
            {
              List<dynamic> values=snapshot.data.snapshot.value;
              values.forEach((values) {
                try{
                  if(values['customer_id']==customerId)
                  {
                    numOfCartItems++;
                    if(values['newPrice']!=null)
                    {
                      // BOTH ARE THERE
                      double save=double.parse(values['oldPrice'])-double.parse(values['newPrice']);
                      save=save*double.parse(values['quantity']);
                      saved=saved+save;
                      cartAmt=cartAmt+(double.parse(values['newPrice'])*double.parse(values['quantity']));
                    }
                    else
                    {
                      // ONLY OLD PRICE IS THERE
                      cartAmt=cartAmt+(double.parse(values['oldPrice'])*double.parse(values['quantity']));
                    }
                  }
                }
                catch(e){
                }
              });
            }
            catch(e)
            {
              Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
              values.forEach((key,values) {
                try{
                  if(values['customer_id']==customerId)
                  {
                    numOfCartItems++;
                    if(values['newPrice']!=null)
                    {
                      // BOTH ARE THERE
                      double save=double.parse(values['oldPrice'])-double.parse(values['newPrice']);
                      save=save*double.parse(values['quantity']);
                      saved=saved+save;
                      cartAmt=cartAmt+(double.parse(values['newPrice'])*double.parse(values['quantity']));
                    }
                    else
                    {
                      // ONLY OLD PRICE IS THERE
                      cartAmt=cartAmt+(double.parse(values['oldPrice'])*double.parse(values['quantity']));
                    }
                  }
                }
                catch(e){
                }
              });
            }
            if (numOfCartItems == 0) {
              return Container(
                height: 2*(MediaQuery.of(context).size.height)/24,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap:(){
                                  Navigator.pop(context);
                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (context) => new Dashboard()));
                                },
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex:3,
                                      child: Image.asset('images/Logo.png',
                                        //'images/LogoWithTM.jpg',
                                        // width: MediaQuery.of(context).size.width/13,
                                      ),
                                    ),
                                    Expanded(child: FittedBox(child: Text("Home",style: TextStyle(fontSize: 12),))),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){

                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (context) => new Categories()));
                                },
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(FlutterIcons.buffer_mco,color: Colors.black,),
                                      ),
                                      Text("Categories"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  showSearch(context: context, delegate: DataSearch());
                                },
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.search,color: Colors.black,),
                                      ),
                                      Text("Search "),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){


                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (context) => new Referral()));


                                },
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(FlutterIcons.user_friends_faw5s,color: Colors.black,),
                                      ),
                                      Text("Referral"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){

                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (context) => new Cart()));

                                },
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(FlutterIcons.cart_mco,color: Colors.black,),
                                      ),
                                      Text("Basket"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: Text(""),)

                  ],
                ),
              );
            }
            else {
              return Container(

                height: 2*(MediaQuery.of(context).size.height)/15,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(

                        decoration: BoxDecoration(border: Border.all(color: Theme.of(context).buttonColor,)),
                        child: FlatButton(
                          color: Theme.of(context).buttonColor,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: ((context)=>Cart())));
                          },
                          child: Row(
                            children: [
                              Expanded(child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 25,top: 4,bottom: 2),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              numOfCartItems.toString(),
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Items",
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,bottom: 6,top:6),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height/30,
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:15,top: 0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: FittedBox(
                                              child: Text(
                                                "\u{20B9}"+ cartAmt.toStringAsFixed(0),
                                                style: new TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,

                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: FittedBox(
                                              child: Text(
                                                "(Saved "+"\u{20B9}"+ saved.toStringAsFixed(0)+ ")",
                                                style: new TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,

                                                ),
                                              ),
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                              Expanded(
                                child: Row(children: [

                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: FittedBox(
                                        child: Text("CHECKOUT",maxLines: 1,style: new TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15

                                        ),),
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()),

                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:5.0,bottom: 2.0),
                                      child: Image.asset("images/Arrow.png",
                                        height: 18.0,
                                      ),),
                                  ),
                                ],),
                              ),





                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap:(){
                                  Navigator.pop(context);
                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (context) => new Dashboard()));
                                },
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex:3,
                                      child: Image.asset('images/Logo.png',
                                      ),
                                    ),
                                    Expanded(child: FittedBox(child: Text("Home",style: TextStyle(fontSize: 12),))),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){

                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (context) => new Categories()));
                                },
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(FlutterIcons.buffer_mco,color: Colors.black,),
                                      ),
                                      Text("Categories"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  showSearch(context: context, delegate: DataSearch());
                                },
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.search,color: Colors.black,),
                                      ),
                                      Text("Search "),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){


                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (context) => new Referral()));


                                },
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(FlutterIcons.user_friends_faw5s,color: Colors.black,),
                                      ),
                                      Text("Referral"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){

                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (context) => new Cart()));

                                },
                                child: FittedBox(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(FlutterIcons.cart_mco,color: Colors.black,),
                                      ),
                                      Text("Basket"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: Container(child: Text(""),color: Colors.white,),)
                  ],
                ),
              );
            }
          }

          return Container();
        },
      ),
    );


  }
}


