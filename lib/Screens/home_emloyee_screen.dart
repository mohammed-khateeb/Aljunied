import 'package:aljunied/Components/Home_Employee_Components/search_section.dart';
import 'package:aljunied/Controller/transaction_controller.dart';
import 'package:aljunied/Controller/user_controller.dart';
import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/Home_Employee_Components/create_atransaction_section.dart';
import '../Components/Home_Employee_Components/tasks_section.dart';
import '../Components/custom_drawer.dart';
import '../Utils/util.dart';
import '../Widgets/custom_app_bar.dart';

class HomeEmployeeScreen extends StatefulWidget {
  const HomeEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<HomeEmployeeScreen> createState() => _HomeEmployeeScreenState();
}

class _HomeEmployeeScreenState extends State<HomeEmployeeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if(CurrentUser.department!=null) {
      context.read<TransactionController>().getEmployeeTasks(CurrentUser.department!.id!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        title: translate(context, "homePage"),
        leading: CustomInkwell(
          onTap: (){
            FocusManager.instance.primaryFocus!.unfocus();
            scaffoldKey.currentState!.openDrawer();

          },
          child: Padding(
            padding: EdgeInsets.all(size.height*0.024),
            child: Image.asset(
              "icons/drawer.png",
            ),
          ),
        ),
        action: Row(
          children: [
            CustomInkwell(
              onTap: ()=>NavigatorUtils.navigateToNotificationsScreen(context),
              child: Padding(
                padding: EdgeInsets.all(size.height*0.02),
                child: Image.asset(
                  "icons/notification.png",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.height*0.000),
              child: CustomInkwell(
                onTap: (){
                  NavigatorUtils.navigateToHomeAdminScreen(context);

                },
                child: Icon(
                    Icons.admin_panel_settings_outlined,
                    size: size.height*0.03
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width*0.05
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<TransactionController>().getEmployeeTasks(CurrentUser.department!.id!);
          },
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: size.height*0.02),
            children: [
              SearchSection(),
              SizedBox(height: size.height*0.03,),
              CreateTransactionSection(),
              SizedBox(height: size.height*0.03,),
              TasksSection(),
            ],
          ),
        ),
      ),
    );
  }
}
