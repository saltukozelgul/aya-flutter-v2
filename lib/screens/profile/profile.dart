import 'package:aya_flutter_v2/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../listing/listing.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userMap;
  final List<dynamic> _favourites = [];
  bool isLoaded = false;

  @override
  // init state
  void initState() {
    super.initState();
    // get user from firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      _userMap = value.data();
      isLoaded = true;
      // For each DocumentReference in the user's "favorites" list, fetch the referenced document and return the list
      if (_userMap?['favourites'].isEmpty) {
        setState(() {});
        return;
      }
      _userMap?['favourites'].forEach((fav) {
        fav.get().then((value) {
          setState(() {
            _favourites.add([value.data(), value.id]);
            print(_favourites);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: isLoaded
          ? _buildProfile(context, _userMap?['displayName'],
              _userMap?['phoneNumber'], _userMap?['location'])
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Column _buildProfile(
          BuildContext context, String user, String phone, String loc) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _avatar(context),
          _userName(context, user),
          _userCom(context, phone),
          _userLoc(context, loc),
          _favTitleAndDivider(context),
          _favList(context),
        ],
      );

  Padding _avatar(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Center(
        child: CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primary,
          child: Text(
            "S",
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }

  Padding _userName(BuildContext context, String user) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: Text(
          user,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }

  Center _userCom(BuildContext context, String phone) {
    return Center(
      child: Text(
        phone,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).disabledColor,
            ),
      ),
    );
  }

  Padding _userLoc(BuildContext context, String loc) {
    return Padding(
      padding: const EdgeInsets.only(left: 125.0),
      child: Row(
        children: [
          Expanded(
            child: Row(children: [
              const Padding(
                  padding: EdgeInsets.only(top: 15, left: 15),
                  child: Icon(Icons.location_city_rounded,
                      color: AppColors.primary, size: 30)),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Text(loc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                          color: AppColors.disable,
                        )),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _favList(BuildContext context) {
    return _favourites.isEmpty
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _favourites.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                    height: 100,
                    width: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      color: AppColors.white,
                      elevation: 5,
                      child: _favIlan(index),
                    ));
              },
            ),
          );
  }

  Widget _favIlan(int index) {
    var lat = _favourites[index][0]['coordinates'].latitude;
    var long = _favourites[index][0]['coordinates'].longitude;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Listing(
              id: _favourites[index][1],
            ),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              'https://www.google.com/maps/vt/pb=!1m4!1m3!1i14!2i$lat!3i$long!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425',
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _favourites[index][0]['ownerUsername'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    color: AppColors.disable,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Row _favTitleAndDivider(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 15),
          child: Icon(Icons.favorite, color: AppColors.primary, size: 30),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15),
          child: Text(
            "Favoriler",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  color: AppColors.disable,
                ),
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 15),
            child: Divider(
              color: AppColors.primary,
              thickness: 2,
            ),
          ),
        ),
      ],
    );
  }
}
