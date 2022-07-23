import 'package:aljunied/Components/area_container.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Shimmers/areas_shimmer.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/reusable_cache_network_image.dart';
import 'package:aljunied/Widgets/waiting_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controller/area_controller.dart';

class ActivitiesAndAreas extends StatelessWidget {

  const ActivitiesAndAreas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height*0.3,
      child: Consumer<AreaController>(
          builder: (context, areaController, child) {
          return !areaController.waiting
              ? areaController.areas!.isNotEmpty? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: size.width*0.05),
                    child: Text(
                      translate(context, "touristAreasAndActivities"),
                      style: TextStyle(
                        fontSize: size.height*0.02,
                        fontFamily: "ArabFontBold",
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
            itemCount: areaController.areas!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_,index){
                    return AreaContainer(area: areaController.areas![index],);
            },
          ),
                  ),
                ],
              ):const SizedBox():Padding(
                padding: EdgeInsets.only(bottom: size.height*0.02),
                child: const AreasShimmer(),
              );
        }
      ),
    );
  }
}
