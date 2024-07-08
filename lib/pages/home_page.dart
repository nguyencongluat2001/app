import 'package:flutter/material.dart';
import 'package:haiduong_sipas/controller/home_controller.dart';
import 'package:haiduong_sipas/models/app_model.dart';
import 'package:haiduong_sipas/pages/account_page.dart';
import 'package:haiduong_sipas/pages/login_page.dart';
import 'package:haiduong_sipas/pages/notification_page.dart';
import 'package:haiduong_sipas/config/app_colors.dart';
import 'package:haiduong_sipas/pages/vote_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePageNavigationBar();
  }
}

class HomePageNavigationBar extends StatefulWidget {
  const HomePageNavigationBar({super.key});

  @override
  State<HomePageNavigationBar> createState() => _HomePageNavigationBarState();
}

class _HomePageNavigationBarState extends State<HomePageNavigationBar> {
  final HomeController homeController = HomeController();
  int _selectedIndex = 0;
  String _label = "Trang chủ";
  static const List<Widget> _widgetOptions = <Widget>[
    VotePage(),
    NotificationPage(),
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _label = homeController.getLabelFromIndex(index);
    });
  }

  void _logOut() {
    // Perform logout action here
    // Typically, this involves clearing user authentication and navigating to the login screen.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_label),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment
                .center, // Align children vertically at the center
            mainAxisSize: MainAxisSize.min, // Minimize vertical space
            children: [
              // Text("Thoát"),
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: _logOut,
              ),
            ],
          )
        ],
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: "Thông báo"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), label: "Tài khoản"),
          ]),
    );
  }
}
