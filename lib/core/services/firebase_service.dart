import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  static User? get currentUser => auth.currentUser;

  static Stream<User?> get authStateChanges => auth.authStateChanges();

  static Future<void> signOut() async {
    await auth.signOut();
  }
}
