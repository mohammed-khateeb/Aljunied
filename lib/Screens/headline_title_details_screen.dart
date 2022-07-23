import 'package:aljunied/Models/headline.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../Constants/constants.dart';
import '../Utils/navigator_utils.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/custom_inkwell.dart';

class HeadlineTitleDetailsScreen extends StatelessWidget {
  final Headline? headline;
  final TitleLine? titleLine;
  const HeadlineTitleDetailsScreen({Key? key, this.headline, this.titleLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: headline!=null?headline!.label:titleLine!.label!,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child: headline==null
            ?ListView(
          padding: EdgeInsets.symmetric(
              horizontal: size.width*0.05,
              vertical: size.height*0.02
          ),
          children: [
            if(titleLine!.des!=null)
            Text(
              titleLine!.des!,
              style: TextStyle(
                fontSize: size.height*0.02,
              ),
            ),
            SizedBox(height: size.height*0.025,),
            if(titleLine!.subTitles!.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: titleLine!.subTitles!.length,
              itemBuilder: (_,index){
                return ExpandablePanel(
                  theme: const ExpandableThemeData(
                    expandIcon: Icons.add,
                    collapseIcon: Icons.remove,
                  ),
                  header: Text(
                    titleLine!.subTitles![index].label!,
                    style: TextStyle(
                        fontSize: size.height * 0.018,
                        ),
                  ),
                  collapsed: const SizedBox(),
                  expanded: Container(
                    width: size.width*0.85,
                    child: Text(
                      titleLine!.subTitles![index].des!,
                      style: TextStyle(
                          fontSize: size.height * 0.018,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                );
              },
            ),
          ],
        )
            :Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width*0.05,
              vertical: size.height*0.02
          ),
              child: Text(headline!.des??"",style: TextStyle(
          fontSize: size.height*0.02,
        ),),
            ),
      ),
    );
  }
}
