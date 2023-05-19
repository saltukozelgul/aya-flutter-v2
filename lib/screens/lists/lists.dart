import 'package:aya_flutter_v2/constants/colors.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
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
              itemBuilder: (context, index) =>
                  _Ilan(context, "Battaniye Lazım", "Erzincan", index),
              itemCount: 8,
            ),
          ],
        ),
      ),
    );
  }

  Container _Ilan(BuildContext context, String desc, String loc, int index) =>
      Container(
        height: 200,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              //ilan açıklaması kısmı
              padding: const EdgeInsets.only(left: 15.0, right: 10, top: 20),
              child: Text(desc,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 18, color: AppColors.disable)),
            ),
            Padding(
              //tag ve konum kısmı
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 5, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                    width: 150,
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
            ),
          ],
        ),
      );

  Container _ilanTag(BuildContext context, String index) => Container(
        //tagler için ayarlar
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right: 5),
        child: Text(index.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 15, color: AppColors.disable)),
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
