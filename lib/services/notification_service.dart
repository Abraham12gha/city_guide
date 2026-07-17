import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../screens/app_models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addNotification({
    required String title,
    required String message,
    required String type,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'title': title,
        'message': message,
        'type': type,
        'isRead': false,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }


  Future<void> addNotificationModel(
      NotificationModel notification,
      ) async {
    try {
      await _firestore
          .collection('notifications')
          .add(notification.toMap());
    } catch (e) {
      rethrow;
    }
  }


  Stream<List<NotificationModel>> getNotifications() {
    return _firestore
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) =>
            NotificationModel.fromFirestore(doc),
      )
          .toList(),
    );
  }


//   push notification

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      await _messaging.subscribeToTopic(
        'all_users',
      );
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted provisional permission');
    }
    else {
      AppSettings.openAppSettings(
        type: AppSettingsType.notification
      );
      print('User declined or has not accepted permission');
    }
  }



  Future<void> initializeFCM() async {

    await FirebaseMessaging.instance.subscribeToTopic(
      'all_users',
    );
    String? token = await FirebaseMessaging.instance.getToken();

    print('FCM Token: $token');

    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        print('Notification clicked');
        print(message.data);
      },
    );
  }
}