//
//
//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:shrifashion/Service/DatabaseConnections.dart';
// import 'package:shrifashion/mobileLogin.dart';
//
// void addToCart(var image,var productName,var old_price,var new_price,var productId,
//     var product_unit,var weight,var stock_status_id,var stock_status,var category_id,
//     var manufacturer,var product_option_id,var product_option_value_id,var option_name)
// {
//   cartLast.once().then(
//           (DataSnapshot datasnapshot){
//         Map<dynamic,dynamic> values= datasnapshot.value;
//         values.forEach((key,value){
//           int newKey=int.parse(key.toString())+1;
//           cart.child(newKey.toString()).set({
//             "customer_id":customerId,
//             "date_added":DateTime.now().toIso8601String(),
//             "image":image,
//             "maximum":"1",
//             "minimum":"1",
//             "name":productName,
//             "oldPrice":old_price,
//             "newPrice":new_price,
//             "product_id":productId,
//             "quantity":"1",
//             "unit":product_unit,
//             "weight":weight,
//             "stock_status_id":stock_status_id,
//             "stock_status":stock_status,
//             "category_id":category_id,
//             "manufacturer":manufacturer,
//
//             "product_option_id":product_option_id,
//             "product_option_value_id":product_option_value_id,
//             "option_name":option_name,
//
//           });
//
//
//         });
//       }
//   );
// }
// void updateCart(var productId,int qty)
// {
//   cart2.once().then(
//           (DataSnapshot datasnapshot) {
//         try{
//           List<dynamic> values = datasnapshot.value;
//           for (int i = 0; i < values.length; i++) {
//             try{
//               if (values[i]['customer_id'].toString() == customerId.toString() &&
//                   values[i]['product_id'].toString() == productId.toString()) {
//                 if(qty==0)
//                 {
//                   cart.child(i.toString()).remove();
//                   // cart.child(i.toString()).update(
//                   //     {"status": 0.toString()});
//
//                 }
//                 else
//                 {
//                   cart.child(i.toString()).update(
//                       {"quantity": qty.toString()});
//                 }
//
//               }}
//             catch(e)
//             {
//               print(e.toString());
//
//             }
//           }
//         }
//         catch(e)
//         {
//           Map<dynamic,dynamic> values = datasnapshot.value;
//           values.forEach((key, value) {
//             try{
//               if(value!=null)
//                 if (value['customer_id'].toString() == customerId.toString() &&
//                     value['product_id'].toString() == productId.toString()) {
//                   if(qty==0)
//                   {
//
//                     cart.child(key.toString()).remove();
//
//                   }
//                   else
//                   {
//                     cart.child(key.toString()).update(
//                         {"quantity": qty.toString()});
//                   }
//
//                 }}
//             catch(e)
//             {
//               print(e.toString());
//
//             }
//           });
//
//         }
//
//
//       }
//   );
// }
