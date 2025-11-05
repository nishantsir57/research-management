import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/department.dart';

class DepartmentRepository {
  DepartmentRepository(this._firestore);

  final FirebaseFirestore _firestore;
  static const collectionName = 'departments';

  Stream<List<Department>> watchDepartments() {
    return _firestore.collection(collectionName).orderBy('name').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Department.fromMap(doc.id, doc.data())).toList(),
        );
  }

  Future<List<Department>> fetchDepartments() async {
    final snapshot = await _firestore.collection(collectionName).orderBy('name').get();
    return snapshot.docs.map((doc) => Department.fromMap(doc.id, doc.data())).toList();
  }

  Future<void> addDepartment(Department department) async {
    await _firestore.collection(collectionName).add(department.toMap());
  }

  Future<void> updateDepartment(Department department) async {
    await _firestore.collection(collectionName).doc(department.id).update(department.toMap());
  }

  Future<void> deleteDepartment(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }

  Future<void> addSubject(String departmentId, String subject) async {
    await _firestore.collection(collectionName).doc(departmentId).update({
      'subjects': FieldValue.arrayUnion([subject]),
    });
  }

  Future<void> removeSubject(String departmentId, String subject) async {
    await _firestore.collection(collectionName).doc(departmentId).update({
      'subjects': FieldValue.arrayRemove([subject]),
    });
  }
}
