import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'constants.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  List<LatLng> polylineCordinates = [];

  void getPolyLines() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    print("---------------------------------------------");
    print(result.points);
    if (result.points.isNotEmpty) {
      print(polylineCordinates);
      for (var point in result.points) {
        polylineCordinates.add(LatLng(point.latitude, point.longitude));
        setState(() {});
      }
    }
    else{
      print("---------------------------------------------");
      print("API not working");
    }
    }


  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    getPolyLines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track order",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Center(
        child: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: sourceLocation, zoom: 14.5),
          polylines: {
            Polyline(
              polylineId: PolylineId("route"),
              points: polylineCordinates,
              color: Colors.orange
            )
          },
          markers: {
            Marker(
              markerId: MarkerId("source"),
              position: sourceLocation,
            ),
            Marker(
              markerId: MarkerId("destination"),
              position: destination,
            )
          },
        ),
      ),
    );
  }
}
