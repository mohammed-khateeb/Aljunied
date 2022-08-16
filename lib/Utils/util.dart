
import 'dart:convert';
import 'package:aljunied/Models/department.dart';
import 'package:aljunied/Utils/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/constants.dart';
import '../Localizations/app_localization.dart';
import '../Models/current_user.dart';
import '../Models/user_app.dart';
import '../Push_notification/push_notification_serveice.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_inkwell.dart';
import '../Widgets/custom_text_field.dart';
import 'package:timezone/timezone.dart';
import 'package:intl/intl.dart';



class Utils{

  static final navKey = GlobalKey<NavigatorState>();

  static SharedPreferences? preferences;


  static final SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(
      context: navKey.currentState!.overlay!.context, barrierDimisable: false);

  static initCurrentUser(UserApp userApp) async {
    CurrentUser.userId = userApp.id;
    CurrentUser.userName = userApp.name;
    CurrentUser.email = userApp.email;
    CurrentUser.city = userApp.city;
    CurrentUser.isSuperAdmin = userApp.isSuperAdmin;
    CurrentUser.isAdmin = userApp.isAdmin;
    CurrentUser.token = userApp.token;
    CurrentUser.mobileNumber = userApp.mobileNumber;
    CurrentUser.department = userApp.department;
    print(CurrentUser.department);

    fetchUserInformationToShared();
  }


  static Future<void> fetchUserInformationToShared() async {
    preferences = await SharedPreferences.getInstance();
    preferences!.setString("userId", CurrentUser.userId!);
    preferences!.setString("userName", CurrentUser.userName!);
    preferences!.setString("mobileNumber", CurrentUser.mobileNumber??"");
    preferences!.setString(
        "email", CurrentUser.email == null ? "" : CurrentUser.email!);

    preferences!.setBool("isSuperAdmin",
        CurrentUser.isSuperAdmin == null ? false : CurrentUser.isSuperAdmin!);
    preferences!.setString(
        "token", CurrentUser.token == null ? "" : CurrentUser.token!);
    preferences!.setBool("isAdmin",
        CurrentUser.isAdmin == null ? false : CurrentUser.isAdmin!);

    preferences!.setString("department",
        CurrentUser.department == null ? "" : json.encode(CurrentUser.department!));

    await preferences!.commit();
  }

  static Future<void> fetchUserInformationFromSharedToSingletonClass() async {
    preferences = await SharedPreferences.getInstance();

    String? userId = preferences!.getString("userId");
    String? userName = preferences!.getString("userName");
    String? email = preferences!.getString("email");
    String? mobileNumber = preferences!.getString("mobileNumber");
    bool? isSuperAdmin = preferences!.getBool("isSuperAdmin");
    //City? city = City.fromJson(jsonDecode(preferences!.getString("city")!));
    String? token = preferences!.getString("token");
    bool? isAdmin = preferences!.getBool("isAdmin");
    Department? department;
    if(preferences!.getString("department")!=null&&preferences!.getString("department")!="") {
       department = Department.fromJson(jsonDecode(preferences!.getString("department")!));
    }

    CurrentUser.userId = userId;
    CurrentUser.userName = userName;
    CurrentUser.email = email;
    //CurrentUser.city = city;
    CurrentUser.isSuperAdmin = isSuperAdmin;
    CurrentUser.isAdmin = isAdmin;
    CurrentUser.token = token;
    CurrentUser.mobileNumber = mobileNumber;
    CurrentUser.department = department;
  }






  static Future<void> logout() async {

    FirebaseMessaging fcm = FirebaseMessaging.instance;
    if(!kIsWeb) {
      fcm.unsubscribeFromTopic(TopicKey.allUsers);
      fcm.unsubscribeFromTopic(TopicKey.citizens);
      fcm.unsubscribeFromTopic(TopicKey.employee);
      if (CurrentUser.department != null) {
        fcm.unsubscribeFromTopic(CurrentUser.department!.id!);
      }
    }

    SharedPreferences preferences;

    preferences = await SharedPreferences.getInstance();

    preferences.setString("userId", "0");
    preferences.clear();

    CurrentUser.userId = null;
    CurrentUser.userName = null;
    CurrentUser.email = null;
    CurrentUser.city = null;
    CurrentUser.mobileNumber = null;
    CurrentUser.isSuperAdmin = null;
    CurrentUser.isAdmin = null;
    CurrentUser.token = null;
    CurrentUser.department = null;


  }

  static String validPhoneNumber(String phoneNumber){
    String? validPhone;
    if(phoneNumber.contains("00962")) {
      validPhone = phoneNumber.replaceAll("00962", "+962");
    }
    else if(!phoneNumber.contains("00962")
        &&!phoneNumber.contains("+962")&&phoneNumber.contains("07")){
      validPhone = phoneNumber.replaceFirst("07", "+9627");
    }
    else{
      validPhone = phoneNumber;
    }
    if(validPhone.contains("+96207")){
      validPhone = validPhone.replaceFirst("+96207", "+9627");
    }

    return validPhone;
  }

