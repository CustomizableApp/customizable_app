import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateIntervalWidget extends StatefulWidget {
  DateIntervalWidget(
    this.id,
    this.name,
    this.firstDate,
    this.secondDate, {
    Key? key,
  }) : super(key: key);
  final String id;
  final String name;
  //THEY NEED TO BE NULLABLE
  DateTime firstDate;
  DateTime secondDate;
  bool hasChanged = false;
  bool isCreated = false;

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
    if (dataId != null) {
      String? intervalDateFieldId = await FieldService.instance
          .createIntervalDateField(dataId, firstDate, secondDate);
      await FieldService.instance
          .updateDataFieldId(dataId, intervalDateFieldId!);
    }
  }

  updateData() {}
  @override
  _DateIntervalWidgetState createState() => _DateIntervalWidgetState();
}

class _DateIntervalWidgetState extends State<DateIntervalWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
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
                            doneStyle:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        onConfirm: (date) {
                      setState(() {
                        widget.firstDate = date;
                      });
                    }, currentTime: widget.firstDate, locale: LocaleType.en);
                  },
                  child: Flexible(
                      child: Card(
                          child: Text(
                              DateFormat.yMd().format(widget.firstDate))))),
              Text(daysBetween(widget.firstDate, widget.secondDate).toString()),
              GestureDetector(
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
                            doneStyle:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        onConfirm: (date) {
                      setState(() {
                        widget.secondDate = date;
                      });
                    }, currentTime: widget.secondDate, locale: LocaleType.en);
                  },
                  child: Flexible(
                      child: Card(
                          child: Text(
                              DateFormat.yMd().format(widget.secondDate))))),
            ],
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
