import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_greeter/strings.dart';
import 'package:http/http.dart' as http;

import 'models/answer.dart';
import 'models/user.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? name = Strings.loading;
  String subText = Strings.loadSuccessText;
  final _nameTextController = TextEditingController();

  _MyHomePageState() {
    name = Strings.loading;
    _getAnswer().then((value) {
      setState(() {
        name = value.name;
        subText = value.subText;
      });
    });
  }

  Future<Answer> _getAnswer() async {
    var response = await http.get(Uri.parse('https://randomuser.me/api/'));

    if (response.statusCode == 200) {
      List<dynamic> results = jsonDecode(response.body)['results'];
      var users = results.map((x) => User.fromJson(x)).toList();

      if (users.isEmpty || users[0].name?.first == null) {
        var name = Strings.loadFailedText;
        var subText = Strings.loadFailedSubtext;
        return Answer(name, subText);
      }

      var subText = Strings.loadSuccessText;
      return Answer('${users[0].name?.first}!', subText);
    } else {
      var name = Strings.loadFailedText;
      var subText = Strings.loadFailedSubtext;
      return Answer(name, subText);
    }
  }

  void _randomizeName() {
    _nameTextController.clear();
    setState(() {
      name = Strings.loading;
    });
    _getAnswer().then((value) {
      setState(() {
        name = value.name;
        subText = value.subText;
      });
    });
  }

  void _setName(String? newName) async {
    setState(() {
      name = '$newName!';
      subText = Strings.loadSuccessText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${Strings.greeting} $name',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              subText,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TextField(
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: Strings.nameLabel),
                  onChanged: (value) => _setName(value),
                  controller: _nameTextController,
                ),
              ),
            ),
            FilledButton(
                onPressed: _randomizeName, child: Text(Strings.randomizeLabel))
          ],
        ),
      ),
    );
  }
}
