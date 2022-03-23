
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
      body: Container(
        child: FutureBuilder(
                future: UserService.instance.getFoodNames(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<String> foodNames=[];
                  if (snapshot.hasData) {
                    List<User> users = [];
                    List<dynamic> datas = snapshot.data.data["food"];
                    
                    
                    for (int i = 0; i < datas.length; i++) {
                      foodNames.add(datas[i]["name"]);
                      //users.add(User.fromMap(datas[i]));
                    }
                    return Scaffold(
                  body: ListView.builder(
                itemCount: foodNames.length,
               itemBuilder: (context, index) {
                return ExpandablePanel(
                    header: Text(foodNames[index]),
                    collapsed: Text(""),
                    expanded:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 1000,
                        height: 150,
                        
                        child: FutureBuilder(
                          future: UserService.instance.getUsers(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            print(index);
                          if (snapshot.hasData) {
                          List<User> users = [];
                          List<dynamic> datas = snapshot.data.data["users"];
                          
                        
                        
                        for (int i = 0; i < datas.length; i++) {
                           users.add(User.fromMap(datas[i]));
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CheckBoxListTileExample(users,foodNames[index]),
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

