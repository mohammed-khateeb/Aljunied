
import 'package:cloud_firestore/cloud_firestore.dart';

class Bid{
  String? id;
  String? type;
  String? title;
  String? imageUrl;
  String? details;
  Timestamp? createAt;
  String? typeId;
  bool? forwarded;


  Bid({this.id,this.type, this.title,this.details,this.imageUrl,this.createAt,this.forwarded});

  Bid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    typeId = json['typeId'];
    forwarded = json['forwarded'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    details = json['details'];
    createAt = json['createAt'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['typeId'] = typeId;
    data['forwarded'] = forwarded;
    data['title'] = title;
    data['imageUrl'] = imageUrl;
    data['details'] = details;
    data['createAt'] = createAt;

    return data;
  }
}


class BidType {
  String? id;
  String? name;

  BidType(
      {this.id,
        this.name,
      });

  BidType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}





