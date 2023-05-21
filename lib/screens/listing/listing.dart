import 'dart:math';
import 'package:flutter/material.dart';
import 'package:map/map.dart';
import '../../constants/colors.dart';
import 'package:latlng/latlng.dart';

class Listing extends StatefulWidget {
  const Listing({super.key});

  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  String? id;

  // final Map<dynamic, dynamic> data = {
  //   'id': ' ',
  //   'name': ' ',
  //   'decs': ' ',
  //   'loc': ' ',
  //   'phone': ' ',
  //   'tags': [],
  //   'com': [], //iletisim adresleri
  // };

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    String formattedTime = "${now.hour}:${now.minute}";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown[50],
      body: Column(
        children: [
          AppBar(
            title: const Text('İlan'),
            centerTitle: true,
          ),
          _Ilan(
              context,
              "Seda Nur Taşkan",
              "$formattedDate $formattedTime",
              "Standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make but also the leap ntially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing tandard dummy text ever since the 1500s,",
              "İstanbul",
              41.015137,
              28.979530,
              ["wp", "telegram"],
              0),
        ],
      ),
    );
  }

  Column _Ilan(BuildContext context, String user, String date, String desc,
          String loc, double lat, double lng, iletisim, int index) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ilanUsername(context, user, date),
          _ilanDesc(desc, context),
          _ilanCom(context, iletisim),
          _ilanLocationAndTags(loc, context),
          _ilanMap(context, lat, lng),
        ],
      );

  Row _ilanUsername(BuildContext context, String user, String date) {
    return Row(
      children: [
        Expanded(
          child: Row(children: [
            const Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Icon(Icons.person, color: AppColors.primary, size: 30)),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15),
              child: Text(user,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        color: AppColors.disable,
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
                        fontSize: 18,
                        color: AppColors.disable,
                      )),
            ),
          ),
        ),
      ],
    );
  }

  Padding _ilanDesc(String desc, BuildContext context) {
    return Padding(
      //ilan açıklaması kısmı
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
          SizedBox(
            height: 30,
            width: 220,
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  _ilanTag(context, _Strings.tagler[index]),
              itemCount: 5,
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

  Padding _ilanCom(BuildContext context, iletisim) {
    return Padding(
      //ilan sahibi kısmı
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: const Icon(Icons.wechat_sharp, color: AppColors.primary),
              onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.call, color: AppColors.primary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.mail, color: AppColors.primary),
            onPressed: () {},
          ),
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
