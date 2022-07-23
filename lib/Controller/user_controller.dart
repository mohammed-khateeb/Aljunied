import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Apis/auth.dart';
import '../Apis/general_api.dart';
import '../Models/user_app.dart';
import '../Utils/util.dart';
import 'admin_controller.dart';

class UserController with ChangeNotifier{
  UserApp? userApp;
  int userNumbers = 0;

  login({required UserApp userApp,bool isRegister = false}) async {

      updateUserInformation(userApp);

      // if(isRegister){
      //   updateUserNumber();
      // }

      GeneralApi.addToken(userApp);

      Utils.initCurrentUser(userApp);

  }


  Future<UserApp?> getUserFromPhoneNumber(String phoneNumber)async{
    UserApp? userApp = await GeneralApi.getUserFromPhoneNumber(phoneNumber);
    return userApp;
  }


  Future forgetPassword(String email)async{
    await AuthUser.forgetPass(email).catchError((errorMsg){
      return Future.error(errorMsg);
    });
  }





  Future<bool> checkIfBlocked(String userId)async{
    return await GeneralApi.checkIfBlocked(userId);
  }


  updateProfile({required UserApp userApp}){
    GeneralApi.settingProfile(userApp);
    updateUserInformation(userApp);
    Utils.initCurrentUser(userApp);
}


  logout(){
    AuthUser.logout();
    Utils.logout();

  }


  updateUserInformation(UserApp? userApp) {
    this.userApp = userApp;
    notifyListeners();
  }


  Future<Timestamp> getLastUpdateAllowedNotification(String userId) async {
    Timestamp timestamp = await GeneralApi.getLastUpdateOfAllowedNotification(userId: userId);
    return timestamp;

  }



}