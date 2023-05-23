import 'dart:convert';
import 'dart:math';
import 'package:aya_flutter_v2/extensions/strings.dart';
import 'package:aya_flutter_v2/screens/models/listings_model.dart';
import 'package:aya_flutter_v2/services/listings_service.dart';
import 'package:aya_flutter_v2/widgets/title_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map/map.dart';
import '../../constants/colors.dart';
import 'package:latlng/latlng.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Listing extends StatefulWidget {
  Listing({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _ListingState createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  ListingsModel? _listingsModel;
  bool isLoaded = false;
  bool isFavorite = false;
  List<dynamic> _contactMethods = [];
  ListingsService _service = ListingsService();

  @override
  void initState() {
    super.initState();

    _service.getListingById(widget.id).then((value) async {
      _listingsModel = await ListingsModel.fromMap(value);
      // get userRef from firestore
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      // get listingRef from firestore
      DocumentReference listingRef =
          FirebaseFirestore.instance.collection('listings').doc(widget.id);

      // Update listingRef ownerUsername field
      listingRef.update({'ownerUsername': _listingsModel!.user.displayName});

      // update contact methods
      _contactMethods = _listingsModel!.user.contactMethods.map((e) {
        if (e == 'telefon') {
          return ['Telefon', Icons.phone];
        } else if (e == 'whatsapp') {
          return ['Whatsapp', FontAwesomeIcons.whatsapp];
        } else {
          return ['Telegram', FontAwesomeIcons.telegram];
        }
      }).toList();

      // check if listing is in user's favourites
      userRef.get().then((value) {
        // Convert the DocumentSnapshot to a Map<String, dynamic>
        var valueMap = value.data()!.toString();
        if (valueMap.contains(listingRef.id)) {
          setState(() {
            isFavorite = true;
            isLoaded = true;
          });
        } else {
          setState(() {
            isFavorite = false;
            isLoaded = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('İlan'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;

                // Add user's favourites field to listing reference
                DocumentReference docRef = FirebaseFirestore.instance
                    .collection('listings')
                    .doc(widget.id);

                // Add listing reference to user's favourites field
                DocumentReference userRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid);

                // If the listing is already in the user's favourites, remove it
                if (!isFavorite) {
                  userRef.update({
                    'favourites': FieldValue.arrayRemove([docRef])
                  });
                } else {
                  userRef.update({
                    'favourites': FieldValue.arrayUnion([docRef])
                  });
                }
              });
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
          ),
        ],
      ),
      body: isLoaded
          ? _Ilan(
              context,
              _listingsModel!.user.displayName,
              _listingsModel!.creationTime.toString().trFormattedDate(),
              _listingsModel!.description,
              _listingsModel!.location,
              _listingsModel!.coordinates.latitude,
              _listingsModel!.coordinates.longitude,
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Column _Ilan(BuildContext context, String user, String date, String desc,
          String loc, double lat, double lng) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ilanUsername(context, user, date),
          _centerTitleDivider(),
          _ilanDesc(desc, context),
          _centerTitleDivider("İletişim Tercihleri"),
          _ilanCom(context),
          _centerTitleDivider(),
          _ilanLocationAndTags(loc, context),
          _ilanMap(context, lat, lng),
        ],
      );

  Widget _centerTitleDivider([String? title]) {
    return title == null
        ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(
              color: AppColors.primary,
              thickness: 1,
            ),
          )
        : Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Divider(
                    color: AppColors.primary,
                    thickness: 1,
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Divider(
                    color: AppColors.primary,
                    thickness: 1,
                  ),
                ),
              ),
            ],
          );
  }

  Row _ilanUsername(BuildContext context, String user, String date) {
    return Row(
      children: [
        Row(children: [
          const Padding(
              padding: EdgeInsets.only(top: 15, left: 15),
              child: Icon(Icons.person, color: AppColors.primary, size: 30)),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: Text(user,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      color: AppColors.disable,
                      overflow: TextOverflow.ellipsis,
                    )),
          ),
        ]),
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: Text(date,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        color: AppColors.disable,
                      )),
            ),
          ),
        ),
      ],
    );
  }

  Container _ilanDesc(String desc, BuildContext context) {
    return Container(
      //ilan açıklaması kısmı
      height: 200,
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
      child: Text(
        desc,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 20,
              color: AppColors.disable,
            ),
      ),
    );
  }

  Padding _ilanLocationAndTags(String loc, BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15, top: 10, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: SizedBox(
              height: 30,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView.builder(
                itemBuilder: (context, index) => _ilanTag(
                    context,
                    _listingsModel!.tags[index]
                        .toString()
                        .capitalizeFirstChar()),
                itemCount: _listingsModel!.tags.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(loc,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 18, color: AppColors.disable)),
          ),
        ],
      ),
    );
  }

  Padding _ilanCom(BuildContext context) {
    return Padding(
      //ilan sahibi kısmı
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ..._contactMethods.map((e) => _ilanComButton(context, e)).toList(),
        ],
      ),
    );
  }

  Container _ilanMap(BuildContext context, double lat, double lng) {
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

  Container _ilanTag(BuildContext context, String index) => Container(
        //tagler için ayarlar
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(7),
        margin: const EdgeInsets.only(right: 8),
        child: Text(index.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14, color: AppColors.white)),
      );

  _ilanComButton(BuildContext context, e) {
    print(e);
    // CREATE A ROW E FIRST INDEX IS TEXT SECOND ONE IS ICONDATA
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: AppColors.primary),
      margin: const EdgeInsets.only(right: 7),
      padding: const EdgeInsets.all(7),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.only(right: 3.0),
          child: Icon(e[1], color: AppColors.white),
        ),
        Text(e[0],
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 18, color: AppColors.white)),
      ]),
    );
  }
}

class _Strings {
  static const List<String> tagler = [
    //geçici olarak eklediğimiz tagler
    "barınma",
    "ısınma",
    "bebek",
    "giyim",
    "diger",
    "barınma",
    "ısınma",
    "bebek",
    "giyim",
    "diger"
  ];
}
