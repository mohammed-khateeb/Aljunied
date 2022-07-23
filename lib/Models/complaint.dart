import 'package:cloud_firestore/cloud_firestore.dart';

class Complaint{
  String? id;
  String? userName;
  String? mobileNumber;

  String? imageUrl;
  String? details;
  int? citizenNumber;
  String? typeId;
  String? type;
  Timestamp? createAt;


  Complaint({this.id, this.userName,this.details,this.imageUrl,
    this.citizenNumber,this.typeId,this.type,
    this.createAt,this.mobileNumber});

  Complaint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    imageUrl = json['imageUrl'];
    details = json['details'];
    createAt = json['createAt'];
    citizenNumber = json['citizenNumber'];
    type = json['type'];
    mobileNumber = json['mobileNumber'];
    typeId = json['typeId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['imageUrl'] = imageUrl;
    data['details'] = details;
    data['createAt'] = createAt;
    data['mobileNumber'] = mobileNumber;

    data['citizenNumber'] = citizenNumber;
    data['type'] = type;
    data['typeId'] = typeId;

    return data;
  }
}

class ComplaintType {
  String? id;
  String? name;

  ComplaintType(
      {this.id,
        this.name,
      });

  ComplaintType.fromJson(Map<String, dynamic> json) {
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





