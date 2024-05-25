import 'package:firebase_messaging/firebase_messaging.dart';

String getMessageId(RemoteMessage message) {
  return message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '';
}
