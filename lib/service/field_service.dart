import 'dart:convert';

import 'package:customizable_app/model/data_model.dart';
import 'package:customizable_app/model/feed_data_model.dart';
import 'package:customizable_app/model/record_model.dart';
import 'package:customizable_app/model/role_model.dart';
import 'package:customizable_app/model/template_model.dart';
import 'package:customizable_app/model/tickable_field_item_model.dart';
import 'package:customizable_app/model/tool_model.dart';
import 'package:customizable_app/model/vote_field_item.dart';
import 'package:customizable_app/service/auth_service.dart';
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

  Future<List> getReadAndWrite(String toolID) async {
    Map<String, dynamic> data = {
      "tool_id": toolID,
    };
    Response response = await Dio().get(
        AppConstants.apiUrl + "/getReadAndWriteByToolID",
        queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    List list = dataMap["DB_tool_role"];
    return list;
  }

  Future<List> getUserRoleID(String recordID, String userID) async {
    Map<String, dynamic> data = {
      "record_id": recordID,
      "user_id": userID,
    };
    Response response = await Dio()
        .get(AppConstants.apiUrl + "/getUserRoleID", queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    List list = dataMap["DB_record_role"];
    return list;
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

  Future<bool> getIsVoted(String userID, String voteFieldID) async {
    Map<String, dynamic> data = {
      "user_id": userID,
      "vote_field_id": voteFieldID,
    };

    bool isVoted = false;
    Response response = await Dio()
        .get(AppConstants.apiUrl + "/getIsUserVoted", queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    List dataList = dataMap["DB_vote_field_voter"];
    if (dataList.isEmpty) {
      return isVoted;
    } else {
      isVoted = true;
      return isVoted;
    }
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

  Future<void> updateVoteItem(String voteItemID) async {
    Map<String, dynamic> data = {
      "vote_item_id": voteItemID,
      //db de datetime olarak updatelenmeli
    };
        await Dio().post(AppConstants.apiUrl + "/updateVoteItem", data: data);
  }

  Future<String?> createRecord(String name, String templateId) async {
    //TODO CONSTANT VALUE HERE
    String creatorId =
        AuthenticationService.instance.getUserId(); //user serviceten alinacak
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

  Future<void> createVoteFieldVoter(String userID, String voteFieldID) async {
    //TODO CONSTANT VALUE HERE
    String creatorId = "sehaId"; //user serviceten alinacak
    Map<String, dynamic> data = {
      "user_id": userID,
      "vote_field_id": voteFieldID,
    };

    Response response = await Dio()
        .post(AppConstants.apiUrl + "/createVoteFieldVoter", data: data);
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

  Future<String?> createTickableField(String dataId) async {
    Map<String, dynamic> data = {
      "data_id": dataId,
    };

    Response response = await Dio()
        .post(AppConstants.apiUrl + "/createTickableField", data: data);
    String id = response.data["insert_DB_tickable_field"]["returning"][0]["id"];
    return id;
  }

  Future<String?> createTickableFieldItem(
      String tickableListId, String text) async {
    Map<String, dynamic> data = {
      "tickable_list_id": tickableListId,
      "content": text,
    };

    Response response =
        await Dio().post(AppConstants.apiUrl + "/createListItem", data: data);
    String id = response.data["insert_DB_list_item"]["returning"][0]["id"];
    return id;
  }

  Future<List<TickableFieldItemModel>> getTickableFieldData(
      String fieldId) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
    };
    List<TickableFieldItemModel> dataList = List.empty(growable: true);
    Response response = await Dio().get(
        AppConstants.apiUrl + "/getTickableFieldData",
        queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    for (int i = 0;
        i < dataMap["DB_tickable_field"][0]["list_items"].length;
        i++) {
      dataList.add(TickableFieldItemModel.fromMap(
          dataMap["DB_tickable_field"][0]["list_items"][i]));
    }

    return dataList;
  }

  Future<String?> createVoteField(String dataId) async {
    Map<String, dynamic> data = {
      "data_id": dataId,
    };

    Response response =
        await Dio().post(AppConstants.apiUrl + "/createVoteField", data: data);
    String id = response.data["insert_DB_vote_field"]["returning"][0]["id"];
    return id;
  }

  Future<String?> createVoteFieldItem(String voteFieldId, String text) async {
    Map<String, dynamic> data = {
      "vote_field_id": voteFieldId,
      "text": text,
    };

    Response response = await Dio()
        .post(AppConstants.apiUrl + "/createVoteFieldItem", data: data);
    String id = response.data["insert_DB_vote_item"]["returning"][0]["id"];
    return id;
  }

  Future<bool> updateVoteFieldItem(String voteFieldItemId, int counter) async {
    Map<String, dynamic> data = {
      "field_item_id": voteFieldItemId,
      "count": counter,
    };
    bool status = false;
    Response response = await Dio()
        .post(AppConstants.apiUrl + "/updateVoteFieldItemCount", data: data);

    if (response.data != null) {
      status = true;
    }
    return status;
  }

  Future<List<VoteFieldItemModel>> getVoteFieldData(String fieldId) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
    };
    List<VoteFieldItemModel> dataList = List.empty(growable: true);
    Response response = await Dio()
        .get(AppConstants.apiUrl + "/getVoteFieldData", queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    for (int i = 0; i < dataMap["DB_vote_field"][0]["vote_items"].length; i++) {
      dataList.add(VoteFieldItemModel.fromMap(
          dataMap["DB_vote_field"][0]["vote_items"][i]));
    }

    return dataList;
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

  Future<String?> createDateField(String dataId, DateTime date) async {
    Map<String, dynamic> data = {
      "data_id": dataId,
      "date": date.toString(),
    };

    Response response =
        await Dio().post(AppConstants.apiUrl + "/createDateField", data: data);
    String id = response.data["insert_DB_date_field"]["returning"][0]["id"];
    return id;
  }

  Future<DateTime> getDateFieldData(String fieldId) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
    };

    Response response = await Dio().get(
        AppConstants.apiUrl + "/getDateFieldDataById",
        queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    DateTime? date = DateTime.parse(dataMap["DB_date_field"][0]["date"]);

    return date;
  }

  Future<bool> updateDateFieldData(String fieldId, DateTime date) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
      "date": date.toString(),
    };
    bool status = false;
    Response response = await Dio()
        .post(AppConstants.apiUrl + "/updateDateFieldDataById", data: data);

    if (response.data != null) {
      status = true;
    }
    return status;
  }

  Future<String?> createCounterField(String dataId, int counter) async {
    Map<String, dynamic> data = {
      "data_id": dataId,
      "counter": counter,
    };

    Response response = await Dio()
        .post(AppConstants.apiUrl + "/createCounterField", data: data);
    String id = response.data["insert_DB_counter_field"]["returning"][0]["id"];
    return id;
  }

  Future<int?> getCounterFieldData(String fieldId) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
    };

    Response response = await Dio().get(
        AppConstants.apiUrl + "/getCounterFieldDataByFieldId",
        queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    int? counterData = dataMap["DB_counter_field"][0]["counter"];

    return counterData;
  }

  Future<bool> updateCounterFieldData(String fieldId, int counter) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
      "counter": counter,
    };
    bool status = false;
    Response response = await Dio().post(
        AppConstants.apiUrl + "/updateCounterFieldDataByFieldId",
        data: data);

    if (response.data != null) {
      status = true;
    }
    return status;
  }

  Future<String?> createImageField(String dataId, String jsonObj) async {
    Map<String, dynamic> data = {
      "data_id": dataId,
      "content": jsonObj,
    };

    Response response =
        await Dio().post(AppConstants.apiUrl + "/createImageField", data: data);
    String id = response.data["insert_DB_image_field"]["returning"][0]["id"];
    return id;
  }

  Future<String?> getImageFieldData(String fieldId) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
    };

    Response response = await Dio()
        .get(AppConstants.apiUrl + "/getImageFieldData", queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    String? counterData = dataMap["DB_image_field"][0]["content"];

    return counterData;
  }

  Future<bool> updateImageFieldData(String fieldId, String jsonObj) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
      "content": jsonObj,
    };
    bool status = false;
    Response response =
        await Dio().post(AppConstants.apiUrl + "/updateImageField", data: data);

    if (response.data != null) {
      status = true;
    }
    return status;
  }

  Future<String?> createDrawField(String dataId, String jsonObj) async {
    Map<String, dynamic> data = {
      "data_id": dataId,
      "content": jsonObj,
    };

    Response response =
        await Dio().post(AppConstants.apiUrl + "/createDrawField", data: data);
    String id = response.data["insert_DB_draw_field"]["returning"][0]["id"];
    return id;
  }

  Future<String?> getDrawFieldData(String fieldId) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
    };

    Response response = await Dio()
        .get(AppConstants.apiUrl + "/getDrawFieldData", queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    String? counterData = dataMap["DB_draw_field"][0]["content"];

    return counterData;
  }

  Future<bool> updateDrawFieldData(String fieldId, String jsonObj) async {
    Map<String, dynamic> data = {
      "field_id": fieldId,
      "content": jsonObj,
    };
    bool status = false;
    Response response =
        await Dio().post(AppConstants.apiUrl + "/updateDrawField", data: data);

    if (response.data != null) {
      status = true;
    }
    return status;
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

  Future<List<FeedDataModel>> getFeedData(String recordID) async {
    Map<String, dynamic> data = {
      "record_id": recordID,
    };
    List<FeedDataModel> dataList = List.empty(growable: true);
    Response response = await Dio().get(
        AppConstants.apiUrl + "/getFeedDataByFieldID",
        queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    for (int i = 0; i < dataMap["DB_feed"].length; i++) {
      dataList.add(FeedDataModel.fromMap(dataMap["DB_feed"][i]));
    }

    return dataList;
  }

  Future<DateTime?> createFeedData(
      String content, int contentType, String recordID, String userID) async {
    Map<String, dynamic> data = {
      "content": content,
      "content_type": contentType,
      "record_id": recordID,
      "user_id": userID,
    };

    Response response =
        await Dio().post(AppConstants.apiUrl + "/createFeedData", data: data);
    DateTime? timeStamp = DateTime.parse(
        response.data["insert_DB_feed"]["returning"][0]["time_stamp"]);
    return timeStamp;
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

  Future<List<RecordModel>> getRecordsByUserId(TemplateModel template) async {
    Map<String, dynamic> data = {
      "user_id": AuthenticationService.instance.getUserId(),
    };
    List<RecordModel> records = List.empty(growable: true);
    Response response = await Dio().get(
        AppConstants.apiUrl + "/getRecordsByAssignedUserId",
        queryParameters: data);
    Map<String, dynamic> dataMap = response.data;
    List dataList = dataMap["DB_record_role"];

    //TODO BETTER SOLUTION
    for (int i = 0; i < dataList.length; i++) {
      //List list = dataList[i]["record_name"];

      records.add(RecordModel.fromMap(dataList[i]["record_name"], template));
    }
    return records;
  }
}
