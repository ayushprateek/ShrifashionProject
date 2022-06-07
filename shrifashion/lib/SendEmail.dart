import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
class Send extends StatefulWidget {
  @override
  _SendState createState() => _SendState();
}
class _SendState extends State<Send> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Center(
          child: RaisedButton(
            child: Text("Send Email"),
            onPressed: (){
              //anuj.kan@gmail.com
              //sendEmailToAdmin("ORDER#1111","Your order has been placed","Hi Ayush, we're getting your order ready to be shipped. We will notify you when it has been sent.<br><br>Thanks,<br>ECOMANDI.");
              sendEmail("ayushpratik08041999@gmail.com","Test","ORDER#1111","Your order has been placed","Hi Ayush, we're getting your order ready to be shipped. We will notify you when it has been sent.<br><br>Thanks,<br>SHRICART.");
            },
          ),
        ),
      )
    );
  }
}


Future<void> sendEmail(var recipient,var subject,var h1,var h2,var body)
async {
  String imagePath="https://shrisolutions.com/images/logos/logo.png";
  body+="<br><I>If you have any query then kindly reply to this email or contact us at sales@shrisolutions.com</I>";
  body+="<br><br><I>This email has been sent by shrisolutions for the DEMO mobile mandi app from shrisolutions.com</I>";
  String username = 'sales@shrisolutions.com';
  String password = 'sales@8899';
  //also use for gmail smtp
  //final smtpServer = gmail(username, password);
  final domainSmtp="mail.shrisolutions.com";
  //user for your own domain
  final smtpServer = SmtpServer(domainSmtp,username: username,password: password,port: 587);
  final message = Message()
    ..from = Address(username, 'SHRICART')
    ..recipients.add(recipient)
    //..recipients=[recipient]
    ..subject = subject
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<img src=$imagePath width=180><h1>$h1</h1>\n\n<h2>$h2</h2>\n\n<p>$body </p>";

  try {
    print(smtpServer.toString());
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
Future<void> sendEmailToAdmin(var h1,var h2,var body)
async {
  String imagePath="https://shrisolutions.com/images/logos/logo.png";
  body+="<br><I>If you have any query then kindly reply to this email or contact us at sales@shrisolutions.com</I>";
  String username = 'sales@shrisolutions.com';
  String password = 'sales@8899';
  final domainSmtp="mail.shrisolutions.com";
  final smtpServer = SmtpServer(domainSmtp,username: username,password: password,port: 587);
  final message = Message()
    ..from = Address(username, 'SHRICART')
    ..recipients.add("shrisolutions04@gmail.com")
  //..recipients=['ecomandiorganics@gmail.com','admin@ecomandi.com']
    //..recipients=['ayushpratik08041999@gmail.com','shrisolutions04@gmail.com']
    ..subject = 'SHRICART'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<img src=$imagePath width=180><h1>$h1</h1>\n\n<h2>$h2</h2>\n\n<p>$body </p>";

  try {
    print(smtpServer.toString());
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}