import 'dart:convert';

class User {
  String? id;
  String? name;
  String? surname;
  String? type;

  User({
    this.id,
    this.name,
    this.surname,
    this.type,
  });

  User copyWith({
    String? id,
    String? name,
    String? surname,
    String? type,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      type: type ?? this.type
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'type': type,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      type:map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(id: $id, name: $name, surname: $surname, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.surname == surname &&
        other.type ==type;


  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ surname.hashCode ^ type.hashCode;
}