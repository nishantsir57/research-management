import 'dart:async';
import 'package:get/get.dart';
import '../../../data/models/connection.dart';
import '../../auth/controllers/auth_controller.dart';
import '../domain/connection_repository.dart';

class ConnectionController extends GetxController {
  ConnectionController({ConnectionRepository? repository})
      : _repository = repository ?? ConnectionRepository();

  final ConnectionRepository _repository;
  final AuthController _authController = Get.find<AuthController>();

  final RxList<ConnectionRequest> requests = <ConnectionRequest>[].obs;
  StreamSubscription<List<ConnectionRequest>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    ever(_authController.currentUser, (_) => _watchConnections());
    _watchConnections();
  }

  bool isConnected(String userId) {
    return requests.any((req) {
      if (req.status != ConnectionStatus.accepted) return false;
      return req.requesterId == userId || req.recipientId == userId;
    });
  }

  ConnectionRequest? findRequestForUser(String userId) {
    for (final req in requests) {
      if (req.requesterId == userId || req.recipientId == userId) {
        return req;
      }
    }
    return null;
  }

  Future<void> sendRequest(String recipientId) async {
    final user = _authController.currentUser.value;
    if (user == null) throw StateError('Not authenticated');
    await _repository.sendRequest(requesterId: user.id, recipientId: recipientId);
  }

  Future<void> respond(String requestId, ConnectionStatus status) =>
      _repository.respondToRequest(requestId: requestId, status: status);

  void _watchConnections() {
    _subscription?.cancel();
    final user = _authController.currentUser.value;
    if (user == null) {
      requests.clear();
      return;
    }
    _subscription =
        _repository.watchConnections(user.id).listen(requests.assignAll);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
