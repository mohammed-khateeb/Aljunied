
class Headline {
  String? id;
  String? labelAr;
  String? labelEn;

  String? des;
  List<TitleLine>? titles;
  int? orderIndex;

  Headline(
      {this.id,
        this.labelAr,
        this.labelEn,
        this.des,
        this.orderIndex,
        this.titles,
      });

  Headline.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    labelAr = json['labelAr'];
    labelEn = json['labelEn'];
    des = json['des'];
    orderIndex = json['orderIndex'];
    if (json['titles'] != null) {
      titles = [];
      json['titles'].forEach((v) {
        titles!.add(TitleLine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['labelAr'] = labelAr;
    data['labelEn'] = labelEn;
    data['des'] = des;
    data['orderIndex'] = orderIndex;

    data['titles'] = titles!=null? titles!.map((v) => v.toJson()).toList():null;
    return data;
  }
}


  class TitleLine {
  String? labelAr;
  String? labelEn;

  String? des;
  List<SubTitle>? subTitles;

  TitleLine(
      {
        this.labelAr,
        this.labelEn,
        this.des,
        this.subTitles,
      });

  TitleLine.fromJson(Map<String, dynamic> json) {
    labelAr = json['labelAr'];
    labelEn = json['labelEn'];

    des = json['des'];
    if (json['subTitles'] != null) {
      subTitles = [];
      json['subTitles'].forEach((v) {
        subTitles!.add(SubTitle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['labelAr'] = labelAr;

    data['labelEn'] = labelEn;
    data['des'] = des;
    data['subTitles'] = subTitles!=null? subTitles!.map((v) => v.toJson()).toList():null;
    return data;
  }
}

class SubTitle {
  String? label;
  String? des;

  SubTitle(
      {
        this.label,
        this.des,
      });

  SubTitle.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    des = json['des'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['des'] = des;

    return data;
  }
}







