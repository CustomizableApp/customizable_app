import 'package:customizable_app/model/vote_field_item.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';

class VoteFieldWidget extends StatefulWidget {
  VoteFieldWidget(this.id, this.fieldId, this.name, this.voteItems, {Key? key})
      : super(key: key);
  final String id;
  final String name;
  String? fieldId;
  List<VoteFieldItemModel>? voteItems;
  bool hasChanged = false;
  bool isCreated = false;

  @override
  _VoteFieldWidgetState createState() => _VoteFieldWidgetState();

  Future<void> createTrigger(String recordId, String toolId) async {
    if (!isCreated) {
      await createData(recordId, toolId);
    }
  }

  void updateTrigger() {
    updateData(fieldId!);
  }

  Future<int> createData(String recordId, String toolId) async {
    String? dataId = await FieldService.instance.createData(recordId, toolId);
    if (dataId != null) {
      String? voteFieldId = await FieldService.instance.createVoteField(dataId);
      await FieldService.instance.updateDataFieldId(dataId, voteFieldId!);
      return 1;
    }
    return 0;
  }

  Future<void> updateData(String fieldId) async {}
}

class _VoteFieldWidgetState extends State<VoteFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("vote"),
    );
  }
}
