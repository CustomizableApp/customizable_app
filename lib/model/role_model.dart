import 'dart:convert';

class RoleModel {
  String id;
  String name;
  RoleModel({
    required this.id,
    required this.name,
  });

  RoleModel copyWith({
    String? id,
    String? name,
  }) {
    return RoleModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role_name': name,
    };
  }

  factory RoleModel.fromMap(Map<String, dynamic> map) {
    return RoleModel(
      id: map['id'] ?? '',
      name: map['role_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RoleModel.fromJson(String source) =>
      RoleModel.fromMap(json.decode(source));

  @override
  String toString() => 'RoleModel(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoleModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