  static int getJordanHour() {
    var istanbulTimeZone = getLocation('Asia/Amman');
    var now = TZDateTime.now(istanbulTimeZone);
    return now.hour;
  }

  static int getJordanDay() {
    var jordanTimeZone = getLocation('Asia/Amman');
    var now = TZDateTime.now(jordanTimeZone);
    return now.day;
  }

  static Timestamp getSaudiDateTime(DateTime time) {
    var saudiTimeZone = getLocation('Asia/Riyadh');
    var timeZone = TZDateTime.from(time, saudiTimeZone);
    return Timestamp.fromDate(DateTime(timeZone.year,timeZone.month,timeZone.day,timeZone.hour,timeZone.minute,timeZone.second));
  }

  static String getOnlyDateNow(){
    var jordanTimeZone = getLocation('Asia/Amman');
    var now = TZDateTime.now(jordanTimeZone);
    return DateFormat('yyyy-MM-dd').format(now);
  }

  static String getDateString(DateTime dateTime){
    var jordanTimeZone = getLocation('Asia/Amman');
    var date = TZDateTime.from(dateTime, jordanTimeZone);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // static String getDateAndTimeString(DateTime dateTime){
  //   var jordanTimeZone = getLocation('Asia/Amman');
  //   var date = TZDateTime.from(dateTime, jordanTimeZone);
  //   return DateFormat('dd MMM, HH:mm a').format(date);
  // }

  static String getDateAndTimeString(DateTime dateTime){

    var jordanTimeZone = getLocation('Asia/Amman');
    var date = TZDateTime.from(dateTime, jordanTimeZone);
    return DateFormat('EEEE d MMMM, hh:mm a',Localizations.localeOf(navKey.currentContext!).languageCode).format(date);
  }

  static Timestamp getJordanDateNow(){
    var jordanTimeZone = getLocation('Asia/Amman');//Asia/Amman
    var timeZone = TZDateTime.now(jordanTimeZone);
    return Timestamp.fromDate(DateTime(timeZone.year,timeZone.month,timeZone.day,timeZone.hour,timeZone.minute,timeZone.second));
  }

  static showWaitingProgressDialog() {
    _dialog.show(message: translate(navKey.currentState!.context, "please_wait"),indicatorColor: kPrimaryColor,backgroundColor: Colors.transparent);
  }

  static hideWaitingProgressDialog() {
    _dialog.hide();
  }

  static showCustomDialog(Widget dialogWidget){
    showDialog(
      context: navKey.currentState!.context,
      barrierColor: Colors.transparent,
      builder: (context) => dialogWidget,
    );
  }

  static showSuccessAlertDialog(String msg,{String? imagePath,String? label,Widget? details,Color? color,Widget? action,Function? onTap,bool bottom = false}) {
    Size size = MediaQuery.of(navKey.currentContext!).size;
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.zero,
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kIsWeb&&size.width>520?25:size.height*0.03),
          bottom: Radius.circular(bottom?0:kIsWeb&&size.width>520?25:size.height*0.03),
        ),
      ),
      title: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              CircleAvatar(
                child: Icon(
                  FontAwesomeIcons.check,
                  size: kIsWeb&&size.width>520?50:size.height*0.06,
                  color: kPrimaryColor,
                ),
                backgroundColor:color?? Color(0xff64c962),
                radius: kIsWeb&&size.width>520?40:size.height*0.05,
              ),
            ],
          ),
        ],
      ),
      content: Container(
        width: kIsWeb&&size.width>520?300:null,
        margin: const EdgeInsetsDirectional.only(bottom: 0),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label??translate(navKey.currentState!.context, 'success'),
                  style:  TextStyle(fontWeight: FontWeight.w600, fontSize: kIsWeb&&size.width>520?17:size.height*0.022),
                ),
                SizedBox(height: kIsWeb&&size.width>520?10:size.height*0.01),
                Center(
                  child: Text(
                    msg,
                    style: TextStyle(fontSize: kIsWeb&&size.width>520?15:size.height*0.018,color: kSubTitleColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: kIsWeb&&size.width>520?10:size.height*0.01,
                ),
                details??const SizedBox(),
                SizedBox(
                  height: kIsWeb&&size.width>520?10:size.height*0.01,
                ),
                action?? CustomButton(

                  onPress: () {
                    Navigator.of(navKey.currentState!.context,
                        rootNavigator: true)
                        .pop('dialog');
                    if(onTap!=null) {
                      onTap();
                    }
                  },
                  label: translate(navKey.currentState!.context, "ok"),
                ),
                SizedBox(
                  height: kIsWeb&&size.width>520?10:size.height*0.01,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: navKey.currentState!.context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return bottom?Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            alert,
          ],
        ):alert;
      },
    );
  }




  static showToast(String msg,double fontSize){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[500],
        textColor: Colors.white,
        fontSize: fontSize
    );
  }


  static String getStringPlace(int place){
    return "${place}st";
  }

  static makeCall(String phone) {
    launch("tel://$phone");
  }

  static launchMapUrl(_urlString) async {
    String _url = 'http'+_urlString.toString().split("http").last;
    if (!await launch(
      _url,
      forceSafariVC: false,
      forceWebView: false,)) throw 'Could not launch $_url';
  }

  static launchUrl(urlString) async {
    String url;
    if(!urlString.toString().contains("http")){
      url = 'https://$urlString';

    }else{
      url = urlString;

    }
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,)) throw 'Could not launch $url';
  }

  static showSureAlertDialog({required Function onSubmit,String? msg}){
    Size size = MediaQuery.of(navKey.currentState!.context).size;
    AlertDialog alert = AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kIsWeb?5:20.0),
      ),
      title: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  const [
              CircleAvatar(
                backgroundColor: kCardColor,
                radius: 55,
                child: Icon(
                  Icons.info_outline,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
      content: Container(
        margin: EdgeInsetsDirectional.only(bottom: 0),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                SizedBox(
                  width:kIsWeb&&size.width>520?300:
                  size.width *
                      0.9,
                  child: Center(
                    child: Text(
                      msg!=null
                          ?translate(navKey.currentState!.context, "areYouSure")+"\n"+msg
                          :translate(navKey.currentState!.context, "areYouSure"),
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 23,
                ),
                SizedBox(
                  width:kIsWeb&&size.width>520?300:
                  size.width *
                      0.6,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomInkwell(
                        onTap: () {
                          Navigator.of(navKey.currentState!.context,
                              rootNavigator: true)
                              .pop('dialog');
                          onSubmit();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: kCardColor,
                            borderRadius: BorderRadius.circular(50.0)
                          ),

                          child: Padding(
                            padding:  EdgeInsets.symmetric(
                                horizontal:kIsWeb&&size.width>520
                                    ?15
                                    : MediaQuery.of(navKey.currentState!.context).size.width *
                                    0.02
                            ),
                            child: Text(
                                translate(navKey.currentState!.context, "ok"),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
                          ),
                        ),
                      ),
                      CustomInkwell(
                        onTap: () {
                          Navigator.of(navKey.currentState!.context,
                              rootNavigator: true)
                              .pop('dialog');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: kCardColor,
                              borderRadius: BorderRadius.circular(50.0)
                          ),

                          child: Padding(
                            padding:  EdgeInsets.symmetric(
                                horizontal:kIsWeb&&size.width>520
                                    ?15
                                    : MediaQuery.of(navKey.currentState!.context).size.width *
                                    0.02
                            ),
                            child: Text(
                                translate(navKey.currentState!.context, "cancel"),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: navKey.currentState!.context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  static Future showErrorAlertDialog(String msg,{bool goToNextScreen = false,Function? whenNavBack}) async{
    Size size = MediaQuery.of(navKey.currentState!.context).size;
    AlertDialog alert = AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(
                child: Icon(
                  Icons.close,
                  size: 80,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
                radius: 55,
              ),
            ],
          ),
        ],
      ),
      content: Container(
        margin: const EdgeInsetsDirectional.only(bottom: 0),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  translate(navKey.currentState!.context, 'error'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  width:kIsWeb&&size.width>520
                      ?300
                      : MediaQuery.of(navKey.currentState!.context).size.width *
                      0.60,
                  child: Center(
                    child: Text(
                      msg,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const  SizedBox(
                  height: 23,
                ),
                SizedBox(
                  width:kIsWeb&&size.width>520
                      ?300
                      : size.width *
                      0.45,
                  height: 40,
                  child: CustomInkwell(
                    onTap: () {
                      Navigator.of(navKey.currentState!.context,
                          rootNavigator: true)
                          .pop('dialog');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: kCardColor,
                          borderRadius: BorderRadius.circular(50.0)
                      ),

                      child: Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal:kIsWeb&&size.width>520
                                ?15
                                : MediaQuery.of(navKey.currentState!.context).size.width *
                                0.02
                        ),
                        child: Text(
                            translate(navKey.currentState!.context, "ok"),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: navKey.currentState!.context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  static Future showInfoAlertDialog(String msg,) async{
    AlertDialog alert = AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(
                child: Icon(
                  Icons.info,
                  size: 80,
                  color: Colors.white,
                ),
                backgroundColor: Color(0xff5DADE2),
                radius: 55,
              ),
            ],
          ),
        ],
      ),
      content: Container(
        margin: const EdgeInsetsDirectional.only(bottom: 0),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                SizedBox(
                  width:
                  MediaQuery.of(navKey.currentState!.context).size.width *
                      0.60,
                  child: Center(
                    child: Text(
                      msg,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const  SizedBox(
                  height: 23,
                ),
                SizedBox(
                  width:
                  MediaQuery.of(navKey.currentState!.context).size.width *
                      0.45,
                  height: 40,
                  child: CustomInkwell(
                    onTap: () {
                      Navigator.of(navKey.currentState!.context,
                          rootNavigator: true)
                          .pop('dialog');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: kCardColor,
                          borderRadius: BorderRadius.circular(50.0)
                      ),

                      child: Padding(
                        padding:  EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(navKey.currentState!.context).size.width *
                              0.02
                        ),
                        child: Text(
                            translate(navKey.currentState!.context, "ok"),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: navKey.currentState!.context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);

  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? true;
  }
}

String getStringFromEnum(Object value) =>
    value
        .toString()
        .split('.')
        .last;

T enumValueFromString<T>(String key, List<T> values) =>
    values.firstWhere((v) => key == getStringFromEnum(v!));


Future<dynamic> openNewPage(BuildContext context, Widget widget,
    {bool popPreviousPages = false,bool replacement = false}) {
  if(replacement){
    return Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>  widget,
      ),
    );
  }
  else {
    if (!popPreviousPages) {
      return Navigator.push(context,PageTransition(type: PageTransitionType.fade, child: widget));
    } else {
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => widget),
              (Route<dynamic> route) => false);
    }
  }
}
void showSnackBar(
    BuildContext context, String title, String desc, String type) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: type == "warning" ? Colors.amber : Colors.redAccent,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          desc,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        )
      ],
    ),
    action: SnackBarAction(
      label: translate(context,'ok'),
      onPressed: () {
        // Some code to undo the change.
      },
      textColor: Colors.white,
      disabledTextColor: Colors.grey,
    ),
  ));
}




// void openGoogleMap(double lat, double lng) async {
//   var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
//   if (await canLaunch(uri.toString())) {
//     await launch(uri.toString());
//   } else {
//     throw 'Could not launch ${uri.toString()}';
//   }
// }

String translate(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key)!;
}



// bool notValidPathFirebase(String path) {
//   //Firebase Database paths must not contain '.', '#', '$', '[', or ']'
//   return path.contains('.') ||
//       path.contains('#') ||
//       path.contains('\$') ||
//       path.contains('[') ||
//       path.contains(']');
// }
//
// Color colorFromHex(String hexColor) {
//   return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
// }
//
// /// the current time, in “seconds since the epoch”
// int currentTimeInSeconds() {
//   var ms = (new DateTime.now()).millisecondsSinceEpoch;
//   return (ms / 1000).round();
// }
//
Widget getCenterCircularProgress({double padding = 0, required double size}) {
  return Container(
    padding: EdgeInsets.all(padding),
    height: size,
    width: size,
    child: const Center(
      child: CircularProgressIndicator(backgroundColor: kPrimaryColor,),
    ),
  );
}

String getTimeFromTimestamp(int timestamp,BuildContext context) {
  final navKey = GlobalKey<NavigatorState>();
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time =
        "${date.isToday() ?  translate(context,"todayAt") : translate(context,"yesterdayAt")} " + format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + translate(context,"dayAgo");
    } else {
      time = translate(context,"before")+ diff.inDays.toString() + translate(context,"daysAgo");
    }
  } else if (diff.inDays > 7 && diff.inDays < 100) {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + translate(context,"weekAgo");
    } else {
      time =  translate(context,"before") +  (diff.inDays / 7).floor().toString() + translate(context,"weeksAgo");
    }
  } else {
    var formatY = DateFormat('dd/MM/yyyy HH:mm a');
    time = formatY.format(date);
  }

  return time;
}

String getStringFromDateTime({required DateTime time}){
  return "${time.year}-${time.month}-${time.day}";
}

// int getDiffInDay(DateTime date) {
//   return date.difference(DateTime.now()).inDays;
// }
//
String formatDate(DateTime date, {DateFormat? formatter}) {
  formatter ??= DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(date);

  return formatted;
}
//
// Map<String, dynamic> listToIndexMap(List<dynamic> list) {
//   Map<String, dynamic> map = Map();
//
//   for (int i = 0; i < list.length; i++) map["$i"] = list[i];
//
//   return map;
// }
//
// void showSnackBar(GlobalKey<ScaffoldState> scaffoldKey,String title,{bool isError = false}){
//   scaffoldKey?.currentState?.showSnackBar( SnackBar(content: new Text(title),backgroundColor: isError ? Colors.red[900] : null,));
// }