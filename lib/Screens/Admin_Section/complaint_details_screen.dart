import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/complaint_controller.dart';
import 'package:aljunied/Dialogs/answerQuestion.dart';
import 'package:aljunied/Models/complaint.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/reusable_cache_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controller/notification_controller.dart';
import '../../Dialogs/add_edit_bid_type.dart';
import '../../Models/notification.dart';
import '../../Push_notification/push_notification_serveice.dart';
import '../../Widgets/label_with_details.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  final Complaint complaint;
  const ComplaintDetailsScreen({Key? key, required this.complaint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      buttonLabel:complaint.kind==1? translate(context, "answer"):null,
      onPressButton:complaint.kind==1?()=> answerQuestion(context):null,
      title:complaint.kind==1
          ?translate(context, "theQuestion")
          : complaint.kind==2
          ?translate(context, "suggestion")
          : complaint.kind==3
          ?translate(context, "complaint")
          :complaint.kind==4
          ?translate(context, "report")
          :complaint.kind==5
          ?translate(context, "tribute")
          :complaint.kind==6
          ?translate(context, "trashContainer")
          :translate(context, "lighting"),
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
                if(complaint.type!=null)
                  LabelWithDetails(
                  label: translate(context, "complaintType"),
                  details: complaint.type!,
                ),
                LabelWithDetails(
                  onTap: complaint.kind==6||complaint.kind==7
                      ?(){
                    Utils.launchMapUrl(complaint.details);
                  }
                      :null,
                  label:complaint.kind==1
                      ?translate(context, "theQuestion")
                      : complaint.kind==2
                      ?translate(context, "suggestion")
                      : complaint.kind==3
                      ?translate(context, "explanationOfTheComplaint")
                      :complaint.kind==4
                      ?translate(context, "report")
                      :complaint.kind==5
                      ?translate(context, "tribute")
                      :complaint.kind==6
                      ?translate(context, "location")
                      :translate(context, "location"),
                  details: complaint.details!,
                ),
                if(complaint.kind==1&&complaint.answer!=null)
                  LabelWithDetails(
                    label: translate(context, "answer"),
                    details: complaint.answer!,
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
      floatingActionButton:complaint.kind==1? FloatingActionButton(
        onPressed: (){
          answerQuestion(context);
        },
        child:  Icon(
          Icons.question_answer,
          color: Colors.white,
          size: size.height*0.04,
        ),
      ):null,
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title:complaint.kind==1
            ?translate(context, "theQuestion")
            : complaint.kind==2
            ?translate(context, "suggestion")
            : complaint.kind==3
            ?translate(context, "complaint")
            :complaint.kind==4
            ?translate(context, "report")
            :complaint.kind==5
            ?translate(context, "tribute")
            :complaint.kind==6
            ?translate(context, "trashContainer")
            :translate(context, "lighting"),
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
                  if(complaint.type!=null)
                  LabelWithDetails(
                    label: translate(context, "complaintType"),
                    details: complaint.type!,
                  ),
                  LabelWithDetails(
                    onTap: complaint.kind==6||complaint.kind==7
                        ?(){
                      Utils.launchMapUrl(complaint.details);
                    }
                        :null,
                    label:complaint.kind==1
                        ?translate(context, "theQuestion")
                        : complaint.kind==2
                        ?translate(context, "suggestion")
                        : complaint.kind==3
                        ?translate(context, "explanationOfTheComplaint")
                        :complaint.kind==4
                        ?translate(context, "report")
                        :complaint.kind==5
                        ?translate(context, "tribute")
                        :complaint.kind==6
                        ?translate(context, "location")
                        :translate(context, "location"),
                    details: complaint.details!,
                  ),
                  if(complaint.kind==1&&complaint.answer!=null)
                    LabelWithDetails(
                      label: translate(context, "answer"),
                      details: complaint.answer!,
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

  answerQuestion(BuildContext context) async {
    dynamic result = await showDialog(context: context,builder: (_) => const AnswerQuestionDialog());
    if(result is String){
      Utils.showWaitingProgressDialog();
      NotificationModel notificationModel = NotificationModel();
      notificationModel.title = "الإدارة:";
      notificationModel.des = result;
      notificationModel.target = complaint.token;
      complaint.answer = result;
      context.read<ComplaintController>().answerQuestion(complaint);
      await context.read<NotificationController>().insertNewNotification(notificationModel);
      PushNotificationServices.sendMessageToAnyUser(
        title: "الإدارة:",
        body: result,
        to:complaint.token!,
        withLoading: false,
      );
      Utils.hideWaitingProgressDialog();
      Utils.showSuccessAlertDialog(
        translate(context,"sendingSuccessfully"),
          bottom: !kIsWeb||MediaQuery.of(Utils.navKey.currentContext!).size.width<520
      );

    }
  }
}
