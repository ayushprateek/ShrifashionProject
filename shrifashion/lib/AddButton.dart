
import 'package:flutter/material.dart';
import 'package:shrifashion/Service/CRUD.dart';
import 'package:shrifashion/mobileLogin.dart';


import 'components/Color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
class AddButton extends StatefulWidget {
  var productId,min_order_qty;
  var quantity, image,maximum, minimum, productName, old_price, new_price, unit,
      weight,stock_status_id, stock_status,category_id,manufacturer,
      product_option_id,product_option_value_id,option_name,product_unit;
  AddButton(var product_unit,var option_name,var product_option_id,var product_option_value_id,var productId, var quantity,var image,var maximum,var minimum,
      var productName,var old_price,var new_price,var unit,var weight,var stock_status_id,var stock_status,var category_id,var manufacturer,var min_order_qty)
  {
    this.min_order_qty=min_order_qty;
    this.productId=productId;
    this.quantity=quantity;
    this.image=image;
    this.maximum=maximum;
    this.minimum=minimum;
    this.productName=productName;
    this.old_price=old_price;
    this.new_price=new_price;
    this.unit=unit;
    this.weight=weight;
    this.stock_status=stock_status;
    this.stock_status_id=stock_status_id;
    this.category_id=category_id;
    this.manufacturer=manufacturer;
    this.product_option_id=product_option_id;
    this.product_option_value_id=product_option_value_id;
    this.option_name=option_name;
    this.product_unit=product_unit;
  }
  @override
  _AddButtonState createState() => _AddButtonState();
}
class _AddButtonState extends State<AddButton> {
  var cartId, productId, quantity;
  final cart = FirebaseDatabase.instance.reference().child("cart");
  final cart2 = FirebaseDatabase.instance.reference().child("cart").orderByChild("customer_id").equalTo(customerId);
  final cartLast = FirebaseDatabase.instance.reference().child("cart").limitToLast(1);
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
  final key = GlobalKey<ScaffoldState>();
  bool enabled=true;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: cart2.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var quantity;
          try{
            Map<dynamic,dynamic> values = snapshot.data.snapshot.value;
            if(values!=null)
              values.forEach((key,value){
                try{
                  if(value!=null)
                    if(value['customer_id'].toString()==customerId.toString() && value['product_id']==widget.productId)
                      quantity=value['quantity'];
                }
                catch(e)
                {

                }
              });

          }
          catch(e)
          {
            List<dynamic> values = snapshot.data.snapshot.value;
            if(values!=null)
              values.forEach((value){
                try{
                  if(value!=null)
                    if(value['customer_id'].toString()==customerId.toString() && value['product_id']==widget.productId)
                      quantity=value['quantity'];
                }
                catch(e)
                {

                }
              });
          }
          if(quantity==0||quantity==null)
          {
            return RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),

                ),
                textColor: Colors.white,
                // color: barColor,
                // padding: const EdgeInsets.all(8.0),
                onPressed: () async {
                  if(enabled)
                  {
                    enabled=false;
                    addToCart(widget.image, widget.productName, widget.old_price, widget.new_price, widget.productId, widget.product_unit, widget.weight, widget.stock_status_id, widget.stock_status, widget.category_id, widget.manufacturer,widget.min_order_qty);

                  }
                },

                child:  FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Text(
                          "ADD TO CART",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 8,),

                        Icon(Icons.add_shopping_cart,)
                      ],
                    ),
                  ),
                ));
          }
          else{
            enabled=true;
            return Row(
              children: [
                Expanded(
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),

                      ),
                      textColor: Colors.white,
                      // color: barColor,
                      onPressed: () async {

                        int x=int.parse(quantity);
                        int min_order_qty=int.tryParse(widget.min_order_qty.toString())??1;
                        x-=min_order_qty;
                        //x--;
                        updateCart(x,widget.productId);

                      },
                      child:  FittedBox(
                        child: Text(
                          "-",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                      )),
                ),

                Expanded(
                  child: Container(
                    child: Center(child: Text(quantity)),
                    width: 20.0,
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),

                      ),
                      textColor: Colors.white,
                      // color: barColor,
                      onPressed: () async {
                        int x=int.parse(quantity);
                        int min_order_qty=int.tryParse(widget.min_order_qty.toString())??1;
                        x+=min_order_qty;
                        // x++;
                        updateCart(x,widget.productId);



                      },

                      child:  FittedBox(
                        child: Text(
                          "+",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
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
                borderRadius: BorderRadius.circular(15.0),
              ),
              textColor: Colors.white,
              // color: barColor,
              onPressed: () async {
                if(enabled)
                {
                  enabled=false;
                  addToCart(widget.image, widget.productName, widget.old_price, widget.new_price, widget.productId, widget.product_unit, widget.weight, widget.stock_status_id, widget.stock_status, widget.category_id, widget.manufacturer,widget.min_order_qty);

                }

              },
              child:  FittedBox(
                  fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Text(
                        "ADD TO CART",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 8,),

                      Icon(Icons.add_shopping_cart,)
                    ],
                  ),
                ),
              ));

        }

      },
    );
  }
}
