import 'package:flutter/material.dart';

import '../Constants/constants.dart';
import 'custom_inkwell.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String label;
  final Color? color;
  final Color? textColor;
  final Function onPress;
  final bool withShadow;
  final Color? borderColor;
  final double? textSize;
  final double? borderWidth;

  final String? imagePath;
  const CustomButton({Key? key, this.height, this.width, required this.label, this.color, this.textColor, required this.onPress, this.withShadow = false, this.borderColor, this.textSize, this.imagePath, this.borderWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomInkwell(
      onTap:(){
        FocusManager.instance.primaryFocus!.unfocus();

        onPress();
      },
      child: Container(
        height: height??size.height*0.06,
        width: width??size.width*0.9,
        decoration: BoxDecoration(
            color: color??kPrimaryColor,
            borderRadius: BorderRadius.circular(size.height*0.005),
            border:borderColor!=null? Border.all(color: borderColor!,width:borderWidth?? 0.5):null,
            boxShadow: [
              BoxShadow(
                color:withShadow? Colors.grey.withOpacity(0.3):Colors.white,
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(imagePath!=null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                child: Image.asset(
                  imagePath!,
                  height: size.height*0.023,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                  fontSize:textSize?? size.height*0.02,
                  color: textColor??Colors.white,
                  fontWeight: FontWeight.w500
              ),
            ),

          ],
        ),
      ),
    );
  }
}
