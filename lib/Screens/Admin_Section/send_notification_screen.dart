import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Controller/notification_controller.dart';
import 'package:aljunied/Models/notification.dart';
import 'package:aljunied/Push_notification/push_notification_serveice.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:aljunied/Widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constants/constants.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_app_bar.dart';

class SendNotificationScreen extends StatefulWidget {
  final String? referenceNumber;
  const SendNotificationScreen({Key? key, this.referenceNumber}) : super(key: key);

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? topic;

  TextEditingController desController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  bool custom = false;



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "sendNotification"),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            if(widget.referenceNumber==null)
              CustomTextField(
                labelText: translate(context, "theTargetGroupOfTheNotice"),
                controller: groupController,
                readOnly: true,
                withValidation: true,
                onChanged: (str){
                  if(str == "Custom"||str == "مخصص"){
                    setState(() {
                      custom = true;
                      topic = null;
                    });
                  }
                  else{
                    setState(() {
                      custom = false;
                      if(str == "All"||str == "الكل"){
                        topic = TopicKey.allUsers;
                      }
                      else if(str == "Citizens"||str == "المواطنين") {
                        topic = TopicKey.citizens;
                      }
                      else{
                        topic = TopicKey.employee;
                      }
                    });
                  }
                },
                dropList: [
                  translate(context, "all"),
                  translate(context, "employees"),
                  translate(context, "citizens"),
                  translate(context, "custom")
                ],
              ),
            if(custom)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height*0.02,
                  ),
                  CustomTextField(
                    labelText: translate(context, "referenceNumber"),
                    controller: referenceController,
                    charLength: 6,
                    digitsOnly: true,
                    keyboardType: TextInputType.number,

                    withValidation: true,
                  ),
                ],
              ),
            SizedBox(
              height: size.height*0.02,
            ),
            CustomTextField(
              labelText: translate(context, "title"),
              controller: titleController,
            ),
            SizedBox(
              height: size.height*0.02,
            ),
            CustomTextField(
              labelText: translate(context, "noticeText"),
              controller: desController,
              minLines:4,
              keyboardType: TextInputType.multiline,
              withValidation: true,

            ),
            SizedBox(
              height:custom?kIsWeb?25:size.height*0.21:kIsWeb?70: size.height*0.33,
            ),
            CustomButton(
              label: translate(context, "send"),
              onPress: (){sendNotification();},
            )
          ],
        ),
      ),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "sendNotification"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width*0.03,
              vertical: size.height*0.04
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if(widget.referenceNumber==null)
                  CustomTextField(
                    labelText: translate(context, "theTargetGroupOfTheNotice"),
                    controller: groupController,
                    readOnly: true,
                    withValidation: true,
                    onChanged: (str){
                      if(str == "Custom"||str == "مخصص"){
                        setState(() {
                          custom = true;
                          topic = null;
                        });
                      }
                      else{
                        setState(() {
                          custom = false;
                          if(str == "All"||str == "الكل"){
                            topic = TopicKey.allUsers;
                          }
                          else if(str == "Citizens"||str == "المواطنين") {
                            topic = TopicKey.citizens;
                          }
                          else{
                            topic = TopicKey.employee;
                          }
                        });
                      }
                    },
                    dropList: [
                      translate(context, "all"),
                      translate(context, "employees"),
                      translate(context, "citizens"),
                      translate(context, "custom")
                    ],
                  ),
                  if(custom)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height*0.02,
                      ),
                      CustomTextField(
                        labelText: translate(context, "referenceNumber"),
                        controller: referenceController,
                        charLength: 6,
                        digitsOnly: true,
                        keyboardType: TextInputType.number,

                        withValidation: true,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height*0.02,
                  ),
                  CustomTextField(
                    labelText: translate(context, "title"),
                    controller: titleController,
                  ),
                  SizedBox(
                    height: size.height*0.02,
                  ),
                  CustomTextField(
                    labelText: translate(context, "noticeText"),
                    controller: desController,
                    minLines:4,
                    keyboardType: TextInputType.multiline,
                    withValidation: true,

                  ),
                  SizedBox(
                    height:custom?size.height*0.21: size.height*0.33,
                  ),
                  CustomButton(
                    label: translate(context, "send"),
                    onPress: (){sendNotification();},
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  sendNotification() async {
    if(!_formKey.currentState!.validate())return;
    NotificationModel notificationModel = NotificationModel();
    notificationModel.title = titleController.text;
    notificationModel.des = desController.text;
    notificationModel.target = widget.referenceNumber ?? (custom?referenceController.text:topic!);
    if(widget.referenceNumber==null&&!custom){
      Utils.showWaitingProgressDialog();
      await context.read<NotificationController>().insertNewNotification(notificationModel);
      Utils.hideWaitingProgressDialog();
    }
    PushNotificationServices.sendMessageToTopic(
      title: titleController.text,
      body: desController.text,
      topicName:widget.referenceNumber?? topic??referenceController.text,
      withLoading: true,
      fromAdmin: true,
    );
  }
}
