
import 'package:cloud_firestore/cloud_firestore.dart';

class News{
  String? id;
  String? title;
  String? imageUrl;
  String? details;
  String? facebookLink;
  String? twitterLink;
  String? instagramLink;
  String? snapchatLink;
  int? orderIndex;

  Timestamp? createAt;


  News({this.id, this.title,this.details,this.imageUrl,
    this.orderIndex,
    this.facebookLink,this.snapchatLink,this.twitterLink,this.instagramLink,
    this.createAt});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    details = json['details'];
    orderIndex = json['orderIndex'];
    createAt = json['createAt'];
    facebookLink = json['facebookLink'];
    snapchatLink = json['snapchatLink'];
    twitterLink = json['twitterLink'];
    instagramLink = json['instagramLink'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['imageUrl'] = imageUrl;
    data['orderIndex'] = orderIndex;
    data['details'] = details;
    data['createAt'] = createAt;
    data['facebookLink'] = facebookLink;
    data['snapchatLink'] = snapchatLink;
    data['twitterLink'] = twitterLink;
    data['instagramLink'] = instagramLink;

    return data;
  }
}