import 'package:shrifashion/mobileLogin.dart';
import 'package:shrifashion/mobileOTP.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'OrderPlaced.dart';
import 'Payment.dart';
import 'package:shrifashion/pages/Cart.dart';
import 'package:firebase_database/firebase_database.dart';
class CheckRazor extends StatefulWidget {
  @override
  _CheckRazorState createState() => _CheckRazorState();
}
class _CheckRazorState extends State<CheckRazor> {
  Razorpay _razorpay = Razorpay();
  var options;
  Future payData() async {
    try {
      _razorpay.open(options);
    } catch (e) {
    }
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    _razorpay.clear();
    rewardUpdate(points.toStringAsFixed(0));
    await sendCartOrder();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        OrderPlaced()), (Route<dynamic> route) => false);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    hasOrdered=false;
    print(response.toString());
    animated_dialog_box.showScaleAlertBox(
        title:Center(child: Text("Payment Failed!")) , // IF YOU WANT TO ADD
        context: context,
        firstButton: MaterialButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          child: Text('Logout',style: TextStyle(color:Colors.white ),),
          onPressed: () {

          },
        ),
        secondButton: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: Colors.white,
          child: Text('Go back'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
        yourWidget: Container(
          child: Text('Oops! Something went wrong...'),
        ));
    _razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    hasOrdered=false;

    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    options = {
      //'key': "rzp_live_21JdsCysdY1aGj", // Enter the Key ID generated from the Dashboard
      'key':"rzp_test_0FAeeRrrMvtzwe",
      'amount': (toPay*100), //in the smallest currency sub-unit.
      //'amount': 100, //in the smallest currency sub-unit.
      'name': 'Shrifashion',
      'currency': "INR",
      'theme.color': "#31BFAF",
      'prefill': {
        'contact': mobile.toString(),
        'email': email.toString(),
      },
      'external': {
        'wallets': ['paytm']
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: payData(),
          builder: (context, snapshot) {
            return Container(
              child: Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
