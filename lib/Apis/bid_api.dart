import 'package:aljunied/Models/bid.dart';
import 'package:aljunied/Models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../Constants/constants.dart';
import '../Models/current_user.dart';
import '../Models/notification.dart';

class BidApi{

  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<Bid> addNewBid({required Bid bid}) async {

    bid.createAt = Timestamp.fromDate(DateTime.now());

    DocumentReference doc = db.collection(CollectionsKey.bid).doc();

    bid.id = doc.id;

    await doc.set(bid.toJson());

    return bid;

  }

  static Future updateBid({required Bid bid})async{

    DocumentReference doc = db.collection(CollectionsKey.bid).doc(bid.id);

    await doc.update(bid.toJson());

  }

  static deleteBid(String bidId){
    db.collection(CollectionsKey.bid).doc(bidId).delete();
  }

  static Future<List<Bid>> getBids() async {
    List<Bid> bids = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.bid)
        .orderBy('createAt', descending: true)
        .get();

    bids = snapshot.docs.map((e) => Bid.fromJson(e.data() as Map<String, dynamic>)).toList() ;

    return bids;
  }




}