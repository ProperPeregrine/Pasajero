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

  List <String>id, pass = new List();
  List <String> lat, lng = [];

      GoogleMapController mapController;

  Set<Circle> circles = Set.from([Circle(
    //circleId: CircleId(),
    center: LatLng(10.396223,123.92164),
    radius: 4000,
  )]);
/*
  void _addmarker() {

    final String val = id.toString();
    final String p = pass.toString();
    final MarkerId markerId = MarkerId(val);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat,lng),
      infoWindow: InfoWindow(
        title: ('Jeep #$val Passengers: $p/20'),
      ),
    );

    setState(() {
      _markers[val] = marker;
    });
    print(val);
  }
  */

//  final Map<String,double> _lat = 0.0;

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
//      print("_getLocation function: $_lat, $_lng");
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 13.0,
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
    return MaterialApp(
      home: Scaffold(
        body: Stack(children: <Widget>[
          GoogleMap(
//        mapType: MapType.hybrid,
            onMapCreated: (GoogleMapController controller) {
            mapController = controller;
//          _getLocation();
//          getData();
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(13.396223, 123.92164),
              zoom: 11,
            ),
            markers: _markers.values.toSet(),
            //circles: circles,
          ),
              Column(children: <Widget>[
                FloatingActionButton(
                onPressed: (){
                  _getLocation();
                  getData();
                  },
                tooltip: 'Get Location',
                child: Icon(Icons.flag),
               ),
                FloatingActionButton(
                  onPressed: (){
//                    _addmarker();
                    getData();
                    print('Hi');
                  },
                  child: Icon(Icons.flag),
                ),
             ],
            ),
          ],
        ),
      ),
    );
  }

  Future getData() async{

//    var url = 'https://oecumenical-deviati.000webhostapp.com/get.php';
    var url = 'https://oecumenical-deviati.000webhostapp.com/try.php';
    http.Response response = await http.get(url);

    List<dynamic> use = jsonDecode(response.body);

    int len = use.length;
//    var data = jsonDecode(response.body);
    print('${use.runtimeType}:$use : length is $len');
//    print(use[len-1]['id']);
    for(var i in use)
      {
        print(i['id']);
        id.add(i['id']);
        print(i['lat']);
        print(i['lng']);
        print(i['passengers']);
      }

    print(id);




//    lng = double.parse(data['lng']);
//    id = int.parse(data['Id']);
//    pass = int.parse(data['passengers']);
//
//    print("Latitude: $lat Longitude: $lng");
//    print('${lat.runtimeType}:$lat');
//    print('${lng.runtimeType}:$lng');
//    print('${id.runtimeType}:$id');

  }

}

