import 'package:customizable_app/model/data_model.dart';
import 'package:customizable_app/model/record_model.dart';
import 'package:customizable_app/model/role_model.dart';
import 'package:customizable_app/model/template_model.dart';
import 'package:customizable_app/model/tool_model.dart';
import 'package:customizable_app/service/user.dart';
import 'package:dio/dio.dart';
import '../core/app_contants.dart';

class FieldService {
  static final FieldService _instance = FieldService._init();
  FieldService._init();

  static FieldService get instance {
    return _instance;
  }

  factory FieldService() {
    return _instance;
  }
  Future<List<ToolModel>> getToolsByTemplateId(String templateId) async {
    Map<String, dynamic> data = {
      "templateId": templateId,
    };
    List<ToolModel> tools = List.empty(growable: true);
    Response response = await Dio().get(
        AppConstants.apiUrl + "/templateToolsByTemplateId",
        queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    List dataList = dataMap["DB_tool"];
    //TODO BETTER SOLUTION
    for (int i = 0; i < dataList.length; i++) {
      tools.add(ToolModel.fromMap(dataList[i]));
    }

    return tools;
  }

  Future<List<DataModel>> getFieldIdAndTool(String recordId) async {
    Map<String, dynamic> data = {
      "recordId": recordId,
    };
    List<DataModel> datas = List.empty(growable: true);
    Response response = await Dio()
        .get(AppConstants.apiUrl + "/getFieldIdAndTool", queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    List dataList = dataMap["DB_data"];
    //TODO BETTER SOLUTION
    for (int i = 0; i < dataList.length; i++) {
      datas.add(DataModel.fromMap(dataList[i]));
    }
    print(datas);
    return datas;
  }

  Future<String> getTextFieldData(String fieldId) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
    };
    String text = "";
    Response response = await Dio().get(
        AppConstants.apiUrl + "/getTextFieldDataById",
        queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    text = dataMap["DB_text_field"][0]["text"];
    return text;
  }

  Future<bool> updateTextFieldData(String fieldId, String text) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
      "text": text,
    };
    bool status = false;
    Response response = await Dio().post(
        AppConstants.apiUrl + "/updateTextFieldDataByFieldId",
        data: data);

