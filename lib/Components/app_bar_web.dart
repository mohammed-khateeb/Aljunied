import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';

class AppBarWeb extends StatelessWidget {
  const AppBarWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 100,
        vertical: 15
      ),
      child: Row(
        children: [
          const Text(
            "بلدية الجنيد \nAl Junaid Municipality",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: ""
            ),
          ),
          Spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CustomInkwell(
                  onTap: ()=>NavigatorUtils.navigateToHomeScreen(context),
                  child: Text(
                    translate(context, "main"),
                    style: const TextStyle(
                        fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(width: 15,),
                Text(
                  translate(context, "aboutTheMunicipality"),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 15,),
                CustomInkwell(
                  onTap: ()=>NavigatorUtils.navigateToBidsScreen(context),

                  child: Text(
                    translate(context, "bids"),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(width: 15,),
                CustomInkwell(
                  onTap: ()=>NavigatorUtils.navigateToTouristAreasScreen(context),

                  child: Text(
                    translate(context, "touristAreasAndActivities"),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(width: 15,),

                CustomInkwell(
                  onTap: ()=>NavigatorUtils.navigateToAddInvestmentScreen(context),
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
    );
  }
}
