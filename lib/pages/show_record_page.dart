import 'dart:convert';

import 'package:customizable_app/model/feed_data_model.dart';
import 'package:customizable_app/model/record_model.dart';
import 'package:customizable_app/model/vote_field_item.dart';
import 'package:customizable_app/pages/assign_role.dart';
import 'package:customizable_app/service/field_service.dart';
import 'package:customizable_app/utils/toast_util.dart';
import 'package:customizable_app/widgets/counter_field_widget.dart';
import 'package:customizable_app/widgets/date_field_widget.dart';
import 'package:customizable_app/widgets/draw_field_widget.dart';
import 'package:customizable_app/widgets/feed_widget.dart';
import 'package:customizable_app/widgets/interval_date_field_widget.dart';
import 'package:customizable_app/widgets/vote_field_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/image_field_widget.dart';
import '../widgets/text_field_widget.dart';

class ShowRecordPage extends StatefulWidget {
  const ShowRecordPage(this.record, {Key? key}) : super(key: key);
  final RecordModel record;

  @override
  _ShowRecordPageState createState() => _ShowRecordPageState();
}

class _ShowRecordPageState extends State<ShowRecordPage> {
  @override
  initState() {
    super.initState();
    createRecordDatas();
  }

  late List<Widget> recordDatas = [];

  createRecordDatas() async {
    await getToolDatas();
    setState(() {});
  }

  Future<void> getToolDatas() async {
    for (int i = 0; i < widget.record.datas!.length; i++) {
      switch (widget.record.datas![i].type) {
        case 1:
          String text = await FieldService.instance
              .getTextFieldData(widget.record.datas![i].fieldId);
          TextEditingController controller = TextEditingController();
          controller.text = text;
          TextFieldWidget textFieldWidget = TextFieldWidget(
            widget.record.datas![i].id,
            widget.record.datas![i].name,
            widget.record.datas![i].fieldId,
            text,
            controller,
          );

          functions.add(textFieldWidget.updateTrigger);
          recordDatas.add(textFieldWidget);
          break;

        case 2:
          List<DateTime> dateList = await FieldService.instance
              .getIntervalDateFieldData(widget.record.datas![i].fieldId);
          DateIntervalWidget dateIntervalWidget = DateIntervalWidget(
            widget.record.datas![i].id,
            widget.record.datas![i].name,
            dateList[0],
            dateList[1],
            widget.record.datas![i].fieldId,
          );

          functions.add(dateIntervalWidget.updateTrigger);

          recordDatas.add(dateIntervalWidget);
          break;

        case 3:
          DateTime date = await FieldService.instance
              .getDateFieldData(widget.record.datas![i].fieldId);
          DateFieldWidget dateFieldWidget = DateFieldWidget(
            widget.record.datas![i].id,
            widget.record.datas![i].name,
            date,
            widget.record.datas![i].fieldId,
          );

          functions.add(dateFieldWidget.updateTrigger);

          recordDatas.add(dateFieldWidget);
          break;

        case 4:
          int? counter = await FieldService.instance
              .getCounterFieldData(widget.record.datas![i].fieldId);
          CounterFieldWidget counterFieldWidget = CounterFieldWidget(
            widget.record.datas![i].id,
            widget.record.datas![i].name,
            widget.record.datas![i].fieldId,
            counter!,
          );

          functions.add(counterFieldWidget.updateTrigger);
          recordDatas.add(counterFieldWidget);
          break;

        case 5:
          String? jsonObj = await FieldService.instance
              .getImageFieldData(widget.record.datas![i].fieldId);
          String base64String = jsonDecode(jsonObj!);
          ImageFieldWidget imageFieldWidget = ImageFieldWidget(
            widget.record.datas![i].id,
            widget.record.datas![i].name,
            widget.record.datas![i].fieldId,
            base64String,
          );

          functions.add(imageFieldWidget.updateTrigger);
          recordDatas.add(imageFieldWidget);
          break;

        case 6:
          String? jsonObj = await FieldService.instance
              .getDrawFieldData(widget.record.datas![i].fieldId);
          String base64String = jsonDecode(jsonObj!);
          DrawFieldWidget drawFieldWidget = DrawFieldWidget(
            widget.record.datas![i].id,
            widget.record.datas![i].name,
            widget.record.datas![i].fieldId,
            base64String,
          );

          functions.add(drawFieldWidget.updateTrigger);
          recordDatas.add(drawFieldWidget);
          break;

          case 7:
          List<VoteFieldItemModel> voteItemList = await FieldService.instance
              .getVoteFieldData(widget.record.datas![i].fieldId);
          VoteFieldWidget voteFieldWidget = VoteFieldWidget(
            widget.record.datas![i].id,
            widget.record.datas![i].fieldId,
            widget.record.datas![i].name,
            voteItemList,
          );

          functions.add(voteFieldWidget.updateTrigger);
          recordDatas.add(voteFieldWidget);
          break;

        default:
          break;
      }
    }
    if(widget.record.isFeed){
      TextEditingController controller = TextEditingController();
      List <FeedDataModel>? feedData= await FieldService.instance.getFeedData(widget.record.id);
      FeedWidget feedWidget = FeedWidget(controller, feedData,widget.record.id);
      
      recordDatas.add(feedWidget);
    }
  }

