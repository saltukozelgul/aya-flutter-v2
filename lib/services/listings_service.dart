// Firestore CRUD operations for listings

import 'package:cloud_firestore/cloud_firestore.dart';

class ListingsService {
  final CollectionReference listingsCollection =
      FirebaseFirestore.instance.collection('listings');

  // Get all listings
  Future getAllListings() async {
    try {
      QuerySnapshot snapshot = await listingsCollection.get();
      return snapshot.docs;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get listing by id
  Future getListingById(String id) async {
    try {
      DocumentSnapshot snapshot = await listingsCollection.doc(id).get();
      return snapshot.data();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Create listing
  // coordinates is GeoPoint
  // creationTime is DateTime
  // description is String
  // location is String
  // tags is List<String>
  // user is DocumentReference
  Future createListing(
      String ownerUsername,
      GeoPoint coordinates,
      DateTime creationTime,
      String description,
      String location,
      List<String> tags,
      DocumentReference user) async {
    try {
      await listingsCollection.add({
        'ownerUsername': ownerUsername,
        'coordinates': coordinates,
        'creationTime': creationTime,
        'description': description,
        'location': location,
        'tags': tags,
        'user': user
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Update listing
  Future updateListing(String id, String title, String description,
      String price, String image) async {}

  // Delete listing
  Future deleteListing(String id) async {
    try {
      await listingsCollection.doc(id).delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
