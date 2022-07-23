
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminInfo{
  int? usersNumber;
  int? shopsNumber;
  int? offersNumber;
  int? notificationsNumber;
  int? pendingOffersNumber;
  int? pendingNotificationsNumber;
  int? allowedNotificationNumber;

  AdminInfo({this.usersNumber,this.shopsNumber,
    this.notificationsNumber, this.pendingNotificationsNumber,
    this.offersNumber,this.pendingOffersNumber,this.allowedNotificationNumber});

  AdminInfo.fromJson(Map<String, dynamic> json) {
    usersNumber = json['usersNumber'];
    shopsNumber = json['shopsNumber'];
    allowedNotificationNumber = json['allowedNotificationNumber'];
    notificationsNumber = json['notificationsNumber'];

    pendingNotificationsNumber = json['pendingNotificationsNumber'];
    offersNumber = json['offersNumber'];
    pendingOffersNumber = json['pendingOffersNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usersNumber'] = usersNumber;
    data['shopsNumber'] = shopsNumber;
    data['notificationsNumber'] = notificationsNumber;
    data['pendingNotificationsNumber'] = pendingNotificationsNumber;
    data['offersNumber'] = offersNumber;
    data['pendingOffersNumber'] = pendingOffersNumber;
    data['allowedNotificationNumber'] = allowedNotificationNumber;

    return data;
  }
}