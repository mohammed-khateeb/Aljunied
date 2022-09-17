import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constants/constants.dart';
import '../../Controller/transaction_controller.dart';
import '../../Utils/navigator_utils.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_text_field.dart';

class WebHeader extends StatefulWidget {
  const WebHeader({Key? key}) : super(key: key);

  @override
  State<WebHeader> createState() => _WebHeaderState();
}

class _WebHeaderState extends State<WebHeader> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: 550,
      width: size.width,

      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 550,
                constraints: BoxConstraints(
                    maxWidth: size.width*0.5
                ),
                decoration: const BoxDecoration(
                    color:Colors.blue,

                    image: DecorationImage(
                        image: AssetImage(
                          "images/home_web.png",
                        ),
                        fit: BoxFit.cover
                    )
                ),

              ),
            ],
          ),

          Container(
            height: 550,
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
                colors: [
                  kPrimaryColor,
                  kPrimaryColor,
                  kPrimaryColor.withOpacity(0.5),
                ],
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "images/up_path.png",
                    width: size.width*0.25,
                    //height: size.height*0.27,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        "images/white_down_path_web.png",
                        width: size.width*0.25,

                        //height: size.height*0.27,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 15
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 100,
                runSpacing: 15,
                children: [
                  SizedBox(
                    width: 700,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(Localizations.localeOf(context).languageCode=="en"?"Junaid Municipality":"بلدية الجنيد",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            )
                        ),
                        Text("لوريم إيبسوم هو ببساطة نص شكلي يستخدم في صناعة الطباعة والتنضيد. كان هو النص الوهميالقياسيغير معروفة لوحًا من النوع وتدافعت عليه لعمل كتاب عينة. لقد صمد ليس فقط لخمسةقرون ، ولكن أيضًا القفزة في التنضيد الإلكتروني ، وظل دون تغيير جوهري. تم نشره في الستينيات منالقرن الماضيمع إصدار أوراق التي تحتوي على مقاط ، ومؤخرًا مع برامج النشر المكتب",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white
                            )
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate(context, "orderStatusTracking"),
                            style: const TextStyle(
                                fontSize: 20,
                                fontFamily: "ArabFontBold",
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            translate(context, "enterTheReferenceNumberToTrackTheStatusOfTheOrder"),
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 10,),
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
                              SizedBox(width: 10,),
                              CustomButton(
                                height: 50,
                                width: 75,
                                label: translate(context, "tracking"),
                                onPress: (){
                                  if(controller.text.isEmpty)return;
                                  Utils.showWaitingProgressDialog();
                                  context.read<TransactionController>().resetTransactionDetails().then((value) {
                                    context.read<TransactionController>().getTransactionById(controller.text).then((value){
                                      Utils.hideWaitingProgressDialog();
                                      if(context.read<TransactionController>().transaction!=null){
                                        //_messaging.subscribeToTopic(controller.text);
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
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
