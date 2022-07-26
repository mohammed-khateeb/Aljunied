import 'package:aljunied/Apis/news_api.dart';
import 'package:aljunied/Models/news.dart';
import 'package:flutter/cupertino.dart';

class NewsController with ChangeNotifier{
  List<News>? news;
  bool waiting = true;

  Future insertNews({required News news})async{
    await NewsApi.addNews(news: news);
    this.news ??=[];
    this.news!.add(news);
    notifyListeners();
  }

  Future getNews()async{
    news = await NewsApi.getNews();
    waiting = false;
    notifyListeners();
  }

  changeOrderIndex(int index,int currentIndex){
    News newsReplacement = news!.elementAt(index-1);
    newsReplacement.orderIndex = currentIndex;
    News currentNews = news!.elementAt(currentIndex-1);
    currentNews.orderIndex = index;
    NewsApi.updateNews(news: newsReplacement);
    NewsApi.updateNews(news: currentNews);
    news!.sort((a, b) => a.orderIndex!.compareTo(b.orderIndex!));
    notifyListeners();
    }

  Future resetWaiting()async{
    waiting = true;
    notifyListeners();
  }

  updateNews(News news){
    NewsApi.updateNews(news: news);
    News _news = this.news!.firstWhere((element) => element.id == news.id);
    _news = news;
    notifyListeners();
  }

  deleteNews(News news){
    NewsApi.deleteNews(news.id!);
    this.news!.removeWhere((element) => element.id == news.id);
    notifyListeners();
  }
}