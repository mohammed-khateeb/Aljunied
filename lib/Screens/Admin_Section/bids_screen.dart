import 'package:aljunied/Components/news_container.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/bid_controller.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/bid_container.dart';
import '../../Controller/admin_controller.dart';
import '../../Widgets/waiting_widget.dart';

class BidsScreen extends StatefulWidget {
  const BidsScreen({Key? key}) : super(key: key);

  @override
  State<BidsScreen> createState() => _BidsScreenState();
}

class _BidsScreenState extends State<BidsScreen> {
  @override
  void initState() {

    Future.delayed(Duration.zero).then((value) {
      context.read<BidController>().resetWaiting().then((value) {
        context.read<BidController>().getBids();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "bids"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          translate(context, "add"),
          style: TextStyle(
              fontSize: size.height*0.018,
              fontWeight: FontWeight.w600
          ),
        ),
        onPressed: () => NavigatorUtils.navigateToAddEditBidScreen(context),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child:  Consumer<BidController>(
            builder: (context, bidController, child) {
          return !bidController.waiting
              ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: size.height*0.18,
                mainAxisSpacing: size.height*0.01,
                crossAxisSpacing: size.height*0.01
            ),
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.02),
            itemCount: bidController.bids!.length,
            itemBuilder: (_, index) {
              return CustomInkwell(
                  onTap: ()=>NavigatorUtils.navigateToAddEditBidScreen(context,bid: bidController.bids![index]),
                  child: Stack(
                    children: [
                      BidContainer(bid: bidController.bids![index]),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        iconSize: size.height*0.025,

                        onPressed: (){
                          Utils.showSureAlertDialog(
                              onSubmit: (){
                                bidController.deleteBid(bidController.bids![index]);
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
