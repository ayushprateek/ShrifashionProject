import 'package:firebase_database/firebase_database.dart';
final subCategories = FirebaseDatabase.instance.reference().child("categorysub_final");
final categories = FirebaseDatabase.instance.reference().child("category");
final postalCodes = FirebaseDatabase.instance.reference().child("codes");
final partners = FirebaseDatabase.instance.reference().child("partners");
final coupons = FirebaseDatabase.instance.reference().child("coupons_master");
final customerRewards = FirebaseDatabase.instance.reference().child("customer_rewards");
final customers = FirebaseDatabase.instance.reference().child("customer");
final address = FirebaseDatabase.instance.reference().child("address");
final search = FirebaseDatabase.instance.reference().child("search");
final prod_images = FirebaseDatabase.instance.reference().child("prod_images");
final admin = FirebaseDatabase.instance.reference().child("admin");
final unitConnection = FirebaseDatabase.instance.reference().child("units");
final currencies = FirebaseDatabase.instance.reference().child("currencies");
final countries = FirebaseDatabase.instance.reference().child("countries");
final storeLocations = FirebaseDatabase.instance.reference().child("store_locations");
final users = FirebaseDatabase.instance.reference().child("users");
final banners = FirebaseDatabase.instance.reference().child("banners");
final manage_stock = FirebaseDatabase.instance.reference().child("manage_stock");
final order_ids = FirebaseDatabase.instance.reference().child("order_ids");





//**************** LAST *************

final categoriesLast = FirebaseDatabase.instance.reference().child("category").limitToLast(1);
final postalCodesLast = FirebaseDatabase.instance.reference().child("codes").limitToLast(1);
final couponsLast = FirebaseDatabase.instance.reference().child("coupons_master").limitToLast(1);
final searchLast = FirebaseDatabase.instance.reference().child("search").limitToLast(1);
final currenciesLast = FirebaseDatabase.instance.reference().child("currencies").limitToLast(1);
final countriesLast = FirebaseDatabase.instance.reference().child("countries").limitToLast(1);
final storeLocationsLast = FirebaseDatabase.instance.reference().child("store_locations").limitToLast(1);
final usersLast = FirebaseDatabase.instance.reference().child("users").limitToLast(1);
final subCategoriesLast = FirebaseDatabase.instance.reference().child("categorysub_final").limitToLast(1);
final bannersLast = FirebaseDatabase.instance.reference().child("banners").limitToLast(1);
final manage_stock_last = FirebaseDatabase.instance.reference().child("manage_stock").limitToLast(1);