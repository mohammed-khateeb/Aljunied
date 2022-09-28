import 'package:aljunied/Models/bid.dart';
import 'package:aljunied/Models/news.dart';
import 'package:aljunied/Models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../Constants/constants.dart';
import '../Models/current_user.dart';
import '../Models/notification.dart';

class NewsApi{

  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<News> addNews({required News news}) async {

    news.createAt = Timestamp.fromDate(DateTime.now());

    DocumentReference doc = db.collection(CollectionsKey.news).doc();

    news.id = doc.id;

    await doc.set(news.toJson());

    return news;

  }

  static Future updateNews({required News news})async{

    DocumentReference doc = db.collection(CollectionsKey.news).doc(news.id);

    await doc.update(news.toJson());

  }



  static deleteNews(String newsId){
    db.collection(CollectionsKey.news).doc(newsId).delete();
  }

  static Future<List<News>> getNews() async {
    List<News> news = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.news)
        .orderBy('orderIndex',)
        .get();

    news = snapshot.docs.map((e) => News.fromJson(e.data() as Map<String, dynamic>)).toList() ;

    return news;
  }




}