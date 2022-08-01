import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
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
          color:isSelected?darken(kPrimaryColor):kIsWeb?darken(kPrimaryColor,0.02): kPrimaryColor,
          borderRadius: BorderRadius.circular(kIsWeb?10:size.height*0.02)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:kIsWeb&&size.width>520?onTab!=null?5:25: size.width*0.03,
            vertical:kIsWeb&&size.width>520?onTab!=null?8:25: size.height*0.01
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height:kIsWeb&&size.width>520?3: size.height*0.01,),

                  Image.asset(
                    "icons/$iconPath",
                    height:kIsWeb&&size.width>520?onTab!=null?30:35:onTab!=null?size.height*0.035: size.height*0.03,
                  ),
                  SizedBox(height: kIsWeb&&size.width>520?onTab!=null?5:15:size.height*0.01,),
                  SizedBox(
                    height: kIsWeb&&size.width>520?onTab!=null?40:30:size.height*0.05,
                    width:kIsWeb&&size.width>520?onTab!=null?85:100: size.width*0.15,
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          height: kIsWeb?null:size.height*0.0015,
                          fontSize:kIsWeb&&size.width>520?onTab!=null?11:14:Localizations.localeOf(context).languageCode=="en"?size.height*0.01:onTab!=null?size.height*0.015: size.height*0.014,
                          color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  )
                ],
              ),
              if(completed)
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size:kIsWeb&&size.width>520?20: size.height*0.02,
              )
            ],
          ),
        ),
      ),
    );
  }
}
