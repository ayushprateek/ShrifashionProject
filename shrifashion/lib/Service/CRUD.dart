

import 'package:firebase_database/firebase_database.dart';
import 'package:shrifashion/Service/DatabaseConnections.dart';
import 'package:shrifashion/mobileLogin.dart';

void addToCart(String image,String productName,String old_price,
    String new_price,String productId,String product_unit,String weight,
    String stock_status_id,String stock_status,String category_id,String manufacturer,String min_order_qty )
{
  cartLast.once().then(
          (DataSnapshot datasnapshot){
        Map<dynamic,dynamic> values= datasnapshot.value;
        values.forEach((key,value){
          int newKey=int.parse(key.toString())+1;
          cart.child(newKey.toString()).set({
            "customer_id":customerId,
            "date_added":DateTime.now().toIso8601String(),
            "image":image,
            "min_order_qty":min_order_qty,
            "name":productName,
            "oldPrice":old_price,
            "newPrice":new_price,
            "product_id": productId,
            "quantity":min_order_qty==null||min_order_qty==""?"1":min_order_qty,
            "unit": product_unit,
            "weight": weight,
            "status":"1",
            "stock_status_id": stock_status_id,
            "stock_status": stock_status,
            "category_id": category_id,
            "manufacturer": manufacturer,
            

          });


        });
      }
  );
}
void updateCart(int qty,String productId)
{
  cart2.once().then(
          (DataSnapshot datasnapshot) {
        try{
          Map<dynamic,dynamic> values = datasnapshot.value;
          if(values!=null)
            values.forEach((key,values) {
              try{
                if (values['customer_id'].toString() == customerId.toString() &&
                    values['product_id'].toString() ==  productId.toString()) {
                  if(qty==0)
                    {
                      cart.child(key.toString()).remove();
                    }
                  else
                    {
                      cart.child(key.toString()).update(
                          {"quantity":qty.toString()});
                    }

                }}
              catch(e)
              {

              }
            });


        }
        catch(e)
        {
          List<dynamic> values = datasnapshot.value;
          if(values!=null)
          {
            for(int i=0;i<values.length;i++)
            {
              try{
                if (values[i]['customer_id'].toString() == customerId.toString() &&
                    values[i]['product_id'].toString() ==  productId.toString()) {
                  if(qty==0)
                  {
                    cart.child(i.toString()).remove();
                  }
                  else
                  {
                    cart.child(i.toString()).update(
                        {"quantity": qty.toString()});
                  }

                }}
              catch(e)
              {

              }
            }
          }
        }
      }
  );
}