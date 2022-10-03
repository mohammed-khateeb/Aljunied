import 'package:aljunied/Models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../Constants/constants.dart';
import '../Models/current_user.dart';
import '../Models/notification.dart';

class TransactionApi{

  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<TransactionModel> addNewTransaction({required TransactionModel transactionModel}) async {

    transactionModel.createAt = Timestamp.fromDate(DateTime.now());
    transactionModel.updateAt = Timestamp.fromDate(DateTime.now());

    DocumentReference doc = db.collection(CollectionsKey.transaction).doc(transactionModel.id);

    await doc.set(transactionModel.toJson());

    return transactionModel;

  }

  static updateTransaction({required TransactionModel transactionModel}){
    transactionModel.updateAt = Timestamp.fromDate(DateTime.now());
    DocumentReference doc = db.collection(CollectionsKey.transaction).doc(transactionModel.id);
    doc.update(transactionModel.toJson());

  }

  static Future<bool> checkIfTransactionNumberExist(String number) async {
    DocumentSnapshot documentSnapshot =
    await db.collection(CollectionsKey.transaction).doc(number).get();

    return documentSnapshot.exists;



  }



  static Future<List<TransactionModel>> getCompletedEmployeeTasks() async {
    List<TransactionModel> transactions = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.transaction)
        .where("employeesId",arrayContains: CurrentUser.userId)
        .orderBy('createAt', descending: true)
        .get();

    transactions = snapshot.docs.map((e) => TransactionModel.fromJson(e.data() as Map<String, dynamic>)).toList() ;

    return transactions;

  }

  static Future<List<TransactionModel>> getUnFinishEmployeeTasks() async {
    List<TransactionModel> transactions = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.transaction)
        .where("convertToId",isEqualTo: CurrentUser.userId)
        .orderBy('createAt', descending: true)
        .get();

    transactions = snapshot.docs.map((e) => TransactionModel.fromJson(e.data() as Map<String, dynamic>)).toList() ;

    return transactions;

  }

  static Future<List<TransactionModel>> getSearchTransactions(String searchKey) async {
    List<TransactionModel> transactions = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.transaction)
        .where("keyWords",arrayContains: searchKey.toLowerCase())
        .get();

    transactions = snapshot.docs.map((e) => TransactionModel.fromJson(e.data() as Map<String, dynamic>)).toList() ;
    return transactions;
  }

  static Future<TransactionModel?> getTransactionById(String transactionId)async{
    DocumentSnapshot documentSnapshot =
    await db.collection(CollectionsKey.transaction).doc(transactionId).get();

    if(documentSnapshot.exists) {
      TransactionModel? transaction = TransactionModel.fromJson(documentSnapshot.data() as Map<String,dynamic>);
      return transaction;
    }
    return null;


  }
  static Future<List<TransactionModel>> getAllTransactions() async {
    List<TransactionModel> transactions = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.transaction)
        .orderBy("createAt",descending: true)
        .get();

    transactions = snapshot.docs.map((e) => TransactionModel.fromJson(e.data() as Map<String, dynamic>)).toList() ;
    return transactions;
  }


}