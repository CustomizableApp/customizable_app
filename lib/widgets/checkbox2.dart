import 'package:flutter/material.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:customizable_app/service/user.dart';

class CheckBoxListTile extends StatefulWidget {
  List<User>  users =[];
  int cargoID=0;
  

  CheckBoxListTile(List<User>  list, int cargoID){
    this.users=list;
    this.cargoID=cargoID;

  }
  
  
  @override
  _CheckBoxListTileState createState() =>
      _CheckBoxListTileState(users,cargoID);

      
      
}

class _CheckBoxListTileState extends State<CheckBoxListTile> {
  List<Data> _data =[];
  List<User>  users=[];
  int i=0;
  String type="";
  List<User> listedUsers=[];
  int cargoID=0;

  _CheckBoxListTileState(List<User>  users,int cargoID){
    this.users=users;
    this.cargoID=cargoID;
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
                UserService.instance.assignCourrier(users[index].id.toString(), cargoID);
              }else{
                UserService.instance.removeCourrier(cargoID);
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
