import 'package:customizable_app/model/data_model.dart';
import 'package:customizable_app/model/record_model.dart';
import 'package:customizable_app/model/tool_model.dart';
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
    print(text);
    return text;
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

  Future<List<RecordModel>> getRecordsByTemplateId(String templateId) async {
    Map<String, dynamic> data = {
      "templateId": templateId,
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
        records.add(RecordModel.fromMap(list[j]));
      }
    }
    return records;
  }
}
