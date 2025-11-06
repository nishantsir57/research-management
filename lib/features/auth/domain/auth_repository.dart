import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/firebase_service.dart';
import '../../../data/models/app_user.dart';
import '../domain/auth_role.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseService.auth,
        _firestore = firestore ?? FirebaseService.firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Stream<AppUser?> watchCurrentUser() {
    return _auth.userChanges().asyncExpand((user) {
      if (user == null) return Stream.value(null);
      return _firestore.collection('users').doc(user.uid).snapshots().map((snapshot) {
        if (!snapshot.exists) return null;
        final data = snapshot.data()!;
        return AppUser.fromJson({
          ...data,
          'id': snapshot.id,
          'role': AuthRole.fromString(data['role'] as String).name,
        });
      });
    });
  }

  Future<AppUser?> fetchCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return AppUser.fromJson({
      ...data,
      'id': doc.id,
      'role': AuthRole.fromString(data['role'] as String).name,
    });
  }

  Future<void> signOut() => _auth.signOut();

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final doc = await _firestore.collection('users').doc(credential.user!.uid).get();
    if (!doc.exists) {
      throw StateError('Profile missing for user ${credential.user!.uid}');
    }
    final data = doc.data()!;
    return AppUser.fromJson({
      ...data,
      'id': doc.id,
      'role': AuthRole.fromString(data['role'] as String).name,
    });
  }

  Future<AppUser> registerUser({
    required String email,
    required String password,
    required String displayName,
    required AuthRole role,
    String? departmentId,
    List<String>? subjectIds,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user!.updateDisplayName(displayName);

    final profile = AppUser(
      id: credential.user!.uid,
      email: email,
      displayName: displayName,
      role: role,
      departmentId: departmentId,
      subjectIds: subjectIds ?? const [],
      createdAt: DateTime.now(),
    );


    await _firestore.collection('users').doc(profile.id).set({
      'email': profile.email,
      'displayName': profile.displayName,
      'role': profile.role.name,
      'departmentId': profile.departmentId,
      'subjectIds': profile.subjectIds,
      'photoUrl': profile.photoUrl,
      'bio': profile.bio,
      'connections': profile.connections,
      'isBlocked': profile.isBlocked,
      'isReviewerApproved': profile.isReviewerApproved,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return profile;
  }

  Future<void> updateUserProfile(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set({
      'email': user.email,
      'displayName': user.displayName,
      'role': user.role.name,
      'departmentId': user.departmentId,
      'subjectIds': user.subjectIds,
      'photoUrl': user.photoUrl,
      'bio': user.bio,
      'connections': user.connections,
      'isBlocked': user.isBlocked,
      'isReviewerApproved': user.isReviewerApproved,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
