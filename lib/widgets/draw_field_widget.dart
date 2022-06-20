import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:customizable_app/service/field_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class DrawFieldWidget extends StatefulWidget {
  DrawFieldWidget(
    this.id,
    this.name,
    this.fieldId,
    this.base64String,
    this.recordID, {
    Key? key,
  }) : super(key: key) {
    oldBase64String = base64String;
  }
  final String id;
  final String name;
  String recordID;
  String base64String = "";
  late String oldBase64String;
  String? fieldId;
  bool hasChanged = false;
  bool isCreated = false;
  bool isDrawPadOpen = false;
     final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  _DrawFieldWidgetState createState() => _DrawFieldWidgetState();

  Future<void> createTrigger(String recordId, String toolId) async {
    if (!isCreated) {
      await createData(recordId, toolId);
    }
  }

  void updateTrigger() {
    if (base64String != oldBase64String) {
      updateData(fieldId!);
    }
  }

  Future<int> createData(String recordId, String toolId) async {
    String? dataId = await FieldService.instance.createData(recordId, toolId);
    if (dataId != null) {
      var jsonObject = jsonEncode(base64String);
      String? imageFieldId =
          await FieldService.instance.createDrawField(dataId, jsonObject);
      await FieldService.instance.updateDataFieldId(dataId, imageFieldId!);
      return 1;
    }
    return 0;
  }

  updateData(String fieldId) async {
    var jsonObject = jsonEncode(base64String);
    await FieldService.instance.updateDrawFieldData(fieldId, jsonObject);
    if(recordID!=""){
      await FieldService.instance.createFeedData(jsonEncode("sehaId"+" edited "+ name), 4, recordID, "sehaId");
    }
  }
}

class _DrawFieldWidgetState extends State<DrawFieldWidget> {
  Future<Image> openImage(String base64Verifier) async {
    Uint8List decodedbytes = base64.decode(base64Verifier);
    return Image.memory(decodedbytes);
  }

  Future<void> saveDrawingAsBase64(ui.Image image) async {
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    String base64string = base64.encode(Uint8List.view(byteData!.buffer));
    setState(() {
      widget.base64String = base64string;
    });
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
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              child: Column(children: [
                widget.base64String != ""
                    ? Column(
                      children: [
                        FutureBuilder(
                            future: openImage(widget.base64String),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                Image image = snapshot.data;
                                return image;
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                            }),
                            ElevatedButton(
                                      child: const Text("RESET"),
                                      onPressed: ()  {
                                        setState(() {
                                          widget.base64String="";
                                          widget.isDrawPadOpen=true;
                                        });
                                      }),
                      ],
                    )
                    : !widget.isDrawPadOpen
                        ? Column(
                            children: [
                              const Text("To draw click 'DRAW' button."),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.isDrawPadOpen = true;
                                        });
                                      },
                                      child: const Text("DRAW")),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                child: 
                                    SfSignaturePad(
                                      key: widget._signaturePadKey,
                                      minimumStrokeWidth: 4,
                                      maximumStrokeWidth: 6,
                                      strokeColor: Colors.black,
                                      backgroundColor: Colors.white,
                                    ),
                                height: 200,
                                width: 300,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      child: const Text("SAVE"),
                                      onPressed: () async {
                                        ui.Image image =
                                            await widget._signaturePadKey
                                                .currentState!
                                                .toImage();
                                        saveDrawingAsBase64(image);
                                      }),
                                  ElevatedButton(
                                      child: const Text("CLEAR"),
                                      onPressed: () async {
                                        widget._signaturePadKey.currentState!
                                            .clear();
                                      }),
                                ],
                              ),
                            ],
                          ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
