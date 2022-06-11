import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  TextFieldWidget(
    this.id,
    this.name,
    this.fieldId,
    this.text,
    this.controller, {
    Key? key,
  }) : super(key: key);
  final String id;
  final String name;
  String text;
  String? fieldId;
  final TextEditingController controller;
  bool hasChanged = false;
  bool isCreated = false;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();

  Future<void> createTrigger(String recordId, String toolId) async {
    if (!isCreated) {
      await createData(recordId, toolId);
    }
  }

  void updateTrigger() {
    if (text != controller.text) {
    updateData(fieldId!);
    }
  }

  Future<int> createData(String recordId, String toolId) async {
    String? dataId = await FieldService.instance.createData(recordId, toolId);
    if (dataId != null) {
      String? textFieldId =
          await FieldService.instance.createTextField(dataId, controller.text);
      await FieldService.instance.updateDataFieldId(dataId, textFieldId!);
      return 1;
    }
    return 0;
  }

  updateData(String fieldId) async {
    await FieldService.instance.updateTextFieldData(fieldId, controller.text);
  }
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.name),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              controller: widget.controller,
            ),
          )
        ],
      ),
    );
  }
}
