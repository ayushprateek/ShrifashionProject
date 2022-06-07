import 'package:shrifashionadmin/Components/Customs.dart';
import 'package:shrifashionadmin/Masters/AddBanner.dart';
import 'package:shrifashionadmin/Masters/Banners.dart';
import 'package:shrifashionadmin/Masters/Categories.dart';
import 'package:shrifashionadmin/Masters/Coupons.dart';
import 'package:shrifashionadmin/RequestDataUsingAPI.dart';
import 'package:shrifashionadmin/System/Countries.dart';
import 'package:shrifashionadmin/System/Currencies.dart';
import 'package:shrifashionadmin/System/StoreLocations.dart';
import 'package:shrifashionadmin/System/Users.dart';
import 'package:shrifashionadmin/UI/Customers.dart';
import 'package:shrifashionadmin/UI/Manufacturers.dart';
import 'package:shrifashionadmin/Masters/PostalCodes.dart';
import 'package:shrifashionadmin/Masters/Products.dart';
import 'package:shrifashionadmin/Masters/Rewards.dart';
import 'package:shrifashionadmin/Masters/SubCategories.dart';
import 'package:shrifashionadmin/UI/System.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
            accountName: Text( 'shrifashionadmin',
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            accountEmail: Text( 'shrifashionadmin@shricart.com',
                style: TextStyle(
                    fontWeight: FontWeight.bold)),
            currentAccountPicture: GestureDetector(
              child: new CircleAvatar(
                child:ClipRRect(
                  child:
                  Image.asset('images/male_user.jpeg'),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            decoration: new BoxDecoration(
              color: barColor,
            ),
          ),
          InkWell(
            child: ListTile(
              leading: Icon(FlutterIcons.home_faw,color: barColor,),
              trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
              title: Text('Dashboard'),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            title: Text('Masters'),
            leading: Icon(FlutterIcons.update_mco,color: barColor,),
            children: [
              InkWell(
                child: ListTile(
                  leading: Icon(FlutterIcons.images_ent,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Banners'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>Banners())));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(FlutterIcons.buffer_mco,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Categories'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>Categories())));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.category ,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Sub-categories'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>SubCategories())));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(FlutterIcons.location_pin_ent,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Postal codes'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>PostalCodes())));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(FlutterIcons.box_open_faw5s,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Products'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>Products())));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(FlutterIcons.tags_faw,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Coupons'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>Coupons())));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(FlutterIcons.trophy_faw,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Rewards'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>Rewards())));
                },
              ),

            ],
          ),
          // InkWell(
          //   child: ListTile(
          //     leading: Icon(FlutterIcons.sale_mco,color: barColor,),
          //     trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
          //     title: Text('Manufacturers'),
          //   ),
          //   onTap: (){
          //     Navigator.push(context, MaterialPageRoute(builder: ((context)=>Manufacturers())));
          //   },
          // ),
          InkWell(
            child: ListTile(
              leading: Icon(FlutterIcons.group_faw,color: barColor,),
              trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
              title: Text('Customers'),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: ((context)=>Customers())));
            },
          ),

          ExpansionTile(
            title: Text('System'),
            leading: Icon(FlutterIcons.ios_settings_ion,color: barColor,),
            children: [
              InkWell(
                child: ListTile(
                  leading: Icon(FlutterIcons.users_ent,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Users'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>Users())));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.location_pin ,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Store locations'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>StoreLocations())));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(FlutterIcons.ios_flag_ion,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Countries'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>Countries())));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(FlutterIcons.currency_inr_mco,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Currencies'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>Currencies())));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(FlutterIcons.currency_inr_mco,color: barColor,),
                  trailing: Icon(FlutterIcons.rightcircle_ant,color: barColor,),
                  title: Text('Request Data Using API'),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context)=>RequestDataUsingAPI())));
                },
              ),

            ],
          ),

        ],
      ),
    );
  }
}
