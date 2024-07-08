import 'package:flutter/material.dart';
import 'package:haiduong_sipas/controller/vote_controller.dart';
import 'package:record/record.dart';

class RecordingWidget extends StatefulWidget {
  const RecordingWidget({super.key});

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> {
   VoteController voteController = VoteController();
  String audioPath = '';
  late Record audioRecord;
  bool isRecording = false;
  @override
  void initState() {
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> playRecording() async {
    try {
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isRecording ? stopRecording : startRecording,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
              horizontal: 5.0, vertical: 5.0), // Adjust padding efy321
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Adjust the size of the row to the content
        children: [
          isRecording ? Text('Dừng ghi âm') : Text('Bắt đầu ghi âm'),
        ],
      ),
    );
  }
}

TextStyle getStyle({double size = 20}) =>
    TextStyle(fontSize: size, fontWeight: FontWeight.bold);
