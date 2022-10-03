import 'package:aljunied/Apis/transaction_api.dart';
import 'package:aljunied/Models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

class TransactionController with ChangeNotifier {
  TransactionModel? transaction;
  int taskType = 0;
  List<TransactionModel>? allTasks;
  List<TransactionModel>? completedTasks;
  List<TransactionModel>? searchTransactions;
  List<TransactionModel>? unFinishTasks;
  List<TransactionModel>? todayTasks;
  List<TransactionModel>? todayCompletedTasks;
  List<TransactionModel>? todayUnFinishTasks;
  List<TransactionModel>? allTransactions;
  bool waitingAllTransactions = true;
  bool waitingTasks = true;
  bool waitingCitizenTransaction = true;
  bool waitingSearchTransactions = true;

  Future insertTransaction({required TransactionModel transaction}) async {
    await TransactionApi.addNewTransaction(transactionModel: transaction);
    todayTasks??=[];
    todayCompletedTasks??=[];
    todayCompletedTasks!.insert(0,transaction);
    todayTasks!.insert(0,transaction);
    notifyListeners();
  }

  updateTransaction({required TransactionModel transaction}) {
    TransactionApi.updateTransaction(transactionModel: transaction);
    this.transaction = transaction;
    notifyListeners();
  }

  convertTransaction({required TransactionModel transaction}) {
    unFinishTasks ??= [];
    completedTasks ??= [];
    todayUnFinishTasks??=[];
    todayCompletedTasks??=[];
    if(todayUnFinishTasks!.firstWhereOrNull((element) => element.id==transaction.id)!=null){
      todayUnFinishTasks!.removeWhere((element) => element.id == transaction.id);
      todayCompletedTasks!.add(transaction);
    }
    else if(unFinishTasks!.firstWhereOrNull((element) => element.id==transaction.id)!=null){
      unFinishTasks!.removeWhere((element) => element.id == transaction.id);
      completedTasks!.add(transaction);
    }
    notifyListeners();
  }

  Future setTransactionDetails(TransactionModel transaction) async {
    this.transaction = transaction;
    notifyListeners();
  }

  Future getTransactionById(String transactionId) async {
    waitingCitizenTransaction = true;
    TransactionModel? transaction =
        await TransactionApi.getTransactionById(transactionId);
    this.transaction = transaction;
    waitingCitizenTransaction = false;
    notifyListeners();
  }

  Future resetTransactionDetails() async {
    transaction = null;
    notifyListeners();
  }

  changeTaskType(int index) {
    taskType = index;
    notifyListeners();
  }

  Future<bool> checkIfTransactionNumberExist(String number) async {
    return await TransactionApi.checkIfTransactionNumberExist(number);
  }

  Future getEmployeeTasks() async {
    completedTasks = await TransactionApi.getCompletedEmployeeTasks();
    unFinishTasks = await TransactionApi.getUnFinishEmployeeTasks();
    if (completedTasks != null &&
        completedTasks!.isNotEmpty &&
        unFinishTasks != null &&
        unFinishTasks!.isNotEmpty) {
      for (int i = 0; i < completedTasks!.length; i++) {
        if (unFinishTasks!.firstWhereOrNull(
                (element) => element.id == completedTasks![i].id) !=
            null) {
          completedTasks!
              .removeWhere((element) => element.id == completedTasks![i].id);
        }
      }
    }
    todayCompletedTasks = completedTasks!
        .where((element) =>
            element.updateAt!.toDate().year == DateTime.now().year &&
            element.updateAt!.toDate().month == DateTime.now().month &&
            element.updateAt!.toDate().day == DateTime.now().day)
        .toList();
    todayUnFinishTasks = unFinishTasks!
        .where((element) =>
    element.updateAt!.toDate().year == DateTime.now().year &&
        element.updateAt!.toDate().month == DateTime.now().month &&
        element.updateAt!.toDate().day == DateTime.now().day)
        .toList();
    todayTasks = [];
    todayTasks!.addAll(todayUnFinishTasks!);
    todayTasks!.addAll(todayCompletedTasks!);
    completedTasks!.removeWhere((element) =>
    element.updateAt!.toDate().month == DateTime.now().month &&
        element.updateAt!.toDate().day == DateTime.now().day);
    unFinishTasks!.removeWhere((element) =>
    element.updateAt!.toDate().month == DateTime.now().month &&
        element.updateAt!.toDate().day == DateTime.now().day);
    allTasks = [];
    allTasks!.addAll(unFinishTasks!);
    allTasks!.addAll(completedTasks!);

    waitingTasks = false;
    notifyListeners();
  }

  getSearchTransactions(String searchKey) async {
    waitingSearchTransactions = true;

    searchTransactions = await TransactionApi.getSearchTransactions(searchKey);
    waitingSearchTransactions = false;
    notifyListeners();
  }

  getAllTransactions() async {
    waitingAllTransactions = true;
    allTransactions = await TransactionApi.getAllTransactions();
    waitingAllTransactions = false;
    notifyListeners();
  }
}
