import 'package:flutter/material.dart';
import 'package:haiduong_sipas/config/app_colors.dart';
import 'package:haiduong_sipas/controller/vote_controller.dart';
import 'package:haiduong_sipas/pages/filter_page.dart';
import 'package:provider/provider.dart';
import 'package:haiduong_sipas/models/app_model.dart';

class MyRouteArguments {
  final String tabIndex;
  final String idVote;

  MyRouteArguments(this.tabIndex, this.idVote);
}

class VoteListComponent extends StatefulWidget {
  final int tabIndex;
  final Function(int, int) callback;
  const VoteListComponent(
      {super.key, required this.tabIndex, required this.callback});

  @override
  State<VoteListComponent> createState() => VoteListComponentState();
}

class VoteListComponentState extends State<VoteListComponent>
    with SingleTickerProviderStateMixin {
  VoteController voteController = VoteController();
  late Future<List<dynamic>> voteData;
  int total = 0;
  @override
  void initState() {
    super.initState();
    voteData = voteController.getAll(widget, widget.tabIndex);
  }

  void setTotal(int total) {}

  @override
  Widget build(BuildContext context) {
    void handleSuffixIconClick() {
      setState(() {
        voteData = voteController.getAll(widget, widget.tabIndex);
      });
    }

    getFilterDataEmit(String? fromDate, String? toDate, String? unitCode) {
      voteController.fromDate = fromDate;
      voteController.toDate = toDate;
      voteController.unitCode = unitCode ?? "";
      Navigator.pop(context);
      voteData = voteController.getAll(widget, widget.tabIndex);
    }

    void filterPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilterPage(
            tabIndex: widget.tabIndex,
            filterDataEmit: getFilterDataEmit,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            onChanged: (value) {
              voteController.search = value;
            },
            decoration: InputDecoration(
              prefixIcon: GestureDetector(
                onTap: filterPressed, // Attach click event handler
                child: Icon(
                    Icons.filter_alt_outlined), // Icon to display as suffixIcon
              ),
              suffixIcon: GestureDetector(
                onTap: handleSuffixIconClick, // Attach click event handler
                child: Icon(Icons.search), // Icon to display as suffixIcon
              ),
              suffixIconColor: Colors.blue,
              border: OutlineInputBorder(),
              hintText: 'Tìm kiếm (tên, số điện thoại, mã phiếu)',
            ),
          ),
        ),
        Expanded(
            child: FutureBuilder<List<dynamic>>(
                future: voteData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // If the API call was successful, build the ListView
                    final List<dynamic> data = snapshot.data!;
                    total = data.length;
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return getRow(data[index]);
                            },
                          ),
                        ),
                      ],
                    );
                    // total = data.length;
                  } else if (snapshot.hasError) {
                    // If the API call was unsuccessful, display an error message
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                  return Center();
                }))
      ],
    );
  }

  Widget getRow(dynamic data) {
    final appModel = Provider.of<AppModel>(context);
    // ignore: no_leading_underscores_for_local_identifiers
    void _editAction(data) {
      appModel.setVote(data['id'], 'id');
      appModel.setVote(data['survey_sipas_id'], 'survey_sipas_id');
      appModel.setVote(data['code'], 'code');
      appModel.setVote(data['unit'], 'unit');
      appModel.setVote(data['quan_huyen'], 'quan_huyen');
      appModel.setVote(data['phuong_xa'], 'phuong_xa');
      appModel.setVote(data['thon_xom'], 'thon_xom');
      appModel.setVote(data['administrative_service'], 'administrative_service');
      appModel.setVote(data['phone'], 'phone');
      appModel.setVote(data['phone_reply'] , 'phone_reply');
      appModel.setVote(data['level_unit'], 'level_unit');
      appModel.setVote(data['sex'], 'sex');
      appModel.setVote(data['name_unit'], 'name_unit');
      appModel.setVote(data['name_investigator'], 'name_investigator');
      appModel.setVote(data['survey_form'], 'survey_form');
      appModel.setVote(data['age'], 'age');
      appModel.setVote(data['nation'], 'nation');
      appModel.setVote(data['education'], 'education');
      appModel.setVote(data['job'], 'job');
      appModel.setVote(data['address'], 'address');
      appModel.setVote(data['address_region'], 'address_region');
      appModel.setVote(data['address_survey'], 'address_survey');
      appModel.setVote(data['geodetic_coordinate'], 'geodetic_coordinate');
      appModel.setVote(data['nation_other'], 'nation_other');
      appModel.setVote(data['education_other'], 'education_other');
      appModel.setVote(data['job_other'], 'job_other');
      appModel.setVote(data['address_other'], 'address_other');
      appModel.setVote(data['address_region_other'], 'address_region_other');
      appModel.setVote(data['created_at'], 'created_at');
      MyRouteArguments args =
          MyRouteArguments(widget.tabIndex.toString(), data['id']);
      Navigator.of(context).pushNamed(
        'voteAdd',
        arguments: args,
      );
    }

    return Card(
        margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        elevation: 1.0, // Adds a shadow to the card for visual separation
        shape: RoundedRectangleBorder(
          // Define the border shape and properties
          borderRadius:
              BorderRadius.circular(10.0), // Adjust border radius as needed
          side: BorderSide(
            color: const Color.fromARGB(
                255, 119, 119, 120), // Specify the border color
            width: 0.5, // Specify the border width
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 10), // Adjust the padding as needed
          child: GestureDetector(
            onTap: () {
              // Handle the tap action here
              _editAction(data);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Mã phiếu: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            data['code'],
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: "Đơn vi: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: data['name_unit'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Ngày tạo: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            data['created_at'],
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  color: Color.fromARGB(255, 209, 12, 12),
                  icon: Icon(
                    Icons.delete,
                  ),
                  onPressed: () {
                    showDeleteConfirmationDialog(context, data);
                  },
                ),
              ],
            ),
          ),
        )); // Optional margin for the car
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, dynamic data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dialog dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cảnh báo'),
          content: Text('Bạn có chắc chắn muốn xóa phiếu ${data['code']}'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy bỏ'),
              onPressed: () {
                // Close the dialog and cancel the delete action
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                voteController.voteDelete(context, data);
                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
