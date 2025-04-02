import 'dart:convert';

List<Dogmodel> dogmodelFromJson(String str) {
  return List<Dogmodel>.from(
      json.decode(str).map((x) => Dogmodel.fromJson(x)));
}

String dogmodelToJson(List<Dogmodel> data) {
  return json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}

class Choice {
  int id;
  String title;
  Choice({required this.id, required this.title});
  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(id: json['id'], title: json['title']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}

class Dogmodel {
  String title;
  List<Choice> choices;

  Dogmodel({
    required this.title, 
    required this.choices
  });

  factory Dogmodel.fromJson(Map<String, dynamic> json) {
    return Dogmodel(
      title: json['title'],
      choices: List<Choice>.from(json['choice'].map((x) => Choice.fromJson(x))),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'choice': List<dynamic>.from(choices.map((x) => x.toJson())),
    };
  }
}