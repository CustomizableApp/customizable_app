import 'dart:convert';

class UserModel {
  String? id;
  String? name;
  String? surname;

  UserModel({
    this.id,
    this.name,
    this.surname,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? surname,
  }) {
    return UserModel(
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'User(id: $id, name: $name, surname: $surname)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.surname == surname;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ surname.hashCode;
}
