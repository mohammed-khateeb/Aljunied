
import 'package:cloud_firestore/cloud_firestore.dart';

class Area{
  String? id;
  String? name;
  String? des;
  String? imageUrl;
  Timestamp? createAt;
  String? location;

  Area({this.id,this.name, this.des,this.createAt,this.location,this.imageUrl});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    des = json['des'];
    imageUrl = json['imageUrl'];
    createAt = json['createAt'];

    location = json['location'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['des'] = des;
    data['imageUrl'] = imageUrl;
    data['createAt'] = createAt;

    data['location'] = location;
    return data;
  }
}