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
                                    context
                                        .watch<HeadlineController>()
                                        .headlines![index]
                                        .label!,
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
                                                context
                                                    .watch<HeadlineController>()
                                                    .headlines![index]
                                                    .titles![subIndex]
                                                    .label!,
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
                                      context
                                          .watch<HeadlineController>()
                                          .headlines![index]
                                          .label!,
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
