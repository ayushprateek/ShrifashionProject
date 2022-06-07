import 'package:html/parser.dart';
String customHtmlParser(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}