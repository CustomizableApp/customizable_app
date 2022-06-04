import 'package:customizable_app/model/template_model.dart';
import 'package:customizable_app/service/user.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:customizable_app/widgets/role_button.dart';
import 'package:customizable_app/widgets/user_checkbox_item.dart';
import 'package:flutter/material.dart';

class AssignRolePage extends StatefulWidget {
  const AssignRolePage(this.template, this.recordId, {Key? key})
      : super(key: key);
  final TemplateModel template;
  final String recordId;

  @override
  _AssignRolePageState createState() => _AssignRolePageState();
}

class _AssignRolePageState extends State<AssignRolePage> {
  bool isCreated = false;
  List<UserModel> users = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  getUsers() async {
    List<UserModel> data = await UserService.instance.getUsers();
    setState(() {
      users = data;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (!isCreated) {
      //TODO
      //delete record that has unassigned roles here
    }
  }

//TODO NEEDS UI IMPROVEMENT
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Roles"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.template.roles!.length,
            itemBuilder: (BuildContext context, int index) {
              List<UserCheckboxItem> userCheckboxItems =
                  List.empty(growable: true);
              for (UserModel user in users) {
                userCheckboxItems.add(UserCheckboxItem(
                    widget.template.roles![index].id, user, widget.recordId));
              }
              return RoleButton(widget.template.roles![index],
                  userCheckboxItems, widget.recordId);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isCreated = true;
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
