import 'dart:convert';

import 'package:customizable_app/model/role_model.dart';
import 'package:customizable_app/model/template_model.dart';
import 'package:flutter/foundation.dart';

import 'package:customizable_app/model/data_model.dart';

class RecordModel {
  String id;
  String name;
  List<DataModel>? datas;
  List<RoleModel>? roles;

  RecordModel({
    required this.id,
    required this.name,
    this.roles,
    this.datas,
  });

  RecordModel copyWith({
    String? id,
    String? name,
    List<DataModel>? datas,
  }) {
    return RecordModel(
      id: id ?? this.id,
      name: name ?? this.name,
      datas: datas ?? this.datas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      //'datas': datas.map((x) => x.toMap()).toList(),
    };
  }

  factory RecordModel.fromMap(
      Map<String, dynamic> map, TemplateModel template) {
    return RecordModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      roles: template.roles,
      // datas:
      //     List<DataModel>.from(map['datas']?.map((x) => DataModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'RecordModel(id: $id, name: $name, datas: $datas)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecordModel &&
        other.id == id &&
        other.name == name &&
        listEquals(other.datas, datas);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ datas.hashCode;
}
