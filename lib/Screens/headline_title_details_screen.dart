import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Models/headline.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';

import '../Constants/constants.dart';
import '../Controller/admin_controller.dart';
import '../Utils/navigator_utils.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/custom_inkwell.dart';
import '../Widgets/reusable_cache_network_image.dart';
import '../Widgets/waiting_widget.dart';

class HeadlineTitleDetailsScreen extends StatefulWidget {
  final Headline? headline;
  final TitleLine? titleLine;
  const HeadlineTitleDetailsScreen({Key? key, this.headline, this.titleLine}) : super(key: key);

  @override
  State<HeadlineTitleDetailsScreen> createState() => _HeadlineTitleDetailsScreenState();
}

class _HeadlineTitleDetailsScreenState extends State<HeadlineTitleDetailsScreen> {
  @override
  void initState() {
    if(widget.titleLine!=null&&widget.titleLine!.labelAr == "اعضاء المجلس البلدي"){
      context.read<AdminController>().getMembersWithoutBoss();
    }
    else if(widget.titleLine!=null&&widget.titleLine!.labelAr == "رئيس بلدية الجنيد"){
      context.read<AdminController>().getBoss();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.titleLine!.labelAr);
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: widget.headline!=null?Localizations.localeOf(context).languageCode=="ar"?widget.headline!.labelAr:widget.headline!.labelEn??widget.headline!.labelAr!
          :Localizations.localeOf(context).languageCode=="ar"?widget.titleLine!.labelAr:widget.titleLine!.labelEn??widget.titleLine!.labelAr,
      body:widget.titleLine!=null&&widget.titleLine!.labelAr == "رئيس بلدية الجنيد"
          ?Consumer<AdminController>(
          builder: (context, adminController, child) {
            return !adminController.waitingMembers? Padding(
              padding:  EdgeInsets.all(15),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10),
                children: [
                  ReusableCachedNetworkImage(
                    height: 150,
                    width: double.infinity,
                    imageUrl: adminController.boss!.imageUrl,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    adminController.boss!.name!,
                    style:  TextStyle(
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    adminController.boss!.des??"",
                    style:  TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ):const WaitingWidget();
          }
      )
          :widget.titleLine!=null&&widget.titleLine!.labelAr == "اعضاء المجلس البلدي"
          ?Consumer<AdminController>(
          builder: (context, adminController, child) {
            return !adminController.waitingMembers? Padding(
              padding:  EdgeInsets.all(15),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: adminController.membersWithoutBoss!.map((e) {
                  return Column(
                    children: [
                      ReusableCachedNetworkImage(
                        imageUrl: e.imageUrl,
                        height: 100,
                        width: 100,
                        borderRadius: BorderRadius.circular(5),
                        fit: BoxFit.cover,
                      ),
                      Text(
                        e.name!.toUpperCase(),
                        style: TextStyle(
                            fontSize: 17
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ):const WaitingWidget();
          }
      )
          : widget.headline==null
          ?ListView(
        shrinkWrap: true,

        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 10
        ),
        children: [
          if(widget.titleLine!.des!=null)
            Linkify(
              onOpen: _onOpen,
              text: widget.titleLine!.des!,
              style: const TextStyle(
                fontSize: 15,
              ),
              linkStyle: const TextStyle(
                fontSize: 15,
                color: kPrimaryColor
              ),
            ),
          SizedBox(height: 10,),
          if(widget.titleLine!.subTitles!.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.titleLine!.subTitles!.length,
              itemBuilder: (_,index){
                return ExpandablePanel(
                  theme: const ExpandableThemeData(
                    expandIcon: Icons.add,
                    collapseIcon: Icons.remove,
                  ),
                  header: Text(
                    widget.titleLine!.subTitles![index].label!,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  collapsed: const SizedBox(),
                  expanded: Container(
                    width: 700,
                    child: Text(
                      widget.titleLine!.subTitles![index].des!,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                );
              },
            ),
        ],
      )
          :Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5
        ),
        child: Linkify(
          onOpen: _onOpen,
          text:widget.headline!.des??"",
          style: TextStyle(
            fontSize: 15,
          ),),
        ),

    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: widget.headline!=null?Localizations.localeOf(context).languageCode=="ar"?widget.headline!.labelAr:widget.headline!.labelEn??widget.headline!.labelAr!
            :Localizations.localeOf(context).languageCode=="ar"?widget.titleLine!.labelAr:widget.titleLine!.labelEn??widget.titleLine!.labelAr,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child:widget.titleLine!=null&&widget.titleLine!.labelAr == "رئيس بلدية الجنيد"
            ?Consumer<AdminController>(
            builder: (context, adminController, child) {
              return !adminController.waitingMembers? Padding(
                padding:  EdgeInsets.all(size.height*0.02),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.04),
                  children: [
                    ReusableCachedNetworkImage(
                      height: size.height*0.25,
                      width: size.width,
                      imageUrl: adminController.boss!.imageUrl,
                    ),
                    SizedBox(height: size.height*0.02,),
                    Text(
                      adminController.boss!.name!,
                      style:  TextStyle(
                        fontSize: size.height*0.022,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: size.height*0.01,),
                    Text(
                      adminController.boss!.des??"",
                      style:  TextStyle(
                        fontSize: size.height*0.014,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ):const WaitingWidget();
            }
        )
            :widget.titleLine!=null&&widget.titleLine!.labelAr == "اعضاء المجلس البلدي"
            ?Consumer<AdminController>(
            builder: (context, adminController, child) {
              return !adminController.waitingMembers? Padding(
                padding:  EdgeInsets.all(size.height*0.02),
                child: Wrap(
                  spacing: size.height*0.02,
                  alignment: WrapAlignment.center,
                  runSpacing: size.height*0.02,
                  children: adminController.membersWithoutBoss!.map((e) {
                    return Column(
                      children: [
                        ReusableCachedNetworkImage(
                          imageUrl: e.imageUrl,
                          height: size.height*0.1,
                          width: size.height*0.1,
                          borderRadius: BorderRadius.circular(5),
                          fit: BoxFit.cover,
                        ),
                        Text(
                          e.name!.toUpperCase(),
                          style: TextStyle(
                              fontSize: size.height*0.02
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ):const WaitingWidget();
            }
        )
            : widget.headline==null
            ?ListView(
          padding: EdgeInsets.symmetric(
              horizontal: size.width*0.05,
              vertical: size.height*0.02
          ),
          children: [
            if(widget.titleLine!.des!=null)
              Linkify(
                onOpen:_onOpen,
                text: widget.titleLine!.des!,
                style:  TextStyle(
                  fontSize: size.height*0.022,
                ),
                linkStyle:  TextStyle(
                    fontSize: size.height*0.022,
                    color: kPrimaryColor
                ),
              ),
            SizedBox(height: size.height*0.025,),
            if(widget.titleLine!.subTitles!.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.titleLine!.subTitles!.length,
              itemBuilder: (_,index){
                return ExpandablePanel(
                  theme: const ExpandableThemeData(
                    expandIcon: Icons.add,
                    collapseIcon: Icons.remove,
                  ),
                  header: Text(
                    widget.titleLine!.subTitles![index].label!,
                    style: TextStyle(
                        fontSize: size.height * 0.018,
                        ),
                  ),
                  collapsed: const SizedBox(),
                  expanded: Container(
                    width: size.width*0.85,
                    child: Text(
                      widget.titleLine!.subTitles![index].des!,
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
              child:  Linkify(
                onOpen: _onOpen,
                text:widget.headline!.des??"",
                style: TextStyle(
                  fontSize: size.height*0.02,
                ),),
            ),
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    Utils.launchUrl(link.url);
  }
}
