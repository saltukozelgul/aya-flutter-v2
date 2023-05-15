import 'package:aya_flutter_v2/screens/wrapper.dart';
import 'package:aya_flutter_v2/services/auth.dart';
import 'package:aya_flutter_v2/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  // init firebaseApp
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
 

  // Write build widget againg and wrap with StreamProvider
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Wrapper(),
      ),
    );
  }
}
