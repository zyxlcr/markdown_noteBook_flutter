class RuleSearch {
  String bookList;
  String bookUrl;
  String checkKeyWord = "";
  String coverUrl;
  String name;

  RuleSearch({
    required this.bookList,
    required this.bookUrl,
    required this.coverUrl,
    required this.name,
  });

  factory RuleSearch.fromJson(Map<String, dynamic> json) {
    var r = RuleSearch(
      bookList: json['bookList'],
      bookUrl: json['bookUrl'],
      coverUrl: json['coverUrl'],
      name: json['name'],
    );
    r.checkKeyWord = json['checkKeyWord'];
    return r;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookList'] = this.bookList;
    data['bookUrl'] = this.bookUrl;
    data['checkKeyWord'] = this.checkKeyWord;
    data['coverUrl'] = this.coverUrl;
    data['name'] = this.name;
    return data;
  }
}
