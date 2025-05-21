class User {
  final int? id;
  final String name;
  final int age;
  final String hobby; 
  final String internet;
  final String gender;

  User({
    this.id,
    required this.name,
    required this.age,
    required this.hobby,
    required this.internet,
    required this.gender,
  });

  Map<String, Object?> toMap() {// using convert data
    return {
      'id': id,
      'name': name,
      'age': age,
      'hobby': hobby, 
      'internet': internet, 
      'gender': gender,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {// using query
    return User(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      hobby: map['hobby'], 
      internet: map['internet'],
      gender: map['gender'],
    );
  }

  @override
  String toString() {// using debug
    return 'User{id: $id, name: $name, age: $age, hobby: $hobby, internet: $internet}, gender: $gender';
  }
}
