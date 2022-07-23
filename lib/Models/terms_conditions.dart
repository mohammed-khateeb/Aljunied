

class TermsCondition {
  String? terms;

  TermsCondition(
      {
        this.terms,
      });

  TermsCondition.fromJson(Map<String, dynamic> json) {
    terms = json['terms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['terms'] = terms;
    return data;
  }
}
