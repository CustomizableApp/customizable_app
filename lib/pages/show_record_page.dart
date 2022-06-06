import 'package:customizable_app/model/record_model.dart';
import 'package:customizable_app/pages/assign_role.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/utils/toast_util.dart';
import 'package:customizable_app/widgets/date_field_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/text_field_widget.dart';

class ShowRecordPage extends StatefulWidget {
  const ShowRecordPage(this.record, {Key? key}) : super(key: key);
  final RecordModel record;

  @override
  _ShowRecordPageState createState() => _ShowRecordPageState();
}

class _ShowRecordPageState extends State<ShowRecordPage> {
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
                switch (widget.record.datas![index].type) {
                  case 1:
                    return FutureBuilder(
                      future: FieldService.instance.getTextFieldData(
                          widget.record.datas![index].fieldId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          String text = snapshot.data;
                          // print("*****" * 10);
                          // print(index);
                          // print(text);
                          // print(widget.record.datas![index].name);
                          // print(widget.record.datas![index].fieldId);
                          // print("*****" * 10);
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
                      },
                    );

                  case 2:
                    return FutureBuilder(
                      future: FieldService.instance.getIntervalDateFieldData(
                          widget.record.datas![index].fieldId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                      },
                    );
                  default:
                    return Container();
                }
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
