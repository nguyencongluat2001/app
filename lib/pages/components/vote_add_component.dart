import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:haiduong_sipas/controller/vote_controller.dart';
import 'package:haiduong_sipas/models/app_model.dart';
import 'package:haiduong_sipas/pages/widget/common/count_down_timer_widget.dart';
import 'package:haiduong_sipas/pages/widget/input_widget.dart';
import 'package:haiduong_sipas/pages/widget/label_widget.dart';
import 'package:haiduong_sipas/pages/widget/listquestion_widget.dart';
import 'package:haiduong_sipas/pages/widget/location_widget.dart';
import 'package:haiduong_sipas/pages/widget/selectbox_widget.dart';
import 'package:haiduong_sipas/config/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

bool isUUID(String value) {
  final uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );
  return uuidPattern.hasMatch(value);
}

class VoteAddComponent extends StatefulWidget {
  final String tabIndex;
  final String idVote;
  const VoteAddComponent(
      {super.key, required this.tabIndex, required this.idVote});

  @override
  State<VoteAddComponent> createState() => VoteAddComponentState();
}

class VoteAddComponentState extends State<VoteAddComponent> {
  VoteController voteController = VoteController();
  late Record audioRecord;
  late Duration? totalDuration = Duration(seconds: 0);
  int recordingCount = 0;
  bool isRecording = false;
  bool isPlay = false;
  bool isSN = false;
  bool isQH = false;
  String pathAudio = '';
  dynamic data;
  late List<dynamic> voteQuetion = [];
  late List<dynamic> listServiceByUnitCode = [];
  late List<dynamic> listUnitPx = [];
  late List<dynamic> listUnitPx_edit = [];

  @override
  void initState() {
    audioRecord = Record();
    super.initState();
    _initializeData();
    // startRecording();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> updateAdministrativeService(code) async {
    final services = await voteController.getServicesByUnitCode(code);
    setState(() {
      listServiceByUnitCode = services;
    });
  }
  Future<void> getArrPX(code) async {
    final services = await voteController.getArrPX(code);
    setState(() {
      listUnitPx = services;
    });
  }

  Future<void> _initializeData() async {
    if (widget.tabIndex == "0") {
      isSN = true;
    } else {
      isQH = true;
    }
    print(widget.idVote);
    final questions =
        await voteController.getAllQuestion(widget.tabIndex, widget.idVote);
    setState(() {
      voteQuetion = questions;
    });
    if(widget.idVote != ''){
    final services = await voteController.getArrPX_edit(widget.idVote);
      setState(() {
        listUnitPx_edit = services;
      });
    }
    
  }

  Future<void> startRecording() async {
    if (await audioRecord.hasPermission()) {
      await audioRecord.start();
      setState(() {
        isRecording = true;
      });
    }
  }

  Future<void> saveRecording() async {
    if (await audioRecord.hasPermission()) {
      pathAudio = await audioRecord.stop() ?? '';
      setState(() {
        isRecording = false;
        recordingCount++;
      });
    }
  }

  Future<void> playAudio() async {
    pathAudio = await audioRecord.stop() ?? '';
  }

  Future<void> stopAudio() async {
    setState(() {
      isPlay = false;
    });
  }

  Future<void> stopRecording(fileAudioName) async {
    if (pathAudio == '') {
      pathAudio = await audioRecord.stop() ?? '';
    }
    voteController.uploadFile(pathAudio, fileAudioName);
  }

  validateQuestion(answers) {
    if (answers != null) {
      // Chuyển thành mảng id
      List<String> answerKeys = answers.keys.cast<String>().toList();
      // Lọc lấy những câu chưa trả lời
      String questionNotAnswer = voteQuetion
          .map((item) {
            if (!answerKeys.contains(item['id'])) {
              var nameArray = item['name'].split(' ');
              var name = (nameArray[0] + ' ' + nameArray[1]);
              if (name[name.length - 1] == '.') {
                name = name.substring(0, name.length - 1);
              }
              return name;
            } else {
              return null;
            }
          })
          .where((result) => result != null)
          .join(', ');
      return questionNotAnswer;
    }
  }

