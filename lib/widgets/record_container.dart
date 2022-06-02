import 'package:customizable_app/model/record_model.dart';
import 'package:customizable_app/pages/show_record_page.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';

//TODO UI IMPROVEMENTS
class RecordContainer extends StatelessWidget {
  const RecordContainer({
    Key? key,
    required this.record,
  }) : super(key: key);
  final RecordModel record;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          record.datas =
              await FieldService.instance.getFieldIdAndTool(record.id);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ShowRecordPage(record)));
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
              child: Text(record.name),
            ),
          ),
        ),
      ),
    );
  }
}
