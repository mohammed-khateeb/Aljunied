import 'package:aljunied/Components/custom_drawer.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/admin_controller.dart';
import 'package:aljunied/Controller/area_controller.dart';
import 'package:aljunied/Controller/bid_controller.dart';
import 'package:aljunied/Controller/headline_controller.dart';
import 'package:aljunied/Controller/news_controller.dart';
import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/Home_Components/activities_and_areas.dart';
import '../Components/Home_Components/banners.dart';
import '../Components/Home_Components/bids_component.dart';
import '../Components/Home_Components/download_app_section.dart';
import '../Components/Home_Components/tracking_widget.dart';
import '../Components/Home_Components/web_header.dart';
import '../Components/app_bar_web.dart';
import '../Components/bottom_bar_web.dart';
import '../Controller/transaction_controller.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    context.read<AdminController>().getAllBidTypes();
    context.read<BidController>().getBids();
    if(!kIsWeb) {
      context.read<HeadlineController>().getHeadlines();
    }
    context.read<NewsController>().getNews();
    context.read<AreaController>().getAreas();
    super.initState();
  }


  @override
  void dispose() {
    FocusManager.instance.primaryFocus!.unfocus();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
      return kIsWeb&&size.width>520
          ?Scaffold(
       body: SingleChildScrollView(
         child: Column(
           children:  [
             if(size.width>824&&Localizations.localeOf(context).languageCode=="ar"||
                 size.width>1000&&Localizations.localeOf(context).languageCode=="en")
             const AppBarWeb(),
             const WebHeader(),
             const SizedBox(height: 20,),
             const Banners(),
             const SizedBox(height: 20,),
             const BidsComponent(),
             const SizedBox(height: 20,),
             const ActivitiesAndAreas(),
             const SizedBox(height: 30,),
             const DownloadAppSection(),
             const BottomBarWeb(),
           ],
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
          action:CurrentUser.isAdmin == true? Row(
            children: [
              CustomInkwell(
                onTap: ()=>NavigatorUtils.navigateToHomeAdminScreen(context),
                child: Padding(
                  padding: EdgeInsets.all(size.height*0.015),
                  child: Icon(
                    Icons.admin_panel_settings_outlined,
                    size: size.height*0.035,
                  ),
                ),
              ),
              CustomInkwell(
                onTap: ()=>NavigatorUtils.navigateToNotificationsScreen(context),
                child: Padding(
                  padding: EdgeInsets.all(size.height*0.02),
                  child: Image.asset(
                    "icons/notification.png",
                  ),
                ),
              ),
            ],
          ):null,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height*0.02,),
              const Banners(),
              SizedBox(height: size.height*0.03,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                child: const TrackingWidget(),
              ),
              SizedBox(height: size.height*0.03,),
              const BidsComponent(),
              SizedBox(height: size.height*0.03,),
              const ActivitiesAndAreas(),
              SizedBox(height: size.height*0.03,),

            ],
          ),
        ),
      );
  }
}