  validateInfoCandidate(body) {
    // Những trường không validate
    var validateRequiredArray = [
      'unit',
      // 'administrative_service',
      'phone',
      'phone_reply'
      'sex',
      'age',
      'nation',
      'education',
      'job',
      'address',
      'level_unit'
    ];
    // Check if all required fields are not empty
    for (String field in body.keys) {
      if (!validateRequiredArray.contains(field)) continue;

      if (body[field] == null || body[field] == '') {
        // Field is empty or null, validation fails
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);

    for (dynamic question in voteQuetion) {
      if (question.containsKey("answer")) {
        appModel.setAnswer(question['id'], question["answer"]!);
      }
    }

    FloatingActionButton myButton = FloatingActionButton(
      onPressed: () async {
        try {
          var body = appModel.dataVote;
          body['dataAnswer'] = appModel.dataAnswer;
          if (isUUID(widget.idVote)) {
            body['id'] = widget.idVote;
          }
          if (widget.tabIndex == "0") {
            body['level_unit'] = "SO_NGANH";
          } else {
            body['level_unit'] = "QUAN_HUYEN";
          }

          // Kiểm tra thông tin người khảo sát và các câu hỏi đã trả lời
          // var questionNotAnswer = validateQuestion(body['dataAnswer']);
          var infoValidate = validateInfoCandidate(body);

          if (infoValidate == false) {
            return EasyLoading.showError(
                'Vui lòng điền đầy đủ thông tin được khảo sát');
          }
          // if (questionNotAnswer != "") {
          //   return EasyLoading.showError(
          //       "Vui lòng trả lời những câu hỏi sau: $questionNotAnswer");
          // }
          String fileAudioName = "";

          // Trường hợp khi audio đã chạy hết thời gian quy định và người dùng ấn tạo phiếu
          if (pathAudio != "" || isRecording) {
            fileAudioName = voteController.getFileNameUpload();
            await stopRecording(fileAudioName);
          }

          body['fileAudioName'] = fileAudioName;
          await voteController.voteUpdate(context, body);
        } catch (e) {}
      },
      child: Icon(Icons.save_as),
    );

    return ChangeNotifierProvider(
      create: (context) => VoteController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
                title: Text("Cập nhật phiếu sipas"),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Pop the current route off the navigator stack
                  },
                ),
                backgroundColor: AppColors.primary),
            floatingActionButton: widget.idVote != "" ? null : myButton,
            body: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 15.0, left: 10.0, right: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align children to the start (left)
                        children: <Widget>[
                          SizedBox(height: 5),
                          LabelWidget(label: "Phần A: Thông tin chung"),
                          if (isSN)
                            SelectboxWidget(
                              label: "Đơn vị cấp sở *",
                              keyInput: 'unit',
                              data: appModel.listtype['arrSN'],
                              value: appModel.dataVote['unit'],
                              // onChanged: updateAdministrativeService,
                            ),
                          if (isQH)
                            SelectboxWidget(
                                label: "Đơn vị cấp huyện *",
                                keyInput: 'unit',
                                data: appModel.listtype['arrQH'],
                                value: appModel.dataVote['unit']),
                          // if (isSN)
                          //   SelectboxWidget(
                          //       label: "Dịch vụ hành chính công",
                          //       keyInput: 'administrative_service',
                          //       data: listServiceByUnitCode.isNotEmpty
                          //           ? listServiceByUnitCode
                          //           : appModel.listtype['linhvucSN'],
                          //       value: listServiceByUnitCode.isNotEmpty
                          //           ? ""
                          //           : appModel
                          //               .dataVote['administrative_service']),
                          // if (isQH)
                          //   SelectboxWidget(
                          //       label: "Dịch vụ hành chính công",
                          //       keyInput: 'administrative_service',
                          //       data: appModel.listtype['linhvucQH'],
                          //       value: appModel
                          //           .dataVote['administrative_service']),
                          InputWidget(
                              label: "Số điện thoại điều tra viên", keyInput: 'phone'),
                          InputWidget(
                              label: "Số điện thoại của người trả lời phiếu", keyInput: 'phone_reply'),
                          SelectboxWidget(
                              label: "Tên huyện/thành phố thị xã *",
                              keyInput: 'quan_huyen',
                              data: appModel.listtype['arrQH_1'],
                              value: appModel.dataVote['quan_huyen'],
                              onChanged: getArrPX,

                            ),
                          if (listUnitPx.isNotEmpty && appModel.dataVote['phuong_xa'] == "")
                          SelectboxWidget(
                              label: "Tên phường, xã, thị trấn *",
                              keyInput: 'phuong_xa',
                              data: listUnitPx.isNotEmpty
                                    ? listUnitPx
                                    : appModel.listtype['arrPx'],
                              value:  listUnitPx.isNotEmpty
                                    ? ""
                                    : appModel
                                        .dataVote['phuong_xa']
                            ),
                          if (appModel.dataVote['phuong_xa'] != "")
                          SelectboxWidget(
                              label: "Tên phường, xã, thị trấn *",
                              keyInput: 'phuong_xa',
                              data: listUnitPx_edit,
                              value: appModel.dataVote['phuong_xa']
                            ),
                          InputWidget(
                              label: "Thôn, xóm, tổ dân phố", keyInput: 'thon_xom'),
                          SelectboxWidget(
                              label: "Giới tính *",
                              keyInput: 'sex',
                              data: appModel.listtype['arrGioiTinh'],
                              value: appModel.dataVote['sex']),
                          SelectboxWidget(
                              label: "Độ tuổi",
                              keyInput: 'age',
                              data: appModel.listtype['arrTuoi'],
                              value: appModel.dataVote['age']),
                          SelectboxWidget(
                              label: "Dân tộc *",
                              keyInput: 'nation',
                              data: appModel.listtype['dantoc'],
                              value: appModel.dataVote['nation']),
                          SelectboxWidget(
                              label: "Trình độ học vấn *",
                              keyInput: 'education',
                              data: appModel.listtype['arrTrinhdo'],
                              value: appModel.dataVote['education']),
                          SelectboxWidget(
                              label: "Nghề nghiệp *",
                              keyInput: 'job',
                              data: appModel.listtype['arrNgheNghiep'],
                              value: appModel.dataVote['job']),
                          SelectboxWidget(
                              label: "Nơi sinh sống *",
                              keyInput: 'address',
                              data: appModel.listtype['arrNoiSinhSong'],
                              value: appModel.dataVote['address']),
                          SelectboxWidget(
                              label: "Khu vực sinh sống *",
                              keyInput: 'address_region',
                              data: appModel.listtype['arrVungSinhSong'],
                              value: appModel.dataVote['address_region']),
                          LocaltionWidget(
                              label: "Địa điểm khảo sát",
                              keyInput: 'address_survey'),
                          LabelWidget(label: "Phần B: Thông tin chung"),
                          ListQuestionWidget(questions: voteQuetion),
                        ])))),
      ),
    );
  }
}
