import 'dart:convert';

class TemplateModel {
  String id;
  String name;
  bool isFeed;
  TemplateModel({
    required this.id,
    required this.name,
    required this.isFeed,
  });

  TemplateModel copyWith({
    String? id,
    String? name,
    bool? isFeed,
  }) {
    return TemplateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isFeed: isFeed ?? this.isFeed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isFeed': isFeed,
    };
  }

  factory TemplateModel.fromMap(Map<String, dynamic> map) {
    return TemplateModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isFeed: map['isFeed'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TemplateModel.fromJson(String source) =>
      TemplateModel.fromMap(json.decode(source));

  @override
  String toString() => 'TemplateModel(id: $id, name: $name, isFeed: $isFeed)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TemplateModel &&
        other.id == id &&
        other.name == name &&
        other.isFeed == isFeed;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ isFeed.hashCode;
}