    if (response.data != null) {
      status = true;
    }
    return status;
  }

  Future<List<DateTime>> getIntervalDateFieldData(String fieldId) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
    };

    List<DateTime> dateList = List.empty(growable: true);
    Response response = await Dio().get(
        AppConstants.apiUrl + "/getIntervalDateFieldDataById",
        queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    dateList.add(DateTime.parse(dataMap["DB_interval_datefield"][0]["date1"]));
    dateList.add(DateTime.parse(dataMap["DB_interval_datefield"][0]["date2"]));

    return dateList;
  }

  Future<bool> updateIntervalDateFieldData(
      String fieldId, DateTime firstDate, DateTime secondDate) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
      //db de datetime olarak updatelenmeli
      "date1": firstDate.toString(),
      "date2": secondDate.toString(),
    };
    bool status = false;
    Response response = await Dio().post(
        AppConstants.apiUrl + "/updateIntervalDateFieldDataByFieldId",
        data: data);

    if (response.data != null) {
      status = true;
    }
    return status;
  }

  Future<String?> createRecord(String name, String templateId) async {
    //TODO CONSTANT VALUE HERE
    String creatorId = "sehaId"; //user serviceten alinacak
    Map<String, dynamic> data = {
      "creator_id": creatorId,
      "template_id": templateId,
      "name": name,
    };

    Response response =
        await Dio().post(AppConstants.apiUrl + "/createRecord", data: data);
    String id = response.data["insert_DB_record"]["returning"][0]["id"];

    return id;
  }

  Future<String?> createData(String recordId, String toolId) async {
    Map<String, dynamic> data = {
      "record_id": recordId,
      "tool_id": toolId,
    };

    Response response =
        await Dio().post(AppConstants.apiUrl + "/createData", data: data);
    String id = response.data["insert_DB_data"]["returning"][0]["id"];

    return id;
  }

  Future<bool> assignUserToRole(
      String recordId, String roleId, String userId) async {
    Map<String, dynamic> data = {
      "record_id": recordId,
      "role_id": roleId,
      "user_id": userId,
    };
    bool status = false;
    Response response =
        await Dio().post(AppConstants.apiUrl + "/createRecordRole", data: data);
    String? id =
        response.data["insert_DB_record_role"]["returning"][0]["relation_id"];
    if (id != null) {
      status = true;
    }
    return status;
  }

  Future<bool> unAssignUserToRole(
      String recordId, String roleId, String userId) async {
    Map<String, dynamic> data = {
      "record_id": recordId,
      "role_id": roleId,
      "user_id": userId,
    };
    bool status = false;
    Response response = await Dio()
        .delete(AppConstants.apiUrl + "/deleteRecordRole", data: data);
    String? id =
        response.data["delete_DB_record_role"]["returning"][0]["role_id"];
    if (id != null) {
      status = true;
    }
    return status;
  }

  Future<String?> createTextField(String dataId, String text) async {
    Map<String, dynamic> data = {
      "data_id": dataId,
      "text": text,
    };

    Response response =
        await Dio().post(AppConstants.apiUrl + "/createTextField", data: data);
    String id = response.data["insert_DB_text_field"]["returning"][0]["id"];
    return id;
  }

  Future<String?> createIntervalDateField(
      String dataId, DateTime firstDate, DateTime secondDate) async {
    Map<String, dynamic> data = {
      "data_id": dataId,
      //db de datetime olarak updatelenmeli
      "date1": firstDate.toString(),
      "date2": secondDate.toString(),
    };

    Response response = await Dio()
        .post(AppConstants.apiUrl + "/createIntervalDateField", data: data);
    String id =
        response.data["insert_DB_interval_datefield"]["returning"][0]["id"];
    return id;
  }

  Future<int?> updateDataFieldId(String dataId, String fieldId) async {
    Map<String, dynamic> data = {
      "data_id": dataId,
      "field_id": fieldId,
    };

    Response response =
        await Dio().post(AppConstants.apiUrl + "/updateData", data: data);

    return response.statusCode;
  }

  // Future<Response> getDatasByRecordId(String recordId) async {
  //   Map<String, dynamic> data = {
  //     //TODO
  //     "recordId": "78363d6f-0657-4be9-a46e-6ddc087574fa",
  //   };
  //   List<DataModel> datas = List.empty(growable: true);
  //   Response response = await Dio().get(
  //       AppConstants.apiUrl + "/getFieldIdAndToolType",
  //       queryParameters: data);
  //   Map<String, dynamic> dataMap = response.data;
  //   List dataList = dataMap["DB_tool"];
  //   //TODO BETTER SOLUTION
  //   for (int i = 0; i < dataList.length; i++) {
  //     datas.add(DataModel.fromMap(dataList[i]));
  //   }
  //   return response;
  // }

  // Future<FieldModel?> getTextFieldData(String fieldId) async {
  //   Map<String, dynamic> data = {
  //     "field_id": fieldId,
  //   };

  //   Response response = await Dio().get(
  //       AppConstants.apiUrl + "/getTextFieldDataById",
  //       queryParameters: data);
  //   Map<String, dynamic> dataMap = response.data;
  //   List list = dataMap["DB_text_field"];
  //   if (list.isNotEmpty) {
  //     FieldModel fieldModel =
  //         TextFieldModel(id: list.first["id"], text: list.first["text"]);
  //     return fieldModel;
  //   }
  //   return null;
  // }

  // Future<FieldModel?> getField(String fieldId, int type) async {
  //   switch (type) {
  //     case 1:
  //       return await getTextFieldData(fieldId);

  //     default:
  //       return null;
  //   }
  // }
  Future<List<RoleModel>> getRolesByTemplateId(String templateId) async {
    Map<String, dynamic> data = {
      "template_id": templateId,
    };
    List<RoleModel> roles = List.empty(growable: true);
    Response response = await Dio().get(
        AppConstants.apiUrl + "/getRolesByTemplateId",
        queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    List dataList = dataMap["DB_role"];

    for (int i = 0; i < dataList.length; i++) {
      roles.add(RoleModel.fromMap(dataList[i]));
    }
    return roles;
  }

  Future<List<String>> getAssignedUsers(String roleId, String recordId) async {
    Map<String, dynamic> data = {
      "role_id": roleId,
      "record_id": recordId,
    };
    List<String> assignedUsers = List.empty(growable: true);
    Response response = await Dio()
        .get(AppConstants.apiUrl + "/getAssignedUsers", queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    List dataList = dataMap["DB_record_role"];

    //TODO BETTER SOLUTION
    for (int i = 0; i < dataList.length; i++) {
      assignedUsers.add(dataList[i]["user_id"]);
    }
    return assignedUsers;
  }

  Future<List<RecordModel>> getRecordsByTemplateId(
      TemplateModel template) async {
    Map<String, dynamic> data = {
      "templateId": template.id,
    };
    List<RecordModel> records = List.empty(growable: true);
    Response response = await Dio().get(
        AppConstants.apiUrl + "/getRecordsByTemplateId",
        queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    List dataList = dataMap["DB_template"];

    //TODO BETTER SOLUTION
    for (int i = 0; i < dataList.length; i++) {
      List list = dataList[i]["Records"];
      for (int j = 0; j < list.length; j++) {
        records.add(RecordModel.fromMap(list[j], template));
      }
    }
    return records;
  }
}
