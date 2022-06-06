import 'package:customizable_app/model/role_model.dart';
import 'package:customizable_app/widgets/user_checkbox_item.dart';
import 'package:flutter/material.dart';

class RoleButton extends StatefulWidget {
  RoleButton(this.role, this.userCheckBoxItems, this.recordId, {Key? key})
      : super(key: key);

  RoleModel role;
  bool isSelected = false;
  List<UserCheckboxItem> userCheckBoxItems;
  String recordId;
  @override
  _RoleButtonState createState() => _RoleButtonState();
}

class _RoleButtonState extends State<RoleButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  widget.isSelected ? Colors.blue : Colors.grey),
            ),
            onPressed: () {
              setState(() {
                widget.isSelected = !widget.isSelected;
              });
            },
            child: Text(widget.role.name)),
        if (widget.isSelected)
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: widget.userCheckBoxItems.length,
              itemBuilder: (BuildContext context, int index) {
                return UserCheckboxItem(
                    widget.role.id,
                    widget.userCheckBoxItems[index].user,
                    widget.recordId,
                    widget.userCheckBoxItems[index].isChecked);
              },
            ),
          ),
      ],
    );
  }
}
