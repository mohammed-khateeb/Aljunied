import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/user_controller.dart';
import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/headline_controller.dart';
import '../Utils/util.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Drawer(

      backgroundColor: kPrimaryColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "images/down_path.png",
              color: Colors.black.withOpacity(0.15),
            ),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "بلدية الجنيد",
                    style: TextStyle(
                        fontSize: size.height * 0.03,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: ""),
                  ),
                  Image.asset(
                    "images/national_without_background.png",
                    height: size.height * 0.08,
                  ),
                ],
              ),
              if (context.watch<HeadlineController>().headlines != null)
                ListView.builder(
                  itemCount: context.watch<HeadlineController>().headlines!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(start: size.width * 0.05),
                      child: context
                              .watch<HeadlineController>()
                              .headlines![index]
                              .titles!
                              .isNotEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpandablePanel(
                                  theme: const ExpandableThemeData(
                                    iconColor: Colors.white,
                                    expandIcon: Icons.add,
                                    collapseIcon: Icons.remove,
                                  ),
                                  header: Text(
                                    Localizations.localeOf(context).languageCode=="ar"?context
                                        .watch<HeadlineController>()
                                        .headlines![index]
                                        .labelAr!:context
                                        .watch<HeadlineController>()
                                        .headlines![index]
                                        .labelEn??context
                                        .watch<HeadlineController>()
                                        .headlines![index]
                                        .labelAr!,
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        color: Colors.white),
                                  ),
                                  expanded: ListView.builder(
                                    itemCount: context
                                        .watch<HeadlineController>()
                                        .headlines![index]
                                        .titles!
                                        .length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (_, subIndex) {
                                      return Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: size.width * 0.05),
                                        child: CustomInkwell(
                                          onTap: (){
                                            NavigatorUtils
                                                .navigateToHeadlineTitleDetailsScreen(context,
                                                titleLine:context
                                                    .read<HeadlineController>()
                                                    .headlines![index]
                                                    .titles![subIndex]);
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Localizations.localeOf(context).languageCode=="ar"?context
                                                    .watch<HeadlineController>()
                                                    .headlines![index]
                                                    .titles![subIndex]
                                                    .labelAr!:context
                                                    .watch<HeadlineController>()
                                                    .headlines![index]
                                                    .titles![subIndex]
                                                    .labelEn??context
                                                    .watch<HeadlineController>()
                                                    .headlines![index]
                                                    .titles![subIndex]
                                                    .labelAr!,
                                                style: TextStyle(
                                                    fontSize: size.height * 0.018,
                                                    color: Colors.white),
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  collapsed: const SizedBox(),
                                ),
                              Divider(height: size.height*0.01,),

                            ],
                          )
                          : CustomInkwell(
                              onTap: () => NavigatorUtils
                                  .navigateToHeadlineTitleDetailsScreen(context,
                                      headline: context
                                          .read<HeadlineController>()
                                          .headlines![index]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: size.height * 0.04,
                                    color: Colors.transparent,
                                    child: Text(
                                      Localizations.localeOf(context).languageCode=="ar"? context
                                          .watch<HeadlineController>()
                                          .headlines![index]
                                          .labelAr!:context
                                          .watch<HeadlineController>()
                                          .headlines![index]
                                          .labelEn??context
                                        .watch<HeadlineController>()
                                        .headlines![index]
                                        .labelAr!,
                                      style: TextStyle(
                                          fontSize: size.height * 0.018,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Divider(height: size.height*0.01,),

                                ],
                              ),
                            ),
                    );
                  },
                ),
              CustomInkwell(
                onTap: (){
                  NavigatorUtils.navigateToLanguageScreen(context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: size.height * 0.04,
                      padding: EdgeInsetsDirectional.only(start: size.width * 0.05),
                      child: Text(
                       translate(context,"language"),
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: Colors.white),
                      ),
                    ),
                    Divider(height: size.height*0.01,),

                  ],
                ),
              ),

              ExpandablePanel(
                theme: const ExpandableThemeData(
                  iconColor: Colors.white,
                  expandIcon: Icons.add,
                  collapseIcon: Icons.remove,
                ),
                header: Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.05),
                  child: Text(
                    translate(context, "atYourService"),
                    style: TextStyle(
                        fontSize: size.height * 0.018,
                        color: Colors.white),
                  ),
                ),
                expanded: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    if(CurrentUser.token!=null)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: size.width * 0.1),
                      child: CustomInkwell(
                        onTap: (){
                          NavigatorUtils
                              .navigateToMakeComplaintScreen(context,kind: 1);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate(context, "askTheMunicipality"),
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  color: Colors.white),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: size.width * 0.1),
                      child: CustomInkwell(
                        onTap: (){
                          NavigatorUtils
                              .navigateToMakeComplaintScreen(context,kind: 2);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate(context, "suggestion"),
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  color: Colors.white),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: size.width * 0.1),
                      child: CustomInkwell(
                        onTap: (){
                          NavigatorUtils
                              .navigateToMakeComplaintScreen(context);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate(context, "complaint"),
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  color: Colors.white),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: size.width * 0.1),
                      child: CustomInkwell(
                        onTap: (){
                          NavigatorUtils
                              .navigateToMakeComplaintScreen(context,kind: 4);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate(context, "report"),
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  color: Colors.white),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: size.width * 0.1),
                      child: CustomInkwell(
                        onTap: (){
                          NavigatorUtils
                              .navigateToMakeComplaintScreen(context,kind: 5);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate(context, "tribute"),
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  color: Colors.white),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                collapsed: const SizedBox(),
              ),
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  iconColor: Colors.white,
                  expandIcon: Icons.add,
                  collapseIcon: Icons.remove,
                ),
                header: Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.05),
                  child: Text(
                    translate(context, "serviceRequest"),
                    style: TextStyle(
                        fontSize: size.height * 0.018,
                        color: Colors.white),
                  ),
                ),
                expanded: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [

                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: size.width * 0.1),
                      child: CustomInkwell(
                        onTap: (){
                          NavigatorUtils
                              .navigateToMakeComplaintScreen(context,kind: 6);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate(context, "requestATrashContainerService"),
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  color: Colors.white),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: size.width * 0.1),
                      child: CustomInkwell(
                        onTap: (){
                          NavigatorUtils
                              .navigateToMakeComplaintScreen(context,kind: 7);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate(context, "lightingServiceRequest"),
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  color: Colors.white),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
                collapsed: const SizedBox(),
              ),
              if(CurrentUser.department==null)

                CustomInkwell(
                onTap: (){
                  NavigatorUtils.navigateToMakeComplaintScreen(context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: size.height * 0.04,
                      padding: EdgeInsetsDirectional.only(start: size.width * 0.05),
                      child: Text(
                        translate(context,"complaints"),
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: Colors.white),
                      ),
                    ),
                    Divider(height: size.height*0.01,),

                  ],
                ),
              ),
              if(CurrentUser.department==null)
              CustomInkwell(
                onTap: (){
                  NavigatorUtils.navigateToAddInvestmentScreen(context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: size.height * 0.04,
                      padding: EdgeInsetsDirectional.only(start: size.width * 0.05),
                      child: Text(
                        translate(context,"investWithUs"),
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: Colors.white),
                      ),
                    ),
                    Divider(height: size.height*0.01,),

                  ],
                ),
              ),
              CustomInkwell(
                onTap: (){
                  if(CurrentUser.userId!=null) {
                    Utils.showSureAlertDialog(
                    onSubmit: (){
                      context.read<UserController>().logout();
                      NavigatorUtils.navigateToSplashScreen(context);
                    }
                  );
                  }
                  else{
                    NavigatorUtils.navigateToSplashScreen(context);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: size.height * 0.04,
                      padding: EdgeInsetsDirectional.only(start: size.width * 0.05),
                      child: Text(
                        translate(context,CurrentUser.userId!=null?"logout":"exit"),
                        style: TextStyle(
                            fontSize: size.height * 0.018,
                            color: Colors.white),
                      ),
                    ),
                    Divider(height: size.height*0.01,),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
