import 'package:customizable_app/model/vote_field_item.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';

class VoteFieldWidget extends StatefulWidget {
  VoteFieldWidget(this.id, this.fieldId, this.name, this.voteItems, {Key? key})
      : super(key: key);
  final String id;
  final String name;
  String? fieldId;
  List<VoteFieldItemModel>? voteItems;
  bool hasChanged = false;
  bool isCreated = false;

  @override
  _VoteFieldWidgetState createState() => _VoteFieldWidgetState();

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
      String? voteFieldId = await FieldService.instance.createVoteField(dataId);
      await FieldService.instance.updateDataFieldId(dataId, voteFieldId!);
      for(int i=0;i<voteItems!.length;i++){
        await FieldService.instance.createVoteFieldItem(voteFieldId, voteItems![i].text);
      }
      return 1;
    }
    return 0;
  }

  Future<void> updateData(String fieldId) async {}
}

class _VoteFieldWidgetState extends State<VoteFieldWidget> {
  @override
  void initState() {
    widget.voteItems ??= [];
    super.initState();
  }

  Future<void> createNewVoteItemDialog() async {
    TextEditingController controller = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create new vote item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Enter the vote item'),
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter vote item',
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
                VoteFieldItemModel voteItem= VoteFieldItemModel(id: "", text: controller.text, count: 0);
                widget.voteItems!.add(voteItem);
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
                widget.voteItems!.isEmpty
                    ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Click + button to add new vote item"),
                    )
                    : SizedBox(
                      height: 100,
                      width: 300,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: widget.voteItems!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.voteItems![index].text,style: const TextStyle(fontSize: 20)),
                                Text(widget.voteItems![index].count.toString(),style: const TextStyle(fontSize: 20))
                              ],
                            );
                          }),
                    ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await createNewVoteItemDialog();
                    setState(() {
                      
                    });
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
