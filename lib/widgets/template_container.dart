import 'package:customizable_app/model/template_model.dart';
import 'package:customizable_app/pages/record_page.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';

//TODO UI IMPROVEMENTS
class TemplateContainer extends StatelessWidget {
  const TemplateContainer({
    Key? key,
    required this.template,
  }) : super(key: key);
  final TemplateModel template;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          template.tools =
              await FieldService.instance.getToolsByTemplateId(template.id);
          template.roles =
              await FieldService.instance.getRolesByTemplateId(template.id);
          template.records =
              await FieldService.instance.getRecordsByTemplateId(template);

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RecordPage(template)));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(template.name),
            ),
          ),
        ),
      ),
    );
  }
}
