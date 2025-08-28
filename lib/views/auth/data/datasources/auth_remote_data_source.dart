import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp(String email, String password, String? displayName);
  Future<UserModel> signIn(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> signUp(String email, String password, String? displayName) async {
    try {
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const AuthFailure('Failed to create user');
      }

      // Create user model directly from Firebase Auth user
      final userModel = UserModel.create(
        id: user.uid,
        email: user.email!,
        displayName: displayName,
      );

      // Create user document in Firestore
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
       } catch (firestoreError) {
        debugPrint('AuthRemoteDataSource: Firestore creation failed: $firestoreError'); // Debug
        // Try again with merge option
        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap(), SetOptions(merge: true));
          debugPrint('AuthRemoteDataSource: User document created with merge option'); // Debug
        } catch (mergeError) {
          debugPrint('AuthRemoteDataSource: Firestore merge also failed: $mergeError'); // Debug
          // Continue with signup even if Firestore fails
        }
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthRemoteDataSource: Firebase Auth Exception: ${e.code} - ${e.message}'); // Debug
      switch (e.code) {
        case 'email-already-in-use':
          throw const AuthFailure('Email is already registered');
        case 'weak-password':
          throw const AuthFailure('Password is too weak');
        case 'invalid-email':
          throw const AuthFailure('Invalid email address');
        default:
          throw AuthFailure(e.message ?? 'Registration failed');
      }
    } catch (e) {
      debugPrint('AuthRemoteDataSource: Signup failed with error: $e'); // Debug
      throw const AuthFailure('Registration failed');
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        debugPrint('AuthRemoteDataSource: User is null after sign in'); // Debug
        throw const AuthFailure('Login failed');
      }

      // Create user model directly from Firebase Auth user
      final userModel = UserModel.create(
        id: user.uid,
        email: user.email!,
        displayName: user.displayName,
      );

      // Update user document in Firestore
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap(), SetOptions(merge: true));
      } catch (firestoreError) {
        debugPrint('AuthRemoteDataSource: Firestore update failed: $firestoreError'); // Debug
        // Try to create the document if it doesn't exist
        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());
        } catch (createError) {
          debugPrint('AuthRemoteDataSource: Firestore creation also failed: $createError'); // Debug
          // Continue with login even if Firestore fails
        }
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthRemoteDataSource: Firebase Auth Exception: ${e.code} - ${e.message}'); // Debug
      switch (e.code) {
        case 'user-not-found':
          throw const AuthFailure('User not found');
        case 'wrong-password':
          throw const AuthFailure('Incorrect password');
        case 'invalid-email':
          throw const AuthFailure('Invalid email address');
        case 'user-disabled':
          throw const AuthFailure('User account is disabled');
        default:
          throw AuthFailure(e.message ?? 'Login failed');
      }
    } catch (e) {
      debugPrint('AuthRemoteDataSource: Login failed with error: $e'); // Debug
      
      // Handle specific Firebase Auth type casting error
      if (e.toString().contains('PigeonUserDetails')) {
        debugPrint('AuthRemoteDataSource: Firebase Auth type casting error detected, using fallback'); // Debug
        // Try to get user data without updating Firestore
        try {
          final user = _auth.currentUser;
          if (user != null) {
            final userModel = UserModel.create(
              id: user.uid,
              email: user.email!,
              displayName: user.displayName,
            );
            return userModel;
          }
        } catch (fallbackError) {
          debugPrint('AuthRemoteDataSource: Fallback also failed: $fallbackError'); // Debug
        }
      }
      
      throw const AuthFailure('Login failed');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw const AuthFailure('Sign out failed');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final userModel = UserModel.create(
        id: user.uid,
        email: user.email!,
        displayName: user.displayName,
      );

      return userModel;
    } catch (e) {
      debugPrint('AuthRemoteDataSource: Failed to get current user: $e'); // Debug
      return null;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        final userModel = UserModel.create(
          id: user.uid,
          email: user.email!,
          displayName: user.displayName,
        );
        return userModel;
      } catch (e) {
        debugPrint('AuthRemoteDataSource: Error in authStateChanges: $e'); // Debug
        return null;
      }
    });
  }

  // Simple test method to verify Firebase Auth works
  Future<bool> testFirebaseAuth() async {
    try {
      final user = _auth.currentUser;
      return user != null;
    } catch (e) {
      debugPrint('AuthRemoteDataSource: Test failed: $e'); // Debug
      return false;
    }
  }
}
