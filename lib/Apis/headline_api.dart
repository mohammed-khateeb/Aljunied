import 'package:aljunied/Models/headline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Constants/constants.dart';

class HeadlineApi{

  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<Headline> addNewHeadline({required Headline headline}) async {

    DocumentReference doc = db.collection(CollectionsKey.headline).doc();

    headline.id = doc.id;

    await doc.set(headline.toJson());

    return headline;

  }

  static Future updateHeadline({required Headline headline})async{

    DocumentReference doc = db.collection(CollectionsKey.headline).doc(headline.id);

    await doc.update(headline.toJson());

  }

  static deleteHeadline(String headlineId){
    db.collection(CollectionsKey.headline).doc(headlineId).delete();
  }

  static Future<List<Headline>> getHeadlines() async {
    List<Headline> headlines = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.headline)
        .orderBy('orderIndex')
        .get();

    headlines = snapshot.docs.map((e) => Headline.fromJson(e.data() as Map<String, dynamic>)).toList() ;

    return headlines;
  }




}