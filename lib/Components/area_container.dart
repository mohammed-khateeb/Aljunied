import 'package:aljunied/Models/area.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';

import '../Constants/constants.dart';
import '../Utils/navigator_utils.dart';
import '../Widgets/reusable_cache_network_image.dart';

class AreaContainer extends StatelessWidget {
  final Area area;
  const AreaContainer({Key? key, required this.area}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
      child: SizedBox(
        width: size.width*0.38,

        child: CustomInkwell(
          onTap: ()=>NavigatorUtils.navigateToNewsDetailsScreen(context, area:area),
          child: Column(
            children: [
              ReusableCachedNetworkImage(
                height: size.height*0.16,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(5)
                ),
                width: size.width,
                fit: BoxFit.cover,
                imageUrl: area.imageUrl,
              ),
              Text(
                area.name!,
                style: TextStyle(
                  fontSize: size.height*0.016,
                  fontFamily: "ArabFontBold",

                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              Text(
                area.des!,
                style: TextStyle(
                  fontSize: size.height*0.011,
                  color: kSubTitleColor,
                ),
                maxLines: 1,
                textAlign: TextAlign.center,

              ),
              CustomInkwell(
                onTap: ()=>Utils.launchMapUrl(area.location),
                child: Text(
                  translate(context, "location"),
                  style: TextStyle(
                      fontSize: size.height*0.011,
                      color: kPrimaryColor
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
