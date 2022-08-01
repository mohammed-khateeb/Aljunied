import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../Constants/constants.dart';
import '../Models/current_user.dart';
import '../Models/department.dart';
import '../Models/user_app.dart';

class GeneralApi{

  static FirebaseFirestore db = FirebaseFirestore.instance;

  //TODO update number of version when push new release to store
  static const int androidVersion = 1, iosVersion = 1;

  static Future<UserApp?> getUserFromUid(String uid,{bool saveLocal = true}) async {
    DocumentSnapshot documentSnapshot =
    await db.collection(CollectionsKey.user).doc(uid).get();

    if(documentSnapshot.exists) {
      UserApp? userApp = UserApp.fromJson(documentSnapshot.data() as Map<String,dynamic>);
      return userApp;
    }
    return null;



  }

  static Future<Timestamp> getLastUpdateOfAllowedNotification({required String userId}) async {
    DocumentSnapshot userDoc = await db.collection(CollectionsKey.user).doc(userId).get();

    return userDoc.get("lastUpdateOfAllowedNotifications");
  }


  static Future<void> updateUserAllowedNotification({required String userId,int? allowedNotificationNumber}) async {
    DocumentReference userDoc = db.collection(CollectionsKey.user).doc(userId);

    userDoc.update({
      "allowedNotificationNumber":allowedNotificationNumber??3,
      "lastUpdateOfAllowedNotifications":Timestamp.fromDate(DateTime(
          DateTime.now().year,DateTime.now().month,
          DateTime.now().day,0
      ))
    });
  }

  static void reduceAllowedNotification(
      String userId)  {
    DocumentReference userDoc =
    db.collection(CollectionsKey.user).doc(userId);

    userDoc.update({
      "allowedNotificationNumber": FieldValue.increment(-1)
    });

    return ;
  }


  static Future<int> getAllowedNotificationNumberFromUserId({required String userId}) async {
    DocumentSnapshot userDoc = await db.collection(CollectionsKey.user).doc(userId).get();

    return userDoc.get("allowedNotificationNumber");
  }

  static void settingProfile(
      UserApp userApp)  {
    DocumentReference userDoc =
    db.collection(CollectionsKey.user).doc(userApp.id);

    userDoc.update({
      "name": userApp.name,
      "city": userApp.city!.toJson(),
      "mobileNumber": userApp.mobileNumber,
    });

    return ;
  }

  static void updateUserShopName(
      String shopName)  {
    DocumentReference userDoc =
    db.collection(CollectionsKey.user).doc(CurrentUser.userId);

    userDoc.update({
      "shopName": shopName,
    });

    return ;
  }

  static void updateUserInterests(
      List<String> userInterests)  {
    DocumentReference userDoc =
    db.collection(CollectionsKey.user).doc(CurrentUser.userId);

    userDoc.update({
      "interests": userInterests,
    });

  }

  static Future deleteUser(String userId) async {
    DocumentReference userDoc =
    db.collection(CollectionsKey.user).doc(userId);

    await userDoc.delete();

  }

  static void addToken(
      UserApp userApp)  {
    DocumentReference userDoc =
    db.collection(CollectionsKey.user).doc(userApp.id);

    userDoc.update({
      "token": userApp.token,
    });

    return ;
  }


  static Future<UserApp?> getUserFromEmail(String email) async {
    QuerySnapshot querySnapshot = await db
        .collection(CollectionsKey.user)
        .where("email", isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      UserApp userApp =
      UserApp.fromJson(querySnapshot.docs.first.data() as Map<String,dynamic>);
      return userApp;
    }
    return null;
  }


  static Future<UserApp?> getUserFromPhoneNumber(String phoneNumber) async {
    QuerySnapshot querySnapshot = await db
        .collection(CollectionsKey.user)
        .where("mobileNumber", isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      UserApp userApp =
      UserApp.fromJson(querySnapshot.docs.first.data() as Map<String,dynamic>);
      return userApp;
    }
    return null;
  }

  static Future<void> userToAdmin(String userId,{bool toAdmin = true})  async {
    DocumentReference userDoc =
    db.collection(CollectionsKey.user).doc(userId);

    userDoc.update({
      "isAdmin": toAdmin,
    });

  }

  static updateRoomOwnerWalletValue(String ownerId,double value)  async {
    DocumentReference userDoc =
    db.collection(CollectionsKey.user).doc(ownerId);

    userDoc.update({
      "walletValue": FieldValue.increment(value),
    });

  }

  static Future<double?> getUserWalletValue(String userId)async{
    DocumentReference userDoc =
    db.collection(CollectionsKey.user).doc(userId);

    double? walletValue;
    await userDoc.get().then((snapshot) {
      try{
        walletValue = snapshot.get("walletValue");
      }catch(_){}

    });
    return walletValue;
  }

  
  
  


  static Future<UserApp?> insertNewUser(
      {required UserApp userApp, required String uid}) async {
      userApp.id = uid;
      await db.collection(CollectionsKey.user).doc(uid).set(userApp.toJson());


      return userApp;

  }



  //used for check if exist update for app on store
  static Future<bool> checkUpdateForApp() async {
    DocumentSnapshot versionsDoc = await db.doc(DocumentsKey.versions).get();

    if (Platform.isAndroid) {
      return (versionsDoc.get("androidUser") ?? double.infinity) >
          androidVersion;
    } else if (Platform.isIOS) {
      return (versionsDoc.get("iosUser") ?? double.infinity) > iosVersion;
    } else {
      return true;
    }
  }


  static Future<bool> checkIfBlocked(String userId) async {
    DocumentSnapshot documentSnapshot = await db.collection(CollectionsKey.user)
        .doc(userId).get();

      return documentSnapshot.get("blocked")??false;
  }




  static Future<String> getTokenFromUserId({required String userId}) async {
    DocumentSnapshot userDoc = await db.collection(CollectionsKey.user).doc(userId).get();

    return userDoc.get("token");
  }

  static Future <dynamic> saveOneImage(
      {File? file,required String folderPath,Uint8List? pictureWeb}) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String? url;
    if(kIsWeb){
      Reference _reference = FirebaseStorage.instance
          .ref()
          .child(folderPath).child(fileName);
      await _reference
          .putData(
        pictureWeb!,
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) {
          url = value;
        });
      });
      return url;
    }
    else{
      Reference reference =
      FirebaseStorage.instance.ref().child(folderPath).child(fileName);
      TaskSnapshot uploadTask = await reference.putFile(file!);
      String url = await uploadTask.ref.getDownloadURL();
      return url;
    }

  }
  static Future<dynamic> deleteFileByUrl({required String url}) async {
    return (FirebaseStorage.instance.refFromURL(url)).delete();
  }



}

