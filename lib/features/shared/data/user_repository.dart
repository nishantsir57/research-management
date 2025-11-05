import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/app_user.dart';
import '../../../core/models/user_role.dart';

class UserRepository {
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const collectionName = 'users';

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionName);

  Future<List<AppUser>> fetchReviewers({bool onlyPending = false}) async {
    Query<Map<String, dynamic>> query =
        _collection.where('role', isEqualTo: UserRole.reviewer.name);
    if (onlyPending) {
      query = query.where('approvedReviewer', isEqualTo: false);
    }
    final snapshot = await query.get();
    return snapshot.docs.map(AppUser.fromDocument).toList();
  }

  Stream<List<AppUser>> watchUsersByRole(UserRole role) {
    return _collection.where('role', isEqualTo: role.name).snapshots().map(
          (snapshot) => snapshot.docs.map(AppUser.fromDocument).toList(),
        );
  }

  Future<void> setReviewerApproval({
    required String uid,
    required bool approved,
  }) async {
    await _collection.doc(uid).update({'approvedReviewer': approved});
  }

  Future<void> setUserBlocked({
    required String uid,
    required bool blocked,
  }) async {
    await _collection.doc(uid).update({'blocked': blocked});
  }

  Future<List<AppUser>> fetchAdmins({bool onlyPending = false}) async {
    Query<Map<String, dynamic>> query =
        _collection.where('role', isEqualTo: UserRole.admin.name);
    if (onlyPending) {
      query = query.where('approvedAdmin', isEqualTo: false);
    }
    final snapshot = await query.get();
    return snapshot.docs.map(AppUser.fromDocument).toList();
  }

  Future<void> setAdminApproval({
    required String uid,
    required bool approved,
  }) async {
    await _collection.doc(uid).update({'approvedAdmin': approved});
  }

  Future<List<AppUser>> fetchReviewersForDepartment(String department) async {
    final snapshot = await _collection
        .where('role', isEqualTo: UserRole.reviewer.name)
        .where('department', isEqualTo: department)
        .where('approvedReviewer', isEqualTo: true)
        .get();
    return snapshot.docs.map(AppUser.fromDocument).toList();
  }

  Future<AppUser?> fetchUser(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromDocument(doc);
  }

  Stream<AppUser?> watchUser(String uid) {
    return _collection.doc(uid).snapshots().map(
          (snapshot) => snapshot.exists ? AppUser.fromDocument(snapshot) : null,
        );
  }
}
