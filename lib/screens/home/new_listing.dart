import 'package:aya_flutter_v2/widgets/interactive_map.dart';
import 'package:aya_flutter_v2/widgets/title_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import '../../constants/colors.dart';
import '../../services/listings_service.dart';

class NewListing extends StatefulWidget {
  NewListing({super.key});
  final service = ListingsService();

  @override
  State<NewListing> createState() => _NewListingState();
}

class _NewListingState extends State<NewListing> {
  final TextEditingController _descriptionController = TextEditingController();
  double markerX = -100;
  double markerY = -100;
  LatLng markerPoint = const LatLng(0, 0);
  void _onClickMap(LatLng point, double x, double y) {
    setState(() {
      markerX = x;
      markerY = y;
      markerPoint = point;
    });
  }

  final List<String> _tags = [];
  final List<String> _allTags = [
    "Barıma",
    "Yemek",
    "Kıyafet",
    "İlaç",
    "Sağlık"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Yeni İlan'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const TitleDivider(title: "İlan Bilgileri"),
          _newTextField(
              context,
              "Nelere ihtiyacınız olduğunu ve isteklerinizin tümünü bu kısımda belirtebilirsiniz.",
              _descriptionController),
          _tagContainer(),
          const TitleDivider(title: "Konum Bilgileri"),
          Expanded(
            child: Stack(children: [
              Container(
                color: Colors.white,
                child: Center(
                  child: InteractiveMapPage(onClickMap: _onClickMap),
                ),
              ),
              Positioned(
                  top: markerY - 35,
                  left: markerX - 20,
                  child: const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 40,
                  )),
              Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.primary,
                    ),
                    height: 30,
                    margin: const EdgeInsets.all(5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Center(
                      child: Text(
                          markerPoint.latitude == 0
                              ? "Konum Seçiniz"
                              : "Lat: ${markerPoint.latitude.toStringAsFixed(4)} Lng: ${markerPoint.longitude.toStringAsFixed(4)}",
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ))
            ]),
          ),
        ],
      ),
      // Save button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // if markerpoint is zero
          if (markerPoint.latitude == 0 || markerPoint.longitude == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.primary,
                content: Text(
                  "Lütfen konum seçiniz",
                  style: TextStyle(color: AppColors.white, fontSize: 16),
                ),
              ),
            );
            return;
          }
          // If description is empty
          if (_descriptionController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.primary,
                content: Text(
                  "Lütfen açıklama giriniz",
                  style: TextStyle(color: AppColors.white, fontSize: 16),
                ),
              ),
            );
            return;
          }

          // if everything is ok
          // save document to firestore
          // Get user uid from firebase auth
          _saveToFirestore();
        },
        label: const Text('Kaydet'),
        icon: const Icon(Icons.save),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
    );
  }

  void _saveToFirestore() {
    // if everything is ok
    // save document to firestore
    // Get user uid from firebase auth
    final user = FirebaseAuth.instance.currentUser;
    // create document reference from users collection from uid
    final DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);
    String username = user?.displayName ?? "Anonim";
    if (username == "") {
      username = "Anonim";
    }
    widget.service.createListing(
        username,
        GeoPoint(markerPoint.latitude, markerPoint.longitude),
        DateTime.now(),
        _descriptionController.text,
        "Ankara",
        _tags.map((e) => e.toLowerCase()).toList(),
        userRef);

    // Pop current page and show snackbar for succes save
    Navigator.pop(context);
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.primary,
        content: Text(
          "İlanınız başarıyla oluşturuldu",
          style: TextStyle(color: AppColors.white, fontSize: 16),
        ),
      ),
    );
  }

  SizedBox _tagContainer() {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          const TitleDivider(title: "Etiketler"),
          _tagSection(),
        ],
      ),
    );
  }

  GridView _tagSection() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: _tags.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        // if index is last index
        if (index == _tags.length) {
          return InkWell(
            onTap: _addNewTag,
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.primary,
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          );
        }
        return InkWell(
          onTap: () => setState(
            () => _tags.removeAt(index),
          ),
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.primary,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    _tags[index],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _addNewTag() => {
        // Open a dialog to list all tags
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Etiketler"),
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.2,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: _allTags.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    // If tag is already selected return empty container
                    return InkWell(
                      onTap: () => setState(() => {
                            if (!_tags.contains(_allTags[index]))
                              {
                                _tags.add(_allTags[index]),
                                Navigator.pop(context),
                              }
                          }),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: _tags.contains(_allTags[index])
                              ? AppColors.primary
                              : AppColors.white,
                        ),
                        child: Center(
                          child: Text(
                            _allTags[index],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: _tags.contains(_allTags[index])
                                      ? AppColors.white
                                      : AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      };

  Container _newTextField(
      BuildContext context, String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        minLines: 5,
        maxLines: 5,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
