import 'package:aljunied/Models/department.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'city.dart';

class UserApp {
  String? id;
  String? name;
  String? email;
  City? city;
  bool? isAdmin;
  String? token;
  Department? department;

  String? mobileNumber;
  Timestamp? registerAt;
  bool? isSuperAdmin;
  bool? blocked;

  UserApp(
      {this.id,
        this.name,
        this.email,
        this.city,
        this.isSuperAdmin,
        this.token,
        this.mobileNumber,
        this.registerAt,
        this.department,
        this.isAdmin = false,
        this.blocked,
      });

  UserApp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    isSuperAdmin = json['isSuperAdmin']??false;
    department =json['department']!=null? Department.fromJson(json['department']):null;
    blocked = json['blocked'] ??false;
    //city = City.fromJson(json['city']);
    isAdmin = json['isAdmin']??false;
    token = json['token'];
    registerAt = json['registerAt'];
    mobileNumber = json['mobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
   // data['city'] = city!.toJson();
    data['isSuperAdmin'] = isSuperAdmin;
    data['department'] = department!=null?department!.toJson():null;

    data['isAdmin'] = isAdmin;
    data['token'] = token;
    data['registerAt'] = registerAt;
    data['mobileNumber'] = mobileNumber;
    data['blocked'] = blocked;
    return data;
  }
}
