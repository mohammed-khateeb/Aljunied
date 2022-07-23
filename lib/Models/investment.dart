
import 'package:cloud_firestore/cloud_firestore.dart';

class Investment{
  String? id;
  String? userName;
  String? mobileNumber;
  String? email;
  String? des;
  Timestamp? createAt;


  Investment({this.id, this.userName,this.mobileNumber,this.email,
    this.des,
    this.createAt});

  Investment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    createAt = json['createAt'];
    des = json['des'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['mobileNumber'] = mobileNumber;
    data['email'] = email;
    data['createAt'] = createAt;
    data['des'] = des;
    return data;
  }
}