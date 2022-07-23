import 'package:aljunied/Apis/bid_api.dart';
import 'package:aljunied/Models/bid.dart';
import 'package:flutter/cupertino.dart';

class BidController with ChangeNotifier{
  List<Bid>? bids;

  bool forwarded = false;
  bool waiting = true;


  Future insertBid({required Bid bid})async{
    await BidApi.addNewBid(bid: bid);
    bids??=[];
    bids!.add(bid);
    notifyListeners();
  }
  Future getBids()async{
    waiting = true;
    bids = await BidApi.getBids();

    waiting = false;
    notifyListeners();
  }

  changeForwarded(bool forwarded){
    this.forwarded = forwarded;
    notifyListeners();
  }

  Future resetWaiting()async{
    waiting = true;
    notifyListeners();
  }

  updateBid(Bid bid){
    BidApi.updateBid(bid: bid);
    Bid _bid = bids!.firstWhere((element) => element.id == bid.id);
    _bid = bid;
    notifyListeners();
  }

  deleteBid(Bid bid){
    BidApi.deleteBid(bid.id!);
    bids!.removeWhere((element) => element.id == bid.id);
    notifyListeners();
  }
}