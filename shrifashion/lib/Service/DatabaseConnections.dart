
import 'package:firebase_database/firebase_database.dart';
import 'package:shrifashion/mobileLogin.dart';

final products = FirebaseDatabase.instance.reference().child("categorysuballproduct_final");
final subCategoryProducts = FirebaseDatabase.instance.reference().child("categorysubproduct_final");
final admin = FirebaseDatabase.instance.reference().child("admin");
final search = FirebaseDatabase.instance.reference().child("search");
final category = FirebaseDatabase.instance.reference().child("category");
final featuredProduct = FirebaseDatabase.instance.reference().child("featuredprod");
final cart = FirebaseDatabase.instance.reference().child("cart");
final PINS = FirebaseDatabase.instance.reference().child("codes");
final firebase_address = FirebaseDatabase.instance.reference().child("address");
final couponCalculation = FirebaseDatabase.instance.reference().child("coupons");
final staples = FirebaseDatabase.instance.reference().child("categorysubgrocery_final");
final fruits = FirebaseDatabase.instance.reference().child("categorysubfruit_final");
final vegetables = FirebaseDatabase.instance.reference().child("categorysubvegetable_final");
final subCategory = FirebaseDatabase.instance.reference().child("categorysub_final");
final customer = FirebaseDatabase.instance.reference().child("customer");
final cart2 = FirebaseDatabase.instance.reference().child("cart").orderByChild("customer_id").equalTo(customerId);

final cartLast = FirebaseDatabase.instance.reference().child("cart").limitToLast(1);
