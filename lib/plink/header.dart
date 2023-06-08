import 'dart:convert';

class Header {
  String url;
  String from;
  String to;

  Header({required this.url, this.from = '', this.to = ''});

  Map<String, dynamic> toJson() => {'Url': url, 'From': from, 'To': to};

  String toJsonString() => jsonEncode(toJson());

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      url: json['Url'],
      from: json['From'],
      to: json['To'],
    );
  }
}
