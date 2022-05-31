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
  DateTime firstDate;
  DateTime secondDate;

  @override
  _DateIntervalWidgetState createState() => _DateIntervalWidgetState();
}

class _DateIntervalWidgetState extends State<DateIntervalWidget> {
  bool hasChanged = false;
  bool isCreated = false;
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

  void createTrigger() {
    if (!isCreated) {
      createData();
    }
  }

  void updateTrigger() {
    if (isCreated && hasChanged) {
      updateData();
    }
  }

  void createData() {
    print("dateField");
  }

  updateData() {}
}
