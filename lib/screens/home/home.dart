import 'dart:math';

import 'package:aya_flutter_v2/constants/colors.dart';
import 'package:aya_flutter_v2/extensions/strings.dart';
import 'package:aya_flutter_v2/screens/listing/listing.dart';
import 'package:aya_flutter_v2/screens/lists/lists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../../services/auth.dart';
import '../profile/profile.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _currentIndex = 0;
  Stream<QuerySnapshot<Object?>>? collectionStream = FirebaseFirestore.instance
      .collection("listings")
      .snapshots(includeMetadataChanges: true);
  late List<DocumentSnapshot> documents;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown[50],
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Data from Firestore is available
          documents = snapshot.data!.docs;
          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: _currentIndex == 0
                      ? const Text('İlanlar')
                      : _currentIndex == 1
                          ? const Text('Profil')
                          : const Text('Anasayfa'),
                  floating: true,
                  centerTitle: true,
                  elevation: 5,
                  actions: <Widget>[
                    IconButton(
                      onPressed: _auth.signOut,
                      icon: const Icon(Icons.logout),
                    ),
                  ],
                ),
              ];
            },
            body: _currentIndex == 0
                ? const Center(
                    child: ListPage(),
                  )
                : _currentIndex == 1
                    ? const Center(
                        child: ProfilePage(),
                      )
                    : _homeContent(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottom navigation bar
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.folder,
          Icons.person,
        ],
        activeIndex: 0,
        notchSmoothness: NotchSmoothness.softEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: AppColors.primary,
        activeColor: AppColors.white,
        inactiveColor: AppColors.white,
      ),
    );
  }

  Widget _homeContent() => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 15, top: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 2),
                          ),
                          hintText: "Arama",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: 18,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic),
                          suffixIcon: IconButton(
                            onPressed: () => print("arama"),
                            icon: const Icon(
                              Icons.search,
                              color: AppColors.primary,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                child: DefaultTabController(
                  length: _Strings.tagler.length,
                  child: TabBar(
                    isScrollable: true,
                    indicatorColor: AppColors.primary,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.disable,
                    tabs: [
                      //kategoriler listesi
                      for (var i = 0; i < _Strings.tagler.length; i++)
                        Tab(
                          child: Text(_Strings.tagler[i].capitalizeFirstChar(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontSize: 18, color: AppColors.disable)),
                        ),
                    ],
                  ),
                ),
              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  //physics sayesinde single child scroll view ile oluşan aşağı inememe problemi çözüldü
                  physics: const NeverScrollableScrollPhysics(),
                  //ilanlar listesi
                  shrinkWrap: true,
                  itemBuilder: (context, index) => _Ilan(
                      context,
                      documents[index]["ownerUsername"],
                      "10-10-2021",
                      documents[index]["description"],
                      documents[index]["location"],
                      documents[index]["coordinates"].latitude,
                      documents[index]["coordinates"].longitude,
                      index),
                  itemCount: documents.length,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: const FloatingActionButton(
          onPressed: null,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.add, color: Colors.white),
        ),
      );

  InkWell _Ilan(BuildContext context, String user, String date, String desc,
          String loc, double lat, double lng, int index) =>
      InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Listing(),
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
                _ilanMap(context, lat, lng),
              ],
            ),
          ),
        ),
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
