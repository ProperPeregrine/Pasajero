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

 // BitmapDescriptor myIcon;

  List <int>id = List<int>();
  List <int>pass = List<int>();
  List <double> lat = List<double>();
  List <double> lng = List<double>();

      GoogleMapController mapController;

//  Set<Circle> circles = Set.from([Circle(
//    //circleId: CircleId(),
//    center: LatLng(10.396223,123.92164),
//    radius: 4000,
//  )]);


  void _addmarker() {



    for(int i in id) {

      final String val = i.toString();
      final String p = pass[id.indexOf(i)].toString();
      final MarkerId markerId = MarkerId(val);

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat[id.indexOf(i)], lng[id.indexOf(i)]),
        infoWindow: InfoWindow(
          title: ('Jeep #$val Passengers: $p/20'),
        ),
       // icon: myIcon
      );

      setState(() {
        _markers[val] = marker;
      });
    }
   // print(val);
  }

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
                child: Icon(Icons.adjust),
               ),
                FloatingActionButton(
                  onPressed: (){
                    _addmarker();
                    getData();
                    print('Hi');
                  },
                  child: Icon(Icons.directions_bus),
                ),
             ],
            ),
          ],
        ),
      ),
    );
  }

//  @override
//  void initState() {
//    // TODO: implement initState
//    BitmapDescriptor.fromAssetImage(
//        ImageConfiguration(size: Size(48,48)), '../assets/jeep.jpg')
//        .then((onValue){
//      myIcon = onValue;
//    });
//  }

  Future getData() async{

//    var url = 'https://oecumenical-deviati.000webhostapp.com/get.php';
    var url = 'https://oecumenical-deviati.000webhostapp.com/try.php';
    http.Response response = await http.get(url);

    id.clear();
    pass.clear();
    lat.clear();
    lng.clear();
    List<dynamic> use = jsonDecode(response.body);

    int len = use.length;
//    var data = jsonDecode(response.body);
    print('${use.runtimeType}:$use : length is $len');

    for(var i in use)
      {
        id.add(int.parse(i['id']));
        pass.add(int.parse(i['passengers']));
        lat.add(double.parse(i['lat']));
        lng.add(double.parse(i['lng']));
      }

    print('IDs; $id');
    print('LAT: $lat');
    print('LNG: $lng');
    print('PASSENGERS: $pass');




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

