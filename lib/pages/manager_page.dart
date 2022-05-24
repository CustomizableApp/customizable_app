import 'package:customizable_app/model/template_model.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:flutter/material.dart';

import '../widgets/template_container.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({Key? key}) : super(key: key);

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
              future: UserService.instance.getTemplatesByUserId("sehaId"),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<TemplateModel> data = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TemplateContainer(templateName: data[index].name);
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
