import 'package:flutter/material.dart';
import 'package:haiduong_sipas/config/app_colors.dart';
import 'package:haiduong_sipas/controller/vote_controller.dart';
import 'package:haiduong_sipas/models/app_model.dart';
import 'package:haiduong_sipas/pages/widget/fromDate_toDate_widget.dart';
import 'package:haiduong_sipas/pages/widget/selectbox_widget.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  final int tabIndex;
  final Function(String? fromDate, String? toDate, String? unitCode)
      filterDataEmit;
  const FilterPage(
      {super.key, required this.tabIndex, required this.filterDataEmit});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool isSN = false;
  bool isQH = false;
  String? fromDateValue;
  String? toDateValue;
  String? unitCode;
  late Future<List<dynamic>> voteData;
  VoteController voteController = VoteController();

  Future<void> _initializeData() async {
    if (widget.tabIndex == 0) {
      isSN = true;
    } else {
      isQH = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    // startRecording();
  }

  void emitFromToDateData(DateTime? fromDate, DateTime? toDate) {
    // Handle the received values in the parent widget
    setState(() {
      fromDateValue = fromDate.toString();
      toDateValue = toDate.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final appModel = Provider.of<AppModel>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            'Lọc tìm kiếm',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                if (isSN)
                  SelectboxWidget(
                    label: "Đơn vị cấp sở *",
                    keyInput: 'unit',
                    data: appModel.listtype['arrSN'],
                    value: appModel.dataVote['unit'],
                  ),
                if (isQH)
                  SelectboxWidget(
                    label: "Đơn vị cấp huyện *",
                    keyInput: 'unit',
                    data: appModel.listtype['arrQH'],
                    value: appModel.dataVote['unit'],
                  ),
                SizedBox(height: 10),
                FromDateToDateWidget(emitData: emitFromToDateData),
                SizedBox(height: 10),
                SizedBox(
                  width: size.width / 2,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        unitCode = appModel.dataVote['unit'];
                      });
                      widget.filterDataEmit(
                          fromDateValue, toDateValue, unitCode);
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    child: Icon(
                      Icons.search,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
