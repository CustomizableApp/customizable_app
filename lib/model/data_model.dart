import 'dart:convert';

import 'package:customizable_app/model/tool_model.dart';

class DataModel extends ToolModel {
  String dataId;
  String fieldId;
  DataModel({
    required String toolId,
    required String name,
    required int type,
    required this.dataId,
    required this.fieldId,
  }) : super(id: toolId, name: name, type: type);

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      toolId: map["tool"]["id"],
      name: map["tool"]["name"],
      type: int.parse(map["tool"]["type"]),
      dataId: map['id'] ?? '',
      fieldId: map['field_id'] ?? '',
    );
  }

  factory DataModel.fromJson(String source) =>
      DataModel.fromMap(json.decode(source));
}
