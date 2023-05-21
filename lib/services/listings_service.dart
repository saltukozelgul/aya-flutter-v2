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
  Future createListing(
      String title, String description, String price, String image) async {}

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
