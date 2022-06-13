import 'package:customizable_app/model/record_model.dart';
import 'package:customizable_app/model/template_model.dart';
import 'package:customizable_app/pages/assign_role.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/utils/toast_util.dart';
import 'package:customizable_app/widgets/counter_field_widget.dart';
import 'package:customizable_app/widgets/draw_field_widget.dart';
import 'package:customizable_app/widgets/image_field_widget.dart';
import 'package:customizable_app/widgets/interval_date_field_widget.dart';
import 'package:customizable_app/widgets/text_field_widget.dart';
import 'package:customizable_app/widgets/vote_field_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/date_field_widget.dart';

class CreateRecordPage extends StatefulWidget {
  const CreateRecordPage(
    this.template,
    this.recordName, {
    Key? key,
  }) : super(key: key);
  final TemplateModel template;
  final String recordName;
  @override
  State<CreateRecordPage> createState() => _CreateRecordPageState();
}

class _CreateRecordPageState extends State<CreateRecordPage> {
  final List<Widget> templateTools = [];
  late List<Function> functions = [];
  @override
  void initState() {
    super.initState();
    getTemplateTools();
  }

  void getTemplateTools() {
    for (int i = 0; i < widget.template.tools!.length; i++) {
      switch (widget.template.tools![i].type) {
        case 1:
          TextEditingController controller = TextEditingController();
          final TextFieldWidget textFieldWidget = TextFieldWidget(
              widget.template.tools![i].id,
              widget.template.tools![i].name,
              null,
              "",
              controller);

          functions.add(textFieldWidget.createTrigger);

          templateTools.add(textFieldWidget);
          break;

        case 2:
          final DateIntervalWidget dateIntervalWidget = DateIntervalWidget(
              widget.template.tools![i].id,
              widget.template.tools![i].name,
              DateTime(2000, 1, 1),
              DateTime(2000, 1, 1),
              null);

          functions.add(dateIntervalWidget.createTrigger);

          templateTools.add(dateIntervalWidget);
          break;

        case 3:
          DateFieldWidget dateFieldWidget = DateFieldWidget(
              widget.template.tools![i].id,
              widget.template.tools![i].name,
              DateTime(2000, 1, 1),
              null);

          functions.add(dateFieldWidget.createTrigger);

          templateTools.add(dateFieldWidget);
          break;
        case 4:
          CounterFieldWidget counterFieldWidget = CounterFieldWidget(
            widget.template.tools![i].id,
            widget.template.tools![i].name,
            null,
            0,
          );

          functions.add(counterFieldWidget.createTrigger);

          templateTools.add(counterFieldWidget);
          break;

        case 5:
          ImageFieldWidget imageFieldWidget = ImageFieldWidget(
              widget.template.tools![i].id,
              widget.template.tools![i].name,
              null,
              "");

          functions.add(imageFieldWidget.createTrigger);

          templateTools.add(imageFieldWidget);
          break;

        case 6:
          DrawFieldWidget drawFieldWidget = DrawFieldWidget(
              widget.template.tools![i].id,
              widget.template.tools![i].name,
              null,
              "");

          functions.add(drawFieldWidget.createTrigger);

          templateTools.add(drawFieldWidget);
          break;

        case 7:
          VoteFieldWidget voteFieldWidget = VoteFieldWidget(
              widget.template.tools![i].id,
              null,
              widget.template.tools![i].name,
              null);

          functions.add(voteFieldWidget.createTrigger);
          templateTools.add(voteFieldWidget);
          break;

        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recordName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: templateTools,
        ),
      )

      /*ListView(
        addRepaintBoundaries: false,
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        children: templateTools,
      )*/

      /*ListView.builder(
        addRepaintBoundaries: false,
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        itemCount: templateTools.length,
        itemBuilder: (BuildContext context, int index) {
          return templateTools[index];
        },
      )*/
      ,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          String? recordId = await FieldService.instance
              .createRecord(widget.recordName, widget.template.id);

          int index = 0;
          for (Function function in functions) {
            await function.call(recordId, widget.template.tools![index].id);

            //await createData(function, recordId, widget.template.tools![index].id);
            index++;
          }

          /*for(int i=0;i<functions.length;i++){
            createData(functions[i], recordId, widget.template.tools![i].id);
          }*/
          functions.clear();

          //TODO BURASI TOPLANACAK

          List<RecordModel> records = await FieldService.instance
              .getRecordsByTemplateId(widget.template);
          Iterable<RecordModel> createdRecordAsList =
              records.where((element) => element.id == recordId);
          RecordModel record = createdRecordAsList.first;

          //TODO BURASI TOPLANACAK

          if (recordId != null) {
            ToastUtil.toastMessage(context, "Record created.", "OK");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AssignRolePage(record),
              ),
            );
          }
        },
      ),
    );
  }
}
