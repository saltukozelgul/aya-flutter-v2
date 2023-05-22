import 'package:aya_flutter_v2/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;

  // Controller to get the text from the TextFormField widget.
  final TextEditingController _phoneNumberController = TextEditingController();
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');

  // Verification code entered by the user.
  final TextEditingController _smsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              color: AppColors.primary,
              height: 250,
              child: Center(child: Text("Buraya Logo gelcek")),
            ),
            _phoneInput(),
            _signInButton(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton _signInButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Get the user's phone number from the TextFormField widget.
        if (number.phoneNumber!.length != 13) {
          print('Lütfen geçerli bir telefon numarası giriniz.');
          return;
        }
        final String phoneNumber = number.phoneNumber!;

        // Send the code to the user's phone.
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          //timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            // ANDROID ONLY!
            // Sign the user in (or link) with the auto-generated credential
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('Numara geçersiz.');
            }
          },
          codeSent: (String verificationId, int? resendToken) async {
            this.verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Auto-resolution timed out...
          },
        );

        // Show the dialog.
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Doğrulama Kodu Giriniz'),
              content: TextFormField(
                controller: _smsController,
                decoration: const InputDecoration(
                  labelText: 'Doğrulama Kodu',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen doğrulama kodunu giriniz.';
                  }
                  return null;
                },
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    // Get the verification code from the dialog.
                    final String smsCode = _smsController.text;

                    // Create a PhoneAuthCredential with the code
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                      verificationId: verificationId ?? '',
                      smsCode: smsCode,
                    );

                    // Sign the user in (or link) with the credential
                    var userCredential =
                        await _auth.signInWithCredential(credential);

                    // Create user in firestore if there isn't
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userCredential.user!.uid)
                        .set({
                      'uid': userCredential.user!.uid,
                      'phoneNumber': userCredential.user!.phoneNumber,
                      'displayName': userCredential.user!.displayName,
                      'photoURL': userCredential.user!.photoURL,
                      'email': userCredential.user!.email,
                      'creationTime':
                          userCredential.user!.metadata.creationTime,
                      'lastSignInTime':
                          userCredential.user!.metadata.lastSignInTime,
                    });

                    // close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Giriş Yap'),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        // border radius
        shadowColor: AppColors.primary,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // Make wide %50
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text('GİRİŞ YAP'),
    );
  }

  Widget _phoneInput() {
    return Container(
      // border
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InternationalPhoneNumberInput(
        countries: const ['TR', 'SY'],
        onInputChanged: (PhoneNumber number) {
          if (number.phoneNumber!.length == 13) {
            this.number = number;
          }
        },
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
        ),
        ignoreBlank: true,
        hintText: "Telefon Numarası",
        errorMessage: "Lütfen geçerli bir telefon numarası giriniz.",
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: const TextStyle(color: Colors.black),
        initialValue: number,
        textFieldController: _phoneNumberController,
        formatInput: true,
        spaceBetweenSelectorAndTextField: 0,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        onSaved: (PhoneNumber number) {
          print('On Saved: $number');
        },
      ),
    );
  }
}
