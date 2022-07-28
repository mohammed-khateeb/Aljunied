import 'dart:developer';

import 'package:aljunied/Apis/general_api.dart';
import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Models/user_app.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:aljunied/Widgets/waiting_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../Constants/constants.dart';
import '../Controller/user_controller.dart';
import '../Push_notification/push_notification_serveice.dart';
import '../Utils/navigator_utils.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';
  final UserApp? userApp;
  final String? phoneNumber;
  final String? fullName;

  const VerifyPhoneNumberScreen({
    Key? key,
    this.phoneNumber, this.fullName, this.userApp,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String _code="";
  final UserApp userApp = UserApp();



  @override
  void initState() {
    if(!kIsWeb) {
      listenOtp();
    }
   // WidgetsBinding.instance.addObserver(this);
    super.initState();
  }



  listenOtp(){
    SmsAutoFill().listenForCode;

  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    if(!kIsWeb) {
      SmsAutoFill().unregisterListener();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber:widget.userApp!=null?widget.userApp!.mobileNumber!: widget.phoneNumber!,
        onLoginSuccess: (userCredential, autoVerified) async {
          Utils.hideWaitingProgressDialog();

          if(widget.userApp==null){
            signUpPhoneNumber(userCredential.user?.uid);
          }
          else{
            signInPhoneNumber(userCredential.user?.uid);
          }
          log(
            VerifyPhoneNumberScreen.id,
            name: autoVerified
                ? 'OTP was fetched automatically!'
                : 'OTP was verified manually!',
          );
          log(
            VerifyPhoneNumberScreen.id,
            name: 'Login Success UID: ${userCredential.user?.uid}',
          );
          },
        onLoginFailed: (authException) {
          Utils.hideWaitingProgressDialog();
          if(authException.message!=null&&authException.message!.toLowerCase().contains(
            "create the phone auth credential is invalid"
          )){
            Utils.showErrorAlertDialog(
              translate(context, "theEnteredCodeIsIncorrectTryAgain")
            );

          }
          else if(authException.message!=null&&authException.message!.toLowerCase().contains(
            "the format of the phone number provided is incorrect"
          ))
          {
            Utils.showErrorAlertDialog(
                translate(context, "theFormatOfThePhoneNumberProvidedIsIncorrect")
            );
          }
          else{
            Utils.showErrorAlertDialog(authException.message??translate(context, "somethingWentWrong"));
          }

          // handle error further if needed
        },
        builder: (context, controller) {
          return Scaffold(
            body: controller.codeSent?VerifyOTPScreen(
              controller: controller,
              phoneNumber: widget.userApp!=null?widget.userApp!.mobileNumber!: widget.phoneNumber!,
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                WaitingWidget(),
                SizedBox(height: MediaQuery.of(context).size.height*0.04),
                Center(
                  child: Text(
                    translate(context, "sendingOTP"),
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.022),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  signUpPhoneNumber(String? uid) async {
    Utils.showWaitingProgressDialog();
    userApp.mobileNumber = widget.phoneNumber;
    userApp.name = widget.fullName;
    userApp.registerAt = Timestamp.fromDate(DateTime.now());

      await GeneralApi.insertNewUser(
        uid: uid!, userApp: userApp).then((userApp) {
      Utils.hideWaitingProgressDialog();
      if (userApp != null) {
        initUserData(userApp);
        if(userApp.department!=null){
          NavigatorUtils.navigateToHomeEmployeeScreen(context);
        }
        else{
          NavigatorUtils.navigateToHomeScreen(context);

        }
      }
    });



  }

  signInPhoneNumber(String? uid) async {
      initUserData(widget.userApp!);
      if(widget.userApp!.department!=null){
        NavigatorUtils.navigateToHomeEmployeeScreen(context);
      }
      else{
        NavigatorUtils.navigateToHomeScreen(context);

      }


  }

  initUserData(UserApp userApp){
    userApp.token = PushNotificationServices.fcmToken;
    context.read<UserController>().login(userApp: userApp,isRegister: widget.userApp==null);
    if(!kIsWeb) {
      _messaging.subscribeToTopic(TopicKey.allUsers);
    }
    if(userApp.department!=null&&!kIsWeb) {
      _messaging.subscribeToTopic(TopicKey.employee);
      _messaging.subscribeToTopic(userApp.department!.id!);
    }

  }
}





class VerifyOTPScreen extends StatefulWidget {
  final dynamic controller;
  final String phoneNumber;
  const VerifyOTPScreen({Key? key, this.controller, required this.phoneNumber}) : super(key: key);

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> with CodeAutoFill {
  String codeValue = "";

  @override
  void codeUpdated() {
    print("Update code $code");
    setState(() {
      print("codeUpdated");
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: size.height*0.03,),

          Text(
            translate(context,"phoneVerification"),
            style: TextStyle(
              fontSize: 30,
              fontFamily: "ArabFontSemiBold",
            ),
          ),
          SizedBox(height: size.height*0.02,),
          Text(
            translate(context,"enterTheCodeSentToYourPhone"),
            style: TextStyle(
                fontSize: 15,
                color: kSubTitleColor
            ),
          ),
          SizedBox(height: size.height*0.01,),
          Text(
            widget.phoneNumber,
            style: TextStyle(
                fontSize: 14,
                color: kSubTitleColor
            ),
          ),
          SizedBox(height: size.height*0.06,),
          Center(
            child: PinFieldAutoFill(
              currentCode: codeValue,
              codeLength: 6,
              cursor: Cursor(height: size.height*0.03,color: kPrimaryColor,width: 1,enabled: true),
              onCodeChanged: (code) {
                setState(() {
                  codeValue = code.toString();
                });
              },
              onCodeSubmitted: (val) {
              },

              decoration:  UnderlineDecoration(
                bgColorBuilder: FixedColorBuilder(Colors.grey[300]!),

                textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                colorBuilder: FixedColorBuilder(Colors.grey[300]!,),),
            ),
          ),
          SizedBox(height: size.height*0.05,),

          TextButton(
            child: Text(
              widget.controller.timerIsActive
                  ?translate(context, "resendCodeAt") + '${widget.controller.timerCount.inSeconds}s'
                  : translate(context, "resend"),
              style: const TextStyle(color: kPrimaryColor,fontWeight: FontWeight.normal, fontSize: 16,),
            ),
            onPressed: widget.controller.timerIsActive
                ? null
                : () async {
              log(VerifyPhoneNumberScreen.id, name: 'Resend OTP');
              await widget.controller.sendOTP();
            },
          ),
          SizedBox(height: size.height*0.015,),
          CustomButton(label: translate(context,"verify"), onPress: () async {
            if(codeValue.length!=6)return;
            Utils.showWaitingProgressDialog();
            await widget.controller.verifyOTP(
              otp: codeValue,
            );
          }),

        ],
      ),
    )
        :Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: size.height*0.03,),

          Text(
            translate(context,"phoneVerification"),
            style: TextStyle(
              fontSize: size.height*0.03,
              fontFamily: "ArabFontSemiBold",
            ),
          ),
          SizedBox(height: size.height*0.02,),
          Text(
            translate(context,"enterTheCodeSentToYourPhone"),
            style: TextStyle(
                fontSize: size.height*0.017,
                color: kSubTitleColor
            ),
          ),
          SizedBox(height: size.height*0.01,),
          Text(
            widget.phoneNumber,
            style: TextStyle(
                fontSize: size.height*0.017,
                color: kSubTitleColor
            ),
          ),
          SizedBox(height: size.height*0.06,),
          Center(
            child: PinFieldAutoFill(
              currentCode: codeValue,
              codeLength: 6,
              cursor: Cursor(height: size.height*0.03,color: kPrimaryColor,width: 1,enabled: true),
              onCodeChanged: (code) {
                setState(() {
                  codeValue = code.toString();
                });
              },
              onCodeSubmitted: (val) {
              },

              decoration:  UnderlineDecoration(
                bgColorBuilder: FixedColorBuilder(Colors.grey[300]!),

                textStyle: TextStyle(
                    fontSize: size.height*0.023,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                colorBuilder: FixedColorBuilder(Colors.grey[300]!,),),
            ),
          ),
          SizedBox(height: size.height*0.05,),

          TextButton(
            child: Text(
              widget.controller.timerIsActive
                  ?translate(context, "resendCodeAt") + '${widget.controller.timerCount.inSeconds}s'
                  : translate(context, "resend"),
              style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.normal, fontSize: size.height*0.018,),
            ),
            onPressed: widget.controller.timerIsActive
                ? null
                : () async {
              log(VerifyPhoneNumberScreen.id, name: 'Resend OTP');
              await widget.controller.sendOTP();
            },
          ),
          SizedBox(height: size.height*0.015,),
          CustomButton(label: translate(context,"verify"), onPress: () async {
            if(codeValue.length!=6)return;
            Utils.showWaitingProgressDialog();
              await widget.controller.verifyOTP(
                otp: codeValue,
              );
          }),

        ],
      ),
    );
  }


}


