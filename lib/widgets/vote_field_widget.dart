import 'package:customizable_app/model/vote_field_item.dart';
import 'package:customizable_app/service/auth_service.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';

class VoteFieldWidget extends StatefulWidget {
  VoteFieldWidget(this.id, this.fieldId, this.name, this.voteItems,
    this.isWritable,this.isVoted,{Key? key})
      : super(key: key);
  final String id;
  final String name;
  String? fieldId;
  bool isWritable=true;
  List<VoteFieldItemModel>? voteItems;
  bool hasChanged = false;
  bool isCreated = false;
  bool isVoted=false;

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
      for (int i = 0; i < voteItems!.length; i++) {
        await FieldService.instance
            .createVoteFieldItem(voteFieldId, voteItems![i].text);
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
                String text = controller.text;
                VoteFieldItemModel voteItem;
                if (widget.fieldId != null) {
                  String? itemID = await FieldService.instance
                      .createVoteFieldItem(widget.fieldId!, text);
                  voteItem =
                      VoteFieldItemModel(id: itemID!, text: text, count: 0);
                } else {
                  voteItem = VoteFieldItemModel(id: "", text: text, count: 0);
                }
                widget.voteItems!.add(voteItem);
                setState(() {
                  
                });
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
                            width: MediaQuery.of(context).size.width*0.95,
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                                padding: const EdgeInsets.all(8),
                                itemCount: widget.voteItems!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.voteItems![index].text,
                                            style: const TextStyle(fontSize: 20)),
                                            widget.isVoted?Container():

                                            ElevatedButton(
                                        child: const Text("VOTE"),
                                        onPressed: ()  async{
                                          await FieldService.instance.createVoteFieldVoter(AuthenticationService.instance.getUserId(), widget.fieldId!);
                                          await FieldService.instance.updateVoteItem(widget.voteItems![index].id);
                                          setState(()  {

                                            widget.voteItems![index].count++;
                                            widget.isVoted=true;
                                          });
                                        }),
                                        Text(
                                            widget.voteItems![index].count
                                                .toString(),
                                            style: const TextStyle(fontSize: 20))
                                      ],
                                    ),
                                  );
                                }),
                          ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        await createNewVoteItemDialog();
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
