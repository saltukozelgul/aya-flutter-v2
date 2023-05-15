import 'package:firebase_auth/firebase_auth.dart';

class AuthService {





  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream user auth change
  Stream<User?> get user {
    return _auth.authStateChanges();
  }


  // Sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password

  // register with email and password

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }

  }

}