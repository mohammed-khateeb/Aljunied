import 'package:flutter/cupertino.dart';

class Extension<T>{

  static String getObjectName({required BuildContext context, required String name}){
    List<String> names = name.split(",");
    for (var element in names) {
      if(Localizations.localeOf(context).languageCode=="en"&&element.contains('"en"')){
        List<String> nameEn = element.split(":");
        return nameEn[1].replaceAll('"', "").replaceAll("{", "").replaceAll("}", "");
      }
      else if(element.contains('"ar"')){
        List<String> nameAr = element.split(":");
        return nameAr[1].replaceAll('"', "").replaceAll("{", "").replaceAll("}", "");
      }

    }
    return "";

  }


}


extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}



extension CompareTwoCountDown on String {
  bool isFirstThan(String other) {
    if(int.parse(split(":").first)<int.parse(other.split(":").first)){
      return true;
    }
    else if(int.parse(split(":").first) == int.parse(other.split(":").first)){
      if(int.parse(split(".").first.split(":").last)<int.parse(other.split(".").first.split(":").last)){
        return true;
      }
      else if(int.parse(split(".").first.split(":").last) == int.parse(other.split(".").first.split(":").last)){
        if(int.parse(split(".").last)<int.parse(other.split(".").last)){
          return true;
        }
      }
    }
    return false;
  }
}

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == day &&
        now.month == month &&
        now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}

extension Utility on BuildContext {
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (FocusScope.of(this).focusedChild!.context == null);
  }
}