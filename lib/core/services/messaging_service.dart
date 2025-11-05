import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  MessagingService(this._messaging);

  final FirebaseMessaging _messaging;

  Future<void> initialise() async {
    await _messaging.requestPermission();
    await _messaging.setAutoInitEnabled(true);
  }

  Future<String?> getToken() => _messaging.getToken();

  Future<void> subscribeToTopic(String topic) => _messaging.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) => _messaging.unsubscribeFromTopic(topic);
}
