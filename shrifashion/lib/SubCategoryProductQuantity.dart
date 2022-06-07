//
// import 'package:shrifashion/ImageURL.dart';
// import 'package:shrifashion/AddButton.dart';
// import 'package:shrifashion/Service/CartInsert.dart';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:html/parser.dart';
// import 'package:shrifashion/components/ProductContainer.dart';
//
// import 'BottomSheet.dart';
//
//
// import 'components/Color.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// class SubCategoryProductQuantity extends StatefulWidget {
//   var categoryId;
//
//   SubCategoryProductQuantity(var categoryId)
//   {
//     print("Category Id="+categoryId);
//     this.categoryId=categoryId;
//
//   }
//   @override
//   _SubCategoryProductQuantityState createState() => _SubCategoryProductQuantityState();
// }
//
// class _SubCategoryProductQuantityState extends State<SubCategoryProductQuantity> {
//   var cartId, productId, quantity;
//   final key = GlobalKey<ScaffoldState>();
//
//   final products = FirebaseDatabase.instance.reference().child("search");
//   FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
//   var future_products;
//   @override
//   void initState()
//   {
//     future_products=products.onValue;
//     super.initState();
//   }
//   List lists=[];
//
//
//   String _parseHtmlString(String htmlString) {
//     final document = parse(htmlString);
//     final String parsedString = parse(document.body.text).documentElement.text;
//
//     return parsedString;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: StreamBuilder(
//         stream: future_products,
//         builder: (context, snapshot) {
//           print(snapshot.connectionState);
//           if (snapshot.hasData) {
//             lists.clear();
//             print("Firebase products");
//             try
//             {
//               List<dynamic> values = snapshot.data.snapshot.value;
//               values.forEach((values) {
//                 //----CONDITION-----
//                 if(values!=null && values['category_id']==widget.categoryId)
//                   lists.add(values);
//               });
//               if(lists.isEmpty)
//                 {
//                   values.forEach((values) {
//                     //----CONDITION-----
//                     if(values!=null && values['parent_id']==widget.categoryId)
//                       lists.add(values);
//
//                   });
//                 }
//             }
//             catch(e)
//           {
//             Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
//             values.forEach((key,values) {
//               //----CONDITION-----
//               if(values!=null &&values['category_id']==widget.categoryId)
//                 lists.add(values);
//
//             });
//             if(lists.isEmpty)
//             {
//               values.forEach((key,values) {
//                 //----CONDITION-----
//                 if(values!=null && values['parent_id']==widget.categoryId)
//                   lists.add(values);
//
//               });
//             }
//           }
//
//
//
//
//             if(lists.isNotEmpty)
//             {
//               return GridView.builder(
//                 physics: ScrollPhysics(),
//                 itemCount: lists.length,
//                 gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: MediaQuery.of(context).size.width /
//                         (MediaQuery.of(context).size.height / 1.2)),
//                 shrinkWrap: true,
//                 itemBuilder: (BuildContext context, index) {
//
//                   var manufacturer= lists[index]['manufacturer']==null?
//                   "shrifashion":lists[index]['manufacturer'];
//
//                  return ProductContainer(
//                    manufacturer: manufacturer,
//                    category_id: lists[index]['category_id'],
//                    name: lists[index]['name'],
//                    quantity: lists[index]['quantity'],
//                    minimun: lists[index]['minimun'],
//                    maximun: lists[index]['maximun'],
//                    stock_status_id: lists[index]['stock_status_id'],
//                    stock_status: lists[index]['stock_status'],
//                    tag: lists[index]['tag'],
//                    location: lists[index]['location'],
//                    weight: lists[index]['weight'],
//                    model: lists[index]['model'],
//                    product_id: lists[index]['product_id'],
//                    description: lists[index]['description'],
//                    new_price: lists[index]['new_price'],
//                    old_price: lists[index]['old_price'],
//                    image: lists[index]['image'],
//                    unit: lists[index]['unit'],
//                  );
//                 },
//               );
//             }
//             else
//             {
//               return Container();
//             }
//
//           } else {
//             print("Snapshot is null");
//           }
//
//           return Container();
//         },
//       ),
//     );
//   }
// }
