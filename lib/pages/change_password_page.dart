import 'package:flutter/material.dart';
import 'package:haiduong_sipas/config/app_colors.dart';
import 'package:haiduong_sipas/controller/change_password_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  final ChangePasswordController changePasswordController =
      ChangePasswordController();
  late TextEditingController passwordController;
  late TextEditingController newPassword01Controller;
  late TextEditingController newPassword02Controller;

  void eyeToggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void updatePassword() {
    if (_formKey.currentState!.validate()) {
      changePasswordController.password = passwordController.text;
      changePasswordController.newPassword01 = newPassword01Controller.text;
      changePasswordController.newPassword02 = newPassword02Controller.text;

      changePasswordController.updatePassword(context);
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    return null; // Return null if the input is valid
  }

  String? comparePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (newPassword01Controller.text != newPassword02Controller.text) {
      return 'Mật khẩu không giống mật khẩu đã nhập';
    }
    return null; // Return null if the input is valid
  }

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    newPassword01Controller = TextEditingController();
    newPassword02Controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
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
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        title: Text(
          'Đổi mật khẩu',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(24),
            height: isLandscape
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  onChanged: (value) => {},
                  obscureText: _obscureText,
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIconColor: AppColors.primary,
                      suffixIconColor: AppColors.primary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: eyeToggle,
                        child: Icon(_obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                      ),
                      prefixIcon: Icon(Icons.lock_outline_rounded)),
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: validatePassword,
                ),
                SizedBox(height: 20),
                TextFormField(
                  onChanged: (value) => {},
                  obscureText: _obscureText,
                  controller: newPassword01Controller,
                  decoration: InputDecoration(
                      labelText: 'Mật khẩu mới',
                      prefixIconColor: AppColors.primary,
                      suffixIconColor: AppColors.primary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      prefixIcon: Icon(Icons.key)),
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: validatePassword,
                ),
                SizedBox(height: 20),
                TextFormField(
                  onChanged: (value) => {},
                  obscureText: _obscureText,
                  controller: newPassword02Controller,
                  decoration: InputDecoration(
                      labelText: 'Nhập lại mật khẩu',
                      prefixIconColor: AppColors.primary,
                      suffixIconColor: AppColors.primary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      prefixIcon: Icon(Icons.key)),
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: comparePassword,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: AppColors.primary),
                  onPressed: updatePassword,
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
