import 'dart:convert';

import 'package:customizable_app/model/feed_data_model.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FeedWidget extends StatefulWidget {
  List<FeedDataModel> feedData;
  final TextEditingController controller;
  String recordID;
  FeedWidget(this.controller, this.feedData,this.recordID, {Key? key}) : super(key: key);

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.feedData == null ? 0 : widget.feedData.length,
                itemBuilder: (BuildContext context, int index) {
                  switch (widget.feedData[index].contentType) {
                    case 1:
                      String text =jsonDecode( widget.feedData[index].content);
                      //String text=jsonEncode(widget.feedData[index].content);

                      return Row(
                        mainAxisAlignment:
                            widget.feedData[index].userID == "sehaId"
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                              child: Text(
                                text,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      );
                    default:
                      return Container();
                  }
                }),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: widget.controller,
                    ),
                  ),
                ),
                IconButton(onPressed: () async {
                  if(widget.controller.text !=""){
                    //TODO CONSTANT USER ID WILL CHANGE
                    DateTime? timeStamp= await FieldService.instance.createFeedData(jsonEncode(widget.controller.text), 1, widget.recordID, "sehaId");
                    widget.feedData.add(FeedDataModel(content: jsonEncode(widget.controller.text), contentType: 1, timeStamp: timeStamp.toString(), userID: "sehaId"));
                    widget.controller.text="";
                    setState(() {
                      
                    });
                  }
                }, icon: Icon(Icons.send))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
