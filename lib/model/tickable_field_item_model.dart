import 'dart:convert';

class TickableFieldItemModel {
  String id;
  String text;
  bool ticked;
  TickableFieldItemModel({
    required this.id,
    required this.text,
    required this.ticked,
  });

  TickableFieldItemModel copyWith({
    String? id,
    String? text,
    bool? ticked,
  }) {
    return TickableFieldItemModel(
      id: id ?? this.id,
      text: text ?? this.text,
      ticked: ticked ?? this.ticked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'ticked': ticked,
    };
  }

  factory TickableFieldItemModel.fromMap(Map<String, dynamic> map) {
    return TickableFieldItemModel(
      id: map['id'] ?? '',
      text: map['content'] ?? '',
      ticked: map['ticked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TickableFieldItemModel.fromJson(String source) =>
      TickableFieldItemModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'TickableFieldItemModel(id: $id, text: $text, ticked: $ticked)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TickableFieldItemModel &&
        other.id == id &&
        other.text == text &&
        other.ticked == ticked;
  }

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ ticked.hashCode;
}
