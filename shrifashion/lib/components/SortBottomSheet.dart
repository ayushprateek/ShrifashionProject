import 'package:flutter/material.dart';
import 'package:shrifashion/components/Font.dart';
class SortBottomSheet extends StatefulWidget {
  String sort_order;
  SortBottomSheet(String sort_order){
    this.sort_order=sort_order;
  }
  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}
class _SortBottomSheetState extends State<SortBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: widget.sort_order,
                  groupValue: "N",
                  onChanged: (val){
                    setState(() {
                      widget.sort_order="N";
                    });

                  },
                ),
                Text("None",
                  style: TextStyle(
                      fontFamily: custom_font,
                      fontSize: 17
                  ),
                )
              ],
            ),
            Row(
              children: [
                Radio(
                  value: widget.sort_order,
                  groupValue: "L",
                  onChanged: (val){
                    setState(() {
                      widget.sort_order="L";
                    });

                  },
                ),
                Text("Low to High",
                  style: TextStyle(
                      fontFamily: custom_font,
                      fontSize: 17
                  ),
                )
              ],
            ),
            Row(
              children: [
                Radio(
                  value: widget.sort_order,
                  groupValue: "H",
                  onChanged: (val){
                    setState(() {
                      widget.sort_order="H";
                    });


                  },
                ),
                Text("High to Low",
                  style: TextStyle(
                      fontFamily: custom_font,
                      fontSize: 17
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
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

