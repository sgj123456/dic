class WordAll {
  String? word;
  dynamic attribute;

  WordAll({this.word, this.attribute});

  WordAll.fromJson(Map<String, dynamic> json) {
    word = json['word'] as String?;
    attribute = json['attribute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['word'] = word;
    data['attribute'] = attribute;
    return data;
  }
}
