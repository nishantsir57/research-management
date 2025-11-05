import 'package:cloud_firestore/cloud_firestore.dart';

enum ConnectionStatus { pending, connected }

extension ConnectionStatusX on ConnectionStatus {
  String get name {
    switch (this) {
      case ConnectionStatus.pending:
        return 'pending';
      case ConnectionStatus.connected:
        return 'connected';
    }
  }

  static ConnectionStatus fromName(String? value) {
    switch (value) {
      case 'connected':
        return ConnectionStatus.connected;
      case 'pending':
      default:
        return ConnectionStatus.pending;
    }
  }
}

class UserConnection {
  UserConnection({
    required this.id,
    required this.userA,
    required this.userB,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String userA;
  final String userB;
  final ConnectionStatus status;
  final DateTime createdAt;

  factory UserConnection.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserConnection(
      id: doc.id,
      userA: data['userA'] as String? ?? '',
      userB: data['userB'] as String? ?? '',
      status: ConnectionStatusX.fromName(data['status'] as String?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userA': userA,
      'userB': userB,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
