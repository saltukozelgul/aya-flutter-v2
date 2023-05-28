import 'package:aya_flutter_v2/constants/colors.dart';
import 'package:aya_flutter_v2/extensions/strings.dart';
import 'package:aya_flutter_v2/screens/home/home.dart';
import 'package:aya_flutter_v2/widgets/title_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telegramController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool isWhatsappActive = false;
  bool isTelegramActive = false;
  bool isPhoneActive = false;
  List<dynamic> _contactMethods = [];
  DocumentReference? userRef;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();

    // create document reference from users collection from uid
    userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    // get user data from firestore
    userRef?.get().then((value) {
      if (value.exists) {
        setState(() {
          userData = value.data() as Map<String, dynamic>;
          _nameController.text = userData?['displayName'];
          _phoneController.text = userData?['phoneNumber'];
          _emailController.text = userData?['email'] ?? '';
          _locationController.text = userData?['location'] ?? '';
          _telegramController.text = userData?['telegramUsername'] ?? '';
          _contactMethods = userData?['contactMethods'] ?? [];
          isWhatsappActive = _contactMethods.contains('whatsapp');
          isTelegramActive = _contactMethods.contains('telegram');
          isPhoneActive = _contactMethods.contains('telefon');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown[50],
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "editProfile",
        onPressed: () {
          // update user data
          userRef?.update({
            'displayName': _nameController.text,
            'phoneNumber': _phoneController.text,
            'email': _emailController.text,
            'location': _locationController.text,
            'telegramUsername': _telegramController.text,
            'contactMethods': _contactMethods,
          });

          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(
                        startingIndex: 1,
                      )));
        },
        backgroundColor: AppColors.primary,
        label: const Text(
          "Kaydet",
          style: TextStyle(color: AppColors.white),
        ),
        icon: const Icon(
          Icons.save,
          color: AppColors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Column(children: [
        const TitleDivider(title: "Kişisel Bilgiler"),
        _newTextField(context, "Adınız", _nameController, false),
        const SizedBox(height: 10),
        _newTextField(context, "Telefon Numaranız", _phoneController, true),
        const SizedBox(height: 10),
        _newTextField(context, "E-posta Adresiniz", _emailController, false),
        const SizedBox(height: 10),
        _newTextField(
            context, "Bulunduğunuz Şehir", _locationController, false),
        const TitleDivider(title: "İletişim Tercihleriniz"),
        _newTextFieldWithSwitch(
            context, "Whatsapp Numarası", _phoneController, true),
        const SizedBox(height: 10),
        _newTextFieldWithSwitch(
            context, "Telegram Kullanıcı Adınız", _telegramController, false),
        const SizedBox(height: 10),
        _newTextFieldWithSwitch(context, "Telefon", _phoneController, true)
      ]),
    );
  }

  Widget _newTextFieldWithSwitch(BuildContext context, String hint,
      TextEditingController controller, bool isDisable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              readOnly: isDisable,
              controller: controller,
              minLines: 1,
              maxLines: 1,
              decoration: InputDecoration(
                label: Text(hint),
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
          ),
          Switch(
            value: hint == "Whatsapp Numarası"
                ? isWhatsappActive
                : hint == "Telegram Kullanıcı Adınız"
                    ? isTelegramActive
                    : isPhoneActive,
            onChanged: (isOn) {
              setState(() {
                if (hint == 'Whatsapp Numarası') {
                  isWhatsappActive = isOn;
                  if (isOn) {
                    _contactMethods.add('whatsapp');
                  } else {
                    _contactMethods.remove('whatsapp');
                  }
                } else if (hint == 'Telegram Kullanıcı Adınız') {
                  isTelegramActive = isOn;
                  if (isOn) {
                    _contactMethods.add('telegram');
                  } else {
                    _contactMethods.remove('telegram');
                  }
                } else if (hint == 'Telefon') {
                  isPhoneActive = isOn;
                  if (isOn) {
                    _contactMethods.add('telefon');
                  } else {
                    _contactMethods.remove('telefon');
                  }
                }
              });
            },
            activeTrackColor: AppColors.primary,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _contactSection() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: _contactMethods.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        // if index is last index
        if (index == _contactMethods.length) {
          return InkWell(
            onTap: () => {},
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
            () => _contactMethods.removeAt(index),
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
                    _contactMethods[index].toString().capitalizeFirstChar(),
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

  Container _newTextField(BuildContext context, String hint,
      TextEditingController controller, bool isDisable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        readOnly: isDisable,
        controller: controller,
        minLines: 1,
        maxLines: 1,
        decoration: InputDecoration(
          label: Text(hint),
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
