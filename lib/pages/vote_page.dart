import 'package:flutter/material.dart';
import 'package:haiduong_sipas/controller/vote_controller.dart';
import 'package:haiduong_sipas/models/app_model.dart';
import 'package:haiduong_sipas/pages/components/vote_list_component.dart';
import 'package:haiduong_sipas/config/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VotePage extends StatefulWidget {
  const VotePage({super.key});
  @override
  State<VotePage> createState() => VotePageState();
}

class VotePageState extends State<VotePage>
    with SingleTickerProviderStateMixin {
  VoteController voteController = VoteController();
  int totalDepartment = 0;
  int totalDistrict = 0;
  @override
  void initState() {
    super.initState();
    getTotal();
  }

  void getTotal() async {
    final prefs = await SharedPreferences.getInstance();
    totalDepartment = prefs.getInt('totalDepartment')!;
    totalDistrict = prefs.getInt('totalDistrict')!;
  }

  // Define a callback function to receive data from the child
  void receiveDataFromChild(int tabIndex, int total) {
    setState(() {
      if (tabIndex == 0) {
        totalDepartment = total;
      }
      if (tabIndex == 1) {
        totalDistrict = total;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: appModel.tabIndex,
      // Number of tabs
      child: Scaffold(
        appBar: TabBar(
          labelColor: AppColors.primary, // Text color of selected tab
          unselectedLabelColor:
              AppColors.black, // Text color of unselected tabs
          tabs: [
            Tab(
              icon: Consumer<AppModel>(
                builder: (context, counter, child) {
                  return Badge(
                    alignment: Alignment(1.4, 0),
                    textColor: AppColors.black,
                    backgroundColor: AppColors.second,
                    smallSize: 1.0,
                    label: Text(totalDepartment.toString()),
                    child: Text("Phiếu cấp Sở"),
                  );
                },
              ),
            ),
            Tab(icon: Consumer<AppModel>(
              builder: (context, counter, child) {
                return Badge(
                  alignment: Alignment(1.3, 0),
                  textColor: AppColors.black,
                  backgroundColor: AppColors.second,
                  smallSize: 1.0,
                  label: Text(totalDistrict.toString()),
                  child: Text("Phiếu cấp Huyện"),
                );
              },
            )),
          ],
          onTap: (int index) {
            appModel.reset();
            appModel.setTabindex(index);
          },
        ),
        body: TabBarView(
          children: [
            // Tab Phiếu cấp Sở
            VoteListComponent(tabIndex: 0, callback: receiveDataFromChild),
            // Tab Phiếu cấp Huyện
            VoteListComponent(tabIndex: 1, callback: receiveDataFromChild),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            MyRouteArguments args = MyRouteArguments(appModel.tabIndex.toString(), "");
            appModel.reset();
            // This function will be executed when the button is pressed.
            // You can put your code here.
            Navigator.of(context).pushNamed(
              'voteAdd',
              arguments: args,
            );
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
