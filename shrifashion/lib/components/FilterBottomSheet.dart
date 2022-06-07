import 'package:flutter/material.dart';
import 'package:shrifashion/components/Font.dart';


class SliderTutorial extends StatefulWidget {

  @override
  _SliderTutorialState createState() => _SliderTutorialState();
}

class _SliderTutorialState extends State<SliderTutorial> {
  int age = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Slider(
            label: "Select Age",
            value: age.toDouble(),
            onChanged: (value) {
              setState(() {
                age = value.toInt();
              });
            },
            min: 5,
            max: 100,
          ),
          Text(
            "Your Age: " + age.toString(),
            style: const TextStyle(
              fontSize: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  String sort_order;
  FilterBottomSheet(String sort_order){
    this.sort_order=sort_order;
  }
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}
class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // RangeSlider(
            //   values: _currentRangeValues,
            //   min: 0,
            //   max: 100,
            //   divisions: 10,
            //
            //   labels: RangeLabels(
            //     _currentRangeValues.start.round().toString(),
            //     _currentRangeValues.end.round().toString(),
            //   ),
            //   onChangeStart: (RangeValues values) {
            //     setState(() {
            //       _currentRangeValues = values;
            //     });
            //   },
            //   onChangeEnd: (RangeValues values) {
            //     setState(() {
            //       _currentRangeValues = values;
            //     });
            //   },
            //   onChanged: (RangeValues values) {
            //     setState(() {
            //       _currentRangeValues = values;
            //     });
            //   },
            // ),
            // SizedBox(
            //   height: 15,
            // ),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width/3,
                      height: MediaQuery.of(context).size.height/17,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,

                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10.0,
                            spreadRadius: 5,
                            offset: const Offset(0.0, 5.0),
                          ),
                        ],
                      ),
                      child: RaisedButton(
                          textColor: Colors.white,
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child:  FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white70
                                ),
                              ))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width/3,
                      height: MediaQuery.of(context).size.height/17,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,

                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10.0,
                            spreadRadius: 5,
                            offset: const Offset(0.0, 5.0),
                          ),
                        ],
                      ),
                      child: RaisedButton(
                          textColor: Colors.white,
                          onPressed: () async {
                            Navigator.pop(context,widget.sort_order);
                          },
                          child:  FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    color: Colors.white70
                                ),
                              ))),
                    ),
                  ),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}

