import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticate {
  final FirebaseAuth _auth;

  Authenticate(this._auth);

  Stream<User> get authStateChanges => _auth.idTokenChanges();

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Logged In";
    } catch (error) {
      return (error.code);
    }
  }

  Future<String> register(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'password': password,
        });
      });
      return "Successfully Signed In";
    } catch (error) {
      return (error.code);
    }
  }
}
