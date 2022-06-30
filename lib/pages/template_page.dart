import 'package:customizable_app/model/template_model.dart';
import 'package:customizable_app/service/auth_service.dart';
import 'package:customizable_app/service/user.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:flutter/material.dart';

import '../widgets/template_container.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({Key? key}) : super(key: key);

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  int userType = -1;

  Future<void> getCurrentUserType() async {
    await UserService.instance.getCurrentUser();
    userType = await UserService.instance.getCurrentUserType();
    setState(() {
      
    });
  }


  @override
  void initState() {
   getCurrentUserType();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            userType == 0
                ? Container()
                : Column(
                    children: [
                      const Text("Templates:"),
                      FutureBuilder(
                        future: userType == 2
                            ? UserService.instance.getAllTemplates()
                            : UserService.instance.getTemplatesByUserId(
                                AuthenticationService.instance.getUserId()),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<TemplateModel> data = snapshot.data;
                            if (data.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TemplateContainer(
                                      template: data[index]);
                                },
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text("No templates to display"),
                                ),
                              );
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                  UserService.instance.currentUser!.type==0?
            Column(
              children: [
                const Text("Records:"),
                FutureBuilder(
              future: UserService.instance.getUsersAssignedRecordsTemplate(
                  AuthenticationService.instance.getUserId()),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<TemplateModel> data = snapshot.data;
                  if (data.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TemplateContainer(template: data[index]);
                      },
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text("No records to display"),
                      ),
                    );
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
              ],
            ):Container(),
            
          ],
        ),
      ),
    );
  }
}
