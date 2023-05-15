import 'package:aya_flutter_v2/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Aya Flutter v2'),
      ),
      body: Center(
        child: TextButton(onPressed: () async {
         dynamic result = await _auth.signInAnon();
         if (result == null) {
           print('error signing in');
         } else {
           print('signed in');
           print(result);
         }
        }, child: Text("Sign in anon")),
      ),
    );
  }
}