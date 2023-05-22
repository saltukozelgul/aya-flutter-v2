// Crate model for Firestore collectiong names listings
// It has 4 different fields: location, coordinates which is GeoPoint, ownerUsername, description
//

import 'package:aya_flutter_v2/screens/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingsModel {
  final String location;
  final GeoPoint coordinates;
  final String ownerUsername;
  final String description;
  final DateTime creationTime;
  final UserModel user;

  ListingsModel(
      {required this.location,
      required this.coordinates,
      required this.ownerUsername,
      required this.description,
      required this.creationTime,
      required this.user});

  static Future<ListingsModel> fromMap(Map<String, dynamic> data) async {
    var user = await data['user'].get();
    var userMap = await user.data();
    print(userMap);
    return ListingsModel(
        location: data['location'],
        coordinates: data['coordinates'],
        ownerUsername: data['ownerUsername'],
        description: data['description'],
        creationTime: data['creationTime'].toDate(),
        user: UserModel.fromMap(userMap));
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
