import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Controller/notification_controller.dart';
import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Widgets/waiting_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/constants.dart';
import '../Utils/util.dart';
import '../Widgets/custom_app_bar.dart';
import '../Components/notification_container.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  @override
  void initState() {
    context.read<NotificationController>().getNotifications(
      CurrentUser.department!=null
          ?[CurrentUser.department!.id!,TopicKey.employee,TopicKey.allUsers]
          :[TopicKey.allUsers],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "notifications"),
      body: Consumer<NotificationController>(
          builder: (context, notificationController, child) {
            return !notificationController.waitingNotification? ListView.builder(
              itemCount: notificationController.notifications!.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 20),
              itemBuilder: (_,index){
                return NotificationContainer(notification: notificationController.notifications![index],);
              },
            ):const WaitingWidget();
          }
      ),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "notifications"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child: Consumer<NotificationController>(
            builder: (context, notificationController, child) {
            return !notificationController.waitingNotification? ListView.builder(
              itemCount: notificationController.notifications!.length,
              padding: EdgeInsets.symmetric(vertical: size.height*0.02),
              itemBuilder: (_,index){
                return NotificationContainer(notification: notificationController.notifications![index],);
              },
            ):const WaitingWidget();
          }
        ),
      ),
    );
  }
}
