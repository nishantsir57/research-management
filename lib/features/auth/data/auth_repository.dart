import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/app_user.dart';
import '../../../core/models/user_role.dart';

class AuthRepository {
  AuthRepository(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static const usersCollection = 'users';

  Stream<AppUser?> authStateChanges() async* {
    await for (final firebaseUser in _auth.authStateChanges()) {
      if (firebaseUser == null) {
        yield null;
      } else {
        yield await _getUser(firebaseUser.uid);
      }
    }
  }

  Future<AppUser?> currentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _getUser(user.uid);
  }

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final credential =
        await _auth.signInWithEmailAndPassword(email: email, password: password);
    return _getUser(credential.user!.uid).then((value) {
      if (value == null) {
        throw FirebaseException(
          plugin: 'AuthRepository',
          code: 'user-not-found',
          message: 'User record not found. Contact administrator.',
        );
      }
      return value;
    });
  }

  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
    required String? department,
    required List<String> subjects,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userDoc = _firestore.collection(usersCollection).doc(credential.user!.uid);
    await userDoc.set({
      'fullName': fullName,
      'email': email,
      'role': role.name,
      'department': department,
      'subjects': subjects,
      'approvedReviewer': role == UserRole.reviewer ? false : true,
      'blocked': false,
      'createdAt': FieldValue.serverTimestamp(),
      'fcmTokens': <String>[],
    });

    return (await _getUser(credential.user!.uid))!;
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> saveFcmToken(String token) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection(usersCollection).doc(uid).update({
      'fcmTokens': FieldValue.arrayUnion([token]),
    });
  }

  Future<void> removeFcmToken(String token) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection(usersCollection).doc(uid).update({
      'fcmTokens': FieldValue.arrayRemove([token]),
    });
  }

  Future<AppUser?> _getUser(String uid) async {
    final doc = await _firestore.collection(usersCollection).doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromDocument(doc);
  }
}
