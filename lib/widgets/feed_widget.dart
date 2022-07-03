import 'dart:async';
import 'dart:convert';

import 'package:customizable_app/model/feed_data_model.dart';
import 'package:customizable_app/service/auth_service.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FeedWidget extends StatefulWidget {
  List<FeedDataModel> feedData;
  final TextEditingController controller;
  String recordID;
  FeedWidget(this.controller, this.feedData, this.recordID, {Key? key})
      : super(key: key);

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  late Timer timer;

  @override
  void initState(){
    super.initState();
    timer =Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() { 
        fetchFeedData();
        print("object");
      });
    });
  }
  @override
  void dispose(){
    timer.cancel();
    super.dispose();
    
  }
  fetchFeedData() async {
    List<FeedDataModel>? fetchFeedData =
          await FieldService.instance.getFeedData(widget.recordID);
          widget.feedData=fetchFeedData;
  }

  Future<String> getUserName(String userID) async {
    return await UserService.instance.getUserNameByID(userID);
  }

  MainAxisAlignment isCurrentUserMain(String userID) {
    if (userID == AuthenticationService.instance.getUserId()) {
      return MainAxisAlignment.end;
    }
    else{
      return MainAxisAlignment.start;
    }
  }
  CrossAxisAlignment isCurrentUserCross(String userID) {
    if (userID == AuthenticationService.instance.getUserId()) {
      return CrossAxisAlignment.end;
    }
    else{
      return CrossAxisAlignment.start;
    }
  }
  bool isCurrentUser(String userID){
    if (userID == AuthenticationService.instance.getUserId()) {
      return true;
    }
    else{
      return false;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0)+const EdgeInsets.only(right:15.0),
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
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  switch (widget.feedData[index].contentType) {
                    case 1:
                      String text = jsonDecode(widget.feedData[index].content);
                      String id = widget.feedData[index].userID;

                      return SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: isCurrentUserMain(widget.feedData[index].userID),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder(
                                  future: getUserName(id),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      String data = snapshot.data;
                                      return Column(
                                        crossAxisAlignment: isCurrentUserCross(widget.feedData[index].userID),
                                        children: [
                                          Row(
                                            children: [
                                              Text(data),
                                            ],
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.87,

                                            child: Padding(
                                              padding: isCurrentUser(widget.feedData[index].userID)? const EdgeInsets.only(left:50.0):
                                              const EdgeInsets.only(right:50.0),
                                              child: Column(
                                                crossAxisAlignment: isCurrentUserCross(widget.feedData[index].userID),
                                                children: [
                                                  Text(
                                                    text,
                                                    overflow: TextOverflow.clip,
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    case 4:
                      String text = jsonDecode(widget.feedData[index].content);

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: Text(
                                      text,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
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
                IconButton(
                    onPressed: () async {
                      if (widget.controller.text != "") {
                        DateTime? timeStamp = await FieldService.instance
                            .createFeedData(
                                jsonEncode(widget.controller.text),
                                1,
                                widget.recordID,
                                AuthenticationService.instance.getUserId());
                        widget.feedData.add(FeedDataModel(
                            content: jsonEncode(widget.controller.text),
                            contentType: 1,
                            timeStamp: timeStamp.toString(),
                            userID:
                                AuthenticationService.instance.getUserId()));
                        widget.controller.text = "";
                        setState(() {});
                      }
                    },
                    icon: Icon(Icons.send))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
