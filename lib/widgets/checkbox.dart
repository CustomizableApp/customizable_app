import 'package:flutter/material.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:customizable_app/service/user.dart';

class CheckBoxListTile extends StatefulWidget {
  List<User>  users =[];


  CheckBoxListTile(List<User>  list){
    this.users=list;
  }
  
  
  @override
  _CheckBoxListTileState createState() =>
      _CheckBoxListTileState(users);
}

class _CheckBoxListTileState extends State<CheckBoxListTile> {
  List<Data> _data =[];
  List<User>  users=[];
  int i=0;
  String type="";
  List<User> listedUsers=[];

  _CheckBoxListTileState(List<User>  users){
    this.users=users;
  }
  

  @override
  Widget build(BuildContext context) {
    for(;i< users.length;i++){
      print(users.length);
        _data.add(Data(false,users[i].name.toString()+" "+users[i].surname.toString(),""));
        listedUsers.add(users[i]);
 }
    return Scaffold(
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            secondary: Icon(Icons.person),
            title: Text(
              _data[index].title + " " ,
            ),
            value: _data[index].isSelected,
            onChanged: (val) {

                if(val==true){
                UserService.instance.createNewAssigner(listedUsers[index].id.toString());
              }else{
                UserService.instance.deleteAssigner(listedUsers[index].id.toString());
              }
              setState(
                () {
                  _data[index].isSelected = val!;
                },
              );
            },
          );
        },
      ),
    );
  }
}

class Data {
  String title="", subTitle ="";
  bool isSelected = false;

  Data(bool isSelected, String title, String subTitle){
    this.isSelected=isSelected;
    this.title=title;
    this.subTitle=subTitle;
  }
}
