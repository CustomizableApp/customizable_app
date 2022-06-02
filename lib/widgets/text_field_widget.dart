import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/utils/toast_util.dart';
import 'package:flutter/material.dart';
//TODO
//BURASI STFULL IKEN  SADECE CREATESTATE DEN CREATETRIGGERA ULASILIYOR O DURUMDA DA BASTAN OLUSTRUDUGU ICIN (?) CONTROLLER BOS OLUYOR VERIYI DBYE ATAMIYORUM

class TextFieldWidget extends StatefulWidget {
  TextFieldWidget(
    this.id,
    this.name,
    this.text,
    this.controller, {
    Key? key,
  }) : super(key: key);
  final String id;
  final String name;
  final String? text;
  final TextEditingController controller;
  bool hasChanged = false;
  bool isCreated = false;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();

  void createTrigger(String recordId, String toolId) {
    if (!isCreated) {
      createData(recordId, toolId);
    }
  }

  void updateTrigger() {
    if (isCreated && hasChanged) {
      updateData();
    }
  }

  Future<void> createData(String recordId, String toolId) async {
    String? dataId = await FieldService.instance.createData(recordId, toolId);
    print(controller.text);
    if (dataId != null) {
      String? textFieldId =
          await FieldService.instance.createTextField(dataId, controller.text);
      await FieldService.instance.updateDataFieldId(dataId, textFieldId!);
    }
  }

  updateData() {}
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.name),
        TextFormField(
          controller: widget.controller,
        ),
      ],
    );
  }
}
