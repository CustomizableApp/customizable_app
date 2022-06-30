import 'dart:convert';

import 'package:customizable_app/service/auth_service.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateIntervalWidget extends StatefulWidget {
  DateIntervalWidget(
    this.id,
    this.name,
    this.firstDate,
    this.secondDate,
    this.fieldId,
    this.recordID,
    this.isReadable,
    this.isWritable, {
    Key? key,
  }) : super(key: key) {
    oldFirstDate=firstDate;
    oldSecondDate=secondDate;
  }
  final String id;
  final String name;
  //THEY NEED TO BE NULLABLE
  DateTime firstDate;
  DateTime secondDate;
  String? fieldId;
  bool isReadable=true;
  bool isWritable=true;
  String recordID;
  bool hasChanged = false;
  bool isCreated = false;
  late DateTime oldFirstDate;
  late DateTime oldSecondDate;

  Future<void> createTrigger(String recordId, String toolId) async {
    if (!isCreated) {
      await createData(recordId, toolId);
    }
  }

  void updateTrigger() {
    if (firstDate!=oldFirstDate || secondDate!=oldSecondDate) {
    updateData(fieldId!);
     }
  }

  Future<void> createData(String recordId, String toolId) async {
    String? dataId = await FieldService.instance.createData(recordId, toolId);
    if (dataId != null) {
      String? intervalDateFieldId = await FieldService.instance
          .createIntervalDateField(dataId, firstDate, secondDate);
      await FieldService.instance
          .updateDataFieldId(dataId, intervalDateFieldId!);
    }
  }

  updateData(String fieldId) async {
    await FieldService.instance
        .updateIntervalDateFieldData(fieldId, firstDate, secondDate);
        if(recordID!=""){
      await FieldService.instance.createFeedData(jsonEncode(AuthenticationService.instance.getUserId()+" edited "+ name), 4, recordID, "sehaId");
    }
  }

  @override
  _DateIntervalWidgetState createState() => _DateIntervalWidgetState();
}

class _DateIntervalWidgetState extends State<DateIntervalWidget> {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1970, 1, 1),
                            maxTime: DateTime(2036, 1, 1),
                            theme: const DatePickerTheme(
                                headerColor: Colors.orange,
                                backgroundColor: Colors.blue,
                                itemStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16)), onConfirm: (date) {
                          setState(() {
                            widget.firstDate = date;
                          });
                        },
                            currentTime: widget.firstDate,
                            locale: LocaleType.en);
                      },
                      child: Card(
                          child:
                              Text(DateFormat.yMd().format(widget.firstDate)))),
                ),
                Text(daysBetween(widget.firstDate, widget.secondDate)
                    .toString()),
                Flexible(
                  child: GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1970, 1, 1),
                            maxTime: DateTime(2036, 1, 1),
                            theme: const DatePickerTheme(
                                headerColor: Colors.orange,
                                backgroundColor: Colors.blue,
                                itemStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16)), onConfirm: (date) {
                          setState(() {
                            widget.secondDate = date;
                          });
                        },
                            currentTime: widget.secondDate,
                            locale: LocaleType.en);
                      },
                      child: Card(
                          child: Text(
                              DateFormat.yMd().format(widget.secondDate)))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
