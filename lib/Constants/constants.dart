import 'package:flutter/material.dart';

const kTextFormFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(
    16.0,
  ),
  border: OutlineInputBorder(),
  labelText: 'Email',
  hintText: 'Enter your Email',
);

const kSendButtonTextStyle = TextStyle(
  color: kPrimaryColor,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: kPrimaryColor, width: 2.0),
  ),
);
class CollectionsKey {

  static const appInfo = "AppInfo";
  static const transaction = "Transaction";
  static const bid = "Bid";
  static const investment = "Investment";
  static const complaint = "Complaint";
  static const complaintType = "Complaint Type";

  static const headline = "Headline";
  static const bidType = "BidType";
  static const area = "Area";
  static const news = "News";
  static const user = "User";
  static const about = "About";
  static const terms = "Terms";
  static const category = "Category";
  static const city = "City";
  static const department = "Department";
  static const notification = "Notification";
  static const adminInfo = "Admin Info";




}

class TopicKey{
  static const employee = "employee";
  static const citizens = "citizens";

  static const allUsers = "allUsers";
}

class DocumentsKey{
  static const versions = CollectionsKey.appInfo + "/Versions";
}

class ReferenceKey{
  static const winnerRef = "Winner";
}

class Status{
  static const pending = "pending";
  static const accepted = "accepted";
  static const rejected = "rejected";
}

const Color kPrimaryColor = Color(0xff3f51b5);
const Color kSecondaryColor = Color(0xff616161);
const Color kSubTitleColor = Color(0xff757575);
const Color kTertiaryColor = Color(0xffE8E8E8);
const Color kBackgroundColor = Color(0xffffffff);
const Color kTitleColor = Color(0xffFFFFFF);
const Color kSubtitleColor = Color(0xffD6D6D6);
const Color kCardColor = Color(0xff3f51b5);
const Color kDarkThemeColor = Color(0xff283149);
const Color kDialogColor = Color(0xff1f2638);
const Color kWhiteColor = Color(0xffdbedf3);

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

// usage
final lightRed = lighten(Colors.red);
final darkBlue = darken(Colors.blue, .3);