import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateFieldWidget extends StatefulWidget {
  DateFieldWidget(
    this.id,
    this.name,
    this.date,
    this.fieldId, {
    Key? key,
  }) : super(key: key) {
   oldDate=date;
  }
  final String id;
  final String name;
  //THEY NEED TO BE NULLABLE
  DateTime date;
  late DateTime oldDate;
  String? fieldId;
  bool hasChanged = false;
  bool isCreated = false;

  Future<void> createTrigger(String recordId, String toolId) async {
    if (!isCreated) {
      await createData(recordId, toolId);
    }
  }

  void updateTrigger() {
     if (date!=oldDate) {
    updateData(fieldId!);
     }
  }

  Future<void> createData(String recordId, String toolId) async {
    String? dataId = await FieldService.instance.createData(recordId, toolId);
    if (dataId != null) {
      String? dateFieldId =
          await FieldService.instance.createDateField(dataId, date);
      await FieldService.instance.updateDataFieldId(dataId, dateFieldId!);
    }
  }

  updateData(String fieldId) async {
    await FieldService.instance.updateDateFieldData(fieldId, date);
  }

  @override
  _DateFieldWidgetState createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
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
                            widget.date = date;
                          });
                        }, currentTime: widget.date, locale: LocaleType.en);
                      },
                      child: Card(
                          child: Text(DateFormat.yMd().format(widget.date)))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
