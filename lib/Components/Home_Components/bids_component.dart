import 'package:aljunied/Components/bid_container.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/admin_controller.dart';
import 'package:aljunied/Controller/bid_controller.dart';
import 'package:aljunied/Shimmers/bids_shimmer.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utils/util.dart';
import '../../Widgets/waiting_widget.dart';

class BidsComponent extends StatelessWidget {
  const BidsComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<BidController>(builder: (context, bidController, child) {
      return !bidController.waiting
          ? bidController.bids!.isNotEmpty
              ? SizedBox(
                  height: size.height * 0.25,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: size.width*0.05),
                        child: Row(
                          children:
                              context.watch<AdminController>().bidTypes!.map((e) {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: size.width * 0.03),
                              child: CustomInkwell(
                                onTap: () {
                                  context
                                      .read<AdminController>()
                                      .selectBidType(e);
                                },
                                child: Text(
                                  e.name!,
                                  style: TextStyle(
                                      fontSize: size.height * 0.017,
                                      color: e ==
                                              context
                                                  .read<AdminController>()
                                                  .selectedType
                                          ? Colors.grey[700]
                                          : Colors.grey[400]),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                          children: [
                            SizedBox(width: size.width*0.05,),
                        CustomInkwell(
                          onTap: ()=>bidController.changeForwarded(false),
                          child: Container(
                            height: size.height * 0.04,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color:bidController.forwarded?Colors.grey[200]: kPrimaryColor),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.01),
                                child: Text(
                                  translate(context, "availableBids"),
                                  style: TextStyle(
                                      fontSize: size.height * 0.015,
                                      color:bidController.forwarded?Colors.grey[700]: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        CustomInkwell(
                          onTap: ()=>bidController.changeForwarded(true),
                          child: Container(
                            height: size.height * 0.04,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color:!bidController.forwarded?Colors.grey[200]: kPrimaryColor),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.01),
                                child: Text(
                                  translate(context, "submittedBids"),
                                  style: TextStyle(
                                      fontSize: size.height * 0.015,
                                      color:!bidController.forwarded?Colors.grey[700]: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      if (context.watch<AdminController>().selectedType != null)
                        Expanded(
                          child: bidController.bids!
                                  .where((element) =>
                                      element.typeId ==
                                      context
                                          .watch<AdminController>()
                                          .selectedType!
                                          .id)
                              .where((element) => element.forwarded == bidController.forwarded)

                              .isNotEmpty
                              ? GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    mainAxisExtent: size.width * 0.5,
                                    mainAxisSpacing: size.width * 0.02,
                                  ),
                                  itemCount: bidController.bids!
                                      .where((element) =>
                                          element.typeId ==
                                          context
                                              .watch<AdminController>()
                                              .selectedType!
                                              .id)
                                      .where((element) => element.forwarded == bidController.forwarded)
                                      .length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    return BidContainer(
                                      bid: bidController.bids!
                                          .where((element) =>
                                              element.typeId ==
                                              context
                                                  .watch<AdminController>()
                                                  .selectedType!
                                                  .id)
                                          .where((element) => element.forwarded == bidController.forwarded)

                                          .toList()[index],
                                    );
                                  },
                                )
                              : SizedBox(),
                        ),
                    ],
                  ),
                )
              : const SizedBox()
          : const BidsShimmer();
    });
  }
}
