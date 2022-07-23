import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controller/transaction_controller.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_text_field.dart';

class TrackingWidget extends StatefulWidget {
  const TrackingWidget({Key? key}) : super(key: key);

  @override
  State<TrackingWidget> createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends State<TrackingWidget> {
  TextEditingController controller = TextEditingController();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(context, "enterTheReferenceNumberToTrackTheStatusOfTheOrder"),
          style: TextStyle(
              fontSize: size.height*0.02,
              fontFamily: "ArabFontBold",
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: size.height*0.01,),
        Row(
          children: [
            Expanded(
                child: CustomTextField(
                  digitsOnly: true,
                  charLength: 6,
                  controller: controller,
                  keyboardType: TextInputType.number,
                  hintText: translate(context, "referenceNumber"),
                )),
            SizedBox(width: size.width*0.05,),
            CustomButton(
              width: Localizations.localeOf(context).languageCode=="en"?size.width*0.22:size.width*0.14,
              height: size.height*0.055,
              label: translate(context, "tracking"),
              onPress: (){
                if(controller.text.isEmpty)return;
                Utils.showWaitingProgressDialog();
                context.read<TransactionController>().resetTransactionDetails().then((value) {
                  context.read<TransactionController>().getTransactionById(controller.text).then((value){
                    Utils.hideWaitingProgressDialog();
                    if(context.read<TransactionController>().transaction!=null){
                      _messaging.subscribeToTopic(controller.text);
                      NavigatorUtils.navigateToTransactionDetailsScreen(context);
                    }
                    else{
                      Utils.showErrorAlertDialog(
                          translate(context, "sorryNotMatchWithOurTransactions")
                      );
                    }
                  });
                });

              },
            )
          ],
        ),
      ],
    );
  }
}
