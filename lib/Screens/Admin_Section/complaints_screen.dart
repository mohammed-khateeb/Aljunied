import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Components/news_container.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/bid_controller.dart';
import 'package:aljunied/Controller/complaint_controller.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/bid_container.dart';
import '../../Controller/admin_controller.dart';
import '../../Widgets/waiting_widget.dart';

class ComplaintsScreen extends StatefulWidget {
  final int kind;
  const ComplaintsScreen({Key? key, required this.kind}) : super(key: key);

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      context.read<ComplaintController>().resetWaiting().then((value) {
        context.read<ComplaintController>().getComplaints(kind: widget.kind);
      });

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title:widget.kind==1
          ?translate(context, "questions")
          : widget.kind==2
          ?translate(context, "suggestions")
          : widget.kind==3
          ?translate(context, "complaints")
          :widget.kind==4
          ?translate(context, "reports")
          :widget.kind==5
          ?translate(context, "tributes")
          :widget.kind==6
          ?translate(context, "trashContainerRequests")
          :translate(context, "lightingRequests"),
      body: Consumer<ComplaintController>(
          builder: (context, complaintController, child) {
            return !complaintController.waiting
                ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10),
              itemCount: complaintController.complaints!.length,
              itemBuilder: (_, index) {
                return ListTile(
                  onTap: ()=>NavigatorUtils.navigateToComplaintDetailsScreen(context, complaintController.complaints![index]),
                  title: RichText(
                    text: TextSpan(
                      text: complaintController.complaints![index].userName!,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontFamily: "ArabFont"
                      ),
                      children:  <TextSpan>[
                        TextSpan(text: ' ',),
                        if(complaintController.complaints![index].answer!=null)
                          TextSpan(text: "(${translate(context, "answered")})",style: TextStyle(fontSize: 12,color: Colors.green)),
                        if(complaintController.complaints![index].type!=null)
                        TextSpan(text: "(${complaintController.complaints![index].type!})",style: TextStyle(fontSize: 12,color: kPrimaryColor)),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    Utils.getDateAndTimeString(
                        complaintController.complaints![index].createAt!.toDate()
                    ),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600]
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    iconSize: 25,

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
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title:widget.kind==1
            ?translate(context, "questions")
            : widget.kind==2
            ?translate(context, "suggestions")
            : widget.kind==3
            ?translate(context, "complaints")
            :widget.kind==4
            ?translate(context, "reports")
            :widget.kind==5
            ?translate(context, "tributes")
            :widget.kind==6
            ?translate(context, "trashContainerRequests")
            :translate(context, "lightingRequests"),
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
                      if(complaintController.complaints![index].answer!=null)
                      TextSpan(text: "(${translate(context, "answered")})",style: TextStyle(fontSize: size.height*0.012,color: Colors.green)),

                      if(complaintController.complaints![index].type!=null)
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
