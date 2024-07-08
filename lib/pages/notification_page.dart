import 'package:flutter/material.dart';
import 'package:haiduong_sipas/controller/notification_controller.dart';
import 'package:flutter_html/flutter_html.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationController notificationController = NotificationController();
  late Future<List<dynamic>> datas;

  @override
  void initState() {
    super.initState();
    datas = notificationController.getAll();
  }

  String removeHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: FutureBuilder<List<dynamic>>(
          future: datas,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // If the API call was successful, build the ListView
              final List<dynamic> data = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true, // Make it take only the space it needs
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle the tap action here
                      showInforDialog(context, data[index]);
                    },
                    child: getRow(data[index]),
                  );
                },
              );
              // total = data.length;
            } else if (snapshot.hasError) {
              // If the API call was unsuccessful, display an error message
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            return Center();
          }),
    );
  }

  Widget getRow(dynamic data) {
    return Card(
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
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
                top: 10.0, bottom: 10.0), // Adjust the padding as needed
            child: ListTile(
              title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Tiêu đề: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                              child: Text(data['title'],
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.visible)),
                        ]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Người nhập: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )),
                          Expanded(
                              child: Text(data['nameuser'],
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.visible)),
                        ]),
                    Row(children: <Widget>[
                      Text("Thời gian: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                      Expanded(
                          child: Text(data['data_time'],
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.visible)),
                    ])
                  ]),
            ))); // Optional margin for the car
  }

  Future<void> showInforDialog(BuildContext context, dynamic data) async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // Prevent dialog dismissal by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 80),
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'chi tiết thông báo'.toUpperCase(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: "Tiêu đề: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: data['title'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        softWrap: true,
                      ),
                    )
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "Người nhập: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Text(data['nameuser'],
                            style: TextStyle(fontSize: 16))),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "Thời gian: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: Text(data['data_time'],
                            style: TextStyle(fontSize: 16))),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: "Nội dung thông báo: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: removeHtmlTags(data['content']),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        softWrap: true,
                      ),
                    )
                  ]),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      child: Text('Đóng'),
                      onPressed: () {
                        // Close the dialog and cancel the delete action
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
