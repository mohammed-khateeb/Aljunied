import 'package:aljunied/Apis/headline_api.dart';
import 'package:aljunied/Models/headline.dart';
import 'package:flutter/cupertino.dart';

class HeadlineController with ChangeNotifier{
  List<Headline>? headlines;
  bool waiting = true;


  Future insertHeadline({required Headline headline})async{
    await HeadlineApi.addNewHeadline(headline: headline);
    headlines??=[];
    headlines!.add(headline);
    notifyListeners();
  }
  Future getHeadlines()async{
    waiting = true;
    headlines = await HeadlineApi.getHeadlines();

    waiting = false;
    notifyListeners();
  }

  Future resetWaiting()async{
    waiting = true;
    notifyListeners();
  }

  changeOrderIndex(int index,int currentIndex){
    Headline headlineReplacing = headlines!.elementAt(index-1);
    headlineReplacing.orderIndex = currentIndex;
    Headline headline = headlines!.elementAt(currentIndex-1);
    headline.orderIndex = index;
    HeadlineApi.updateHeadline(headline: headlineReplacing);
    HeadlineApi.updateHeadline(headline: headline);
    headlines!.sort((a, b) => a.orderIndex!.compareTo(b.orderIndex!));
    notifyListeners();
  }

  updateHeadline(Headline headline){
    HeadlineApi.updateHeadline(headline: headline);
    Headline _headLine = headlines!.firstWhere((element) => element.id == headline.id);
    _headLine = headline;
    notifyListeners();
  }

  deleteHeadline(Headline headline){
    HeadlineApi.deleteHeadline(headline.id!);
    headlines!.removeWhere((element) => element.id == headline.id);
    notifyListeners();
  }
}