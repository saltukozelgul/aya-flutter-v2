// Crate model for Firestore collectiong names listings
// It has 4 different fields: location, coordinates which is GeoPoint, ownerUsername, description
//

import 'package:cloud_firestore/cloud_firestore.dart';

class ListingsModel {
  final String location;
  final GeoPoint coordinates;
  final String ownerUsername;
  final String description;

  ListingsModel(
      {required this.location,
      required this.coordinates,
      required this.ownerUsername,
      required this.description});

  factory ListingsModel.fromMap(Map<String, dynamic> data) {
    return ListingsModel(
        location: data['location'],
        coordinates: data['coordinates'],
        ownerUsername: data['ownerUsername'],
        description: data['description']);
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'coordinates': coordinates,
      'ownerUsername': ownerUsername,
      'description': description
    };
  }
}
