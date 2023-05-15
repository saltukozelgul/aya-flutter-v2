
import 'package:flutter/material.dart';

import '../../services/auth.dart';

class Home extends StatelessWidget {
  Home({super.key});
  
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('Aya Flutter v2'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: const Icon(Icons.person),
            label: const Text('logout'),
          ),
        ],
      ),
    );
  }
}