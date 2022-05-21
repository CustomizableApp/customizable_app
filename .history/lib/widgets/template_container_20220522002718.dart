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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(templateName),
            ),
          ),
        ),
      ),
    );
  }
}
