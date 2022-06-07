//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:shrifashion/AddButton.dart';
// import 'package:shrifashion/components/Color.dart';
// class FetchOptions extends StatefulWidget {
//   var unit,product_id,new_price,old_price,quantity,min_order_qty,image,maximum,minimum,productName,weight,
//       stock_status,stock_status_id,category_id,manufacturer,product_unit;
//   FetchOptions(var product_unit,var unit,var product_id, var quantity,var image,var maximum,var minimum,
//       var productName,var old_price,var new_price,var weight,var stock_status_id,var stock_status,var category_id,var manufacturer,var min_order_qty){
//     this.min_order_qty=min_order_qty;
//     this.product_id=product_id;
//     this.quantity=quantity;
//     this.image=image;
//     this.maximum=maximum;
//     this.minimum=minimum;
//     this.productName=productName;
//     this.old_price=old_price;
//     this.new_price=new_price;
//     this.unit=unit;
//     this.weight=weight;
//     this.stock_status=stock_status;
//     this.stock_status_id=stock_status_id;
//     this.category_id=category_id;
//     this.manufacturer=manufacturer;
//     this.product_unit=product_unit;
//   }
//   @override
//   _FetchOptionsState createState() => _FetchOptionsState();
// }
//
// class _FetchOptionsState extends State<FetchOptions> {
//   final option = FirebaseDatabase.instance.reference().child("option");
//   String dropdownValue;
//   List<String> listNames=[];
//   List lists=[];
//   bool isSet=false;
//   List<String> opt=[];
//   var product_option_id="0",product_option_value_id="0";
//   @override
//   Widget build(BuildContext context) {
//     double new_price=double.tryParse(widget.new_price.toString())??0.0;
//     double old_price=double.tryParse(widget.old_price.toString())??0.0;
//     double margin=old_price-new_price;
//
//     return StreamBuilder(
//         stream: option.onValue,
//         builder: (context,snapshot){
//           if(snapshot.hasData)
//           {
//             listNames.clear();
//             List<dynamic> values = snapshot.data.snapshot.value;
//             if(values!=null)
//             values.forEach((values) {
//               if(values!=null && values['product_id']==widget.product_id)
//               {
//                 if(values['name']==widget.unit)
//                 {
//                   print(widget.unit);
//                   print("widget.unit");
//                   widget.new_price=values['price'];
//                   widget.old_price=values['weight'];
//
//
//                   product_option_id=values['product_option_id'];
//                   product_option_value_id=values['product_option_value_id'];
//
//                 }
//                 listNames.add(values['name']);
//               }
//             });
//             if(listNames.isEmpty)
//             {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Container(),
//                   ),
//
//                   Expanded(
//                     flex: 15,
//                     child: Column(
//                       children: [
//                         widget.old_price!=null && widget.old_price!=""?
//                         Expanded(
//                           flex: 4,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Padding(
//                                   padding:
//                                   const EdgeInsets
//                                       .only(
//                                       left: 8.0,right:6),
//                                   child: Text(
//                                     "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
//                                     style: TextStyle(
//                                         fontSize: 17,
//                                         color: Colors
//                                             .orange,
//                                         fontWeight:
//                                         FontWeight
//                                             .bold),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Padding(
//                                   padding:
//                                   const EdgeInsets
//                                       .only(
//                                       left: 8.0,right:6),
//                                   child: Text(
//                                     "\u{20B9}${double.parse(widget.old_price).toStringAsFixed(0)}",
//                                     style: TextStyle(
//                                         fontSize: 17,
//                                         color: Colors
//                                             .grey,
//                                         decoration:
//                                         TextDecoration
//                                             .lineThrough),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ):
//                         Expanded(
//                           flex: 3,
//                           child: Padding(
//                             padding:
//                             const EdgeInsets
//                                 .only(
//                                 left: 8.0),
//                             child: FittedBox(
//                               child: Text(
//                                 "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
//                                 style: TextStyle(
//                                     fontSize: 17,
//                                     color: Colors
//                                         .orange,
//                                     fontWeight:
//                                     FontWeight
//                                         .bold),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Text("Margin: \u{20b9}"+margin.toString()),
//                           ),
//                         ),
//
//                         Expanded(
//                             flex: 7,
//                             child:Padding(
//                                 padding: EdgeInsets.all(8),
//                                 child:AddButton(widget.product_unit,widget.unit,product_option_id,product_option_value_id,widget.product_id,widget.quantity,
//                                     widget.image,widget.maximum,widget.minimum,
//                                     widget.productName,widget.old_price , widget.new_price,
//                                     widget.unit,widget.weight,widget.stock_status_id,
//                                     widget.stock_status,widget.category_id,widget.manufacturer,widget.min_order_qty
//                                 ))
//
//                         )
//                       ],
//                     ),
//                   ),
//
//                 ],
//               );
//             }
//             if(!isSet)
//             {
//               isSet=true;
//               dropdownValue=listNames[0];
//             }
//             return Column(
//               children: [
//                 Expanded(
//                   flex: 4,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top:6.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           flex: 4,
//                           child: Padding(
//                             padding:
//                             const EdgeInsets.only(left: 8.0,right: 8.0),
//                             child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: Material(
//                                   elevation: 0.0,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(2.0),
//                                         border: Border.all(color: Theme.of(context).buttonColor)),
//                                     child: DropdownButton<String>(
//                                       isExpanded: true,
//                                       value: dropdownValue,
//                                       icon: Container(
//                                           decoration: BoxDecoration(
//                                               color: Theme.of(context).buttonColor,
//                                               borderRadius: BorderRadius.circular(2.0),
//                                               border: Border.all(color: Theme.of(context).buttonColor)),
//                                           child: Icon(Icons.arrow_drop_down_sharp,color: Colors.white,)),
//                                       underline: Container(),
//                                       items: listNames
//                                           .map<DropdownMenuItem<String>>((String value) {
//                                         return DropdownMenuItem<String>(
//                                           value: value,
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(2.0),
//                                             child: Text(value,
//                                                 style: TextStyle(
//                                                   fontSize: 14,
//                                                 )
//                                             ),
//                                           ),
//                                         );
//                                       }).toList(),
//                                       onChanged: (newValue) {
//                                         var price,unit;
//                                         values.forEach((values) {
//                                           if(values['product_id']==widget.product_id && values['name']==newValue)
//                                           {
//                                             price=values['price'];
//                                             unit=values['name'];
//                                           }
//                                         });
//                                         setState(() {
//                                           print(price);
//                                           widget.new_price=price;
//                                           widget.unit=unit;
//                                           print("unit is");
//                                           print(widget.unit);
//                                           dropdownValue = newValue;
//                                         });
//                                       },
//
//                                     ),
//                                   )
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(flex: 5,child: Text(""),),
//                         Expanded(child: Text(""),)
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 10,
//                   child: Column(
//                     children: [
//                       widget.old_price!=null && widget.old_price!=""?
//                       Expanded(
//                         flex: 4,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Padding(
//                                 padding:
//                                 const EdgeInsets
//                                     .only(
//                                     left: 8.0,right:6),
//                                 child: Text(
//                                   "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
//                                   style: TextStyle(
//                                       fontSize: 17,
//                                       color: Colors
//                                           .orange,
//                                       fontWeight:
//                                       FontWeight
//                                           .bold),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding:
//                                 const EdgeInsets
//                                     .only(
//                                     left: 8.0,right:6),
//                                 child: Text(
//                                   "\u{20B9}${double.parse(widget.old_price).toStringAsFixed(0)}",
//                                   style: TextStyle(
//                                       fontSize: 17,
//                                       color: Colors
//                                           .grey,
//                                       decoration:
//                                       TextDecoration
//                                           .lineThrough),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ):
//                       Expanded(
//                         flex: 4,
//                         child: Padding(
//                           padding:
//                           const EdgeInsets
//                               .only(
//                               left: 8.0),
//                           child: Text(
//                             "\u{20B9}${double.parse(widget.old_price).toStringAsFixed(0)}",
//                             style: TextStyle(
//                                 fontSize: 17,
//                                 color: Colors
//                                     .orange,
//                                 fontWeight:
//                                 FontWeight
//                                     .bold),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                           flex: 6,
//                           child:Padding(
//                               padding: EdgeInsets.all(8),
//                               child:AddButton(widget.product_unit,widget.unit,product_option_id,product_option_value_id,widget.product_id,widget.quantity,
//                                   widget.image,widget.maximum,widget.minimum,
//                                   widget.productName,widget.old_price , widget.new_price,
//                                   widget.unit,widget.weight,widget.stock_status_id,
//                                   widget.stock_status,widget.category_id,widget.manufacturer,widget.min_order_qty
//                               ),
//                           )
//
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }
//           return Column(
//             children: [
//               Expanded(
//                 child: Container(),
//               ),
//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding:
//                         const EdgeInsets.only(left: 8.0,right: 8.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(widget.unit),
//                         ),
//                       ),
//                     ),
//                     Expanded(child: Text(""),)
//                   ],
//                 ),
//                 flex: 3,
//               ),
//               Expanded(
//                 flex: 10,
//                 child: Column(
//                   children: [
//                     widget.old_price!=null && widget.old_price!=""?
//                     Expanded(
//                       flex: 4,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Padding(
//                               padding:
//                               const EdgeInsets
//                                   .only(
//                                   left: 8.0,right:6),
//                               child: FittedBox(
//                                 child: Text(
//                                   "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
//                                   style: TextStyle(
//                                       fontSize: 17,
//                                       color: Colors
//                                           .orange,
//                                       fontWeight:
//                                       FontWeight
//                                           .bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding:
//                               const EdgeInsets
//                                   .only(
//                                   left: 8.0,right:6),
//                               child: FittedBox(
//                                 child: Text(
//                                   "\u{20B9}${double.parse(widget.old_price).toStringAsFixed(0)}",
//                                   style: TextStyle(
//                                       fontSize: 17,
//                                       color: Colors
//                                           .grey,
//                                       decoration:
//                                       TextDecoration
//                                           .lineThrough),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ):
//                     Expanded(
//                       flex: 3,
//                       child: Padding(
//                         padding:
//                         const EdgeInsets
//                             .only(
//                             left: 8.0),
//                         child: FittedBox(
//                           child: Text(
//                             "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
//                             style: TextStyle(
//                                 fontSize: 17,
//                                 color: Colors
//                                     .orange,
//                                 fontWeight:
//                                 FontWeight
//                                     .bold),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                         flex: 6,
//                         child:Padding(
//                             padding: EdgeInsets.all(8),
//                             child:AddButton(widget.product_unit,widget.unit,product_option_id,product_option_value_id,widget.product_id,widget.quantity,
//                                 widget.image,widget.maximum,widget.minimum,
//                                 widget.productName,widget.old_price , widget.new_price,
//                                 widget.unit,widget.weight,widget.stock_status_id,
//                                 widget.stock_status,widget.category_id,widget.manufacturer,widget.min_order_qty
//                             ))
//
//                     )
//                   ],
//                 ),
//               ),
//
//             ],
//           );
//         });
//   }
// }
