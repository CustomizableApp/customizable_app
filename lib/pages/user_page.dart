import 'package:flutter/material.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:customizable_app/service/user.dart';
import 'package:customizable_app/service/auth_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({ Key? key }) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<String> userList = [];
  String dropdownValue = "";
  List<User> users = [];
  int i = 0;
  int z=0;

  @override
  Widget build(BuildContext context) {
    
    
    return FutureBuilder(
                  future: UserService.instance.getAllUsers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData){
                        List<dynamic> datas = snapshot.data.data["CargoDB_User"];
                      for (; i < datas.length;) {
                           users.add(User.fromMap(datas[i]));
                           userList.add(users[i].name.toString());
                           i++;
                        }
                        z++;
                        if(z==1){
                          dropdownValue=userList[0];
                        }
                      return Scaffold(
        appBar: AppBar(
          title: Text("User Page"),
          centerTitle: true,
          ),
          body:Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                    ),
                    ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Content',
                    ),
        ),
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: DropdownButton(
                  style: TextStyle(
                    color: Colors.blueGrey[500]
                  ),
                  selectedItemBuilder: (BuildContext context){
                    return userList.map((String value){
                      return Text(
                        dropdownValue,
                        style: TextStyle(color: Colors.black),
                      );
                    }).toList();
                  },
                  value: dropdownValue,
                  onChanged: (String? value){
                    setState(() {
                      dropdownValue = value.toString();
                    });
                  },
                  items: userList.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value),
                    );
                  }).toList(),
              ),
                ),
                SizedBox(
                  child: ElevatedButton(
            onPressed: () {
              for(int k=0;k<users.length;k++){
                print(dropdownValue);
                if(dropdownValue==users[k].name){
                  print("sent");
                  UserService.instance.createNewCargo(_addressController.text, _contentController.text, users[k].id.toString());
                }
              }
            },
        
            child: const Text('Send'),
          ),

                ),
              ],
            ),
          ),
      );
                      }
                      else{
                        return Container();
                      }
                    }
                );
  }
}