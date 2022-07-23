import 'package:flutter/material.dart';
import '../Constants/constants.dart';
import 'custom_inkwell.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget{
  final String? title;
  final Widget? action;
  final Widget? leading;
  final bool allowBack;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? arrowColor;
  const CustomAppBar({Key? key, this.title, this.action, this.allowBack = true, this.backgroundColor, this.titleColor, this.leading, this.arrowColor}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: backgroundColor??Colors.transparent,
      leading:leading!=null?leading: allowBack?CustomInkwell(
        onTap: ()=>Navigator.pop(context),
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: size.width*0.05,end: size.width*0.01),
          child: Icon(
            Icons.arrow_back,
            size: size.height*0.022,
            color:arrowColor?? kDarkThemeColor,
          ),
        ),
      ):null,
      title: Text(
        title??"",
        style: TextStyle(
            fontSize: size.height*0.021,
            color: titleColor??Colors.grey[800],
          fontWeight: FontWeight.w600
        ),
      ),
      actions: [
        action!=null?Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width*0.04),
          child: action!,
        ):const SizedBox()
      ],

    );
  }
}