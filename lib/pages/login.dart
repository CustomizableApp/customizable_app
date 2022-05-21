import 'package:customizable_app/pages/manager_page.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _id,
            decoration: const InputDecoration(
              hintText: "Enter your ID",
              labelText: "ID",
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 35),
          MaterialButton(
            color: Colors.blue,
            child: const Text("Login In"),
            onPressed: () {
              if (_id.text.toString() == "1") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManagerPage(),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
