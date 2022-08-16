import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../Constants/constants.dart';
import '../Utils/util.dart';

class PushNotificationServices {
  static String? fcmToken;
  static String fcmKey = 'AAAAusbY7ds:APA91bFzM--qm6K7XhiUegL6nQclOR9Fw-uHvT85y6XI0cH0KvLlMSJuj9WkYKEuazWsAEuAA27nbRyJfD_NQR8jbZZgMwq4Ef-V3c0cmox2C8MEf7OjgaDfLndaWjkyY6LWpOm_FQIK';
  static final flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('logo');

    //Initialization Settings for iOS
    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    return Future<void>.value();
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory? directory = await getExternalStorageDirectory();
    final String filePath = '${directory!.path}/$fileName.png';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static showNotification(String title, String message) async {
    AndroidNotificationDetails _androidNotificationDetails =
    const AndroidNotificationDetails(
      'channel_ID', 'channel name',
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
      fullScreenIntent: true,
      color: kPrimaryColor,
      icon: "logo",


    );

    IOSNotificationDetails _iosNotificationDetails =
    const IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1);

    var platform = NotificationDetails(
        android: _androidNotificationDetails, iOS: _iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platform,
      payload: 'PushNotification Payload',
    );
  }

  static showNotificationWithPic(String title, String message,String image) async {
    final String bigPicturePath = await _downloadAndSaveFile(
      image,
      'bigPicture',
    );
    AndroidNotificationDetails _androidNotificationDetails =
     AndroidNotificationDetails(
      'channel_ID', 'channel name',
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
      fullScreenIntent: true,
      color: kPrimaryColor,
      icon: "logo",
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        hideExpandedLargeIcon: false,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: message,
        htmlFormatSummaryText: true,
      ),


    );

    IOSNotificationDetails _iosNotificationDetails =
    const IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1);

    var platform = NotificationDetails(
        android: _androidNotificationDetails, iOS: _iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platform,
      payload: 'PushNotification Payload',
    );
  }
  static Future<void> sendMessageToTopic({required String title,required String body,required String topicName,bool withLoading = false,bool fromAdmin = false}) async {
    if(withLoading) Utils.showWaitingProgressDialog();
    await http.post( Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmKey'
        },
        body: jsonEncode({
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'sound': 'true',


        },
          'priority': 'high',

          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': "/topics/$topicName"
        })).whenComplete(() {
      if(withLoading) Utils.hideWaitingProgressDialog();
      if(fromAdmin) {
        Navigator.pop(Utils.navKey.currentContext!);
        Utils.showSuccessAlertDialog(translate(Utils.navKey.currentContext!,
            "theNotificationHasBeenSentSuccessfully"),bottom: !kIsWeb||MediaQuery.of(Utils.navKey.currentContext!).size.width<520);
      }
    }).catchError((e) {
      debugPrint('error: $e');
    });
  }

  static void sendMessageToAnyUser({required String title,required String body,required String to,bool withLoading = false}) async {
    if(withLoading) Utils.showWaitingProgressDialog();
    await http.post( Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmKey'
        },
        body: jsonEncode({
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'sound': 'true'
          },

          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': to
        })).whenComplete(() {
      if(withLoading) {
        Utils.hideWaitingProgressDialog();
        Navigator.pop(Utils.navKey.currentContext!);
        Utils.showSuccessAlertDialog(translate(Utils.navKey.currentContext!,
            "theNotificationHasBeenSentSuccessfully"),bottom: !kIsWeb||MediaQuery.of(Utils.navKey.currentContext!).size.width<520);
      }
    }).catchError((e) {
      debugPrint('error: $e');
    });
  }

  static void sendMessageToListUser({required String title,required String body,required List<String> tokens}) async {
    Utils.showWaitingProgressDialog();
    await http.post( Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmKey'
        },
        body: jsonEncode({
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'sound': 'true'
          },
          'registration_ids':tokens,
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
        })).whenComplete(() {
      Utils.hideWaitingProgressDialog();
      Navigator.pop(Utils.navKey.currentContext!);
      Utils.showSuccessAlertDialog(translate(Utils.navKey.currentContext!, "theNotificationHasBeenSentSuccessfully"));
    }).catchError((e) {
      debugPrint('error: $e');
    });
  }
}