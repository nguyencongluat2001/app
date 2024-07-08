import 'package:flutter/material.dart';
import 'package:haiduong_sipas/controller/account_controller.dart';

class UserAccountWidget extends StatefulWidget {
  const UserAccountWidget({super.key});

  @override
  State<UserAccountWidget> createState() => _UserAccountWidgetState();
}

class _UserAccountWidgetState extends State<UserAccountWidget> {
  AccountController accountController = AccountController();

  String username = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final user = await accountController.getUser();
    setState(() {
      // ignore: prefer_interpolation_to_compose_strings
      username = "- " + user['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    void changePasswordPressed() {
      Navigator.of(context).pushNamed('changePassword');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.supervised_user_circle),
            SizedBox(width: 10),
            Text(username),
          ]),
          SizedBox(height: 10),
          InkWell(
            onTap: changePasswordPressed,
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Row(children: [
                  Icon(Icons.lock),
                  SizedBox(width: 10),
                  Text('Đổi mật khẩu'),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
