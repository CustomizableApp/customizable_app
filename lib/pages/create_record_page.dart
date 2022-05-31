import 'package:customizable_app/model/template_model.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/widgets/date_field_widget.dart';
import 'package:customizable_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Function> functions = [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recordName),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.template.tools == null
                  ? 0
                  : widget.template.tools!.length,
              itemBuilder: (BuildContext context, int index) {
                switch (widget.template.tools![index].type) {
                  case 1:
                    TextEditingController controller = TextEditingController();
                    TextFieldWidget textFieldWidget = TextFieldWidget(
                        widget.template.tools![index].id,
                        widget.template.tools![index].name,
                        null,
                        controller);

                    functions.add(textFieldWidget.createTrigger);
                    return textFieldWidget;

                  case 2:
                    DateIntervalWidget dateIntervalWidget = DateIntervalWidget(
                        widget.template.tools![index].id,
                        widget.template.tools![index].name,
                        DateTime(2000, 1, 1),
                        DateTime(2000, 1, 1));

                    functions
                        .add(dateIntervalWidget.createState().createTrigger);

                    return dateIntervalWidget;

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
          String? recordId = await FieldService.instance
              .createRecord(widget.recordName, widget.template.id);
          int index = 0;
          for (Function function in functions) {
            function.call(recordId, widget.template.tools![index].id);
            index++;
          }
        },
      ),
    );
  }
}
