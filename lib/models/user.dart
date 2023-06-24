import 'package:flutter_greeter/models/name.dart';

class User {
  Name? name;

  User.fromJson(Map<String, dynamic> json) {
    name = Name.fromJson(json['name']);
  }
}
