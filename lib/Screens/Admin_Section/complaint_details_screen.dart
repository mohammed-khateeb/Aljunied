import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/complaint.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/reusable_cache_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Widgets/label_with_details.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  final Complaint complaint;
  const ComplaintDetailsScreen({Key? key, required this.complaint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "complaintDetails"),
      body: Column(
        children: [
          if(complaint.imageUrl!=null)
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20
              ),
              child: DottedBorder(
                child: ReusableCachedNetworkImage(
                  height: 200,
                  width: 400,
                  imageUrl: complaint.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Column(
              children: [
                LabelWithDetails(
                  label: translate(context, "name"),
                  details: complaint.userName!,
                ),
                LabelWithDetails(
                  label: translate(context, "mobileNumber"),
                  details: complaint.mobileNumber!,
                ),
                LabelWithDetails(
                  label: translate(context, "theIDNumber"),
                  details: complaint.citizenNumber.toString(),
                ),
                LabelWithDetails(
                  label: translate(context, "complaintType"),
                  details: complaint.type!,
                ),
                LabelWithDetails(
                  label: translate(context, "explanationOfTheComplaint"),
                  details: complaint.details!,
                ),
                LabelWithDetails(
                  label: translate(context, "time"),
                  details: Utils.getDateAndTimeString(complaint.createAt!.toDate()),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "complaintDetails"),
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
            if(complaint.imageUrl!=null)
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height*0.03,
                horizontal: size.width*0.05
              ),
              child: DottedBorder(
                child: ReusableCachedNetworkImage(
                  height: size.height*0.2,
                  width: size.width*0.9,
                  imageUrl: complaint.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height*0.03,
              ),
              child: Column(
                children: [
                  LabelWithDetails(
                    label: translate(context, "name"),
                    details: complaint.userName!,
                  ),
                  LabelWithDetails(
                    label: translate(context, "mobileNumber"),
                    details: complaint.mobileNumber!,
                  ),
                  LabelWithDetails(
                    label: translate(context, "theIDNumber"),
                    details: complaint.citizenNumber.toString(),
                  ),
                  LabelWithDetails(
                    label: translate(context, "complaintType"),
                    details: complaint.type!,
                  ),
                  LabelWithDetails(
                    label: translate(context, "explanationOfTheComplaint"),
                    details: complaint.details!,
                  ),
                  LabelWithDetails(
                    label: translate(context, "time"),
                    details: Utils.getDateAndTimeString(complaint.createAt!.toDate()),
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
