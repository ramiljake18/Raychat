import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDao extends ChangeNotifier {
 final auth = FirebaseAuth.instance;
// 1
bool isLoggedIn() {
 return auth.currentUser != null;
}
// 2
String? userId() {
 return auth.currentUser?.uid;
}
//3
String? email() {
 return auth.currentUser?.email;
}
// 1
Future<String?> signup(String email, String password) async {
 try {
 // 2
 await auth.createUserWithEmailAndPassword(
 email: email,
 password: password,
 );
 // 3
 notifyListeners();
 return null;
 } on FirebaseAuthException catch (e) {
 // 4
 if (e.code == 'weak-password') {
 log('The password provided is too weak.');
 } else if (e.code == 'email-already-in-use') {
 log('The account already exists for that email.');
 }
 return e.message;
 } catch (e) {
 // 5
 log(e.toString());
 return e.toString();
 }
}
// 1
Future<String?> login(String email, String password) async {
 try {
 // 2
 await auth.signInWithEmailAndPassword(
 email: email,
 password: password,
 );
 // 3
 notifyListeners();
 return null;
 } on FirebaseAuthException catch (e) {
 if (e.code == 'weak-password') {
 log('The password provided is too weak.');
 } else if (e.code == 'email-already-in-use') {
 log('The account already exists for that email.');
 }
 return e.message;
 } catch (e) {
 log(e.toString());
 return e.toString();
 }
}
void logout() async {
 await auth.signOut();
 notifyListeners();
}
}