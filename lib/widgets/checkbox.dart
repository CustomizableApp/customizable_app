import 'package:flutter/material.dart';
import 'package:customizable_app/service/user_service.dart';

class CheckBoxListTileExample extends StatefulWidget {
  List users =[];
  CheckBoxListTileExample(List list){
    this.users=list;
  }
  
  
  @override
  _CheckBoxListTileExampleState createState() =>
      _CheckBoxListTileExampleState(users);

      
      
}

class _CheckBoxListTileExampleState extends State<CheckBoxListTileExample> {
  List<Data> _data =[];
  List users=[];
  int i=0;
  _CheckBoxListTileExampleState(List users){
    this.users=users;
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
              UserService.instance.editCanChange(users[index+1].id, "su");
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
