import 'dart:convert';

import 'package:customizable_app/service/auth_service.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';

import '../service/user_service.dart';

class CounterFieldWidget extends StatefulWidget {
  CounterFieldWidget(
    this.id,
    this.name,
    this.fieldId,
    this.counter,
    this.recordID,
    this.isWritable, {
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
  bool isWritable=true;

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
    if (recordID != "") {
      await FieldService.instance.createFeedData(
          jsonEncode(await getUserName(AuthenticationService.instance.getUserId()) + " edited " + name), 4, recordID, AuthenticationService.instance.getUserId());
    }
  }
   Future<String> getUserName(String userID) async {
    return await UserService.instance.getUserNameByID(userID);
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
                widget.isWritable?
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (widget.counter > 0) {
                          widget.counter--;
                        }
                      });
                    },
                    icon: const Icon(Icons.remove)):Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.counter.toString()),
                ),
                widget.isWritable?
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.counter++;
                      });
                    },
                    icon: const Icon(Icons.add)):
                    Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
