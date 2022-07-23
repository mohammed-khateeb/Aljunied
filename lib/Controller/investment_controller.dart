import 'package:aljunied/Apis/investment_api.dart';
import 'package:aljunied/Models/investment.dart';
import 'package:flutter/cupertino.dart';

class InvestmentController with ChangeNotifier{
  List<Investment>? investments;
  bool waiting = true;


  Future insertInvestment({required Investment investment})async{
    await InvestmentApi.addNewInvestment(investment: investment);
    investments??=[];
    investments!.add(investment);
    notifyListeners();
  }
  Future getInvestments()async{
    waiting = true;
    investments = await InvestmentApi.getInvestments();

    waiting = false;
    notifyListeners();
  }

  Future resetWaiting()async{
    waiting = true;
    notifyListeners();
  }

  deleteInvestment(Investment investment){
    InvestmentApi.deleteInvestment(investment.id!);
    investments!.removeWhere((element) => element.id == investment.id);
    notifyListeners();
  }
}