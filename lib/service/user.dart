import 'dart:convert';

class UserModel {
  String? id;
  String? name;
  String? surname;
  int type;

  UserModel({
    this.id,
    this.name,
    this.surname,
    required this.type,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? surname,
    int? type,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      type: type ?? this.type,
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      type: map['type']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, surname: $surname, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.surname == surname &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ surname.hashCode ^ type.hashCode;
  }
}
