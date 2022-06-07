import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> customLaunchURL(String url)
async {
  try{
    if (await canLaunch(url)) {
      await launch(url);
    }
    else {
      Fluttertoast.showToast(msg: "Something went wrong");

    }
  }
  catch(e)
  {
    Fluttertoast.showToast(msg: "Something went wrong");
  }

}