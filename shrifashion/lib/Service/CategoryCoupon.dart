
import 'dart:convert';

import 'package:shrifashion/mobileLogin.dart';
import 'package:http/http.dart' as http;


Future<List<CouponAPI>>categoryCoupon(var couponCode) async{
  print("aaA"+couponCode+"AA");

  String url="https://shrifashion.com/prod/categoryCoupon.php";
  final response=await http.post(url,body:
  {
    'couponCode':couponCode.toString().trim(),
  }
  );
  String str=response.body;
  print(str);
  str=str.trim();

  if(str=='coupon already applied')
  {
    print("Setting applied");

  }
  str=str.substring(1,str.length-1);//[{"email":"abc@gmail.com","psw":"1234"}] cutting extra braces
  try{
    return CouponAPIFromJson(str);
  }
  catch(e)
  {

  }
}

List<CouponAPI> CouponAPIFromJson(String str) => List<CouponAPI>.from(json.decode(str).map((x) => CouponAPI.fromJson(x)));

String CouponAPIToJson(List<CouponAPI> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CouponAPI {
  CouponAPI({
    this.category_id,
  });

  String category_id;


  factory CouponAPI.fromJson(Map<String, dynamic> json) => CouponAPI(
    category_id: json["category_id"],

  );

  Map<String, dynamic> toJson() => {
    "category_id": category_id,

  };
}
