
class City{
  String? id;
  String? nameEn;
  String? nameAr;

  City({this.id,this.nameEn, this.nameAr});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nameEn'] = nameEn;
    data['nameAr'] = nameAr;
    return data;
  }
}