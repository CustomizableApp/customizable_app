import 'package:flutter/material.dart';

import 'adminPage.dart';


class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{
  TextEditingController _id = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: TextFormField(
                controller: _id,
                decoration: InputDecoration(
                  hintText: "Enter your ID",
                  labelText: "ID",
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            MaterialButton(
              color: Colors.blue,
              child: Text("Login In"),
              onPressed: () {
                if( _id.text.toString() == "1"  ){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminPage(),
                  ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}