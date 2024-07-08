import 'package:flutter/material.dart';
import 'package:haiduong_sipas/config/app_colors.dart';

class LabelWidget extends StatefulWidget {
  final String label;
  const LabelWidget({super.key, required this.label});

  @override
  State<LabelWidget> createState() => _LabelWidgetState();
}

class _LabelWidgetState extends State<LabelWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 18.0, // Font size
            fontWeight: FontWeight.bold, // Font weight
            color: AppColors.primary, // Text color
            fontStyle: FontStyle.normal, // Text style (italic)
            letterSpacing: 1.2, // Letter spacing
            //  decoration: TextDecoration.underline, // Text decoration (underline)
            // decorationColor: AppColors.primary,  // Decoration color
            // decorationStyle: TextDecorationStyle.dotted, // Decoration style
          ),
        ));
  }
}