  List<Function> functions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record.name),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignRolePage(widget.record),
                  ),
                );
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: recordDatas.isEmpty?MainAxisAlignment.center:MainAxisAlignment.start,
          
            children: recordDatas.isEmpty
                ? [const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )]
                : recordDatas),
      )

      /* ListView.builder(
        shrinkWrap: true,
        itemCount:
            widget.record.datas == null ? 0 : widget.record.datas!.length,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder(
            future: getFunctionWithType(widget.record.datas![index].type)
                .call(widget.record.datas![index].fieldId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (widget.record.datas![index].type) {
                case 1:
                  if (snapshot.hasData) {
                    String text = snapshot.data;
                    TextEditingController controller =
                        TextEditingController();
                    controller.text = text;
                    TextFieldWidget textFieldWidget = TextFieldWidget(
                      widget.record.datas![index].id,
                      widget.record.datas![index].name,
                      widget.record.datas![index].fieldId,
                      text,
                      controller,
                    );
      
                    functions.add(textFieldWidget.updateTrigger);
                    return textFieldWidget;
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                case 2:
                  if (snapshot.hasData) {
                    List<DateTime> dateList = snapshot.data;
                    DateIntervalWidget dateIntervalWidget =
                        DateIntervalWidget(
                      widget.record.datas![index].id,
                      widget.record.datas![index].name,
                      dateList[0],
                      dateList[1],
                      widget.record.datas![index].fieldId,
                    );
      
                    functions.add(dateIntervalWidget.updateTrigger);
      
                    return dateIntervalWidget;
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                case 3:
                  if (snapshot.hasData) {
                    DateTime date = snapshot.data;
                    DateFieldWidget dateFieldWidget = DateFieldWidget(
                      widget.record.datas![index].id,
                      widget.record.datas![index].name,
                      date,
                      widget.record.datas![index].fieldId,
                    );
      
                    functions.add(dateFieldWidget.updateTrigger);
      
                    return dateFieldWidget;
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
      
                case 4:
                  if (snapshot.hasData) {
                    int counter = snapshot.data;
                    CounterFieldWidget counterFieldWidget =
                        CounterFieldWidget(
                      widget.record.datas![index].id,
                      widget.record.datas![index].name,
                      widget.record.datas![index].fieldId,
                      counter,
                    );
      
                    functions.add(counterFieldWidget.updateTrigger);
                    return counterFieldWidget;
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  case 5:
                  if (snapshot.hasData) {
                    String jsonObj = snapshot.data;
                    String base64String=jsonDecode(jsonObj);
                    ImageFieldWidget imageFieldWidget = ImageFieldWidget(
                      widget.record.datas![index].id,
                      widget.record.datas![index].name,
                      widget.record.datas![index].fieldId,
                      base64String,
                    );
      
                    functions.add(imageFieldWidget.updateTrigger);
                    return imageFieldWidget;

                    
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  case 6:
                  if (snapshot.hasData) {
                    String jsonObj = snapshot.data;
                    String base64String=jsonDecode(jsonObj);
                    DrawFieldWidget drawFieldWidget = DrawFieldWidget(
                      widget.record.datas![index].id,
                      widget.record.datas![index].name,
                      widget.record.datas![index].fieldId,
                      base64String,
                    );
      
                    functions.add(drawFieldWidget.updateTrigger);
                    return drawFieldWidget;

                    
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                default:
                  return Container();
              }
            },
          );
        },
      )*/
      ,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          for (Function function in functions) {
            function.call();
          }
          functions.clear();
          ToastUtil.toastMessage(context, "updated.", "OK");
          Navigator.pop(context);
        },
      ),
    );
  }
}
