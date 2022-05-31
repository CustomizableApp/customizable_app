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
}
