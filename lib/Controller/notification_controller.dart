import 'package:flutter/cupertino.dart';
import '../Apis/notification_api.dart';
import '../Models/notification.dart';

class NotificationController with ChangeNotifier{

  bool waitingNotification = true;



  List<NotificationModel>? notifications;



  Future insertNewNotification(NotificationModel notificationModel)async{
    await NotificationApi.addNewNotification(notificationModel: notificationModel);
  }




  Future getNotifications(List<String> interests)async{
    waitingNotification = true;
    List<NotificationModel> notifications =await NotificationApi.getNotifications(interests);
    this.notifications = notifications;
    waitingNotification = false;
    notifyListeners();
  }

  resetWaitingNotifications(){

    waitingNotification = false;
    notifyListeners();
  }



  deleteNotification(NotificationModel notificationModel) async {
    NotificationApi.deleteNotification(notificationModel);
    notifyListeners();


  }


}