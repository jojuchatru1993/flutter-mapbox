import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class FullScreenMap extends StatefulWidget {
  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController mapController;

  final center = LatLng(45.411298, -71.886248);

  final darkTheme = 'mapbox://styles/jojuchatru1993/ckn7nb5b2107k17o3siebsqob';
  final streetTheme =
      'mapbox://styles/jojuchatru1993/ckn7ndjuz0ktb17p7c2o3o9q9';

  String selectedStyle =
      'mapbox://styles/jojuchatru1993/ckn7nb5b2107k17o3siebsqob';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl(
        "networkImage", Uri.parse("https://via.placeholder.com/50"));
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: _createMap(), floatingActionButton: _buttons());
  }

  Column _buttons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
            child: Icon(Icons.emoji_symbols),
            onPressed: () {
              mapController.addSymbol(SymbolOptions(
                  geometry: center,
                  iconImage: 'assetImage',
                  textField: 'Point here',
                  textOffset: Offset(0, 2)));
            }),
        SizedBox(height: 5.0),
        FloatingActionButton(
            child: Icon(Icons.zoom_in),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomIn());
            }),
        SizedBox(height: 5.0),
        FloatingActionButton(
            child: Icon(Icons.zoom_out),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomOut());
            }),
        SizedBox(height: 5.0),
        FloatingActionButton(
            child: Icon(Icons.add_to_home_screen),
            onPressed: () {
              if (selectedStyle == darkTheme) {
                selectedStyle = streetTheme;
              } else {
                selectedStyle = darkTheme;
              }

              setState(() {});
            })
      ],
    );
  }

  MapboxMap _createMap() {
    return MapboxMap(
      styleString: selectedStyle,
      accessToken:
          'pk.eyJ1Ijoiam9qdWNoYXRydTE5OTMiLCJhIjoiY2tuN2w3azB1MHAxaTJ2cDcybTViM2YxaCJ9.ETTI1_Z0PES5CvqT8WRdeg',
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: center, zoom: 14),
      onStyleLoadedCallback: _onStyleLoaded,
    );
  }
}
