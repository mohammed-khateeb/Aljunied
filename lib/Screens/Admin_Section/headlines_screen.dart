import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/bid_controller.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Controller/headline_controller.dart';
import '../../Widgets/waiting_widget.dart';

class HeadlinesScreen extends StatefulWidget {
  const HeadlinesScreen({Key? key}) : super(key: key);

  @override
  State<HeadlinesScreen> createState() => _HeadlinesScreenState();
}

class _HeadlinesScreenState extends State<HeadlinesScreen> {
  @override
  void initState() {
    context.read<HeadlineController>().getHeadlines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "headlines"),
      buttonLabel: translate(context, "add"),
      onPressButton: ()=>NavigatorUtils.navigateToAddEditHeadlineScreen(context,orderIndex: context.read<HeadlineController>().headlines!.length+1),
      body:  Consumer<HeadlineController>(
          builder: (context, headlineController, child) {
            return !headlineController.waiting
                ? ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10),
              itemCount: headlineController.headlines!.length,
              itemBuilder: (_, index) {
                return CustomInkwell(
                    onTap: ()=>NavigatorUtils.navigateToAddEditHeadlineScreen(context,headline: headlineController.headlines![index],orderIndex: headlineController.headlines!.length+1),
                    child: Stack(
                      children: [
                        ListTile(
                          title: Text(
                            Localizations.localeOf(context).languageCode=="ar"
                                ? headlineController.headlines![index].labelAr!
                                :headlineController.headlines![index].labelEn!=null&&headlineController.headlines![index].labelEn!=""?headlineController.headlines![index].labelEn!+"lko":headlineController.headlines![index].labelAr!,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.red
                            ),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            iconSize: 25,

                            onPressed: (){
                              Utils.showSureAlertDialog(
                                  onSubmit: (){
                                    headlineController.deleteHeadline(headlineController.headlines![index]);
                                  }
                              );
                            },
                          ),
                        ),

                      ],
                    ));
              },
            )
                : const WaitingWidget();
          }),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "headlines"),
      ),
      floatingActionButton:!context.watch<HeadlineController>().waiting? FloatingActionButton(
        child: const Icon(Icons.add,color: Colors.white,),

        onPressed: () => NavigatorUtils.navigateToAddEditHeadlineScreen(context,orderIndex: context.read<HeadlineController>().headlines!.length+1),
      ):null,
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child: Consumer<HeadlineController>(
            builder: (context, headlineController, child) {
              return !headlineController.waiting
                  ? ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.02),
                itemCount: headlineController.headlines!.length,
                itemBuilder: (_, index) {
                  return CustomInkwell(
                      onTap: ()=>NavigatorUtils.navigateToAddEditHeadlineScreen(context,headline: headlineController.headlines![index],orderIndex: headlineController.headlines!.length+1),
                      child: Stack(
                        children: [
                          ListTile(
                            title: Text(
                               Localizations.localeOf(context).languageCode=="ar"
                                   ? headlineController.headlines![index].labelAr!
                                   :headlineController.headlines![index].labelEn!=null&&headlineController.headlines![index].labelEn!=""?headlineController.headlines![index].labelEn!+"lko":headlineController.headlines![index].labelAr!,
                              style: TextStyle(
                                fontSize: size.height*0.018,
                                color: Colors.red
                              ),
                            ),
                            leading: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              iconSize: size.height*0.025,

                              onPressed: (){
                                Utils.showSureAlertDialog(
                                    onSubmit: (){
                                      headlineController.deleteHeadline(headlineController.headlines![index]);
                                    }
                                );
                              },
                            ),
                          ),

                        ],
                      ));
                },
              )
                  : const WaitingWidget();
            }),
      ),
    );
  }
}
