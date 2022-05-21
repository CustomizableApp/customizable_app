import 'package:flutter/material.dart';

//TODO UI IMPROVEMENTS
class TemplateContainer extends StatelessWidget {
  const TemplateContainer({
    Key? key,
    required this.templateName,
  }) : super(key: key);
  final String templateName;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: 
        ),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text(templateName)),
        ),
      ),
    );
  }
}
