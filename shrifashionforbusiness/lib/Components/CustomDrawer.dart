import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrifashionforbusiness/Components/Customs.dart';
import 'package:shrifashionforbusiness/Components/GetImageUrl.dart';
import 'package:shrifashionforbusiness/Components/PartnerDetails.dart';
import 'package:shrifashionforbusiness/LoginSignup/LoginPage.dart';
import 'package:shrifashionforbusiness/Masters/AddBanner.dart';
import 'package:shrifashionforbusiness/Masters/Banners.dart';
import 'package:shrifashionforbusiness/Masters/Categories.dart';
import 'package:shrifashionforbusiness/Masters/Coupons.dart';
import 'package:shrifashionforbusiness/RequestDataUsingAPI.dart';
import 'package:shrifashionforbusiness/System/Countries.dart';
import 'package:shrifashionforbusiness/System/Currencies.dart';
import 'package:shrifashionforbusiness/System/StoreLocations.dart';
import 'package:shrifashionforbusiness/System/Users.dart';
import 'package:shrifashionforbusiness/UI/ContactUs.dart';
import 'package:shrifashionforbusiness/UI/Customers.dart';
import 'package:shrifashionforbusiness/UI/Manufacturers.dart';
import 'package:shrifashionforbusiness/Masters/PostalCodes.dart';
import 'package:shrifashionforbusiness/Masters/Products.dart';
import 'package:shrifashionforbusiness/Masters/Rewards.dart';
import 'package:shrifashionforbusiness/Masters/SubCategories.dart';
import 'package:shrifashionforbusiness/UI/System.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:shrifashionforbusiness/main.dart';
class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text( PartnerDetails.store_name,
              style: TextStyle(
                color: Theme.of(context).buttonColor,
                  fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(PartnerDetails.email==null?"":PartnerDetails.email,
                style: TextStyle(
                    color: Theme.of(context).buttonColor,
                    fontWeight: FontWeight.bold)),
            currentAccountPicture: FutureBuilder(
              future: imageurl(context, PartnerDetails.image_name, FirebaseStorage.instance),
              builder: (context,snapshot){
                if(!snapshot.hasData)

                    return Container();

                try
                {
                  return GestureDetector(
                    child: new CircleAvatar(
                      child:ClipRRect(
                        child: Image.network(snapshot.data.image),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  );
                }
                catch(e)
                {
                  return Container();
                }


              },
            ),
            decoration: new BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          InkWell(
            child: ListTile(
              leading: Icon(FlutterIcons.home_faw,color: Theme.of(context).buttonColor,),
              trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor,),
              title: Text('Dashboard'),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            title: Text('Masters'),
            leading: Icon(FlutterIcons.update_mco,color: Theme.of(context).buttonColor),
            children: [
              // InkWell(
              //   child: ListTile(
              //     leading: Icon(FlutterIcons.images_ent,color: Theme.of(context).buttonColor),
              //     trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
              //     title: Text('Banners'),
              //   ),
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(builder: ((context)=>Banners())));
              //   },
              // ),
              // InkWell(
              //   child: ListTile(
              //     leading: Icon(FlutterIcons.buffer_mco,color: Theme.of(context).buttonColor),
              //     trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
              //     title: Text('Categories'),
              //   ),
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(builder: ((context)=>Categories())));
              //   },
              // ),
              // InkWell(
              //   child: ListTile(
              //     leading: Icon(Icons.category ,color: Theme.of(context).buttonColor),
              //     trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
              //     title: Text('Sub-categories'),
              //   ),
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(builder: ((context)=>SubCategories())));
              //   },
              // ),
              // InkWell(
              //   child: ListTile(
              //     leading: Icon(FlutterIcons.location_pin_ent,color: Theme.of(context).buttonColor),
              //     trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
              //     title: Text('Postal codes'),
              //   ),
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(builder: ((context)=>PostalCodes())));
              //   },
              // ),
              InkWell(
                child: ListTile(
                  leading: Icon(FlutterIcons.box_open_faw5s,color: Theme.of(context).buttonColor),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
                  title: Text('Products'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>Products())));
                },
              ),
              // InkWell(
              //   child: ListTile(
              //     leading: Icon(FlutterIcons.tags_faw,color: Theme.of(context).buttonColor),
              //     trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
              //     title: Text('Coupons'),
              //   ),
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(builder: ((context)=>Coupons())));
              //   },
              // ),
              // InkWell(
              //   child: ListTile(
              //     leading: Icon(FlutterIcons.trophy_faw,color: Theme.of(context).buttonColor),
              //     trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
              //     title: Text('Rewards'),
              //   ),
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(builder: ((context)=>Rewards())));
              //   },
              // ),

            ],
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.info_outline,color: Theme.of(context).buttonColor),
              trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
              title: Text('About Us'),
            ),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>ContactUs()));
            },
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.logout,color: Theme.of(context).buttonColor),
              trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
              title: Text('Logout'),
            ),
            onTap: (){
              animated_dialog_box.showScaleAlertBox(
                  title:Center(child: Text("Logout"),) , // IF YOU WANT TO ADD
                  context: context,
                  firstButton: MaterialButton(
                    // OPTIONAL BUTTON
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: Colors.white,
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  secondButton: MaterialButton(
                    // FIRST BUTTON IS REQUIRED
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: Theme.of(context).buttonColor,
                    child: Text('Logout',style:TextStyle(color: Colors.white)),
                    onPressed: () {
                      PartnerDetails.partner_id=null;
                      localStorage.setString("partner_id", null);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          mobileLogin()), (Route<dynamic> route) => false);
                    },
                  ),
                  icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
                  yourWidget: Container(
                    child: Text('Are you sure you want to log out?'),
                  ));
            },
          ),

          // InkWell(
          //   child: ListTile(
          //     leading: Icon(FlutterIcons.sale_mco,color: Theme.of(context).buttonColor),
          //     trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
          //     title: Text('Manufacturers'),
          //   ),
          //   onTap: (){
          //     Navigator.push(context, MaterialPageRoute(builder: ((context)=>Manufacturers())));
          //   },
          // ),
          // InkWell(
          //   child: ListTile(
          //     leading: Icon(FlutterIcons.group_faw,color: Theme.of(context).buttonColor),
          //     trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
          //     title: Text('Customers'),
          //   ),
          //   onTap: (){
          //     Navigator.push(context, MaterialPageRoute(builder: ((context)=>Customers())));
          //   },
          // ),

          // ExpansionTile(
          //   title: Text('System'),
          //   leading: Icon(FlutterIcons.ios_settings_ion,color: Theme.of(context).buttonColor),
          //   children: [
          //     InkWell(
          //       child: ListTile(
          //         leading: Icon(FlutterIcons.users_ent,color: Theme.of(context).buttonColor),
          //         trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
          //         title: Text('Users'),
          //       ),
          //       onTap: (){
          //         Navigator.push(context, MaterialPageRoute(builder: ((context)=>Users())));
          //       },
          //     ),
          //     InkWell(
          //       child: ListTile(
          //         leading: Icon(Icons.location_pin ,color: Theme.of(context).buttonColor),
          //         trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
          //         title: Text('Store locations'),
          //       ),
          //       onTap: (){
          //         Navigator.push(context, MaterialPageRoute(builder: ((context)=>StoreLocations())));
          //       },
          //     ),
          //     InkWell(
          //       child: ListTile(
          //         leading: Icon(FlutterIcons.ios_flag_ion,color: Theme.of(context).buttonColor),
          //         trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
          //         title: Text('Countries'),
          //       ),
          //       onTap: (){
          //         Navigator.push(context, MaterialPageRoute(builder: ((context)=>Countries())));
          //       },
          //     ),
          //     InkWell(
          //       child: ListTile(
          //         leading: Icon(FlutterIcons.currency_inr_mco,color: Theme.of(context).buttonColor),
          //         trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
          //         title: Text('Currencies'),
          //       ),
          //       onTap: (){
          //         Navigator.push(context, MaterialPageRoute(builder: ((context)=>Currencies())));
          //       },
          //     ),
          //     InkWell(
          //       child: ListTile(
          //         leading: Icon(FlutterIcons.currency_inr_mco,color: Theme.of(context).buttonColor),
          //         trailing: Icon(FlutterIcons.rightcircle_ant,color: Theme.of(context).buttonColor),
          //         title: Text('Request Data Using API'),
          //       ),
          //       onTap: (){
          //         Navigator.push(context, MaterialPageRoute(builder: ((context)=>RequestDataUsingAPI())));
          //       },
          //     ),
          //
          //   ],
          // ),

        ],
      ),
    );
  }
}
