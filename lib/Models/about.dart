

class About {
  String? aboutEn;
  String? aboutAr;
  String? phone;
  String? email;

  About(
      {
        this.aboutEn,
        this.aboutAr,
        this.email,
        this.phone
      });

  About.fromJson(Map<String, dynamic> json) {
    aboutEn = json['aboutEn'];
    aboutAr = json['aboutAr'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aboutEn'] = aboutEn;
    data['aboutAr'] = aboutAr;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
