import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Widgets/waiting_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/headline_controller.dart';
import '../Utils/navigator_utils.dart';
import '../Utils/util.dart';
import '../Widgets/custom_inkwell.dart';

class AboutWebScreen extends StatefulWidget {
  const AboutWebScreen({Key? key}) : super(key: key);

  @override
  State<AboutWebScreen> createState() => _AboutWebScreenState();
}

class _AboutWebScreenState extends State<AboutWebScreen> {
  @override
  void initState() {
    context.read<HeadlineController>().getHeadlines();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWeb(
      title: translate(context, "aboutTheMunicipality"),
      body:!context.watch<HeadlineController>().waiting? ListView.builder(
        itemCount: context.watch<HeadlineController>().headlines!.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return Padding(
            padding: EdgeInsetsDirectional.only(start: 10),
            child: context
                .watch<HeadlineController>()
                .headlines![index]
                .titles!
                .isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandablePanel(
                  theme: const ExpandableThemeData(
                    expandIcon: Icons.add,
                    collapseIcon: Icons.remove,
                  ),
                  header: Text(
                    Localizations.localeOf(context).languageCode=="ar"?context
                        .watch<HeadlineController>()
                        .headlines![index]
                        .labelAr!:context
                        .watch<HeadlineController>()
                        .headlines![index]
                        .labelEn??context
                        .watch<HeadlineController>()
                        .headlines![index]
                        .labelAr!,
                    style: TextStyle(
                        fontSize: 16,
                        ),
                  ),
                  expanded: ListView.builder(
                    itemCount: context
                        .watch<HeadlineController>()
                        .headlines![index]
                        .titles!
                        .length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, subIndex) {
                      return Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: 8),
                        child: CustomInkwell(
                          onTap: (){
                            NavigatorUtils
                                .navigateToHeadlineTitleDetailsScreen(context,
                                titleLine:context
                                    .read<HeadlineController>()
                                    .headlines![index]
                                    .titles![subIndex]);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Localizations.localeOf(context).languageCode=="ar"?context
                                    .watch<HeadlineController>()
                                    .headlines![index]
                                    .titles![subIndex]
                                    .labelAr!:context
                                    .watch<HeadlineController>()
                                    .headlines![index]
                                    .titles![subIndex]
                                    .labelEn??context
                                    .watch<HeadlineController>()
                                    .headlines![index]
                                    .titles![subIndex]
                                    .labelAr!,
                                style: TextStyle(
                                    fontSize: 16,
                                    ),
                              ),
                              if(subIndex!=context
                                  .watch<HeadlineController>()
                                  .headlines![index]
                                  .titles!
                                  .length-1)
                              const Divider(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  collapsed: const SizedBox(),
                ),
                Divider(height: 3,),

              ],
            )
                : CustomInkwell(
              onTap: () => NavigatorUtils
                  .navigateToHeadlineTitleDetailsScreen(context,
                  headline: context
                      .read<HeadlineController>()
                      .headlines![index]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    color: Colors.transparent,
                    child: Text(
                      Localizations.localeOf(context).languageCode=="ar"? context
                          .watch<HeadlineController>()
                          .headlines![index]
                          .labelAr!:context
                          .watch<HeadlineController>()
                          .headlines![index]
                          .labelEn??context
                          .watch<HeadlineController>()
                          .headlines![index]
                          .labelAr!,
                      style: TextStyle(
                          fontSize: 16,

                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Divider(height: 3,),

                ],
              ),
            ),
          );
        },
      ):const WaitingWidget(),
    );
  }
}
