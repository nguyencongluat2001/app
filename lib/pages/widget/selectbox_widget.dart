import 'package:flutter/material.dart';
import 'package:haiduong_sipas/models/app_model.dart';
import 'package:haiduong_sipas/pages/widget/input_widget.dart';
import 'package:provider/provider.dart';

class SelectboxWidget extends StatefulWidget {
  final String label;
  final String keyInput;
  final dynamic data;
  String? value;
  Function? onChanged;
  SelectboxWidget(
      {super.key,
      required this.label,
      required this.keyInput,
      required this.data,
      required this.value,
      this.onChanged});

  @override
  State<SelectboxWidget> createState() => _SelectboxWidgetState();
}

class _SelectboxWidgetState extends State<SelectboxWidget> {
  String defaultValue = 'Select an option';

  String getLabelOther() {
    return "${widget.label} khác";
  }

  String getKeyInputOther() {
    return "${widget.keyInput}_other";
  }

  bool showOther = false;
  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    if (widget.value == "KHAC") {
      showOther = true;
    }
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Column(children: <Widget>[
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                    labelText: widget.label,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    onChanged: (String? newValue) {
                      appModel.setVote(newValue!, widget.keyInput);
                      if (widget.onChanged != null) {
                        widget.onChanged!(newValue);
                      }
                      setState(() {
                        if (newValue == "KHAC") {
                          showOther = true;
                        } else {
                          showOther = false;
                        }
                        widget.value = newValue;
                      });
                    },
                    value: widget.value ?? defaultValue,
                    isDense: true,
                    items: widget.data.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item["code"],
                        child: SizedBox(
                          width: size.width * 0.75,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.topLeft,
                            child: Text(
                              item["name"],
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          if (showOther)
            InputWidget(label: getLabelOther(), keyInput: getKeyInputOther())
        ]));
  }
}
