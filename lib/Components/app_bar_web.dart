import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/constants.dart';
import '../Controller/user_controller.dart';
import '../Localizations/app_language.dart';
import '../Widgets/custom_text_field.dart';

class AppBarWeb extends StatefulWidget {
  const AppBarWeb({Key? key}) : super(key: key);

  @override
  State<AppBarWeb> createState() => _AppBarWebState();
}

class _AppBarWebState extends State<AppBarWeb> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Column(
      children: [
        Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(CurrentUser.userId !=null)
                CustomInkwell(
                  onTap: () {
                    Utils.showSureAlertDialog(
                        onSubmit: (){
                      context.read<UserController>().logout();
                      NavigatorUtils.navigateToSplashScreen(context);
                    });
                  },
                  child: Text(
                    translate(context, "logout"),
                    style: TextStyle(
                      fontSize:  12,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              if(CurrentUser.userId !=null)
                const Spacer(),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomInkwell(
                  onTap: () {},
                  child: Image.asset(
                    "icons/youtube.png",
                    height: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomInkwell(
                  onTap: () {},
                  child: Image.asset(
                    "icons/twitter.png",
                    height: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomInkwell(
                  onTap: () {},
                  child: Image.asset(
                    "icons/instagram.png",
                    height: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomInkwell(
                  onTap: () {},
                  child: Image.asset(
                    "icons/facebook.png",
                    height: 20,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              if(CurrentUser.isAdmin ==true)
              CustomInkwell(
                onTap: () {
                    NavigatorUtils.navigateToHomeAdminScreen(context);
                },
                child: Text(
                  translate(context, "adminDashboard"),
                  style: TextStyle(
                      fontSize:  12,
                      color: Colors.grey[800],
                      ),
                ),
              ),
              if(CurrentUser.isAdmin ==true)

                Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                height: 25,
                color: Colors.grey,
                width: 1,
              ),
              CustomInkwell(
                onTap: () {
                  if (CurrentUser.userName == null) {
                    NavigatorUtils.navigateToLoginScreen(context);
                  }
                },
                child: Text(
                  CurrentUser.userName != null
                      ? CurrentUser.userName!
                      : translate(context, "signIn"),
                  style: TextStyle(
                      fontSize: CurrentUser.userName != null ? 15 : 12,
                      color: CurrentUser.userName != null
                          ? Colors.grey[800]
                          : Colors.grey,
                      fontWeight: CurrentUser.userName != null
                          ? FontWeight.bold
                          : null),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                height: 25,
                color: Colors.grey,
                width: 1,
              ),
              CustomInkwell(
                onTap: () {
                  if (Localizations.localeOf(context).languageCode == "en") {
                    appLanguage.changeLanguage(Locale("ar"));
                  } else {
                    appLanguage.changeLanguage(Locale("en"));
                  }
                },
                child: Text(
                  Localizations.localeOf(context).languageCode == "en"
                      ? "العربية"
                      : "English",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          child: Row(
            children: [
              const Text(
                "بلدية الجنيد \nAl Junaid Municipality",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, fontFamily: ""),
              ),
              Spacer(),
              if(CurrentUser.department!=null||CurrentUser.isAdmin ==true)
                SizedBox(
                width: 300,
                child: CustomTextField(
                  hintText: translate(context, "search"),
                  controller: controller,
                ),
              ),
              if(CurrentUser.department!=null||CurrentUser.isAdmin ==true)
              const SizedBox(width: 10),
              if(CurrentUser.department!=null||CurrentUser.isAdmin ==true)
              CustomInkwell(
                onTap: (){
                  FocusScope.of(context).unfocus();
                  NavigatorUtils.navigateToTransactionsScreen(context, controller.text);
                  controller.clear();
                },
                child: Container(
                  height: 45,
                  width: 45,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: kPrimaryColor,
                  ),
                  child: Image.asset("icons/search.png"),
                ),
              ),
              if(CurrentUser.department!=null)
                const Spacer(),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: CurrentUser.department != null&&CurrentUser.isAdmin!=true
                    ? Row(
                        children: [


                            CustomInkwell(
                              onTap: () =>
                                  NavigatorUtils.navigateToNotificationsScreen(
                                      context),
                              child: Text(
                                translate(context, "notifications"),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomInkwell(
                            onTap: () =>
                                NavigatorUtils.navigateToCreateEditATransactionScreen(context),
                            child: Text(
                              translate(context, "createATransaction"),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),


                        ],
                      )
                    : Row(
                        children: [
                          CustomInkwell(
                            onTap: () =>
                                NavigatorUtils.navigateToHomeScreen(context),
                            child: Text(
                              translate(context, "main"),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if(CurrentUser.userId!=null)
                          SizedBox(
                            width: 15,
                          ),
                          if(CurrentUser.userId!=null)

                            CustomInkwell(
                            onTap: () =>
                                NavigatorUtils.navigateToNotificationsScreen(
                                    context),
                            child: Text(
                              translate(context, "notifications"),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomInkwell(
                            onTap: () =>
                                NavigatorUtils.navigateToAboutWebScreen(
                                    context),
                            child: Text(
                              translate(context, "aboutTheMunicipality"),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomInkwell(
                            onTap: () =>
                                NavigatorUtils.navigateToBidsScreen(context),
                            child: Text(
                              translate(context, "bids"),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomInkwell(
                            onTap: () =>
                                NavigatorUtils.navigateToTouristAreasScreen(
                                    context),
                            child: Text(
                              translate(context, "touristAreasAndActivities"),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          CustomInkwell(
                            onTap: () =>
                                NavigatorUtils.navigateToAddInvestmentScreen(
                                    context),
                            child: Text(
                              translate(context, "investWithUs"),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
