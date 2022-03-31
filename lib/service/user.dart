import 'dart:convert';

class User {
  String? id;
  String? name;
  String? surname;


  User({
    this.id,
    this.name,
    this.surname,
  });

  User copyWith({
    String? id,
    String? name,
    String? surname,

  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['UserID'],
      name: map['Name'],
      surname: map['Surname'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(id: $id, name: $name, surname: $surname)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.surname == surname;


  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ surname.hashCode;
}