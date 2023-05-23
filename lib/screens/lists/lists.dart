import 'dart:math';

import 'package:aya_flutter_v2/constants/colors.dart';
import 'package:aya_flutter_v2/extensions/strings.dart';
import 'package:aya_flutter_v2/screens/listing/listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var documents = [];

  @override
  void initState() {
    super.initState();

    // get document from listing collection that has user reference is equal to active auth user reference

    //FierebaseAuth active user Firestore refernce
    var userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    FirebaseFirestore.instance
        .collection('listings')
        .where('user', isEqualTo: userRef)
        .get()
        .then((value) {
      setState(() {
        documents = value.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    String formattedTime = "${now.hour}:${now.minute}";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //single child scroll view kullanıldı çünkü ekran küçük olduğunda hata veriyordu, overflow oluyordu
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListView.builder(
              //physics sayesinde single child scroll view ile oluşan aşağı inememe problemi çözüldü
              physics: const NeverScrollableScrollPhysics(),
              //ilanlar listesi
              shrinkWrap: true,
              itemBuilder: (context, index) => _Ilan(
                  context,
                  documents[index]['ownerUsername'],
                  DateTime.fromMicrosecondsSinceEpoch(documents[index]
                              ["creationTime"]
                          .microsecondsSinceEpoch)
                      .toString()
                      .trFormattedDate(),
                  documents[index]["description"],
                  documents[index]["location"],
                  documents[index]["tags"].cast<String>(),
                  documents[index]["coordinates"].latitude,
                  documents[index]["coordinates"].longitude,
                  documents[index].id,
                  index),
              itemCount: documents.length,
            ),
          ],
        ),
      ),
    );
  }

  InkWell _Ilan(
          BuildContext context,
          String user,
          String date,
          String desc,
          String loc,
          List<String> tags,
          double lat,
          double long,
          String id,
          int index) =>
      InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Listing(
              id: id,
            ),
          ),
        ),
        child: Container(
          height: 300,
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Card(
            color: AppColors.white,
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ilanUsername(user, date, context),
                _ilanDesc(desc, context),
                _ilanLocationAndTags(loc, context),
                _ilanMap(context, lat, long),
              ],
            ),
          ),
        ),
      );

  Padding _ilanLocationAndTags(String loc, BuildContext context) {
    return Padding(
      //tag ve konum kısmı
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 30,
            width: 150,
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  _ilanTag(context, _Strings.tagler[index]),
              itemCount: 2,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Text(loc,
              textAlign: TextAlign.right,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 18, color: AppColors.disable)),
        ],
      ),
    );
  }

  Padding _ilanDesc(String desc, BuildContext context) {
    return Padding(
      //ilan açıklaması kısmı
      padding: const EdgeInsets.only(left: 15.0, right: 10, top: 5),
      child: Text(desc,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 18, color: AppColors.disable)),
    );
  }

  Row _ilanUsername(String user, String date, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(children: [
            const Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Icon(Icons.person, color: AppColors.primary, size: 25)),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15),
              child: Text(user,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        color: AppColors.disable,
                        fontWeight: FontWeight.bold,
                      )),
            ),
          ]),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: Text(date,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        color: AppColors.disable,
                      )),
            ),
          ),
        ),
      ],
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

  Container _ilanMap(BuildContext context, double lat, double lng) {
    return Container(
      //maps kısmı
      height: 150,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
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
