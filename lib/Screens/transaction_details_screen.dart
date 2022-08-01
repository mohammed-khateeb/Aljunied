import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/transaction_controller.dart';
import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Models/transaction.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../Utils/navigator_utils.dart';
import '../Utils/util.dart';
import '../Widgets/custom_app_bar.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: context.watch<TransactionController>().transaction!.citizenName,
      body: Column(
        children: [
          Image.asset(
            "images/man.png",
            height: 120,

            fit: BoxFit.cover,
          ),
          SizedBox(height: 15,),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.height*0.02),
            ),
            elevation: 6,
            shadowColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:15,vertical: 10),
              child: SizedBox(
                height: 80,
                child: Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: size.width,),
                          Text(
                            "${context.watch<TransactionController>().transaction!.duration} ${context.watch<TransactionController>().transaction!.isDay == true?translate(context, "days"):translate(context,"hours")}",
                            style: TextStyle(
                                fontSize: 18,
                                height: size.height*0.0015,
                                fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,

                          ),
                          Text(
                            translate(context, "estimatedTime"),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: size.width,),
                          Text(
                            context.watch<TransactionController>().transaction!.currentStage!,
                            style: TextStyle(
                                fontSize: 18,
                                height: size.height*0.0015,
                                fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          Text(
                            translate(context, "currentStage"),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),


          Container(
            width: size.width,
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate(context, "typeOfTransaction"),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "ArabFontBold",
                        ),
                      ),
                      CustomInkwell(
                        onTap: (){
                          NavigatorUtils.navigateToTransactionTrackingDetails(context,context.read<TransactionController>().transaction!);
                        },
                        child: Text(
                          translate(context, "tracking"),
                          style: TextStyle(
                            fontSize: 15,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Card(
                    elevation: 6,
                    shadowColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: size.width,),
                          Text(
                            context.watch<TransactionController>().transaction!.type!,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            translate(context, "typeOfTransaction"),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  if(context.watch<TransactionController>().transaction!.subType!=null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate(context, "typeTransaction")+" "+(Localizations.localeOf(context).languageCode=="ar"?"ال":"")+context.watch<TransactionController>().transaction!.type!,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "ArabFontBold",
                          ),
                        ),
                        SizedBox(height: 10,),
                        Card(
                          elevation: 6,
                          shadowColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: size.width,),
                                Text(
                                  context.watch<TransactionController>().transaction!.subType!,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  translate(context, "typeTransaction")
                                      +" "+(Localizations.localeOf(context).languageCode=="ar"?"ال":"")
                                      +context.watch<TransactionController>().transaction!.type!,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20,),
                  if(context.watch<TransactionController>().transaction!.additionInfo!=null
                      &&context.watch<TransactionController>().transaction!.additionInfo!="")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate(context, "anotherAddition"),
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "ArabFontBold",
                          ),
                        ),
                        SizedBox(height: 10,),
                        Card(
                          elevation: 6,
                          shadowColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: size.width,),
                                Text(
                                  context.watch<TransactionController>().transaction!.additionInfo!,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),


                      ],
                    ),


                ],
              ),
            ),
          ),
          context.read<TransactionController>().transaction!=null&&context.read<TransactionController>().transaction!.completed==true
          ?Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.height*0.02),
            ),
            elevation: 6,
            shadowColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15
              ),
              child: Text(
                translate(context, "theTransactionIsComplete"),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                    fontSize: 18
                ),
              ),
            ),
          )

          :CurrentUser.department!=null||CurrentUser.isAdmin==true?Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: CustomButton(
                  width: 130,
                    label: translate(context, "edit"),
                    onPress: ()=>NavigatorUtils.navigateToCreateEditATransactionScreen(context,transaction: context.read<TransactionController>().transaction,)
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CustomButton(
                    width: 130,
                    borderWidth: 2.5,
                    borderColor: kPrimaryColor,
                    textColor: kPrimaryColor,
                    color: Colors.white,
                    label: translate(context, "sendNotification"),
                    onPress: (){
                      NavigatorUtils.navigateToSendNotificationScreen(context,referenceNumber:context.read<TransactionController>().transaction!.id );
                    },
                  )
              ),
            ],
          ):const SizedBox()
        ],
      ),
    )
        :Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:context.read<TransactionController>().transaction!=null&&context.read<TransactionController>().transaction!.completed==true
          ?Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.height*0.02),
        ),
        elevation: 6,
        shadowColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height*0.01,
                horizontal: size.width*0.01
              ),
              child: Text(
        translate(context, "theTransactionIsComplete"),
        style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.green,
              fontSize: size.height*0.028
        ),
      ),
            ),
          )
          :CurrentUser.department!=null||CurrentUser.isAdmin==true? Row(
            children: [

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.03),
                  child: CustomButton(
        label: translate(context, "edit"),
        onPress: ()=>NavigatorUtils.navigateToCreateEditATransactionScreen(context,transaction: context.read<TransactionController>().transaction,)
      ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.03),
                  child: CustomButton(
                    width: size.width*0.35,
                    borderWidth: 2.5,
                    borderColor: kPrimaryColor,
                    textColor: kPrimaryColor,
                    color: Colors.white,
                    label: translate(context, "sendNotification"),
                    onPress: (){
                      NavigatorUtils.navigateToSendNotificationScreen(context,referenceNumber:context.read<TransactionController>().transaction!.id );
                    },
                  )
              ),
            ],
          ):null,
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: context.watch<TransactionController>().transaction!.citizenName,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: size.height*0.2,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height*0.14,
                      child: Image.asset(
                        "images/man.png",
                        fit: BoxFit.cover,
                      ),
                    ),

                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: size.width,
                  margin: EdgeInsets.only(top: size.height*0.02),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width*0.05,
                      vertical: size.height*0.03
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height*0.05,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate(context, "typeOfTransaction"),
                                style: TextStyle(
                                    fontSize: size.height*0.025,
                                    fontFamily: "ArabFontBold",
                                ),
                              ),
                              CustomInkwell(
                                onTap: (){
                                  NavigatorUtils.navigateToTransactionTrackingDetails(context,context.read<TransactionController>().transaction!);
                                },
                                child: Text(
                                  translate(context, "tracking"),
                                  style: TextStyle(
                                    fontSize: size.height*0.022,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height*0.015,),
                          Card(
                            elevation: 6,
                            shadowColor: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(size.height*0.01),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: size.width,),
                                  Text(
                                    context.watch<TransactionController>().transaction!.type!,
                                    style: TextStyle(
                                        fontSize: size.height*0.02,
                                    ),
                                  ),
                                  Text(
                                    translate(context, "typeOfTransaction"),
                                    style: TextStyle(
                                      fontSize: size.height*0.017,
                                      color: Colors.grey
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: size.height*0.03,),
                          if(context.watch<TransactionController>().transaction!.subType!=null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translate(context, "typeTransaction")+" "+(Localizations.localeOf(context).languageCode=="ar"?"ال":"")+context.watch<TransactionController>().transaction!.type!,
                                style: TextStyle(
                                  fontSize: size.height*0.025,
                                  fontFamily: "ArabFontBold",
                                ),
                              ),
                              SizedBox(height: size.height*0.015,),
                              Card(
                                elevation: 6,
                                shadowColor: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(size.height*0.01),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: size.width,),
                                      Text(
                                        context.watch<TransactionController>().transaction!.subType!,
                                        style: TextStyle(
                                          fontSize: size.height*0.02,
                                        ),
                                      ),
                                      Text(
                                        translate(context, "typeTransaction")
                                            +" "+(Localizations.localeOf(context).languageCode=="ar"?"ال":"")
                                            +context.watch<TransactionController>().transaction!.type!,
                                        style: TextStyle(
                                            fontSize: size.height*0.017,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height*0.03,),
                          if(context.watch<TransactionController>().transaction!.additionInfo!=null
                          &&context.watch<TransactionController>().transaction!.additionInfo!="")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translate(context, "anotherAddition"),
                                style: TextStyle(
                                  fontSize: size.height*0.025,
                                  fontFamily: "ArabFontBold",
                                ),
                              ),
                              SizedBox(height: size.height*0.015,),
                              Card(
                                elevation: 6,
                                shadowColor: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(size.height*0.01),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: size.width,),
                                      Text(
                                        context.watch<TransactionController>().transaction!.additionInfo!,
                                        style: TextStyle(
                                          fontSize: size.height*0.02,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height*0.06,),


                            ],
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: size.width*0.03,
              right: size.width*0.03,
              top: size.height*0.16
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.height*0.02),
              ),
              elevation: 6,
              shadowColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:size.width*0.01,vertical: size.height*0.01),
                child: SizedBox(
                  height: size.height*0.1,
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width*0.3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: size.width,),
                            Text(
                              "${context.watch<TransactionController>().transaction!.duration} ${context.watch<TransactionController>().transaction!.isDay == true?translate(context, "days"):translate(context,"hours")}",
                              style: TextStyle(
                                fontSize: size.height*0.02,
                                  height: size.height*0.0015,
                                  fontWeight: FontWeight.w600
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,

                            ),
                            Text(
                              translate(context, "estimatedTime"),
                              style: TextStyle(
                                  fontSize: size.height*0.015,
                                  color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: size.width,),
                            Text(
                              context.watch<TransactionController>().transaction!.currentStage!,
                              style: TextStyle(
                                fontSize: size.height*0.02,
                                height: size.height*0.0015,
                                fontWeight: FontWeight.w600
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                            Text(
                              translate(context, "currentStage"),
                              style: TextStyle(
                                  fontSize: size.height*0.015,
                                  color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
