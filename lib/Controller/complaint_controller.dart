import 'package:aljunied/Apis/complaint_api.dart';
import 'package:flutter/cupertino.dart';

import '../Models/complaint.dart';

class ComplaintController with ChangeNotifier{
  List<Complaint>? complaints;
  bool waiting = true;


  Future insertComplaint({required Complaint complaint})async{
    await ComplaintApi.addNewComplaint(complaint: complaint);
    complaints??=[];
    complaints!.add(complaint);
    notifyListeners();
  }

  answerQuestion(Complaint complaint){
    ComplaintApi.answerQuestion(complaint);
    complaints??=[];
    complaints!.firstWhere((element) => element.id==complaint.id).answer = complaint.answer;
    notifyListeners();
  }

  Future getComplaints({int kind = 3})async{
    waiting = true;
    complaints = await ComplaintApi.getComplaints(kind);
    waiting = false;
    notifyListeners();
  }

  Future resetWaiting()async{
    waiting = true;
    notifyListeners();
  }

  deleteComplaint(Complaint complaint){
    ComplaintApi.deleteComplaint(complaint.id!);
    complaints!.removeWhere((element) => element.id == complaint.id);
    notifyListeners();
  }
}