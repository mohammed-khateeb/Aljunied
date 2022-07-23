import 'package:aljunied/Apis/area_api.dart';
import 'package:aljunied/Models/area.dart';
import 'package:flutter/cupertino.dart';

class AreaController with ChangeNotifier{
  List<Area>? areas;
  bool waiting = true;


  Future insertArea({required Area area})async{
    await AreaApi.addNewArea(area: area);
    areas??=[];
    areas!.add(area);
    notifyListeners();
  }
  Future getAreas()async{
    waiting = true;
    areas = await AreaApi.getAreas();
    waiting = false;
    notifyListeners();
  }

  Future resetWaiting()async{
    waiting = true;
    notifyListeners();
  }

  updateArea(Area area){
    AreaApi.updateArea(area: area);
    Area _area = areas!.firstWhere((element) => element.id == area.id);
    _area = area;
    notifyListeners();
  }

  deleteArea(Area area){
    AreaApi.deleteArea(area.id!);
    areas!.removeWhere((element) => element.id == area.id);
    notifyListeners();
  }
}