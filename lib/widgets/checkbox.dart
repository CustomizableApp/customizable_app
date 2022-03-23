import 'package:flutter/material.dart';
import 'package:customizable_app/service/user_service.dart';

class CheckBoxListTileExample extends StatefulWidget {
  List users =[];
  String foodName="";
  CheckBoxListTileExample(List list,String foodName){
    this.users=list;
    this.foodName=foodName;
  }
  
  
  @override
  _CheckBoxListTileExampleState createState() =>
      _CheckBoxListTileExampleState(users,foodName);

      
      
}

class _CheckBoxListTileExampleState extends State<CheckBoxListTileExample> {
  List<Data> _data =[];
  List users=[];
  String foodName="";
  int i=0;
  _CheckBoxListTileExampleState(List users,String foodName){
    this.users=users;
    this.foodName=foodName;
  }
  

  @override
  Widget build(BuildContext context) {
    for(;i< users.length;i++){
                      if(users[i].id !="1" ){
                        _data.add(Data(false,users[i].name.toString()+" "+users[i].surname.toString(),""));

                      }
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
              UserService.instance.editCanChange(users[index+1].id, foodName);
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