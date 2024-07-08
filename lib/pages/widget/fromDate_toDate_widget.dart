import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FromDateToDateWidget extends StatefulWidget {
  final Function(DateTime? fromDate, DateTime? toDate) emitData;
  const FromDateToDateWidget({super.key, required this.emitData});

  @override
  State<FromDateToDateWidget> createState() => _FromDateToDateWidgetState();
}

class _FromDateToDateWidgetState extends State<FromDateToDateWidget> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  DateTime? fromDateValue;
  DateTime? toDateValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: fromDate,
          decoration: InputDecoration(
            labelText: "Từ ngày",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
            );

            if (date != null) {
              setState(() {
                fromDateValue = date;
                fromDate.text = DateFormat('dd/MM/yyyy').format(date);
                widget.emitData(fromDateValue, toDateValue);
              });
            }
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: toDate,
          decoration: InputDecoration(
            labelText: "Đến ngày",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
            );

            if (date != null) {
              setState(() {
                toDateValue = date;
                toDate.text = DateFormat('dd/MM/yyyy').format(date);
                widget.emitData(fromDateValue, toDateValue);
              });
            }
          },
        ),
      ],
    );
  }
}
