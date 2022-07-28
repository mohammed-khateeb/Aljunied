import 'package:aljunied/Apis/general_api.dart';
import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Screens/verify_phone_number_screen.dart';
import 'package:aljunied/Utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';
import '../Apis/auth.dart';
import '../Constants/constants.dart';
import '../Controller/admin_controller.dart';
import '../Controller/user_controller.dart';
import '../Models/city.dart';
import '../Models/user_app.dart';
import '../Push_notification/push_notification_serveice.dart';
import '../Utils/navigator_utils.dart';
import '../Utils/util.dart';
import '../Widgets/custom_animation_up.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_inkwell.dart';
import '../Widgets/custom_text_field.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final _formKey = GlobalKey<FormState>();
  bool isShopOwner = false;
  City? city;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController nameController = TextEditingController();


  Duration get loginTime => const Duration(milliseconds: 2250);

  final UserApp userApp = UserApp();

  bool showPassword = true;

  @override
  void initState() {
    context.read<AdminController>().getAllCities();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      body:  Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height*0.03,),

            CustomAnimationUp(
              millisecond: 300,
              child: Text(
                translate(context,"welcomeToTheJuniedApp"),
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "ArabFontSemiBold",
                ),
              ),
            ),
            SizedBox(height: size.height*0.01,),
            CustomAnimationUp(
              millisecond: 400,
              child: Text(
                translate(context,"andEnjoyFollowingYourTransactionsWhileYouAreAtHome"),
                style: TextStyle(
                    fontSize: 17,
                    color: kSubTitleColor
                ),
              ),
            ),
            SizedBox(height: size.height*0.06,),
            CustomAnimationUp(
              millisecond: 600,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                child: CustomTextField(
                  labelText: translate(context, "userName"),
                  controller: nameController,
                  suffixIcon: Image.asset(
                    "icons/profile.png",
                    color: Colors.grey[700],

                    height: size.height*0.001,
                  ),
                  validator: (str){
                    if(str!.isEmpty){
                      return translate(context, "pleaseEnterYourName");
                    }
                    return null;
                  },
                ),
              ),
            ),

            CustomAnimationUp(
              millisecond: 700,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                child: CustomTextField(
                  labelText: translate(context, "mobileNumber"),
                  controller: mobileController,
                  keyboardType: TextInputType.number,
                  suffixIcon: Image.asset(
                    "icons/call.png",
                    color: Colors.grey[700],
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
            SizedBox(height: size.height*0.03,),
            CustomAnimationUp(
              millisecond: 800,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: kPrimaryColor,
                        size: size.height*0.025,
                      ),
                      SizedBox(width: size.width*0.03,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            translate(context,"byCreatingAnAccountYouAgreeTo"),
                            style: const TextStyle(
                                fontSize:14,
                                color: kSubTitleColor
                            ),
                          ),
                          CustomInkwell(
                            onTap: ()=>NavigatorUtils.navigateToTermsConditionsScreen(context),
                            child: Text(
                              translate(context,"termsAndConditionsAndPrivacyPolicy"),
                              style: const TextStyle(
                                  fontSize:14,
                                  color: kPrimaryColor
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
              ),
            ),

            SizedBox(height: size.height*0.1,),
            CustomAnimationUp(
              direction: Direction.horizontal,
              millisecond: 900,
              child: Column(
                children: [
                  CustomButton(
                    label: translate(context, "signUp"),
                    onPress: ()=>signUp(),

                  ),
                  SizedBox(height: size.height*0.025,),
                  CustomButton(
                    label: translate(context, "registerWithGoogle"),
                    color: Colors.transparent,
                    borderColor: kSubTitleColor,
                    imagePath: "icons/google.png",
                    textColor: Colors.grey[850],
                    onPress: (){
                      signWithGoogle(register: true);
                    },
                  ),
                  SizedBox(height: size.height*0.02,),
                  Center(
                    child: CustomInkwell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: translate(context, "alreadyHaveAnAccount"),
                          style: TextStyle(
                            fontFamily: "ArabFontSemiBold",
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                          children:  <TextSpan>[
                            TextSpan(text: translate(context, "signIn"), style: const TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height*0.1,),

          ],
        ),
      ),
    )
        :Scaffold(
        appBar: CustomAppBar(
          title: translate(context, "signUp"),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width*0.05
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height*0.03,),

                  CustomAnimationUp(
                    millisecond: 300,
                    child: Text(
                      translate(context,"welcomeToTheJuniedApp"),
                      style: TextStyle(
                        fontSize: size.height*0.03,
                        fontFamily: "ArabFontSemiBold",
                      ),
                    ),
                  ),
                  SizedBox(height: size.height*0.01,),
                  CustomAnimationUp(
                    millisecond: 400,
                    child: Text(
                      translate(context,"andEnjoyFollowingYourTransactionsWhileYouAreAtHome"),
                      style: TextStyle(
                          fontSize: size.height*0.02,
                          color: kSubTitleColor
                      ),
                    ),
                  ),
                  SizedBox(height: size.height*0.06,),
                  CustomAnimationUp(
                    millisecond: 600,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                      child: CustomTextField(
                        labelText: translate(context, "userName"),
                        controller: nameController,
                        suffixIcon: Image.asset(
                          "icons/profile.png",
                          color: Colors.grey[700],

                          height: size.height*0.001,
                        ),
                        validator: (str){
                          if(str!.isEmpty){
                            return translate(context, "pleaseEnterYourName");
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  CustomAnimationUp(
                    millisecond: 700,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                      child: CustomTextField(
                        labelText: translate(context, "mobileNumber"),
                        controller: mobileController,
                        keyboardType: TextInputType.number,
                        suffixIcon: Image.asset(
                          "icons/call.png",
                          color: Colors.grey[700],
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
                  SizedBox(height: size.height*0.03,),
                  CustomAnimationUp(
                    millisecond: 800,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: kPrimaryColor,
                            size: size.height*0.025,
                          ),
                          SizedBox(width: size.width*0.03,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                translate(context,"byCreatingAnAccountYouAgreeTo"),
                                style: TextStyle(
                                  height: size.height*0.0015,
                                    fontSize: size.height*0.015,
                                    color: kSubTitleColor
                                ),
                              ),
                              CustomInkwell(
                                onTap: ()=>NavigatorUtils.navigateToTermsConditionsScreen(context),
                                child: Text(
                                  translate(context,"termsAndConditionsAndPrivacyPolicy"),
                                  style: TextStyle(
                                      height: size.height*0.0015,
                                      fontSize: size.height*0.015,
                                      color: kPrimaryColor
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ),
                  ),

                  SizedBox(height: size.height*0.1,),
                  CustomAnimationUp(
                    direction: Direction.horizontal,
                    millisecond: 900,
                    child: Column(
                      children: [
                        CustomButton(
                          label: translate(context, "signUp"),
                          onPress: ()=>signUp(),

                        ),
                        SizedBox(height: size.height*0.025,),
                        CustomButton(
                          label: translate(context, "registerWithGoogle"),
                          color: Colors.transparent,
                          borderColor: kSubTitleColor,
                          imagePath: "icons/google.png",
                          textColor: Colors.grey[850],
                          onPress: (){
                            signWithGoogle(register: true);
                          },
                        ),
                        SizedBox(height: size.height*0.02,),
                        Center(
                          child: CustomInkwell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: RichText(
                              text: TextSpan(
                                text: translate(context, "alreadyHaveAnAccount"),
                                style: TextStyle(
                                  fontFamily: "ArabFontSemiBold",
                                  fontSize: size.height*0.018,
                                  color: Colors.grey[600],
                                ),
                                children:  <TextSpan>[
                                  TextSpan(text: translate(context, "signIn"), style: const TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height*0.1,),

                ],
              ),
            ),
          ),
        )
    );
  }

  signUp() async {
    if(!_formKey.currentState!.validate())return;
    Utils.showWaitingProgressDialog();
    UserApp? phoneUserApp =await context.read<UserController>()
        .getUserFromPhoneNumber(Utils.validPhoneNumber(mobileController.text));
    Utils.hideWaitingProgressDialog();
    if(phoneUserApp!=null){
      Utils.showErrorAlertDialog(translate(context, "thisNumberIsAlreadyRegistered"));
      return;
    }
    NavigatorUtils.navigateToVerifyPhoneNumberScreen(
        context,
      phoneNumber: Utils.validPhoneNumber(mobileController.text),
      fullName: nameController.text,
    );
  }

  signWithGoogle({bool register = false})async{
    if(!_formKey.currentState!.validate())return;

    Utils.showWaitingProgressDialog();
    String errorMessage = "";
    await AuthUser.signInWithGoogle(register: register,mobileNumber: Utils.validPhoneNumber(mobileController.text)).catchError((errorMsg) {
      errorMessage = errorMsg;
    }).then((userApp) {
      Utils.hideWaitingProgressDialog();
      if (userApp != null) {
        initUserData(userApp);
        NavigatorUtils.navigateToHomeScreen(context);
      }
    });

    if (errorMessage != "") {
      if(translate(context, errorMessage)!="") {
        Utils.showErrorAlertDialog(translate(context,errorMessage));
      }
      else{
        Utils.showErrorAlertDialog(errorMessage);
      }
    }
  }



  initUserData(UserApp userApp){
    userApp.token = PushNotificationServices.fcmToken;
    context.read<UserController>().login(userApp: userApp,isRegister: true);
    _messaging.subscribeToTopic(TopicKey.allUsers);
    if(userApp.department!=null) {
      _messaging.subscribeToTopic(TopicKey.employee);
      _messaging.subscribeToTopic(userApp.department!.id!);
    }
  }



}
