import 'dart:math';
import 'package:aya_flutter_v2/screens/models/listings_model.dart';
import 'package:aya_flutter_v2/services/listings_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map/map.dart';
import '../../constants/colors.dart';
import 'package:latlng/latlng.dart';

class Listing extends StatefulWidget {
  Listing({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _ListingState createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  ListingsModel? _listingsModel;
  bool isLoaded = false;
  ListingsService _service = ListingsService();

  @override
  void initState() {
    super.initState();

    _service.getListingById(widget.id).then((value) {
      setState(() {
        // If we want to use user.
        // var user = value['user'].get().then((value) => print(value.data()));
        _listingsModel = ListingsModel.fromMap(value);
        isLoaded = true;
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
      ),
      body: isLoaded
          ? _Ilan(
              context,
              _listingsModel!.ownerUsername,
              "Tarih",
              _listingsModel!.description,
              _listingsModel!.location,
              _listingsModel!.coordinates.latitude,
              _listingsModel!.coordinates.longitude,
              ["wp", "telegram"],
              0)
          : const Center(child: CircularProgressIndicator()),
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
