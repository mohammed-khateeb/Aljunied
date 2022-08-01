import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/notification.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/reusable_cache_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationContainer extends StatelessWidget {
  final NotificationModel notification;
  const NotificationContainer({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:kIsWeb&&size.width>520?20: size.width*0.05,
        vertical:kIsWeb&&size.width>520?10: size.height*0.01
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title??"اشعار جديد",
                  style: TextStyle(
                      fontSize:kIsWeb&&size.width>520?16: size.height*0.018,
                      fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  notification.des!,
                  style: TextStyle(
                      fontSize:kIsWeb&&size.width>520?12: size.height*0.013,
                      color: kSubTitleColor
                  ),
                ),
              ],
            ),
          ),
          Text(
            Utils.getDateAndTimeString(notification.createAt!.toDate()),
            style: TextStyle(
                fontSize:kIsWeb&&size.width>520?10: size.height*0.01,
                color: kSubTitleColor
            ),
          ),
        ],
      ),
    );
  }

}
