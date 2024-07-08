import 'package:flutter/material.dart';
import 'package:haiduong_sipas/config/app_colors.dart';
import 'package:haiduong_sipas/controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LoginController loginController = LoginController();
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          height: isLandscape
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: const [
                  SizedBox(height: 30),
                  Text(
                    'SỞ NỘI VỤ TỈNH THÁI NGUYÊN',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'KHẢO SÁT SIPAS',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  TextField(
                    controller: usernameController,
                    onChanged: (value) {
                      loginController.username = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Tên đăng nhập',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      filled: true,
                      fillColor: AppColors.white.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    onChanged: (value) {
                      loginController.password = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Mật khẩu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      filled: true,
                      fillColor: AppColors.white.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        loginController.login(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.second,
                        foregroundColor: AppColors.black,
                      ),
                      child: Text('Đăng nhập'),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.history,
                    color: AppColors.white,
                  ),
                  Text(
                    'Phiên bản 1.1.4',
                    style: TextStyle(color: AppColors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
