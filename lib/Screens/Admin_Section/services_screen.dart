import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Constants/constants.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_app_bar.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "atYourService"),
      body: Column(
        children: [
          SizedBox(height: 30,),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 15
            ),
            child: CustomButton(
              label: translate(context, "questions"),
              onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 1),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 15
            ),
            child: CustomButton(
              label: translate(context, "suggestions"),
              onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 15
            ),
            child: CustomButton(
              label: translate(context, "complaints"),
              onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 3),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 15
            ),
            child: CustomButton(
              label: translate(context, "reports"),
              onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 4),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 15
            ),
            child: CustomButton(
              label: translate(context, "tributes"),
              onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 5),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 15
            ),
            child: CustomButton(
              label: translate(context, "trashContainerRequests"),
              onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 6),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 15
            ),
            child: CustomButton(
              label: translate(context, "lightingRequests"),
              onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 7),
            ),
          ),

        ],
      ),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "atYourService"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child: Column(
          children: [
            SizedBox(height: size.height*0.05,),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height*0.015
              ),
              child: CustomButton(
                  label: translate(context, "questions"),
                  onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 1),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height*0.015
              ),
              child: CustomButton(
                label: translate(context, "suggestions"),
                onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height*0.015
              ),
              child: CustomButton(
                label: translate(context, "complaints"),
                onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 3),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height*0.015
              ),
              child: CustomButton(
                label: translate(context, "reports"),
                onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 4),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height*0.015
              ),
              child: CustomButton(
                label: translate(context, "tributes"),
                onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 5),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height*0.015
              ),
              child: CustomButton(
                label: translate(context, "trashContainerRequests"),
                onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 6),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height*0.015
              ),
              child: CustomButton(
                label: translate(context, "lightingRequests"),
                onPress: ()=>NavigatorUtils.navigateToComplaintsScreen(context,kind: 7),
              ),
            ),

          ],
        ),
      ),

    );
  }
}
