import 'package:aljunied/Models/complaint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Constants/constants.dart';

class ComplaintApi{

  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<Complaint> addNewComplaint({required Complaint complaint}) async {

    complaint.createAt = Timestamp.fromDate(DateTime.now());

    DocumentReference doc = db.collection(CollectionsKey.complaint).doc();

    complaint.id = doc.id;

    await doc.set(complaint.toJson());

    return complaint;

  }

  static void answerQuestion(
      Complaint complaint)  {
    DocumentReference complaintDoc =
    db.collection(CollectionsKey.complaint).doc(complaint.id);

    complaintDoc.update({
      "answer": complaint.answer,
    });

    return ;
  }

  static deleteComplaint(String complaintId){
    db.collection(CollectionsKey.complaint).doc(complaintId).delete();
  }

  static Future<List<Complaint>> getComplaints(int kind) async {
    List<Complaint> complaints = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.complaint)
        .where("kind",isEqualTo: kind)
        .orderBy('createAt', descending: true)
        .get();

    complaints = snapshot.docs.map((e) => Complaint.fromJson(e.data() as Map<String, dynamic>)).toList() ;

    return complaints;
  }
}