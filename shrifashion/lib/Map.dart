import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart' hide LocationAccuracy;
import 'package:http/http.dart' as http;

import 'AddressBottomSheet.dart';

import 'components/Color.dart';
import 'mobileLogin.dart';
import 'navbar.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _formKey = GlobalKey<FormState>();

  var custAddress, city, postalCode, state, country;
  TextEditingController _location = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition cameraPosition;
  double lat, lon;

  //static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(28.7041,77.1025), zoom: 14.4746,);
  static CameraPosition _kGooglePlex;

  void initState() {

    super.initState();
    print("Init");

    cameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 17.0);
    getCurrentLocation();
  }

  Future getCurrentLocation() async {
    print("getCurrentLocation");
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.GRANTED) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.GRANTED) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        LatLng latlong = new LatLng(position.latitude, position.longitude);
        print("Printing current ");
        print(position.latitude);
        print(position.longitude);

        setState(() {
          cameraPosition = CameraPosition(target: latlong, zoom: 17.0);
          _kGooglePlex = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.4746,
          );
          updateMarker(cameraPosition);
        });
      }

      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latlong = new LatLng(position.latitude, position.longitude);
    cameraPosition = CameraPosition(target: latlong, zoom: 17.0);
    print("Printing");
    print(position.latitude);
    print(position.longitude);
    setState(() {
      _kGooglePlex = cameraPosition;
      updateMarker(cameraPosition);
    });
  }

  void updateMarker(CameraPosition position) {
    final MarkerId markerId = MarkerId("selectedLocation");
    Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position: LatLng(position.target.latitude, position.target.longitude),
        onDragEnd: ((newPosition) {
          print("drag ended");
          print(newPosition.latitude);
          print(newPosition.longitude);
        }),
        onTap: () {
          print("Location selected");
          print(position.target.latitude.toString());
          print(position.target.longitude.toString());
          address(position.target.latitude.toString(),
              position.target.longitude.toString());
        });

    markers[markerId] = marker;
  }

  Future<void> address(var lat, var long) async {
    List<Address> results = [];
    print("Address called");
    final coordinates = new Coordinates(double.parse(lat), double.parse(long));
    results = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    var first = results.first;
    if (first != null) {
      custAddress = first.featureName + "," + first.subLocality.toString();
      city = first.subAdminArea;
      postalCode = first.postalCode;
      state = first.adminArea;
      country = first.countryName;

      setState(() {
        _location.text = first.addressLine.toString().trim();
      });

      //print(custAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        // height: _height,
        // width: _width,
        child: Column(
          children: [
            Container(
              height: _height * .65,
              width: _width,
              child: _kGooglePlex != null
                  ? GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                myLocationEnabled: true,
                onCameraIdle: () {
                  address(cameraPosition.target.latitude.toString(),
                      cameraPosition.target.longitude.toString());
                },
                onCameraMove: (position) {
                  //debugPrint("Camera Position Ghulam Mustafa $position ");
                  setState(() {
                    cameraPosition = position;
                    updateMarker(cameraPosition);
                  });
                },
                markers: Set<Marker>.of(markers.values),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              )
                  : Container(
                color: Colors.white,
              ),
            ),
            Container(
              // color: HexColor("#d8ffd8"),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 7,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                height: _height * .35,
                width: _width,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 10),
                          child: new Text(
                            "Your Location",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )),

                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
//---------FirstName-----------------
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.location_on,

                                    ),
                                  ),
                                  Flexible(
                                      child: Text(
                                        _location.text,
                                        maxLines: 2,
                                      )),
                                ],
                              ),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: EdgeInsets.only(left: 10.0, right: 10.0),
                              width: _width,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),

                                onPressed: () {

                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) =>
                                          FractionallySizedBox(
                                              heightFactor: 1.4,
                                              child:  DraggableScrollableSheet(
                                                  builder: (context,
                                                      scrollController) =>
                                                      AddressBottomSheet(_location.text,postalCode.toString(),custAddress,city,state,country)
                                              )
                                          )).then((value) {
                                    Navigator.pop(context);
                                  });
                                  // Navigator.pop(context);

                                }, //ON PRESSED
                                child: Text(
                                  "Confirm Location and Proceed",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                )),
          ],
        ),
      ),

    );
  }
}