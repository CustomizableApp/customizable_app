import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/service/user.dart';
import 'package:customizable_app/utils/toast_util.dart';

import 'package:flutter/material.dart';

class UserCheckboxItem extends StatefulWidget {
  UserCheckboxItem(this.roleId, this.user, this.recordId, {Key? key})
      : super(key: key);
  final UserModel user;
  bool isChecked = false;
  String roleId;
  String recordId;

  @override
  _UserCheckboxItemState createState() => _UserCheckboxItemState();
}

class _UserCheckboxItemState extends State<UserCheckboxItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: widget.isChecked,
            onChanged: (value) async {
              setState(() {
                widget.isChecked = value!;
              });
              if (value!) {
                bool status = await FieldService.instance.assignUserToRole(
                    widget.recordId, widget.roleId, widget.user.id!);
                if (status) {
                  ToastUtil.toastMessage(
                      context, "${widget.user.name} assigned to role!", "OK");
                }
              } else {
                bool status = await FieldService.instance.unAssignUserToRole(
                    widget.recordId, widget.roleId, widget.user.id!);
                if (status) {
                  ToastUtil.toastMessage(context,
                      "${widget.user.name} unassigned from role!", "OK");
                }
              }
            }),
        Text(widget.user.name! + " " + widget.user.surname!),
      ],
    );
  }
}
