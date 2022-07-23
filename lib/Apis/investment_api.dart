import 'package:cloud_firestore/cloud_firestore.dart';
import '../Constants/constants.dart';
import '../Models/investment.dart';

class InvestmentApi{

  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<Investment> addNewInvestment({required Investment investment}) async {

    investment.createAt = Timestamp.fromDate(DateTime.now());

    DocumentReference doc = db.collection(CollectionsKey.investment).doc();

    investment.id = doc.id;

    await doc.set(investment.toJson());

    return investment;

  }

  static deleteInvestment(String investmentId){
    db.collection(CollectionsKey.investment).doc(investmentId).delete();
  }

  static Future<List<Investment>> getInvestments() async {
    List<Investment> investments = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.investment)
        .orderBy('createAt', descending: true)
        .get();

    investments = snapshot.docs.map((e) => Investment.fromJson(e.data() as Map<String, dynamic>)).toList() ;

    return investments;
  }
}