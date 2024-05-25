import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/config/helpers/helper.dart';
import 'package:push_app/domain/entities/post.dart';

class RemoteMessageModel {
  static Post toPost(RemoteMessage message) {
    final isAndroid = (Platform.isAndroid);

    return Post(
      postId: getMessageId(message),
      title: message.notification?.title ?? '',
      caption: message.notification?.body ?? '',
      urlImage: isAndroid ? message.notification?.android?.imageUrl ?? '' : '',
      type: message.data['type'] ?? '',
      author: message.data['author'] ?? '',
      published:
          message.sentTime ?? DateTime.now().add(const Duration(days: 2)),
    );
  }
}
