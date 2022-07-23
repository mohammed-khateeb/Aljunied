
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? id;
  String? des;
  String? title;
  String? target;

  Timestamp? createAt;

  NotificationModel(
      {this.id,
        this.des,
        this.createAt,
        this.title,
        this.target,
      });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    des = json['des'];
    createAt = json['createAt'];
    title = json['title'];
    target = json['target'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['des'] = des;
    data['createAt'] = createAt;
    data['title'] = title;
    data['target'] = target;

    return data;
  }
}
