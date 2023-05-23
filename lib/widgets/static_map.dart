import 'dart:math';

import 'package:flutter/material.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';

class StaticMap extends StatelessWidget {
  const StaticMap(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.zoom});
  final double latitude;
  final double longitude;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    return mapWidget(context, latitude, longitude);
  }

  Container mapWidget(BuildContext context, double lat, double lng) {
    return Container(
      //maps kısmı
      height: 260,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0), topRight: Radius.circular(0)),
      ),
      clipBehavior: Clip.hardEdge,
      width: MediaQuery.of(context).size.width,
      child: MapLayout(
        controller: MapController(
          location: LatLng(lat, lng),
          zoom: 14,
        ),
        builder: (context, transformer) {
          return TileLayer(
            builder: (context, x, y, z) {
              final tilesInZoom = pow(2.0, z).floor();

              while (x < 0) {
                x += tilesInZoom;
              }
              while (y < 0) {
                y += tilesInZoom;
              }

              x %= tilesInZoom;
              y %= tilesInZoom;

              //Google Maps
              final url =
                  'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

              return Image.network(
                url,
                fit: BoxFit.cover,
              );
            },
          );
        },
      ),
    );
  }
}
