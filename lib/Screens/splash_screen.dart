import 'dart:async';
import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Models/department.dart';
import 'package:aljunied/Widgets/waiting_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Apis/general_api.dart';
import '../Constants/constants.dart';
import '../Controller/admin_controller.dart';
import '../Controller/user_controller.dart';
import '../Models/current_user.dart';
import '../Models/user_app.dart';
import '../Push_notification/push_notification_serveice.dart';
import '../Utils/navigator_utils.dart';
import '../Utils/res.dart';
import '../Utils/util.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool newUpdate = false;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;


  String? fcmToken;



  @override
  void initState() {
    super.initState();

    startSplashScreenTimer();

  }



  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  startSplashScreenTimer() async {
    var _duration = const Duration(seconds: 2);
    return Timer(_duration, checkAppVersion);
  }

  void checkAppVersion() async {

    if(!kIsWeb) {
      newUpdate = await GeneralApi.checkUpdateForApp();
    }

    if (newUpdate) {
      setState(() {});
    } else {
      checkIfStayLogin();
    }
  }

  Widget _getNewVersionShow() {
    Size size  = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,

        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                ImageHelper.logo,
                width: size.width*0.7,
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  translate(context, "welcomeGreatNewsThereIsANewVersionAvailablePleaseUpdateToTheLatestVersionFromYourStore"),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: size.height*0.02),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 18),
                padding: EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () {
                    LaunchReview.launch();
                  },
                  highlightColor: Colors.red[400],
                  textColor: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0)),
                  padding: EdgeInsets.all(8.0),
                  color: Color(0xffea5c2b),
                  child:  Text(
                    translate(context, "update"),
                    style: TextStyle(fontSize: size.height*0.02, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////





  void checkIfStayLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString("userId");
    if (userId != null && userId != "0") {
        await Utils.fetchUserInformationFromSharedToSingletonClass();

        await updateUserInformation();
        if(!kIsWeb) {
          _messaging.subscribeToTopic(TopicKey.allUsers);
        }

        if(CurrentUser.department!=null){
          if(!kIsWeb) {
          _messaging.subscribeToTopic(TopicKey.employee);
          _messaging.subscribeToTopic(CurrentUser.department!.id!);
        }
        NavigatorUtils.navigateToHomeEmployeeScreen(context);
        }
        else{
          NavigatorUtils.navigateToHomeScreen(context);
        }

    } else {
      NavigatorUtils.navigateToWelcomeScreen(context);
    }
  }
  



   updateUserInformation()  {
    UserApp userApp = UserApp(
      id: CurrentUser.userId,
      name: CurrentUser.userName,
      department: CurrentUser.department,
      email: CurrentUser.email,
      city: CurrentUser.city,
      isAdmin: CurrentUser.isAdmin,
      mobileNumber: CurrentUser.mobileNumber,
      isSuperAdmin:  CurrentUser.isSuperAdmin,

    );


    Provider.of<UserController>(context, listen: false)
        .updateUserInformation(userApp);


  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return kIsWeb&&size.width>520
        ?const CustomScaffoldWeb(
      showHeaderAndBottom: false,
      body: SizedBox(child: WaitingWidget(),),
    )
        : newUpdate
        ? _getNewVersionShow()
        : Scaffold(
            body: Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: AssetImage(
                          "images/splash.png"
                      ),
                    fit: BoxFit.cover
                  ),
                )),
          );
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }
}
