import 'package:flutter/material.dart';
import 'package:haiduong_sipas/pages/change_password_page.dart';
import 'package:haiduong_sipas/pages/components/vote_add_component.dart';
import 'package:haiduong_sipas/pages/components/vote_list_component.dart';
import 'package:haiduong_sipas/pages/home_page.dart';
import 'package:haiduong_sipas/pages/login_page.dart';

class Routes {
  static const initialRoute = 'login';
  static final pages = {
    'login': (context) => LoginPage(),
    'voteAdd': (context) {
      // Extract the passed data from arguments
      final MyRouteArguments args =
          ModalRoute.of(context)!.settings.arguments as MyRouteArguments;

      // Create and return the destination screen
      return VoteAddComponent(tabIndex: args.tabIndex, idVote: args.idVote);
    },
    'home': (context) => HomePage(),
    'changePassword': (context) => ChangePasswordPage(),
  };
}
