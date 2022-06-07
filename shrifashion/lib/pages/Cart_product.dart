import 'package:shrifashion/navbar.dart';
import 'package:flutter/material.dart';

class Cart_product extends StatefulWidget {
  final name;
  final int number;
  final new_price;
  final old_price;
  final picture;
  final unit;

  Cart_product({
    this.name,
    this.number,
    this.new_price,
    this.old_price,
    this.picture,
    this.unit,
  });

  @override
  _Cart_productState createState() => _Cart_productState();
}

class _Cart_productState extends State<Cart_product> {

  int number =0;


  void subtractNumbers() {
    setState(() {
      number = number==0?number: number - 1;
    });
  }

  void addNumbers() {
    setState(() {
      number = number + 1;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        title: Text('Cart'),
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              }),
        ],
      ),
      body: GridView.builder(
        itemCount: 1,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 5)),
          itemBuilder: (BuildContext, int index) {
            return Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      /*onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                            //passing the value of the product to product_details page
                              builder: (context) => new Fruits())),
*/
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              widget.picture,
                              fit: BoxFit.cover,
                            ),
                            flex: 7,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    "images/veg_green.webp",
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Text(" "),
                                  flex: 3,
                                ),
                              ],
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    flex: 2, //elevation: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(),
                          flex: 1,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.name,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black),
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ' ${widget.unit}',
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '  \Rs${widget.old_price} ',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w900,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '  \Rs${widget.new_price} ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                // alignment: Alignment.center,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(

                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.lightGreen,
                                        ),
                                        onPressed: () {subtractNumbers();}),

                                    Text(
                                      '$number',
                                      style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    IconButton(

                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.lightGreen,
                                        ),
                                        onPressed: () {addNumbers();
                                        }),

                                  ],
                                ),
                                flex: 2,
                              ),
                            ],
                          ),
                          flex: 3,
                        ),
                      ],
                    ),

                    flex: 3, //elevation: 10,
                  )
                ],
              ),
              //),
            );
          }),
      /*new ListView(
        children: <Widget>[
          new Container(
            height: 350.0,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ' ${widget.unit}',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        flex: 1,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '  \Rs${widget.new_price} ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "\Rs${widget.old_price}",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough)),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '25% off ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                  flex: 1, //elevation: 10,
                ),
                Expanded(
                  child: Image.asset(
                    widget.picture,
                    fit: BoxFit.cover,
                  ),

                  flex: 3, //elevation: 10,
                ),
              ],
            ),
          ),

          //-----------First Button-----------------


            ],
          ),*/
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: new Text("Total Amt:"),
                subtitle: Text("230"),
              ),
            ),
            Expanded(
              child: MaterialButton(
                onPressed: () {},
                child: Text(
                  "Check out",
                  style: new TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
