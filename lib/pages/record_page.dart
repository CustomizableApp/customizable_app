import 'package:customizable_app/model/template_model.dart';
import 'package:customizable_app/pages/create_record_page.dart';
import 'package:customizable_app/widgets/record_container.dart';
import 'package:flutter/material.dart';

class RecordPage extends StatefulWidget {
  const RecordPage(this.template, {Key? key}) : super(key: key);
  final TemplateModel template;
  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Page"),
        actions: [
          IconButton(
              onPressed: () {
                showMyDialog();
              },
              icon: const Icon(Icons.add))
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.template.records == null
                  ? 0
                  : widget.template.records!.length,
              itemBuilder: (BuildContext context, int index) {
                return RecordContainer(record: widget.template.records![index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showMyDialog() async {
    TextEditingController controller = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create new record'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Name your new record'),
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter record name',
                  ),
                  controller: controller,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateRecordPage(
                            widget.template, controller.text)));
              },
            ),
          ],
        );
      },
    );
  }
}
