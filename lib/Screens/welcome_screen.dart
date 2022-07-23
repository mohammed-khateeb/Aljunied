import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:flutter/material.dart';

import '../Utils/util.dart';
import '../Widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            "images/up_path.png",
            height: size.height*0.3,
            width: size.width*0.9,
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                translate(context,"welcome"),
                style: TextStyle(
                  fontSize: size.height*0.025,
                  fontFamily: "ArabFontSemiBold",
                ),
              ),
              SizedBox(height: size.height*0.015,),
              Text(
                "بلدية الجنيد",
                style: TextStyle(
                  fontSize: size.height*0.05,
                  fontFamily: "",
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: size.height*0.015,),
              Text(
                "نص شكلي بمعنى أن الغاية هي الشكل \nوليس المحتوى",
                style: TextStyle(
                  fontSize: size.height*0.02,
                  color: Colors.grey
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height*0.4,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height*0.02
                  ),
                  child: Image.asset(
                    "images/national.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: size.height*0.02,),

              CustomButton(
                label: translate(context, "start"),
                onPress: ()=>NavigatorUtils.navigateToLoginScreen(context),
              ),
              SizedBox(height: size.height*0.02,),
              CustomButton(
                borderWidth: 1.5,
                borderColor: kPrimaryColor,
                color: Colors.transparent,
                textColor: kPrimaryColor,
                label: translate(context, "skip"),
                onPress: ()=>NavigatorUtils.navigateToHomeScreen(context),
              ),
              SizedBox(height: size.height*0.08,width: size.width,),

            ],
          ),
        ],
      ),
    );
  }
}
