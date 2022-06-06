import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:customizable_app/model/record_model.dart';
import 'package:customizable_app/model/role_model.dart';
import 'package:customizable_app/model/tool_model.dart';

class TemplateModel {
  String id;
  String name;
  bool isFeed;
  List<ToolModel>? tools;
  List<RoleModel>? roles;
  List<RecordModel>? records;
  TemplateModel({
    required this.id,
    required this.name,
    required this.isFeed,
    this.tools,
    this.roles,
    this.records,
  });

  TemplateModel copyWith({
    String? id,
    String? name,
    bool? isFeed,
    List<ToolModel>? tools,
    List<RoleModel>? roles,
    List<RecordModel>? records,
  }) {
    return TemplateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isFeed: isFeed ?? this.isFeed,
      tools: tools ?? this.tools,
      roles: roles ?? this.roles,
      records: records ?? this.records,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isFeed': isFeed,
      'tools': tools?.map((x) => x.toMap()).toList(),
      'roles': roles?.map((x) => x.toMap()).toList(),
      'records': records?.map((x) => x.toMap()).toList(),
    };
  }

  factory TemplateModel.fromMap(Map<String, dynamic> map) {
    return TemplateModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isFeed: map['isFeed'] ?? false,
      tools: map['tools'] != null
          ? List<ToolModel>.from(map['tools']?.map((x) => ToolModel.fromMap(x)))
          : null,
      roles: map['roles'] != null
          ? List<RoleModel>.from(map['roles']?.map((x) => RoleModel.fromMap(x)))
          : null,
      records:
          // map['records'] != null
          // ? List<RecordModel>.from(
          //     map['records']?.map((x) => RecordModel.fromMap(x)))
          //:
          null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TemplateModel.fromJson(String source) =>
      TemplateModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TemplateModel(id: $id, name: $name, isFeed: $isFeed, tools: $tools, roles: $roles, records: $records)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TemplateModel &&
        other.id == id &&
        other.name == name &&
        other.isFeed == isFeed &&
        listEquals(other.tools, tools) &&
        listEquals(other.roles, roles) &&
        listEquals(other.records, records);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        isFeed.hashCode ^
        tools.hashCode ^
        roles.hashCode ^
        records.hashCode;
  }
}
