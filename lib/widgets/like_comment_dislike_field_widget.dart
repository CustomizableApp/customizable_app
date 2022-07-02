import 'package:customizable_app/model/like_dislike_comment_model.dart';
import 'package:customizable_app/service/auth_service.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:flutter/material.dart';

class LikeDislikeCommentWidget extends StatefulWidget {
  LikeDislikeCommentWidget(this.id, this.fieldId, this.name,
      this.likeDislikeCommentItems, this.isWritable,this.isInteracted, this.isLiked,
      {Key? key})
      : super(key: key);
  final String id;
  final String name;
  String? fieldId;
  bool isWritable = true;
  LikeDislikeCommentItemModel? likeDislikeCommentItems;
  bool isInteracted = false;
  bool isLiked = false;
  bool hasChanged = false;
  bool isCreated = false;

  @override
  _LikeDislikeCommentWidgetState createState() =>
      _LikeDislikeCommentWidgetState();

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
      String? fieldId =
          await FieldService.instance.createLikeCommentDislikeField(dataId);
      await FieldService.instance.updateDataFieldId(dataId, fieldId!);
      return 1;
    }
    return 0;
  }

  Future<void> updateData(String fieldId) async {}
}

class _LikeDislikeCommentWidgetState extends State<LikeDislikeCommentWidget> {
  bool writeComment = false;
  TextEditingController controller = TextEditingController();
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.0),
                              )),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.likeDislikeCommentItems?.like
                                      .toString() ??
                                  "0"),
                            ),
                          )),
                    ),
                    IconButton(
                        onPressed: () async {
                          if (widget.isInteracted) {
                            if (widget.isLiked) {
                            } else {
                              await FieldService.instance.updateLCDItem(widget.fieldId!, true, AuthenticationService.instance.getUserId());
                              await FieldService.instance
                                  .updateLikeAndDislike(widget.fieldId!, 1, -1);
                              setState(() {
                                widget.isLiked = true;
                                widget.likeDislikeCommentItems!.like++;
                                widget.likeDislikeCommentItems!.dislike--;
                              });
                            }
                          } else {
                            await FieldService.instance.createLCDItem(widget.fieldId!, true, AuthenticationService.instance.getUserId());
                            await FieldService.instance
                                .updateLikeAndDislike(widget.fieldId!, 1, 0);
                            setState(() {
                              widget.isInteracted=true;
                              widget.isLiked = true;
                              widget.likeDislikeCommentItems!.like++;
                            });
                          }
                        },
                        icon: const Icon(Icons.arrow_upward)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            writeComment = !writeComment;
                          });
                        },
                        icon: const Icon(Icons.comment)),
                    IconButton(
                        onPressed: () async {
                          if (widget.isInteracted) {
                            if (!widget.isLiked) {
                            } else {
                              await FieldService.instance.updateLCDItem(widget.fieldId!, false, AuthenticationService.instance.getUserId());
                              await FieldService.instance
                                  .updateLikeAndDislike(widget.fieldId!, -1, 1);
                              setState(() {
                                widget.isLiked = false;
                                widget.likeDislikeCommentItems!.like--;
                                widget.likeDislikeCommentItems!.dislike++;
                              });
                            }
                          } else {
                            await FieldService.instance.createLCDItem(widget.fieldId!, false, AuthenticationService.instance.getUserId());
                            await FieldService.instance
                                .updateLikeAndDislike(widget.fieldId!, 0, 1);
                            setState(() {
                              widget.isInteracted=true;
                              widget.isLiked = false;
                              widget.likeDislikeCommentItems!.dislike++;
                            });
                          }
                        },
                        icon: const Icon(Icons.arrow_downward)),
                    Container(
                      color: Colors.transparent,
                      child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.0),
                              )),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget
                                      .likeDislikeCommentItems?.dislike
                                      .toString() ??
                                  "0"),
                            ),
                          )),
                    ),
                  ],
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      widget.likeDislikeCommentItems?.comments?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Text(widget.likeDislikeCommentItems!
                                      .comments![index].comment),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 40),
                              child: SizedBox(
                                height: 20,
                                child: FutureBuilder(
                                  future: UserService.instance.getUserNameByID(
                                      widget.likeDislikeCommentItems!
                                          .comments![index].userId),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(snapshot.data);
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                if (writeComment)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller,
                          decoration: const InputDecoration(
                              hintText: "write comment.."),
                        ),
                        IconButton(
                            onPressed: () async {
                              String? id = await FieldService.instance
                                  .createComment(
                                      widget.fieldId!, controller.text);
                              if (id != null) {
                                setState(() {
                                  widget.likeDislikeCommentItems!.comments?.add(
                                      CommentModel(
                                          comment: controller.text,
                                          id: id,
                                          likeDislikeFieldId: widget.fieldId!,
                                          userId: AuthenticationService.instance
                                              .getUserId()));
                                  writeComment = false;
                                });
                              }
                            },
                            icon: const Icon(Icons.send))
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
