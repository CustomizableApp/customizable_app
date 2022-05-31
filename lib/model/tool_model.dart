import 'dart:convert';

class ToolModel {
  String id;
  String name;
  int type;
  ToolModel({
    required this.id,
    required this.name,
    required this.type,
  });

  ToolModel copyWith({
    String? id,
    String? name,
    int? type,
  }) {
    return ToolModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  factory ToolModel.fromMap(Map<String, dynamic> map) {
    return ToolModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: int.parse(map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ToolModel.fromJson(String source) =>
      ToolModel.fromMap(json.decode(source));

  @override
  String toString() => 'ToolModel(id: $id, name: $name, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ToolModel &&
        other.id == id &&
        other.name == name &&
        other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ type.hashCode;
}
