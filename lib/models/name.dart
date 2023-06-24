class Name {
  String? title;
  String? first;
  String? last;

  Name.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    first = json['first'];
    last = json['last'];
  }
}
