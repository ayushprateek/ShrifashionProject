
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shrifashion/Service/CRUD.dart';
import 'package:shrifashion/Service/CartInsert.dart';
import 'package:shrifashion/mobileLogin.dart';

import 'components/Color.dart';
class FooterOptions extends StatefulWidget {
  var unit,new_price,old_price,product_id,min_order_qty,
      product_unit,
      image,
      name,
      weight,
      stock_status_id,
      stock_status,
      category_id,
      manufacturer;
  FooterOptions({this.min_order_qty,this.unit,this.new_price,this.old_price,this.product_id,
    this.product_unit,this.image,this.name,this.weight,this.stock_status_id,this.stock_status,this.category_id,this.manufacturer
  });
  @override
  _FooterOptionsState createState() => _FooterOptionsState();
}
class _FooterOptionsState extends State<FooterOptions> {
  bool enabled=true;
  final cart = FirebaseDatabase.instance.reference().child("cart");
  final cart2 = FirebaseDatabase.instance.reference().child("cart").orderByChild("customer_id").equalTo(customerId);
  final cartLast = FirebaseDatabase.instance.reference().child("cart").limitToLast(1);
  final option = FirebaseDatabase.instance.reference().child("option");
  String dropdownValue;
  List<String> listNames=[];
  var product_option_id="0",product_option_value_id="0";
  List lists=[];
  bool isSet=false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: option.onValue,
        builder: (context,snapshot){
          if(snapshot.hasData)
          {
            listNames.clear();
            List<dynamic> values = snapshot.data.snapshot.value;
            if(values!=null)
            values.forEach((values) {
              if(values!=null && values['product_id']==widget.product_id)
              {
                if(values['name']==widget.unit)
                {
                  widget.new_price=values['price'];
                  widget.old_price=values['weight'];
                  product_option_id=values['product_option_id'];
                  product_option_value_id=values['product_option_value_id'];
                }
                listNames.add(values['name']);
              }
            });
            if(listNames.isEmpty)
            {
              double new_price=double.tryParse(widget.new_price.toString())??0.0;
              double old_price=double.tryParse(widget.old_price.toString())??0.0;
              double margin=old_price-new_price;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width /
                          2.5,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.unit),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Margin: \u{20b9}"+margin.toString()),
                  ),
                  widget.old_price!=null && widget.old_price!=""?
                  Expanded(
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width /
                          2.5,
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 8.0),
                                child: Align(
                                  alignment:
                                  Alignment.topLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
                                      style: TextStyle(
                                          color:
                                          Colors.orange,
                                          fontWeight:
                                          FontWeight
                                              .bold),
                                    ),
                                  ),
                                ),
                              ),
                              flex: 1),
                          Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 0.0),
                                child: Align(
                                  alignment:
                                  Alignment.topLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "\u{20B9}${double.parse(widget.old_price).toStringAsFixed(0)}",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                          TextDecoration
                                              .lineThrough),
                                    ),
                                  ),
                                ),
                              ),
                              flex: 1),
                        ],
                      ),
                    ),

                    flex: 1, //elevation: 10,
                  ):
                  Expanded(
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width /
                          2.5,
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 8.0),
                                child: Align(
                                  alignment:
                                  Alignment.topLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
                                      style: TextStyle(
                                          color:
                                          Colors.orange,
                                          fontWeight:
                                          FontWeight
                                              .bold),
                                    ),
                                  ),
                                ),
                              ),
                              flex: 1),

                        ],
                      ),
                    ),

                    flex: 1, //elevation: 10,
                  ),
                  Expanded(
                      flex: 1,
                      child: StreamBuilder(
                        stream: cart2.onValue,
                        builder: (context, snap) {
                          if (snap.hasData) {

                            var quantity;
                            try
                            {
                              List<dynamic> values = snap.data.snapshot.value;
                              if(values!=null)
                                values.forEach((value){
                                  try{
                                    if(value!=null)
                                      if(value['customer_id'].toString()==customerId.toString() && value['product_id']==widget.product_id
                                      )
                                        quantity=value['quantity'];
                                  }
                                  catch(e)
                                  {

                                  }
                                });
                            }
                            catch(e)
                            {
                              Map<dynamic,dynamic> values = snap.data.snapshot.value;
                              if(values!=null)
                                values.forEach((key,value){
                                  try{
                                    if(value!=null)
                                      if(value['customer_id'].toString()==customerId.toString() && value['product_id']==widget.product_id
                                      )
                                        quantity=value['quantity'];
                                  }
                                  catch(e)
                                  {

                                  }
                                });
                            }
                            if (quantity == 0 || quantity==null) {
                              return RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        15.0),
                                  ),
                                  onPressed: () async {
                                    if(enabled)
                                    {
                                      enabled=false;

                                      addToCart(widget.image, widget.name, widget.old_price, widget.new_price, widget.product_id, widget.product_unit, widget.weight, widget.stock_status_id, widget.stock_status, widget.category_id, widget.manufacturer,widget.min_order_qty);
                                    }
                                  },
                                  textColor: Colors.white,
                                   
                                  padding:
                                  const EdgeInsets.all(2.0),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: new Text(
                                      "Add",
                                    ),
                                  ));
                            }
                            else {
                              enabled=true;
                              return Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width:40,
                                    child: RaisedButton(
                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              15.0),
                                        ),
                                        textColor:
                                        Colors.white,
                                         
                                        padding:
                                        const EdgeInsets
                                            .only(bottom:2.0),
                                        onPressed:
                                            () async {

                                          // if ((int.parse(quantity) - 1) == 0) {
                                          //
                                          //
                                          //   cart.once().then(
                                          //           (DataSnapshot datasnapshot) {
                                          //         List<dynamic> values = datasnapshot.value;
                                          //         for (int i = 0; i < values.length; i++) {
                                          //           try{
                                          //             if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //                 values[i]['product_id'].toString() == widget.product_id.toString()) {
                                          //               cart.child(i.toString()).update(
                                          //                   {"status": 0.toString()});
                                          //             }
                                          //           }
                                          //           catch(e)
                                          //           {
                                          //
                                          //           }
                                          //
                                          //         }
                                          //       }).then((value) => setState((){}));
                                          // }
                                          // else {
                                          //   cart.once().then(
                                          //           (DataSnapshot datasnapshot) {
                                          //         int x= int.parse(quantity.toString());
                                          //         x--;
                                          //         List<dynamic> values = datasnapshot.value;
                                          //         for (int i = 0; i < values.length; i++) {
                                          //           try{
                                          //             if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //                 values[i]['product_id'].toString() == widget.product_id.toString()) {
                                          //               cart.child(i.toString()).update(
                                          //                   {"quantity": x.toString()});
                                          //             }}
                                          //           catch(e)
                                          //           {
                                          //
                                          //
                                          //           }
                                          //         }
                                          //       }
                                          //   ).then((value) => setState((){}));
                                          //
                                          // }
                                          //     if ((int.parse(quantity) - 1) == 0) {
                                          //       print("Delete called");
                                          //
                                          //       cart2.once().then(
                                          //               (DataSnapshot datasnapshot) {
                                          //
                                          //             try{
                                          //               Map<dynamic,dynamic> values = datasnapshot.value;
                                          //               if(values!=null)
                                          //                 values.forEach((key,values) {
                                          //                   try{
                                          //                     if (values['customer_id'].toString() == customerId.toString() &&
                                          //                         values['product_id'].toString() == widget.product_id.toString()&& values['status'].toString()=="1") {
                                          //                       cart.child(key.toString()).update(
                                          //                           {"status": 0.toString()});
                                          //                     }}
                                          //                   catch(e)
                                          //                   {
                                          //
                                          //                   }
                                          //                 });
                                          //             }
                                          //             catch(e)
                                          //             {
                                          //               List<dynamic> values = datasnapshot.value;
                                          //               if(values!=null)
                                          //               {
                                          //                 for(int i=0;i<values.length;i++)
                                          //                 {
                                          //                   try{
                                          //                     if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //                         values[i]['product_id'].toString() == widget.product_id.toString()&& values[i]['status'].toString()=="1") {
                                          //                       cart.child(i.toString()).update(
                                          //                           {"status": 0.toString()});
                                          //                     }}
                                          //                   catch(e)
                                          //                   {
                                          //
                                          //                   }
                                          //                 }
                                          //               }
                                          //             }
                                          //           }).then((value) => setState((){}));
                                          //     }
                                          //     else {
                                          //       cart2.once().then(
                                          //               (DataSnapshot datasnapshot) {
                                          //             int x= int.parse(quantity.toString());
                                          //             x--;
                                          //             try{
                                          //               Map<dynamic,dynamic> values = datasnapshot.value;
                                          //               if(values!=null)
                                          //                 values.forEach((key,values) {
                                          //                   try{
                                          //                     if (values['customer_id'].toString() == customerId.toString() &&
                                          //                         values['product_id'].toString() == widget.product_id.toString()&& values['status'].toString()=="1") {
                                          //                       cart.child(key.toString()).update(
                                          //                           {"quantity": x.toString()});
                                          //                     }}
                                          //                   catch(e)
                                          //                   {
                                          //
                                          //                   }
                                          //                 });
                                          //
                                          //
                                          //             }
                                          //             catch(e)
                                          //             {
                                          //               List<dynamic> values = datasnapshot.value;
                                          //               if(values!=null)
                                          //               {
                                          //                 for(int i=0;i<values.length;i++)
                                          //                 {
                                          //                   try{
                                          //                     if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //                         values[i]['product_id'].toString() == widget.product_id.toString()&& values[i]['status'].toString()=="1") {
                                          //                       cart.child(i.toString()).update(
                                          //                           {"quantity": x.toString()});
                                          //                     }}
                                          //                   catch(e)
                                          //                   {
                                          //
                                          //                   }
                                          //                 }
                                          //               }
                                          //             }
                                          //           }
                                          //       ).then((value) => setState((){}));
                                          //
                                          //     }
                                          int x= int.parse(quantity.toString());
                                          x--;
                                          updateCart(x,widget.product_id);


                                        },
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              "-",
                                              style: TextStyle(
                                                  fontSize:
                                                  20),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Container(
                                    child: Center(
                                        child: Text(quantity)),
                                    width: 40.0,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width:40,
                                    child: RaisedButton(
                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              15.0),
                                        ),
                                        textColor:
                                        Colors.white,
                                         
                                        padding:
                                        const EdgeInsets
                                            .only(bottom:2.0),
                                        onPressed:
                                            () async {



                                          // cart2.once().then(
                                          //         (DataSnapshot datasnapshot) {
                                          //       int x= int.parse(quantity.toString());
                                          //       x++;
                                          //       try{
                                          //         Map<dynamic,dynamic> values = datasnapshot.value;
                                          //         if(values!=null)
                                          //           values.forEach((key,values) {
                                          //             try{
                                          //               if (values['customer_id'].toString() == customerId.toString() &&
                                          //                   values['product_id'].toString() == widget.product_id.toString() && values['status'].toString()=="1") {
                                          //                 cart.child(key.toString()).update(
                                          //                     {"quantity": x.toString()});
                                          //               }}
                                          //             catch(e)
                                          //             {
                                          //
                                          //             }
                                          //           });
                                          //
                                          //
                                          //       }
                                          //       catch(e)
                                          //       {
                                          //         List<dynamic> values = datasnapshot.value;
                                          //         if(values!=null)
                                          //         {
                                          //           for(int i=0;i<values.length;i++)
                                          //           {
                                          //             try{
                                          //               if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //                   values[i]['product_id'].toString() == widget.product_id.toString()&& values[i]['status'].toString()=="1") {
                                          //                 cart.child(i.toString()).update(
                                          //                     {"quantity": x.toString()});
                                          //               }}
                                          //             catch(e)
                                          //             {
                                          //
                                          //             }
                                          //           }
                                          //         }
                                          //       }
                                          //       // List<dynamic> values = datasnapshot.value;
                                          //       // for (int i = 0; i < values.length; i++) {
                                          //       //   try{
                                          //       //     if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //       //         values[i]['product_id'].toString() == widget.product_id.toString()) {
                                          //       //       cart.child(i.toString()).update(
                                          //       //           {"quantity": x.toString()});
                                          //       //     }}
                                          //       //   catch(e)
                                          //       //   {
                                          //       //
                                          //       //   }
                                          //       // }
                                          //     }
                                          // ).then((value) => setState((){}));
                                          int x= int.parse(quantity.toString());
                                          x++;
                                          updateCart(x,widget.product_id);



                                        },
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              "+",
                                              style: TextStyle(
                                                  fontSize:
                                                  20),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              );
                            }
                          } else {
                            return RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      15.0),
                                ),
                                onPressed: () async {




                                  addToCart(widget.image, widget.name, widget.old_price, widget.new_price, widget.product_id, widget.product_unit, widget.weight, widget.stock_status_id, widget.stock_status, widget.category_id, widget.manufacturer,widget.min_order_qty);

                                },
                                textColor: Colors.white,
                                 
                                padding:
                                const EdgeInsets.all(2.0),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: new Text(
                                    "Add",
                                  ),
                                ));
                          }
                        },
                      )),
                ],
              );
            }
            if(!isSet)
            {
              isSet=true;
              dropdownValue=listNames[0];
            }
            return Container(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Row(
                          children: [
                            Expanded(
                              child: Material(
                                  color: Colors.white.withOpacity(0.8),
                                  elevation: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2.0),
                                        border: Border.all(color: Theme.of(context).buttonColor)),
                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: Container(
                                          decoration: BoxDecoration(
                                               
                                              borderRadius: BorderRadius.circular(2.0),
                                              border: Border.all(color: Theme.of(context).buttonColor)),
                                          child: Icon(Icons.arrow_drop_down_sharp,color: Colors.white,)),
                                      underline: Container(),
                                      isExpanded: true,
                                      onChanged: (newValue) {
                                        var price,unit;
                                        values.forEach((values) {

                                          if(values['product_id']==widget.product_id && values['name']==newValue)
                                          {
                                            price=values['price'];
                                            unit=values['name'];
                                          }

                                        });
                                        setState(() {
                                          widget.new_price=price;
                                          widget.unit=unit;
                                          dropdownValue = newValue;
                                        });
                                      },
                                      items: listNames
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(value,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                )),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                              ),
                            ),
                            Expanded(child: Container())
                          ],
                        ),
                      ),
                    ),
                  ),
                  widget.old_price!=null && widget.old_price!=""?
                  Expanded(
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width /
                          2.5,
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 8.0),
                                child: Align(
                                  alignment:
                                  Alignment.topLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
                                      style: TextStyle(
                                          color:
                                          Colors.orange,
                                          fontWeight:
                                          FontWeight
                                              .bold),
                                    ),
                                  ),
                                ),
                              ),
                              flex: 1),
                          Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 0.0),
                                child: Align(
                                  alignment:
                                  Alignment.topLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "\u{20B9}${double.parse(widget.old_price).toStringAsFixed(0)}",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                          TextDecoration
                                              .lineThrough),
                                    ),
                                  ),
                                ),
                              ),
                              flex: 1),
                        ],
                      ),
                    ),

                    flex: 1, //elevation: 10,
                  ):
                  Expanded(
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width /
                          2.5,
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 8.0),
                                child: Align(
                                  alignment:
                                  Alignment.topLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
                                      style: TextStyle(
                                          color:
                                          Colors.orange,
                                          fontWeight:
                                          FontWeight
                                              .bold),
                                    ),
                                  ),
                                ),
                              ),
                              flex: 1),

                        ],
                      ),
                    ),

                    flex: 1, //elevation: 10,
                  ),
                  Expanded(
                      flex: 1,
                      child: StreamBuilder(
                        stream: cart2.onValue,
                        builder: (context, snap) {
                          if (snap.hasData) {

                            var quantity;
                            try
                            {
                              List<dynamic> values = snap.data.snapshot.value;
                              if(values!=null)
                                values.forEach((value){
                                  try{
                                    if(value!=null)
                                      if(value['customer_id'].toString()==customerId.toString() && value['product_id']==widget.product_id
                                      )
                                        quantity=value['quantity'];
                                  }
                                  catch(e)
                                  {

                                  }
                                });
                            }
                            catch(e)
                            {
                              Map<dynamic,dynamic> values = snap.data.snapshot.value;
                              if(values!=null)
                                values.forEach((key,value){
                                  try{
                                    if(value!=null)
                                      if(value['customer_id'].toString()==customerId.toString() && value['product_id']==widget.product_id
                                      )
                                        quantity=value['quantity'];
                                  }
                                  catch(e)
                                  {

                                  }
                                });
                            }
                            if (quantity == 0 || quantity==null) {
                              return RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        15.0),
                                  ),
                                  onPressed: () async {
                                    if(enabled)
                                    {
                                      enabled=false;

                                      addToCart(widget.image, widget.name, widget.old_price, widget.new_price, widget.product_id, widget.product_unit, widget.weight, widget.stock_status_id, widget.stock_status, widget.category_id, widget.manufacturer,widget.min_order_qty);
                                    }


                                  },
                                  textColor: Colors.white,
                                   
                                  padding:
                                  const EdgeInsets.all(2.0),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: new Text(
                                      "Add",
                                    ),
                                  ));
                            }
                            else {
                              enabled=true;
                              return Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width:40,
                                    child: RaisedButton(
                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              15.0),
                                        ),
                                        textColor:
                                        Colors.white,
                                         
                                        padding:
                                        const EdgeInsets
                                            .only(bottom:2.0),
                                        onPressed:
                                            () async {

                                          // if ((int.parse(quantity) - 1) == 0) {
                                          //
                                          //
                                          //   cart.once().then(
                                          //           (DataSnapshot datasnapshot) {
                                          //         List<dynamic> values = datasnapshot.value;
                                          //         for (int i = 0; i < values.length; i++) {
                                          //           try{
                                          //             if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //                 values[i]['product_id'].toString() == widget.product_id.toString()) {
                                          //               cart.child(i.toString()).update(
                                          //                   {"status": 0.toString()});
                                          //             }
                                          //           }
                                          //           catch(e)
                                          //           {
                                          //
                                          //           }
                                          //
                                          //         }
                                          //       }).then((value) => setState((){}));
                                          // }
                                          // else {
                                          //   cart.once().then(
                                          //           (DataSnapshot datasnapshot) {
                                          //         int x= int.parse(quantity.toString());
                                          //         x--;
                                          //         List<dynamic> values = datasnapshot.value;
                                          //         for (int i = 0; i < values.length; i++) {
                                          //           try{
                                          //             if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //                 values[i]['product_id'].toString() == widget.product_id.toString()) {
                                          //               cart.child(i.toString()).update(
                                          //                   {"quantity": x.toString()});
                                          //             }}
                                          //           catch(e)
                                          //           {
                                          //
                                          //
                                          //           }
                                          //         }
                                          //       }
                                          //   ).then((value) => setState((){}));
                                          //
                                          // }
                                          //     if ((int.parse(quantity) - 1) == 0) {
                                          //       print("Delete called");
                                          //
                                          //       cart2.once().then(
                                          //               (DataSnapshot datasnapshot) {
                                          //
                                          //             try{
                                          //               Map<dynamic,dynamic> values = datasnapshot.value;
                                          //               if(values!=null)
                                          //                 values.forEach((key,values) {
                                          //                   try{
                                          //                     if (values['customer_id'].toString() == customerId.toString() &&
                                          //                         values['product_id'].toString() == widget.product_id.toString()&& values['status'].toString()=="1") {
                                          //                       cart.child(key.toString()).update(
                                          //                           {"status": 0.toString()});
                                          //                     }}
                                          //                   catch(e)
                                          //                   {
                                          //
                                          //                   }
                                          //                 });
                                          //             }
                                          //             catch(e)
                                          //             {
                                          //               List<dynamic> values = datasnapshot.value;
                                          //               if(values!=null)
                                          //               {
                                          //                 for(int i=0;i<values.length;i++)
                                          //                 {
                                          //                   try{
                                          //                     if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //                         values[i]['product_id'].toString() == widget.product_id.toString()&& values[i]['status'].toString()=="1") {
                                          //                       cart.child(i.toString()).update(
                                          //                           {"status": 0.toString()});
                                          //                     }}
                                          //                   catch(e)
                                          //                   {
                                          //
                                          //                   }
                                          //                 }
                                          //               }
                                          //             }
                                          //           }).then((value) => setState((){}));
                                          //     }
                                          //     else {
                                          //       cart2.once().then(
                                          //               (DataSnapshot datasnapshot) {
                                          //             int x= int.parse(quantity.toString());
                                          //             x--;
                                          //             try{
                                          //               Map<dynamic,dynamic> values = datasnapshot.value;
                                          //               if(values!=null)
                                          //                 values.forEach((key,values) {
                                          //                   try{
                                          //                     if (values['customer_id'].toString() == customerId.toString() &&
                                          //                         values['product_id'].toString() == widget.product_id.toString()&& values['status'].toString()=="1") {
                                          //                       cart.child(key.toString()).update(
                                          //                           {"quantity": x.toString()});
                                          //                     }}
                                          //                   catch(e)
                                          //                   {
                                          //
                                          //                   }
                                          //                 });
                                          //
                                          //
                                          //             }
                                          //             catch(e)
                                          //             {
                                          //               List<dynamic> values = datasnapshot.value;
                                          //               if(values!=null)
                                          //               {
                                          //                 for(int i=0;i<values.length;i++)
                                          //                 {
                                          //                   try{
                                          //                     if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //                         values[i]['product_id'].toString() == widget.product_id.toString()&& values[i]['status'].toString()=="1") {
                                          //                       cart.child(i.toString()).update(
                                          //                           {"quantity": x.toString()});
                                          //                     }}
                                          //                   catch(e)
                                          //                   {
                                          //
                                          //                   }
                                          //                 }
                                          //               }
                                          //             }
                                          //           }
                                          //       ).then((value) => setState((){}));
                                          //
                                          //     }
                                          int x= int.parse(quantity.toString());
                                          x--;
                                          updateCart(x,widget.product_id);


                                        },
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              "-",
                                              style: TextStyle(
                                                  fontSize:
                                                  20),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Container(
                                    child: Center(
                                        child: Text(quantity)),
                                    width: 40.0,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width:40,
                                    child: RaisedButton(
                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              15.0),
                                        ),
                                        textColor:
                                        Colors.white,
                                         
                                        padding:
                                        const EdgeInsets
                                            .only(bottom:2.0),
                                        onPressed:
                                            () async {



                                          // cart2.once().then(
                                          //         (DataSnapshot datasnapshot) {
                                          //       int x= int.parse(quantity.toString());
                                          //       x++;
                                          //       // List<dynamic> values = datasnapshot.value;
                                          //       // for (int i = 0; i < values.length; i++) {
                                          //       //   try{
                                          //       //     if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //       //         values[i]['product_id'].toString() == widget.product_id.toString()) {
                                          //       //       cart.child(i.toString()).update(
                                          //       //           {"quantity": x.toString()});
                                          //       //     }}
                                          //       //   catch(e)
                                          //       //   {
                                          //       //
                                          //       //   }
                                          //       // }
                                          //       try{
                                          //         Map<dynamic,dynamic> values = datasnapshot.value;
                                          //         if(values!=null)
                                          //           values.forEach((key,values) {
                                          //             try{
                                          //               if (values['customer_id'].toString() == customerId.toString() &&
                                          //                   values['product_id'].toString() == widget.product_id.toString() && values['status'].toString()=="1") {
                                          //                 cart.child(key.toString()).update(
                                          //                     {"quantity": x.toString()});
                                          //               }}
                                          //             catch(e)
                                          //             {
                                          //
                                          //             }
                                          //           });
                                          //
                                          //
                                          //       }
                                          //       catch(e)
                                          //       {
                                          //         List<dynamic> values = datasnapshot.value;
                                          //         if(values!=null)
                                          //         {
                                          //           for(int i=0;i<values.length;i++)
                                          //           {
                                          //             try{
                                          //               if (values[i]['customer_id'].toString() == customerId.toString() &&
                                          //                   values[i]['product_id'].toString() == widget.product_id.toString()&& values[i]['status'].toString()=="1") {
                                          //                 cart.child(i.toString()).update(
                                          //                     {"quantity": x.toString()});
                                          //               }}
                                          //             catch(e)
                                          //             {
                                          //
                                          //             }
                                          //           }
                                          //         }
                                          //       }
                                          //     }
                                          // ).then((value) => setState((){}));
                                          int x= int.parse(quantity.toString());
                                          x++;
                                          updateCart(x,widget.product_id);
                                        },
                                        child: Center(
                                          child: FittedBox(
                                            child: Text(
                                              "+",
                                              style: TextStyle(
                                                  fontSize:
                                                  20),
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              );
                            }
                          } else {
                            return RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      15.0),
                                ),
                                onPressed: () async {


                                  addToCart(widget.image, widget.name, widget.old_price, widget.new_price, widget.product_id, widget.product_unit, widget.weight, widget.stock_status_id, widget.stock_status, widget.category_id, widget.manufacturer,widget.min_order_qty);

                                },
                                textColor: Colors.white,
                                 
                                padding:
                                const EdgeInsets.all(2.0),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: new Text(
                                    "Add",
                                  ),
                                ));
                          }
                        },
                      )),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.unit),
                    ),
                  ),
                ),
                flex: 1,
              ),
              widget.old_price!=null && widget.old_price!=""?Expanded(
                child: Container(
                  width:
                  MediaQuery.of(context).size.width /
                      2.5,
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(
                                left: 8.0),
                            child: Align(
                              alignment:
                              Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
                                  style: TextStyle(
                                      color:
                                      Colors.orange,
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                ),
                              ),
                            ),
                          ),
                          flex: 1),
                      Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(
                                left: 0.0),
                            child: Align(
                              alignment:
                              Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "\u{20B9}${double.parse(widget.old_price).toStringAsFixed(0)}",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      decoration:
                                      TextDecoration
                                          .lineThrough),
                                ),
                              ),
                            ),
                          ),
                          flex: 1),
                    ],
                  ),
                ),

                flex: 1, //elevation: 10,
              ):
              Expanded(
                child: Container(
                  width:
                  MediaQuery.of(context).size.width /
                      2.5,
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(
                                left: 8.0),
                            child: Align(
                              alignment:
                              Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "\u{20B9}${double.parse(widget.new_price).toStringAsFixed(0)}",
                                  style: TextStyle(
                                      color:
                                      Colors.orange,
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                ),
                              ),
                            ),
                          ),
                          flex: 1),

                    ],
                  ),
                ),

                flex: 1, //elevation: 10,
              ),
              Expanded(
                  flex: 1,
                  child: StreamBuilder(
                    stream: cart2.onValue,
                    builder: (context, snap) {
                      if (snap.hasData) {
                        var quantity;
                        try
                        {
                          List<dynamic> values = snap.data.snapshot.value;
                          if(values!=null)
                            values.forEach((value){
                              try{
                                if(value!=null)
                                  if(value['customer_id'].toString()==customerId.toString() && value['product_id']==widget.product_id
                                  )
                                    quantity=value['quantity'];
                              }
                              catch(e)
                              {
                              }
                            });
                        }
                        catch(e)
                        {
                          Map<dynamic,dynamic> values = snap.data.snapshot.value;
                          if(values!=null)
                            values.forEach((key,value){
                              try{
                                if(value!=null)
                                  if(value['customer_id'].toString()==customerId.toString() && value['product_id']==widget.product_id
                                  )
                                    quantity=value['quantity'];
                              }
                              catch(e)
                              {
                              }
                            });
                        }
                        if (quantity == 0 || quantity==null) {
                          return RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    15.0),
                              ),
                              onPressed: () async {
                                if(enabled)
                                {
                                  enabled=false;

                                  addToCart(widget.image, widget.name, widget.old_price, widget.new_price, widget.product_id, widget.product_unit, widget.weight, widget.stock_status_id, widget.stock_status, widget.category_id, widget.manufacturer,widget.min_order_qty);
                                }


                              },
                              textColor: Colors.white,
                               
                              padding:
                              const EdgeInsets.all(2.0),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: new Text(
                                  "Add",
                                ),
                              ));
                        }
                        else {
                          enabled=true;
                          return Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width:40,
                                child: RaisedButton(
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          15.0),
                                    ),
                                    textColor:
                                    Colors.white,
                                     
                                    padding:
                                    const EdgeInsets
                                        .only(bottom:2.0),
                                    onPressed:
                                        () async {

                                      // if ((int.parse(quantity) - 1) == 0) {
                                      //
                                      //
                                      //   cart.once().then(
                                      //           (DataSnapshot datasnapshot) {
                                      //         List<dynamic> values = datasnapshot.value;
                                      //         for (int i = 0; i < values.length; i++) {
                                      //           try{
                                      //             if (values[i]['customer_id'].toString() == customerId.toString() &&
                                      //                 values[i]['product_id'].toString() == widget.product_id.toString()) {
                                      //               cart.child(i.toString()).update(
                                      //                   {"status": 0.toString()});
                                      //             }
                                      //           }
                                      //           catch(e)
                                      //           {
                                      //
                                      //           }
                                      //
                                      //         }
                                      //       }).then((value) => setState((){}));
                                      // }
                                      // else {
                                      //   cart.once().then(
                                      //           (DataSnapshot datasnapshot) {
                                      //         int x= int.parse(quantity.toString());
                                      //         x--;
                                      //         List<dynamic> values = datasnapshot.value;
                                      //         for (int i = 0; i < values.length; i++) {
                                      //           try{
                                      //             if (values[i]['customer_id'].toString() == customerId.toString() &&
                                      //                 values[i]['product_id'].toString() == widget.product_id.toString()) {
                                      //               cart.child(i.toString()).update(
                                      //                   {"quantity": x.toString()});
                                      //             }}
                                      //           catch(e)
                                      //           {
                                      //
                                      //
                                      //           }
                                      //         }
                                      //       }
                                      //   ).then((value) => setState((){}));
                                      //
                                      // }
                                      //     if ((int.parse(quantity) - 1) == 0) {
                                      //       print("Delete called");
                                      //
                                      //       cart2.once().then(
                                      //               (DataSnapshot datasnapshot) {
                                      //
                                      //             try{
                                      //               Map<dynamic,dynamic> values = datasnapshot.value;
                                      //               if(values!=null)
                                      //                 values.forEach((key,values) {
                                      //                   try{
                                      //                     if (values['customer_id'].toString() == customerId.toString() &&
                                      //                         values['product_id'].toString() == widget.product_id.toString()&& values['status'].toString()=="1") {
                                      //                       cart.child(key.toString()).update(
                                      //                           {"status": 0.toString()});
                                      //                     }}
                                      //                   catch(e)
                                      //                   {
                                      //
                                      //                   }
                                      //                 });
                                      //             }
                                      //             catch(e)
                                      //             {
                                      //               List<dynamic> values = datasnapshot.value;
                                      //               if(values!=null)
                                      //               {
                                      //                 for(int i=0;i<values.length;i++)
                                      //                 {
                                      //                   try{
                                      //                     if (values[i]['customer_id'].toString() == customerId.toString() &&
                                      //                         values[i]['product_id'].toString() == widget.product_id.toString()&& values[i]['status'].toString()=="1") {
                                      //                       cart.child(i.toString()).update(
                                      //                           {"status": 0.toString()});
                                      //                     }}
                                      //                   catch(e)
                                      //                   {
                                      //
                                      //                   }
                                      //                 }
                                      //               }
                                      //             }
                                      //           }).then((value) => setState((){}));
                                      //     }
                                      //     else {
                                      //       cart2.once().then(
                                      //               (DataSnapshot datasnapshot) {
                                      //             int x= int.parse(quantity.toString());
                                      //             x--;
                                      //             try{
                                      //               Map<dynamic,dynamic> values = datasnapshot.value;
                                      //               if(values!=null)
                                      //                 values.forEach((key,values) {
                                      //                   try{
                                      //                     if (values['customer_id'].toString() == customerId.toString() &&
                                      //                         values['product_id'].toString() == widget.product_id.toString()&& values['status'].toString()=="1") {
                                      //                       cart.child(key.toString()).update(
                                      //                           {"quantity": x.toString()});
                                      //                     }}
                                      //                   catch(e)
                                      //                   {
                                      //
                                      //                   }
                                      //                 });
                                      //
                                      //
                                      //             }
                                      //             catch(e)
                                      //             {
                                      //               List<dynamic> values = datasnapshot.value;
                                      //               if(values!=null)
                                      //               {
                                      //                 for(int i=0;i<values.length;i++)
                                      //                 {
                                      //                   try{
                                      //                     if (values[i]['customer_id'].toString() == customerId.toString() &&
                                      //                         values[i]['product_id'].toString() == widget.product_id.toString()&& values[i]['status'].toString()=="1") {
                                      //                       cart.child(i.toString()).update(
                                      //                           {"quantity": x.toString()});
                                      //                     }}
                                      //                   catch(e)
                                      //                   {
                                      //
                                      //                   }
                                      //                 }
                                      //               }
                                      //             }
                                      //           }
                                      //       ).then((value) => setState((){}));
                                      //
                                      //     }
                                      int x= int.parse(quantity.toString());
                                      x--;
                                      updateCart(x,widget.product_id);


                                    },
                                    child: Center(
                                      child: FittedBox(
                                        child: Text(
                                          "-",
                                          style: TextStyle(
                                              fontSize:
                                              20),
                                        ),
                                      ),
                                    )),
                              ),
                              Container(
                                child: Center(
                                    child: Text(quantity)),
                                width: 40.0,
                              ),
                              SizedBox(
                                height: 30,
                                width:40,
                                child: RaisedButton(
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          15.0),
                                    ),
                                    textColor:
                                    Colors.white,
                                     
                                    padding:
                                    const EdgeInsets
                                        .only(bottom:2.0),
                                    onPressed:
                                        () async {
                                      // cart2.once().then(
                                      //         (DataSnapshot datasnapshot) {
                                      //       int x= int.parse(quantity.toString());
                                      //       x++;
                                      //       // List<dynamic> values = datasnapshot.value;
                                      //       // for (int i = 0; i < values.length; i++) {
                                      //       //   try{
                                      //       //     if (values[i]['customer_id'].toString() == customerId.toString() &&
                                      //       //         values[i]['product_id'].toString() == widget.product_id.toString()) {
                                      //       //       cart.child(i.toString()).update(
                                      //       //           {"quantity": x.toString()});
                                      //       //     }}
                                      //       //   catch(e)
                                      //       //   {
                                      //       //
                                      //       //   }
                                      //       // }
                                      //       try{
                                      //         Map<dynamic,dynamic> values = datasnapshot.value;
                                      //         if(values!=null)
                                      //           values.forEach((key,values) {
                                      //             try{
                                      //               if (values['customer_id'].toString() == customerId.toString() &&
                                      //                   values['product_id'].toString() == widget.product_id.toString() && values['status'].toString()=="1") {
                                      //                 cart.child(key.toString()).update(
                                      //                     {"quantity": x.toString()});
                                      //               }}
                                      //             catch(e)
                                      //             {
                                      //
                                      //             }
                                      //           });
                                      //       }
                                      //       catch(e)
                                      //       {
                                      //         List<dynamic> values = datasnapshot.value;
                                      //         if(values!=null)
                                      //         {
                                      //           for(int i=0;i<values.length;i++)
                                      //           {
                                      //             try{
                                      //               if (values[i]['customer_id'].toString() == customerId.toString() &&
                                      //                   values[i]['product_id'].toString() == widget.product_id.toString()&& values[i]['status'].toString()=="1") {
                                      //                 cart.child(i.toString()).update(
                                      //                     {"quantity": x.toString()});
                                      //               }}
                                      //             catch(e)
                                      //             {
                                      //
                                      //             }
                                      //           }
                                      //         }
                                      //       }
                                      //     }
                                      // ).then((value) => setState((){}));
                                      int x= int.parse(quantity.toString());
                                      x++;
                                      updateCart(x,widget.product_id);



                                    },
                                    child: Center(
                                      child: FittedBox(
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                              fontSize:
                                              20),
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          );
                        }
                      }
                      else {
                        return RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  15.0),
                            ),
                            onPressed: () async {


                              addToCart(widget.image, widget.name, widget.old_price, widget.new_price, widget.product_id, widget.product_unit, widget.weight, widget.stock_status_id, widget.stock_status, widget.category_id, widget.manufacturer,widget.min_order_qty);


                            },
                            textColor: Colors.white,
                             
                            padding:
                            const EdgeInsets.all(2.0),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: new Text(
                                "Add",
                              ),
                            ));
                      }
                    },
                  )),
            ],
          );
        });
  }
}
