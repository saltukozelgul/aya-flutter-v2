import 'package:aya_flutter_v2/screens/authenticate/authenticate.dart';
import 'package:aya_flutter_v2/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    // return either home or authenticate widget
    if (user != null) {
      return Home();
    } else {
      return const Authenticate();
    }
  }
}
