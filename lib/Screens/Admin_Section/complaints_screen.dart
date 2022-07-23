import 'package:aljunied/Components/news_container.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/bid_controller.dart';
import 'package:aljunied/Controller/complaint_controller.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/bid_container.dart';
import '../../Controller/admin_controller.dart';
import '../../Widgets/waiting_widget.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  @override
  void initState() {

    context.read<ComplaintController>().getComplaints();
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
        title: translate(context, "complaints"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child:  Consumer<ComplaintController>(
            builder: (context, complaintController, child) {
          return !complaintController.waiting
              ? ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.02),
            itemCount: complaintController.complaints!.length,
            itemBuilder: (_, index) {
              return ListTile(
                onTap: ()=>NavigatorUtils.navigateToComplaintDetailsScreen(context, complaintController.complaints![index]),
                title: RichText(
                  text: TextSpan(
                    text: complaintController.complaints![index].userName!,
                    style: TextStyle(
                      fontSize: size.height*0.02,
                      color: Colors.grey[800],
                      fontFamily: "ArabFont"
                    ),
                    children:  <TextSpan>[
                      TextSpan(text: ' ',),
                      TextSpan(text: "(${complaintController.complaints![index].type!})",style: TextStyle(fontSize: size.height*0.012,color: kPrimaryColor)),
                    ],
                  ),
                ),
                subtitle: Text(
                  Utils.getDateAndTimeString(
                      complaintController.complaints![index].createAt!.toDate()
                  ),
                  style: TextStyle(
                    fontSize: size.height*0.012,
                    color: Colors.grey[600]
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  iconSize: size.height*0.025,

                  onPressed: (){
                    Utils.showSureAlertDialog(
                        onSubmit: (){
                          complaintController.deleteComplaint(complaintController.complaints![index]);
                        }
                    );
                  },
                ),
              );
            },
          )
              : const WaitingWidget();
        }),
      ),
    );
  }
}
