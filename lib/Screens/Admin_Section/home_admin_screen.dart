import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Components/Home_Employee_Components/search_section.dart';
import '../../Components/app_bar_web.dart';
import '../../Components/bottom_bar_web.dart';
import '../../Widgets/custom_inkwell.dart';

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({Key? key}) : super(key: key);

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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 200),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runSpacing: 50,
                                spacing: 50,
                                children: List.generate(16, (index) {
                                  return CustomInkwell(
                                    onTap: (){
                                      openPageByIndex(index,context);
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.grey[200],
                                          ),
                                          child: Padding(
                                            padding:  EdgeInsets.all(30),
                                            child: Image.asset(
                                              "icons/${getImagePathByIndex(context, index)}",
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          getLabelByIndex(context, index),
                                          style: TextStyle(
                                              fontSize: 16
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  );
                                }),
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
    ):Scaffold(
      appBar: CustomAppBar(
        title: translate(context, "homePage"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height*0.02,horizontal: size.width*0.04),
        child: Column(
          children: [
            SearchSection(),
            SizedBox(height: size.height*0.05,),
            Expanded(
              child: GridView.builder(
                itemCount: 16,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 150,
                    crossAxisSpacing: size.height*0.02
                ),
                itemBuilder: (_,index){
                  return CustomInkwell(
                    onTap: (){
                      openPageByIndex(index,context);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: size.width*0.25,
                          width: size.width*0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(size.height*0.005),
                            color: Colors.grey[200],
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(size.height*0.02),
                            child: Image.asset(
                              "icons/${getImagePathByIndex(context, index)}",
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        Text(
                        getLabelByIndex(context, index),
                          style: TextStyle(
                              fontSize: size.height*0.017
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getLabelByIndex(BuildContext context,int index){
    switch(index) {
      case 0: {
        return translate(context, "createATransaction");
      }
      case 1: {
        return translate(context, "employees");
      }
      case 2: {
        return translate(context, "news");
      }
      case 3: {
        return translate(context, "bidsTypes");
      }
      case 4: {
        return translate(context, "bids");
      }
      case 5: {
        return translate(context, "transactionsTypes");
      }
      case 6: {
        return translate(context, "transactions");
      }
      case 7: {
        return translate(context, "departments");
      }
      case 8: {
        return translate(context, "citizens");
      }
      case 9: {
        return translate(context, "touristAreasAndActivities");
      }
      case 10: {
        return translate(context, "headlines");
      }
      case 11: {
        return translate(context, "complaintsTypes");
      }
      case 12: {
        return translate(context, "atYourService");
      }
      case 13: {
        return translate(context, "investments");
      }
      case 14: {
        return translate(context, "termsAndConditions");
      }
      case 15: {
        return translate(context, "municipalityMembers");
      }

      default: {
        return translate(context, "sendNotifications");
      }
    }
  }
  String getImagePathByIndex(BuildContext context,int index){
    switch(index) {
      case 0: {
        return "add_transaction.png";
      }
      case 1: {
        return "group.png";
      }
      case 2: {
        return "document.png";
      }
      case 3: {
        return "list_1.png";
      }
      case 4: {
        return "info.png";
      }
      case 5: {
        return "list.png";
      }
      case 6: {
        return "transactions.png";
      }
      case 7: {
        return "department.png";
      }
      case 8: {
        return "group.png";
      }
      case 9: {
        return "culture.png";
      }
      case 10: {
        return "about.png";
      }
      case 11: {
        return "complaint_type.png";
      }
      case 12: {
        return "support.png";
      }
      case 13: {
        return "investment.png";
      }

      case 14: {
        return "terms.png";
      }
      case 15: {
        return "group.png";
      }

      default: {
        return "notification.png";
      }

    }
  }
  void openPageByIndex(int index,BuildContext context){
    switch(index) {
      case 0: {
        NavigatorUtils.navigateToCreateEditATransactionScreen(context);
        break;
      }
      case 1: {
        NavigatorUtils.navigateToEmployeeScreen(context);
        break;
      }
      case 2: {
        NavigatorUtils.navigateToNewsScreen(context);
        break;
      }
      case 3: {
        NavigatorUtils.navigateToBidsTypesScreen(context);
        break;
      }
      case 4: {
        NavigatorUtils.navigateToBidsScreen(context);
        break;
      }
      case 5: {
        NavigatorUtils.navigateToAdminCategoriesScreen(context);
        break;
      }
      case 6: {
        NavigatorUtils.navigateToAllTransactionsScreen(context);
        break;
      }
      case 7: {
        NavigatorUtils.navigateToDepartmentsScreen(context);
        break;
      }
      case 8: {
        NavigatorUtils.navigateToUsersScreen(context);
        break;
      }
      case 9: {
        NavigatorUtils.navigateToTouristAreasScreen(context);
        break;
      }

      case 10: {
        NavigatorUtils.navigateToHeadlinesScreen(context);
        break;
      }

      case 11: {
        NavigatorUtils.navigateToComplaintsTypesScreen(context);
        break;
      }

      case 12: {
        NavigatorUtils.navigateToServicesScreen(context);
        break;
      }

      case 13: {
        NavigatorUtils.navigateToInvestmentsScreen(context);
        break;
      }

      case 14: {
        NavigatorUtils.navigateToAddEditTermsScreen(context);
        break;
      }
      case 15: {
        NavigatorUtils.navigateToMembersScreen(context);
        break;
      }

      default: {
        NavigatorUtils.navigateToSendNotificationScreen(context);
        break;
      }

    }
  }
}
