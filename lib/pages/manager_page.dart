import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:customizable_app/service/user.dart';
import 'package:customizable_app/service/auth_service.dart';
import 'package:customizable_app/widgets/checkbox.dart';
import 'package:customizable_app/widgets/checkbox2.dart' as ManagerCheckbox;

class managerPage extends StatefulWidget {
  const managerPage({ Key? key }) : super(key: key);

  @override
  State<managerPage> createState() => _managerPageState();
}

class _managerPageState extends State<managerPage> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manager"),
        centerTitle: true,
        
      ),
      body: Container(
        child: FutureBuilder(
                future: UserService.instance.getNonAssignedCargo(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<int> cargoIDs=[];
                  if (snapshot.hasData) {
                    List<dynamic> datas = snapshot.data.data["CargoDB_Cargo"];
                    for (int i = 0; i < datas.length; i++) {
                      cargoIDs.add(datas[i]["CargoID"]);
                    }
                    return Scaffold(
                  body: ListView.builder(
                itemCount: cargoIDs.length,
               itemBuilder: (context, index) {
                return ExpandablePanel(
                    header: Text(cargoIDs[index].toString()),
                    collapsed: Text(""),
                    expanded:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 1000,
                        height: 150,
                        
                        child: FutureBuilder(
                          future: UserService.instance.getAllUsers(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                          List<User> users = [];
                          List<dynamic> datas = snapshot.data.data["CargoDB_User"];

                        for (int i = 0; i < datas.length; i++) {
                           users.add(User.fromMap(datas[i]));
                           print(users[i].name);
                        }

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ManagerCheckbox.CheckBoxListTile(users,cargoIDs[index]),
                        );

                          }
                          else{
                            return Container();
                          }
                         
                        
                          }
    ),
                      ),
                    ),);
        }
      ),
    );

                  } else {
                    return Container(
                      
                    );
                  }
                },
              ),
  
      ),
    );
  }
}