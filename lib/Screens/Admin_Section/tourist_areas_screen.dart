import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Controller/area_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Components/area_container.dart';
import '../../Constants/constants.dart';
import '../../Utils/navigator_utils.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/waiting_widget.dart';

class TouristAreasScreen extends StatefulWidget {
  const TouristAreasScreen({Key? key}) : super(key: key);

  @override
  State<TouristAreasScreen> createState() => _TouristAreasScreenState();
}

class _TouristAreasScreenState extends State<TouristAreasScreen> {
  @override
  void initState() {
    context.read<AreaController>().getAreas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "touristAreasAndActivities"),
      buttonLabel: translate(context, "add"),
      onPressButton: ()=>NavigatorUtils.navigateToAddEditAreaScreen(context),
      body: Consumer<AreaController>(
          builder: (context, areaController, child) {
            return !areaController.waiting
                ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 260,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10),
              itemCount: areaController.areas!.length,
              itemBuilder: (_, index) {
                return CustomInkwell(
                    onTap: ()=>NavigatorUtils.navigateToAddEditAreaScreen(context,area: areaController.areas![index]),
                    child: Stack(
                      children: [
                        AreaContainer(area: areaController.areas![index]),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          iconSize: 25,

                          onPressed: (){
                            Utils.showSureAlertDialog(
                                onSubmit: (){
                                  areaController.deleteArea(areaController.areas![index]);
                                }
                            );
                          },
                        )
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
        title: translate(context, "touristAreasAndActivities"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: () => NavigatorUtils.navigateToAddEditAreaScreen(context),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child:  Consumer<AreaController>(
            builder: (context, areaController, child) {
              return !areaController.waiting
                  ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: size.height*0.25,
                    mainAxisSpacing: size.height*0.01,
                    crossAxisSpacing: size.height*0.01
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.02),
                itemCount: areaController.areas!.length,
                itemBuilder: (_, index) {
                  return CustomInkwell(
                      onTap: ()=>NavigatorUtils.navigateToAddEditAreaScreen(context,area: areaController.areas![index]),
                      child: Stack(
                        children: [
                          AreaContainer(area: areaController.areas![index]),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            iconSize: size.height*0.025,

                            onPressed: (){
                              Utils.showSureAlertDialog(
                                  onSubmit: (){
                                    areaController.deleteArea(areaController.areas![index]);
                                  }
                              );
                            },
                          )
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
