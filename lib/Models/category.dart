
class Category {
  String? id;
  String? imageUrl;
  String? nameAr;
  List<Subcategory>? subcategories;

  Category(
      {this.id,
        this.imageUrl,
        this.nameAr,
        this.subcategories,
      });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    nameAr = json['nameAr'];
    if (json['subcategories'] != null) {
      subcategories = [];
      json['subcategories'].forEach((v) {
        subcategories!.add(Subcategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['nameAr'] = nameAr;
    data['subcategories'] = subcategories!=null? subcategories!.map((v) => v.toJson()).toList():null;
    return data;
  }
}



class Subcategory {
  String? id;
  String? nameAr;



  Subcategory(
      {this.id,
        this.nameAr,
      });

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['nameAr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nameAr'] = nameAr;
    return data;
  }
}


