import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/complaint.dart';
import 'package:aljunied/Models/investment.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/reusable_cache_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../Widgets/label_with_details.dart';

class InvestmentDetailsScreen extends StatelessWidget {
  final Investment investment;
  const InvestmentDetailsScreen({Key? key, required this.investment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "investmentDetails"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child: ListView(
          children: [

            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height*0.03,
              ),
              child: Column(
                children: [
                  LabelWithDetails(
                    label: translate(context, "name"),
                    details: investment.userName!,
                  ),
                  LabelWithDetails(
                    label: translate(context, "mobileNumber"),
                    details: investment.mobileNumber!,
                  ),
                  LabelWithDetails(
                    label: translate(context, "email"),
                    details: investment.email!,
                  ),
                  LabelWithDetails(
                    label: translate(context, "ideaText"),
                    details: investment.des!,
                  ),
                  LabelWithDetails(
                    label: translate(context, "time"),
                    details: Utils.getDateAndTimeString(investment.createAt!.toDate()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
