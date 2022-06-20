import 'package:customizable_app/model/tickable_field_item_model.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';

class TickableFieldWidet extends StatefulWidget {
  TickableFieldWidet(this.id, this.fieldId, this.name, this.tickableItems,
      {Key? key})
      : super(key: key);
  final String id;
  final String name;
  String? fieldId;
  List<TickableFieldItemModel>? tickableItems;
  bool hasChanged = false;
  bool isCreated = false;

  @override
  _TickableFieldWidetState createState() => _TickableFieldWidetState();

  Future<void> createTrigger(String recordId, String toolId) async {
    if (!isCreated) {
      await createData(recordId, toolId);
    }
  }

  void updateTrigger() {
    updateData(fieldId!);
  }

  Future<int> createData(String recordId, String toolId) async {
    String? dataId = await FieldService.instance.createData(recordId, toolId);
    if (dataId != null) {
      String? tickableFieldId =
          await FieldService.instance.createTickableField(dataId);
      await FieldService.instance.updateDataFieldId(dataId, tickableFieldId!);
      for (int i = 0; i < tickableItems!.length; i++) {
        await FieldService.instance
            .createTickableFieldItem(tickableFieldId, tickableItems![i].text);
      }
      return 1;
    }
    return 0;
  }

  Future<void> updateData(String fieldId) async {}
}

class _TickableFieldWidetState extends State<TickableFieldWidet> {
  @override
  void initState() {
    widget.tickableItems ??= [];
    super.initState();
  }

  Future<void> createNewListItemDialog() async {
    TextEditingController controller = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create new list item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Enter the list item'),
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter list item',
                  ),
                  controller: controller,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue'),
              onPressed: () async {
                String text = controller.text;
                TickableFieldItemModel tickableItem;
                if (widget.fieldId != null) {
                  String? itemID = await FieldService.instance
                      .createTickableFieldItem(widget.fieldId!, text);
                  tickableItem = TickableFieldItemModel(
                      id: itemID!, text: text, ticked: false);
                } else {
                  tickableItem =
                      TickableFieldItemModel(id: "", text: text, ticked: false);
                }
                widget.tickableItems!.add(tickableItem);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    widget.tickableItems!.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Click + button to add new list item"),
                          )
                        : SizedBox(
                            height: 100,
                            width: 300,
                            child: ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: widget.tickableItems!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(widget.tickableItems![index].text,
                                          style: const TextStyle(fontSize: 20)),
                                      Text(
                                          widget.tickableItems![index].ticked
                                              .toString(),
                                          style: const TextStyle(fontSize: 20))
                                    ],
                                  );
                                }),
                          ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        await createNewListItemDialog();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
