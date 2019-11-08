import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocation Google Maps Demo',
      home: MyMap(),
    );
  }
}

class MyMap extends StatefulWidget {
  @override
  State<MyMap> createState() => MyMapSampleState();
}

class MyMapSampleState extends State<MyMap> {

  final Map<String, Marker> _markers = {};

  GoogleMapController mapController;

  var _data = '';

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 18.0,
          ),
        ),
      );
    });
  }

//  var locations = [];
//  var currentLocation;
//  bool mapToggle = false;
//  bool clientsToggle = false;
//
//  void initState() {
//    super.initState();
//    Geolocator().getCurrentPosition().then((currloc) {
//      setState(() {
//        currentLocation = currloc;
//        mapToggle = true;
//        databaseLocation();
//      });
//    });
//  }
//
//  databaseLocation(){
//    locations = [];
//    Firestore.instance.collection('locations').getDocuments().then((docs) {
//      if (docs.documents.isNotEmpty) {
//        setState(() {
//          clientsToggle = true;
//        });
//        for (int i = 0; i < docs.documents.length; ++i) {
//          locations.add(docs.documents[i].data);
//          initMarker(docs.documents[i].data);
//        }
//      }
//    });
//  }
//
//  initMarker(locations) {
//      _markers.clear();
//      final marker = Marker(
//        markerId: MarkerId("curr_loc"),
//        position: LatLng(locations['sacsac'].latitude, locations['sacsac'].longitude),
//       infoWindow: InfoWindow(title: 'Your Location'),
//      );
//      _markers["Current Location"] = marker;
//  }
////  var _data = '';


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
//        mapType: MapType.hybrid,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          _getLocation();
          getData();
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(40.688841, -74.044015),
          zoom: 11,
        ),
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: Icon(Icons.flag),
      ),
    );
  }

  Future getData() async{
    var url = 'https://oecumenical-deviati.000webhostapp.com/get.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
//    print(data.toString());
//    _data = data.toString();

  }

}

