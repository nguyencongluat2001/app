import 'package:flutter/material.dart';
import 'package:haiduong_sipas/config/app_colors.dart';
import 'package:haiduong_sipas/models/app_model.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class InputWidget extends StatefulWidget {
  final String label;
  final String keyInput;
  dynamic data;
  InputWidget({super.key, required this.label, required this.keyInput});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    TextEditingController inputController = TextEditingController(text: appModel.dataVote[widget.keyInput]);
    return Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: TextField(
          controller: inputController,
          onChanged: (newText) {
            appModel.setVote(newText,
                widget.keyInput); // Call your appModel method with newText
          },
          decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.label,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              filled: true,
              fillColor: AppColors.white.withOpacity(0.5)),
        ));
  }
}
