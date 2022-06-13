import 'dart:convert';

class VoteFieldItemModel {
  String id;
  String text;
  String count;
  VoteFieldItemModel({
    required this.id,
    required this.text,
    required this.count,
  });

  VoteFieldItemModel copyWith({
    String? id,
    String? text,
    String? count,
  }) {
    return VoteFieldItemModel(
      id: id ?? this.id,
      text: text ?? this.text,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'count': count,
    };
  }

  factory VoteFieldItemModel.fromMap(Map<String, dynamic> map) {
    return VoteFieldItemModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      count: map['count'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VoteFieldItemModel.fromJson(String source) =>
      VoteFieldItemModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'VoteFieldItemModel(id: $id, text: $text, count: $count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VoteFieldItemModel &&
        other.id == id &&
        other.text == text &&
        other.count == count;
  }

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ count.hashCode;
}
