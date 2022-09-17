
class Member {
  String? id;
  String? imageUrl;
  String? name;
  String? des;

  bool? isBoss;
  Member(
      {this.id,
        this.imageUrl,
        this.name,
        this.isBoss,
        this.des
      });

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    des = json['des'];

    isBoss = json['isBoss'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['des'] = des;
    data['isBoss'] = isBoss;
    return data;
  }
}





