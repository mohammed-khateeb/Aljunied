import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';
import '../Apis/auth.dart';
import '../Constants/constants.dart';
import '../Controller/user_controller.dart';
import '../Localizations/app_language.dart';
import '../Models/user_app.dart';
import '../Push_notification/push_notification_serveice.dart';
import '../Utils/navigator_utils.dart';
import '../Utils/util.dart';
import '../Widgets/custom_animation_up.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_inkwell.dart';
import '../Widgets/custom_text_field.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController mobileNumberController = TextEditingController();



  final UserApp userApp = UserApp();

  bool showPassword = true;


  @override
  Widget build(BuildContext context) {
    AppLanguage language = Provider.of<AppLanguage>(context);
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      showHeaderAndBottom: false,

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height*0.03,),

              CustomAnimationUp(
                millisecond: 200,
                child: Text(
                  translate(context,"LetsGetIn"),
                  style: const TextStyle(
                    fontSize: 30,
                    fontFamily: "ArabFontSemiBold",
                  ),
                ),
              ),
              SizedBox(height: size.height*0.02,),
              CustomAnimationUp(
                millisecond: 300,
                child: Text(
                  translate(context,"welcomeBackAgain"),
                  style: const TextStyle(
                      fontSize:17,
                      color: kSubTitleColor
                  ),
                ),
              ),
              SizedBox(height: size.height*0.06,),

              CustomAnimationUp(
                millisecond: 400,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                  child: CustomTextField(
                    labelText: translate(context, "mobileNumber"),
                    controller: mobileNumberController,
                    keyboardType: TextInputType.phone,
                    suffixIcon: Image.asset(
                      "icons/call.png",
                      height: size.height*0.001,
                    ),
                    validator: (str){
                      if(str!.isEmpty){
                        return translate(context, "pleaseEnterYourMobileNumber");
                      }
                      return null;
                    },
                  ),
                ),
              ),

              SizedBox(height: size.height*0.2,),
              CustomAnimationUp(
                millisecond: 500,
                direction: Direction.horizontal,
                child: Column(
                  children: [
                    SizedBox(height: size.height*0.06,),
                    CustomButton(
                      label: translate(context, "signIn"),
                      onPress: ()=>login(),

                    ),
                    SizedBox(height: size.height*0.025,),
                    CustomButton(
                      label: translate(context, "loginWithGoogle"),
                      color: Colors.transparent,
                      borderColor: kSubTitleColor,
                      imagePath: "icons/google.png",
                      textColor: Colors.grey[850],
                      onPress:()=> signWithGoogle(),
                    ),
                    SizedBox(height: size.height*0.03,),
                    Center(
                      child: CustomInkwell(
                        onTap: (){
                          NavigatorUtils.navigateToSignupScreen(context);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: translate(context, "dontHaveAnAccount"),
                            style: TextStyle(
                              fontFamily: "ArabFontSemiBold",
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                            children:  <TextSpan>[
                              TextSpan(text: translate(context, "signUp"), style: const TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height*0.01,),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    )
        :Scaffold(
      appBar: CustomAppBar(
        title: translate(context, "signIn"),
        action: Center(
          child: CustomInkwell(
            onTap: ()=>NavigatorUtils.navigateToHomeScreen(context),
            child: Text(
              translate(context,"skip"),
              style: TextStyle(
                fontSize: size.height*0.018,
                color: kSubTitleColor
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: size.height*0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomInkwell(
              onTap: (){
                language.changeLanguage(Locale("en"));
              },
              child: Text(
                "English",
                style: TextStyle(
                    fontSize: size.height*0.02
                ),
              ),
            ),
            SizedBox(width: size.width*0.02,),
            Container(
              height: size.height*0.02,
              width: 1,
              color: Colors.grey[300],
            ),
            SizedBox(width: size.width*0.02,),
            CustomInkwell(
              onTap: (){
                language.changeLanguage(Locale("ar"));
              },
              child: Text(
                "العربية",
                style: TextStyle(
                  fontSize: size.height*0.02
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width*0.05
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height*0.03,),

                CustomAnimationUp(
                  millisecond: 200,
                  child: Text(
                    translate(context,"LetsGetIn"),
                    style: TextStyle(
                      fontSize: size.height*0.03,
                      fontFamily: "ArabFontSemiBold",
                    ),
                  ),
                ),
                SizedBox(height: size.height*0.02,),
                CustomAnimationUp(
                  millisecond: 300,
                  child: Text(
                    translate(context,"welcomeBackAgain"),
                    style: TextStyle(
                        fontSize: size.height*0.017,
                        color: kSubTitleColor
                    ),
                  ),
                ),
                SizedBox(height: size.height*0.06,),

                CustomAnimationUp(
                  millisecond: 400,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                    child: CustomTextField(
                      labelText: translate(context, "mobileNumber"),
                      controller: mobileNumberController,
                      keyboardType: TextInputType.phone,
                      suffixIcon: Image.asset(
                        "icons/call.png",
                        height: size.height*0.001,
                      ),
                      validator: (str){
                        if(str!.isEmpty){
                          return translate(context, "pleaseEnterYourMobileNumber");
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                SizedBox(height: size.height*0.2,),
                CustomAnimationUp(
                  millisecond: 500,
                  direction: Direction.horizontal,
                  child: Column(
                    children: [
                      SizedBox(height: size.height*0.06,),
                      CustomButton(
                        label: translate(context, "signIn"),
                        onPress: ()=>login(),

                      ),
                      SizedBox(height: size.height*0.025,),
                      CustomButton(
                        label: translate(context, "loginWithGoogle"),
                        color: Colors.transparent,
                        borderColor: kSubTitleColor,
                        imagePath: "icons/google.png",
                        textColor: Colors.grey[850],
                        onPress:()=> signWithGoogle(),
                      ),
                      SizedBox(height: size.height*0.03,),
                      Center(
                        child: CustomInkwell(
                          onTap: (){
                            NavigatorUtils.navigateToSignupScreen(context);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: translate(context, "dontHaveAnAccount"),
                              style: TextStyle(
                                fontFamily: "ArabFontSemiBold",
                                fontSize: size.height*0.018,
                                color: Colors.grey[600],
                              ),
                              children:  <TextSpan>[
                                TextSpan(text: translate(context, "signUp"), style: const TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height*0.01,),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      )
    );
  }

  login() async {
    if(!_formKey.currentState!.validate()){
      return;
    }
    Utils.showWaitingProgressDialog();
    UserApp? userApp = await
        context.read<UserController>().getUserFromPhoneNumber(Utils.validPhoneNumber(mobileNumberController.text));
    Utils.hideWaitingProgressDialog();
    if(userApp != null){
      NavigatorUtils.navigateToVerifyPhoneNumberScreen(
        context,userApp: userApp
      );
    }
    else{
      Utils.showErrorAlertDialog(translate(context, "thereIsNoRecordForThisNumber"));
    }
  }


  initUserData(UserApp userApp){
    userApp.token = PushNotificationServices.fcmToken;
    context.read<UserController>().login(userApp: userApp);
    if(!kIsWeb) {
      _messaging.subscribeToTopic(TopicKey.allUsers);
    }
    if(userApp.department!=null&&!kIsWeb) {
      _messaging.subscribeToTopic(TopicKey.employee);
      _messaging.subscribeToTopic(userApp.department!.id!);
    }

  }


  signWithGoogle({bool register = false})async{
    Utils.showWaitingProgressDialog();
    String errorMessage = "";
    await AuthUser.signInWithGoogle(register: register).catchError((errorMsg) {
      errorMessage = errorMsg;
    }).then((userApp) {
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

    if (errorMessage != "") {
      if(translate(context, errorMessage)!="") {
        Utils.showErrorAlertDialog(translate(context,errorMessage));
      }
      else{
        Utils.showErrorAlertDialog(errorMessage);
      }    }
  }



}
