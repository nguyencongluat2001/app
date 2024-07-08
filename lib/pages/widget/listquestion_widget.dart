import 'package:flutter/material.dart';
import 'package:haiduong_sipas/models/app_model.dart';
import 'package:haiduong_sipas/pages/widget/other_question_input_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ListQuestionWidget extends StatefulWidget {
  late List<dynamic> questions;
  ListQuestionWidget({super.key, required this.questions});

  @override
  State<ListQuestionWidget> createState() => _ListQuestionWidgetState();
}

enum SingingCharacter { lafayette, jefferson }

class _ListQuestionWidgetState extends State<ListQuestionWidget> {
  @override
  void initState() {
    super.initState();
    // startRecording();
  }
  // bool ischecked = false;
  bool _isChecked = false;
  String _isChange = '';
  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    // Create an empty list to store the grid of widgets
    List<Widget> gridWidgets = [];
    bool checkboxValue1 = true;
    bool checkboxValue2 = true;
    bool checkboxValue3 = true;
    for (dynamic question in widget.questions) {
      List<Widget> rowWidgets = [
          if(question['CHECK_nhom_cauhoi'] == "1")
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 0.0),
            child: Text(
              question['nhomcauhoihienthi'],
              style: TextStyle(
                  fontSize:
                      16.0, // Font size// Font weight// Text color// Text style (italic)
                 
                  fontWeight: FontWeight.bold),
            )),
          if(question['CHECK_loai_cauhoi'] == "1")
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 0.0),
            child: Text(
              question['loaicauhoihienthi'],
              style: TextStyle(
                  fontSize:
                      16.0, // Font size// Font weight// Text color// Text style (italic)
                  fontWeight: FontWeight.bold),
            )),
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 0.0),
            child: Text(
              question['name'],
              style: TextStyle(
                  fontSize:
                      16.0, // Font size// Font weight// Text color// Text style (italic)
                  fontWeight: FontWeight.bold),
            )),
      ];
      int length = question['listoption'].length; // Widgets for the current row
      int i = 1;
      for (dynamic listoption in question['listoption']) {
        i++;
        if(question['type_question'] == 'RADIO'){
            // Create a Container widget for each grid cell
            ListTile cell = ListTile(
              title: GestureDetector(
                onTap: () {
                  setState(() {
                    appModel.setAnswer(question['id'], listoption['code']!);
                  });
                },
                child: Text(listoption['name']),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: -1.1),
              leading: Radio<String>(
                value: listoption['code'],
                groupValue: appModel.getAnswer(question['id']),
                onChanged: (String? value) {
                  setState(() {
                    appModel.setAnswer(question['id'], value!);
                    // kiem tra neu
                  });
                },
              ),
            );
            rowWidgets.add(cell);
        }else if(question['type_question'] == 'CHECKBOX'){
          // if(listoption['code'] == listoption['result']){
          //   _isChecked = true;
          // }else{
          //   _isChecked = false;
          // }
          rowWidgets.add(
            CheckboxListTile(
              title: Text(listoption['name']),
              value: _isChecked ,
              onChanged: (bool? value) {
                setState(() {
                  appModel.setAnswerCheckBox(question['id'], listoption['code']!);
                  _isChange = listoption['code'];
                  _isChecked = value ?? false;
                  // if(listoption['code'] == 'plan_2'){
                  //   _isChecked = true;
                  // }
                   print(listoption['code']);
                });
              },
            ),
          );
        } 
      }
      if (question['other'] == "1") {
        var note = "";
        if (question['note'] != null) {
          note = question['note'];
        }
        rowWidgets.add(
          OtherQuestionInputWidget(
              // ignore: prefer_interpolation_to_compose_strings
              label: "Câu trả lời khác",
              keyInput: "other_" + question['id'],
              value: note),
        );
      }
      if (question['plan_1'] == "") {
        var note = "";
        if (question['note'] != null) {
          note = question['note'];
        }
        rowWidgets.add(
          OtherQuestionInputWidget(
              // ignore: prefer_interpolation_to_compose_strings
              label: "",
              keyInput: "other_" + question['id'],
              value: note),
        );
      }
      gridWidgets.addAll(rowWidgets);





          // CheckboxListTile(
          //   value: checkboxValue1,
          //   onChanged: (bool? value) {
          //     setState(() {
          //       checkboxValue1 = value!;
          //     });
          //   },
          //   title: const Text('Headline'),
          //   subtitle: const Text('Supporting text'),
          // );
          // const Divider(height: 0);
          // CheckboxListTile(
          //   value: checkboxValue2,
          //   onChanged: (bool? value) {
          //     setState(() {
          //       checkboxValue2 = value!;
          //     });
          //   },
          //   title: const Text('Headline'),
          //   subtitle: const Text(
          //       'Longer supporting text to demonstrate how the text wraps and the checkbox is centered vertically with the text.'),
          // );
          // const Divider(height: 0);
          // CheckboxListTile(
          //   value: checkboxValue3,
          //   onChanged: (bool? value) {
          //     setState(() {
          //       checkboxValue3 = value!;
          //     });
          //   },
          //   title: const Text('Headline'),
          //   subtitle: const Text(
          //       "Longer supporting text to demonstrate how the text wraps and how setting 'CheckboxListTile.isThreeLine = true' aligns the checkbox to the top vertically with the text."),
          //   isThreeLine: true,
          // );
          // const Divider(height: 0);
    }
    return Container(
        padding: EdgeInsets.only(top: 8),
        child: Column(
          children: gridWidgets,
        ));
  }
}
