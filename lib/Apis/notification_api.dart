import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../Constants/constants.dart';
import '../Models/current_user.dart';
import '../Models/notification.dart';

class NotificationApi{

  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<NotificationModel> addNewNotification({required NotificationModel notificationModel}) async {

    notificationModel.createAt = Timestamp.fromDate(DateTime.now());

    DocumentReference doc = db.collection(CollectionsKey.notification).doc();

    notificationModel.id = doc.id;

    await doc.set(notificationModel.toJson());

    return notificationModel;

  }



  static Future<List<NotificationModel>> getNotifications(List<String> interests) async {
    List<NotificationModel> notifications = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.notification)
        .where("target",whereIn: interests)
        .orderBy('createAt', descending: true)
        .get();

    notifications = snapshot.docs.map((e) => NotificationModel.fromJson(e.data() as Map<String, dynamic>)).toList() ;

    return notifications;
  }




  static Future<bool> deleteNotification(NotificationModel notificationModel) async {
    try{
      DocumentReference doc = db.collection(CollectionsKey.notification).doc(notificationModel.id);
      await doc.delete();
      return true;
    }catch(_){return false;}
  }



}