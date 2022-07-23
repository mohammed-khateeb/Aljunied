import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/step_widget.dart';
import 'package:flutter/material.dart';

import '../../Widgets/custom_button.dart';

class CreateTransactionSection extends StatelessWidget {
  const CreateTransactionSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(context, "createATransaction"),
                    style: TextStyle(
                      fontSize: size.height*0.02,
                      fontFamily: "ArabFontBold",
                    ),
                  ),
                  Text(
                    translate(context, "followTheStepsBelowToCreateATransaction"),
                    style: TextStyle(
                      fontSize: size.height*0.017,
                      color: kSubTitleColor
                    ),
                  )
                ],
              ),
            ),
            CustomButton(
              width: size.width*0.14,
              height: size.height*0.045,
              textSize: size.height*0.017,
              label: translate(context, "create"),
              onPress: (){
                NavigatorUtils.navigateToCreateEditATransactionScreen(context);
              },
            )
          ],
        ),
        SizedBox(height: size.height*0.02,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StepWidget(label: translate(context, "typeOfTransaction"), iconPath: "work.png"),
            StepWidget(label: translate(context, "subTypeOfTransaction"), iconPath: "paper.png"),
            StepWidget(label: translate(context, "anotherAddition"), iconPath: "document.png"),
            StepWidget(label: translate(context, "citizenInformation"), iconPath: "info.png"),

          ],
        ),
      ],
    );
  }
}
