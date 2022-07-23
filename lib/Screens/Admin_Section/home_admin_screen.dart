import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../Components/Home_Employee_Components/search_section.dart';
import '../../Widgets/custom_inkwell.dart';

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                    mainAxisExtent: size.height*0.18,
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
        return translate(context, "complaints");
      }
      case 13: {
        return translate(context, "investments");
      }
      case 14: {
        return translate(context, "termsAndConditions");
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
        return "complaint.png";
      }
      case 13: {
        return "investment.png";
      }

      case 14: {
        return "terms.png";
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
        NavigatorUtils.navigateToComplaintsScreen(context);
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

      default: {
        NavigatorUtils.navigateToSendNotificationScreen(context);
        break;
      }

    }
  }
}