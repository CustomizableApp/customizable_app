import 'dart:convert';

import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';

class CounterFieldWidget extends StatefulWidget {
  CounterFieldWidget(
    this.id,
    this.name,
    this.fieldId,
    this.counter,
    this.recordID, {
    Key? key,
  }) : super(key: key) {
    oldCounter=counter;
  }
  final String id;
  final String name;
  String recordID;
  int counter;
  late int oldCounter;
  String? fieldId;
  bool hasChanged = false;
  bool isCreated = false;

  @override
  _CounterFieldWidgetState createState() => _CounterFieldWidgetState();

  Future<void> createTrigger(String recordId, String toolId) async {
    if (!isCreated) {
      await createData(recordId, toolId);
    }
  }

  void updateTrigger() {
    if (counter!=oldCounter) {
    updateData(fieldId!);
    }
  }

  Future<int> createData(String recordId, String toolId) async {
    String? dataId = await FieldService.instance.createData(recordId, toolId);
    if (dataId != null) {
      String? counterFieldId =
          await FieldService.instance.createCounterField(dataId, counter);
      await FieldService.instance.updateDataFieldId(dataId, counterFieldId!);
      return 1;
    }
    return 0;
  }

  updateData(String fieldId) async {
    await FieldService.instance.updateCounterFieldData(fieldId, counter);
    if(recordID!=""){
      await FieldService.instance.createFeedData(jsonEncode("sehaId"+" edited "+ name), 4, recordID, "sehaId");
    }
  }
}

class _CounterFieldWidgetState extends State<CounterFieldWidget> {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (widget.counter > 0) {
                          widget.counter--;
                        }
                      });
                    },
                    icon: const Icon(Icons.remove)),
                Text(widget.counter.toString()),
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.counter++;
                      });
                    },
                    icon: const Icon(Icons.add)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
