import 'package:aljunied/Components/Home_Employee_Components/search_section.dart';
import 'package:aljunied/Components/app_bar_web.dart';
import 'package:aljunied/Controller/transaction_controller.dart';
import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/Home_Employee_Components/create_atransaction_section.dart';
import '../Components/Home_Employee_Components/tasks_section.dart';
import '../Components/bottom_bar_web.dart';
import '../Components/custom_drawer.dart';
import '../Utils/util.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/step_widget.dart';

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
    return kIsWeb&&size.width>520
        ?Scaffold(
          body: SingleChildScrollView(
      child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [

                    SizedBox(height: 100,),

                    Container(
                      width: size.width,
                      height: size.height * 0.55,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/custom_scaffold.jpeg"),
                              fit: BoxFit.fill)),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[100],
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Image.asset(
                            "images/down_web_path.png",
                            height: size.height * 0.3,
                          ),
                        ),
                      ),
                    ),
                    const BottomBarWeb(),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(width: size.width,),
                  const AppBarWeb(),
                  Expanded(
                    child: SizedBox(
                      width: size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            Text(
                              translate(context, "createATransaction"),
                              style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                            ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if(Localizations.localeOf(context).languageCode=="ar")
                                  Spacer(),
                                  if(Localizations.localeOf(context).languageCode=="en")
                                    SizedBox(width: 100,),
                                  if(Localizations.localeOf(context).languageCode=="en")
                                    CustomButton(
                                      width: 200,
                                      height: 60,
                                      label: translate(context, "createATransaction"),
                                      onPress: ()=>NavigatorUtils.navigateToCreateEditATransactionScreen(context),
                                    ),
                                  if(Localizations.localeOf(context).languageCode=="ar")
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 300
                                    ),
                                    child: Text(
                                      translate(context, "followTheStepsBelowToCreateATransaction"),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[200]
                                      ),
                                      textAlign: TextAlign.center,

                                    ),
                                  ),
                                  Spacer(),
                                  if(Localizations.localeOf(context).languageCode=="en")
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 300
                                      ),
                                      child: Text(
                                        translate(context, "followTheStepsBelowToCreateATransaction"),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[200]
                                        ),
                                        textAlign: TextAlign.center,

                                      ),
                                    ),
                                  if(Localizations.localeOf(context).languageCode=="ar")
                                  CustomButton(
                                    width: 200,
                                    height: 60,
                                    label: translate(context, "createATransaction"),
                                    onPress: ()=>NavigatorUtils.navigateToCreateEditATransactionScreen(context),
                                  ),
                                  if(Localizations.localeOf(context).languageCode=="ar")
                                  SizedBox(width: 100,),
                                  if(Localizations.localeOf(context).languageCode=="en")
                                    Spacer(),
                                ],
                              ),


                            Container(
                                width: 800,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                              child: Column(
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 15,
                                    runSpacing: 15,
                                    children: [
                                      StepWidget(label: translate(context, "typeOfTransaction"), iconPath: "work.png"),
                                      StepWidget(label: translate(context, "subTypeOfTransaction"), iconPath: "paper.png"),
                                      StepWidget(label: translate(context, "anotherAddition"), iconPath: "document.png"),
                                      StepWidget(label: translate(context, "citizenInformation"), iconPath: "info.png"),

                                    ],
                                  ),
                                  SizedBox(height: 30,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 65
                                    ),
                                    child: TasksSection(),
                                  ),
                                ],
                              ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                ],
              )
            ],
          ),
      ),
    ),
        )
        :Scaffold(
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
