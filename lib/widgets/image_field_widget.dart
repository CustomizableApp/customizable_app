import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';




class ImageFieldWidget extends StatefulWidget {
  ImageFieldWidget(
    this.id,
    this.name,
    this.fieldId,
    this.base64String,
     {
    Key? key,
  }) : super(key: key);
  final String id;
  final String name;
  String base64String="";
  String? fieldId;
  bool hasChanged = false;
  bool isCreated = false;
  
  @override
  _ImageFieldWidgetState createState() => _ImageFieldWidgetState();

  Future<void> createTrigger(String recordId, String toolId) async {
    if (!isCreated) {
      await createData(recordId, toolId);
    }
  }

  void updateTrigger() {
    //if (isCreated && hasChanged) {
    updateData(fieldId!);
    //}
  }

  Future<int> createData(String recordId, String toolId) async {
    String? dataId = await FieldService.instance.createData(recordId, toolId);
    if (dataId != null) {
      var jsonObject=jsonEncode(base64String);
      String? imageFieldId =
          await FieldService.instance.createImageField(dataId, jsonObject);
      await FieldService.instance.updateDataFieldId(dataId, imageFieldId!);
      return 1;
    }
    return 0;
  }

  updateData(String fieldId) async {
    var jsonObject=jsonEncode(base64String);
    await FieldService.instance.updateImageFieldData(fieldId, jsonObject);
  }
}

class _ImageFieldWidgetState extends State<ImageFieldWidget> {

final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";

  Future<Image> openImage(String base64Verifier) async {
      Uint8List decodedbytes = base64.decode(base64Verifier);
      return Image.memory(decodedbytes);
    }

  selectImage() async {
    try {
        var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
        //you can use ImageCourse.camera for Camera capture
        if(pickedFile != null){
              imagepath = pickedFile.path;
              File imagefile = File(imagepath); //convert Path to File
              Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
              String base64string = base64.encode(imagebytes); //convert bytes to base64 string
              widget.base64String=base64string;
              Uint8List decodedbytes = base64.decode(base64string);
              //decode base64 stirng to bytes

              setState(() {
              
              });
        }else{
           print("No image is selected.");
        }
    }catch (e) {
        print("error while picking file.");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.name),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(15),
            ),
            child:
            
            Container(
             alignment: Alignment.center,
             padding: EdgeInsets.all(20),
             child: Column(
               children: [
                  widget.base64String!=""?
                  FutureBuilder(
                    future: openImage(widget.base64String),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData){
                        Image image=snapshot.data;
                        return image;
                      }
                      else{
                        return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                      }

                    })
                  
                  :
                  imagepath != "" ? Image.file(File(imagepath)):
                    Container( 
                      child: Text("No Image selected."),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                              selectImage();
                          }, 
                          child: Text("Open Image")
                        ),imagepath != ""?
                        ElevatedButton(
                          onPressed: (){
                              setState(() {
                                imagepath="";
                              });
                          }, 
                          child: Text("Cancel")
                        ):Container(),
                      ],
                    ),
               ]
             ),
         )
          )
        ],
      ),
    );
  }
}
