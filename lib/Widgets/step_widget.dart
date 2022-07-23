import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';

class StepWidget extends StatelessWidget {
  final String label;
  final String iconPath;
  final Function? onTab;
  final bool isSelected;
  final bool completed;
  const StepWidget({Key? key, required this.label, required this.iconPath, this.onTab, this.isSelected = false, this.completed = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomInkwell(
      onTap:onTab!=null? ()=>onTab!():(){},
      child: Container(
        decoration: BoxDecoration(
          color:isSelected?darken(kPrimaryColor): kPrimaryColor,
          borderRadius: BorderRadius.circular(size.height*0.02)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width*0.03,
            vertical: size.height*0.01
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height*0.01,),

                  Image.asset(
                    "icons/$iconPath",
                    height:onTab!=null?size.height*0.035: size.height*0.03,
                  ),
                  SizedBox(height: size.height*0.01,),
                  SizedBox(
                    width: size.width*0.15,
                    child: Text(
                      label,
                      style: TextStyle(
                        height: size.height*0.0015,
                        fontSize:Localizations.localeOf(context).languageCode=="en"?size.height*0.01:onTab!=null?size.height*0.015: size.height*0.014,
                        color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  )
                ],
              ),
              if(completed)
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: size.height*0.02,
              )
            ],
          ),
        ),
      ),
    );
  }
}
