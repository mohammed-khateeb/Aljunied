import 'package:aljunied/Models/area.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Constants/constants.dart';
class AreaApi{

  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<Area> addNewArea({required Area area}) async {

    area.createAt = Timestamp.fromDate(DateTime.now());

    DocumentReference doc = db.collection(CollectionsKey.area).doc();

    area.id = doc.id;

    await doc.set(area.toJson());

    return area;

  }

  static Future updateArea({required Area area})async{

    DocumentReference doc = db.collection(CollectionsKey.area).doc(area.id);

    await doc.update(area.toJson());

  }

  static deleteArea(String areaId){
    db.collection(CollectionsKey.area).doc(areaId).delete();
  }

  static Future<List<Area>> getAreas() async {
    List<Area> areas = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.area)
        .orderBy('createAt', descending: true)
        .get();

    areas = snapshot.docs.map((e) => Area.fromJson(e.data() as Map<String, dynamic>)).toList() ;

    return areas;
  }




}