import 'package:customizable_app/model/template_model.dart';
import 'package:customizable_app/pages/record_page.dart';
import 'package:customizable_app/service/auth_service.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/service/user.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:flutter/material.dart';

//TODO UI IMPROVEMENTS
class TemplateContainer extends StatelessWidget {
  TemplateContainer({
    Key? key,
    required this.template,
  }) : super(key: key);
  final TemplateModel template;
  int userType=-1;

  checkUserType() async{
    if(userType==-1){
      userType=await  UserService.instance.getCurrentUserType();
      return userType;
    }else{
      return userType;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          checkUserType();
          template.tools =
              await FieldService.instance.getToolsByTemplateId(template.id);
          template.roles =
              await FieldService.instance.getRolesByTemplateId(template.id);
              
          if (userType==2 ||userType == 1) {
            template.records =
                await FieldService.instance.getRecordsByTemplateId(template);
          } else {
            template.records =
                await FieldService.instance.getRecordsByUserId(template);
          }

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RecordPage(template)));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(template.name),
            ),
          ),
        ),
      ),
    );
  }
}
