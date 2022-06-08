import 'package:customizable_app/model/record_model.dart';
import 'package:customizable_app/pages/assign_role.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/utils/toast_util.dart';
import 'package:customizable_app/widgets/counter_field_widget.dart';
import 'package:customizable_app/widgets/date_field_widget.dart';
import 'package:customizable_app/widgets/interval_date_field_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/text_field_widget.dart';

class ShowRecordPage extends StatefulWidget {
  const ShowRecordPage(this.record, {Key? key}) : super(key: key);
  final RecordModel record;

  @override
  _ShowRecordPageState createState() => _ShowRecordPageState();
}

class _ShowRecordPageState extends State<ShowRecordPage> {
  Function getFunctionWithType(int type) {
    switch (type) {
      case 1:
        return FieldService.instance.getTextFieldData;

      case 2:
        return FieldService.instance.getIntervalDateFieldData;

      case 3:
        return FieldService.instance.getDateFieldData;
      case 4:
        return FieldService.instance.getCounterFieldData;

      default:
        return FieldService.instance.getTextFieldData;
    }
  }

  List<Function> functions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record.name),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignRolePage(widget.record),
                  ),
                );
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount:
                  widget.record.datas == null ? 0 : widget.record.datas!.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder(
                  future: getFunctionWithType(widget.record.datas![index].type)
                      .call(widget.record.datas![index].fieldId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (widget.record.datas![index].type) {
                      case 1:
                        if (snapshot.hasData) {
                          String text = snapshot.data;
                          TextEditingController controller =
                              TextEditingController();
                          controller.text = text;
                          TextFieldWidget textFieldWidget = TextFieldWidget(
                            widget.record.datas![index].id,
                            widget.record.datas![index].name,
                            widget.record.datas![index].fieldId,
                            text,
                            controller,
                          );

                          functions.add(textFieldWidget.updateTrigger);
                          return textFieldWidget;
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      case 2:
                        if (snapshot.hasData) {
                          List<DateTime> dateList = snapshot.data;
                          DateIntervalWidget dateIntervalWidget =
                              DateIntervalWidget(
                            widget.record.datas![index].id,
                            widget.record.datas![index].name,
                            dateList[0],
                            dateList[1],
                            widget.record.datas![index].fieldId,
                          );

                          functions.add(dateIntervalWidget.updateTrigger);

                          return dateIntervalWidget;
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      case 3:
                        if (snapshot.hasData) {
                          DateTime date = snapshot.data;
                          DateFieldWidget dateFieldWidget = DateFieldWidget(
                            widget.record.datas![index].id,
                            widget.record.datas![index].name,
                            date,
                            widget.record.datas![index].fieldId,
                          );

                          functions.add(dateFieldWidget.updateTrigger);

                          return dateFieldWidget;
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                      case 4:
                        if (snapshot.hasData) {
                          int counter = snapshot.data;
                          CounterFieldWidget counterFieldWidget =
                              CounterFieldWidget(
                            widget.record.datas![index].id,
                            widget.record.datas![index].name,
                            widget.record.datas![index].fieldId,
                            counter,
                          );

                          functions.add(counterFieldWidget.updateTrigger);
                          return counterFieldWidget;
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      default:
                        return Container();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          for (Function function in functions) {
            function.call();
          }
          functions.clear();
          ToastUtil.toastMessage(context, "updated.", "OK");
          Navigator.pop(context);
        },
      ),
    );
  }
}
