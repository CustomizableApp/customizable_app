import 'dart:convert';

import 'package:customizable_app/service/auth_service.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/service/user.dart';
import 'package:customizable_app/utils/toast_util.dart';

import 'package:flutter/material.dart';

import '../service/user_service.dart';

class UserCheckboxItem extends StatefulWidget {
  UserCheckboxItem(this.roleId, this.user, this.recordId, this.isChecked,
      {Key? key})
      : super(key: key);
  final UserModel user;
  bool isChecked;
  String roleId;
  String recordId;

  

  @override
  _UserCheckboxItemState createState() => _UserCheckboxItemState();
}

class _UserCheckboxItemState extends State<UserCheckboxItem> {
   Future<String> getUserName(String userID) async {
    return await UserService.instance.getUserNameByID(userID);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserService.instance.currentUser!.type == 0
            ? Container()
            : Checkbox(
                value: widget.isChecked,
                onChanged: (value) async {
                  setState(() {
                    widget.isChecked = value!;
                  });
                  if (value!) {
                    bool status = await FieldService.instance.assignUserToRole(
                        widget.recordId, widget.roleId, widget.user.id!);
                    if (widget.recordId != "") {
                      await FieldService.instance.createFeedData(
                          jsonEncode(
                              await getUserName(AuthenticationService.instance.getUserId()) +
                                  " assigned " +
                                  widget.user.name! +
                                  " to role x"),
                          4,
                          widget.recordId,
                          AuthenticationService.instance.getUserId());
                    }
                    if (status) {
                      ToastUtil.toastMessage(context,
                          "${widget.user.name} assigned to role!", "OK");
                    }
                  } else {
                    bool status = await FieldService.instance
                        .unAssignUserToRole(
                            widget.recordId, widget.roleId, widget.user.id!);
                    if (widget.recordId != "") {
                      await FieldService.instance.createFeedData(
                          jsonEncode(
                              await getUserName(AuthenticationService.instance.getUserId()) +
                                  " unassigned " +
                                  widget.user.name! +
                                  " from role x"),
                          4,
                          widget.recordId,
                          AuthenticationService.instance.getUserId());
                    }
                    if (status) {
                      ToastUtil.toastMessage(context,
                          "${widget.user.name} unassigned from role!", "OK");
                    }
                  }
                }),
        SizedBox(height:40,child: Text(widget.user.name! + " " + widget.user.surname!)),
      ],
    );
  }
}
