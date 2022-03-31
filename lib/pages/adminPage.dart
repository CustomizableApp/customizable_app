
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:customizable_app/service/user.dart';
import 'package:customizable_app/widgets/checkbox.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        centerTitle: true,
        
      ),
      body: SizedBox(
        child: Container(
          child: FutureBuilder(
                  future: UserService.instance.getAllUsers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<User> users = [];
                      List<dynamic> datas = snapshot.data.data["CargoDB_User"];
                      for (int i = 0; i < datas.length; i++) {
                           users.add(User.fromMap(datas[i]));
                        }
                      return CheckBoxListTile(users);
                      
                    } else {
                      return Container(
                        
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }
}

