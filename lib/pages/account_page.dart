import 'package:flutter/material.dart';
import 'package:haiduong_sipas/pages/widget/label_widget.dart';
import 'package:haiduong_sipas/pages/widget/user/user_account_widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 16),
          LabelWidget(label: "Thông tin tài khoản"),
          SizedBox(height: 10),
          UserAccountWidget(),
          SizedBox(height: 24),
          LabelWidget(label: "Trung tâm hỗ trợ"),
          SizedBox(height: 10),
          Text('- Hotline: 1900 6142 (máy lẻ 302)'),
          SizedBox(height: 10),
          Text('- Mr.Dưỡng: (091)165 9660')
        ],
      ),
    );
  }
}
