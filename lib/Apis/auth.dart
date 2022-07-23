import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user_app.dart';
import 'general_api.dart';


class AuthUser {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  //create new user email/password

  static Future<UserApp?> signUpByEmailAndPass(
      {required String email,
      required String password,
      required UserApp userApp}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return await GeneralApi.insertNewUser(
          userApp: userApp, uid: userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      //handle auth error
      return Future.error(e.code);

    } catch (e) {
      debugPrint(e.toString());
      return Future.error("Unknown error, please try again later");
    }
  }

  static Future<UserApp?> signInWithGoogle({bool register = false,String? mobileNumber}) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      if(register) {
        if(await GeneralApi.getUserFromUid(userCredential.user!.uid)==null) {
          UserApp userApp = UserApp(
            id: userCredential.user!.uid,
            name: userCredential.user!.displayName,
            email: userCredential.user!.email,
            registerAt: Timestamp.fromDate(DateTime.now()),
            mobileNumber: mobileNumber
          );
          return await GeneralApi.insertNewUser(
              userApp: userApp, uid: userCredential.user!.uid);
        }
        else{
          signOutFromGoogle();
          return Future.error("emailAlreadyInUse");
        }
      }
      else{
        UserApp? user = await GeneralApi.getUserFromUid(userCredential.user!.uid);
        if(user!=null){
          return user;
        }
        else{
          signOutFromGoogle();
          return Future.error("noRecordForThisEmail");
        }

      }

    } on FirebaseAuthException catch (e) {
      return Future.error(e.code);
    }catch(e){
      debugPrint(e.toString());
      return Future.error("Unknown error, please try again later");
    }

  }

  static Future<void> signOutFromGoogle() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }



  static Future forgetPass(String email)async{
    try{
      await _auth.sendPasswordResetEmail(
          email: email);
    }on FirebaseAuthException catch (e) {
      return Future.error(e.code);
    }
  }

  static Future<UserApp?> signUpByPhoneNumber(
      {
        required PhoneAuthCredential phoneAuthCredential,required String phoneNumber,
        required UserApp userApp}) async {
    try {
      UserCredential userCredential = await _auth
          .signInWithCredential(phoneAuthCredential);
      UserApp? phoneUserApp =await GeneralApi.getUserFromPhoneNumber(phoneNumber);
      if(phoneUserApp!=null) {
        return Future.error("هذا الرقم مستخدم");
      } else {
        return await GeneralApi.insertNewUser(
          userApp: userApp, uid: userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      //handle auth error
      if (e.code == "email-already-in-use") {
        return Future.error("This Email is already used");
      } else if (e.code == "invalid-email") {
        return Future.error("Invalid Email");
      } else if (e.code == "weak-password") {
        return Future.error(
            "Password is weak ,password must be at least 8 char");
      } else {
        return Future.error(e.code);
      }
    } catch (e) {
      debugPrint(e.toString());
      if(e.toString()=="invalid-verification-code") {
        return Future.error("خطأ في رمز التحقق");
      } else {
        return Future.error(e.toString());
      }
    }
  }



  //login email/password
  static Future<UserApp?> loginByEmailAndPass(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return await GeneralApi.getUserFromUid(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return Future.error("No record for this email");
      } else {
        return Future.error("Email or password is incorrect");
      }
    }
  }

  static Future<UserApp?> loginByPhoneNumber(PhoneAuthCredential phoneAuthCredential) async {
    try{
      UserCredential userCredential = await _auth.signInWithCredential(phoneAuthCredential);

      return await GeneralApi.getUserFromUid(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        return Future.error("خطأ في رمز التحقق");
      } else {
        return Future.error(e.code);
      }
    } catch (e) {
      debugPrint(e.toString());
      return Future.error("هذا الرقم غير مسجل");
    }

  }

  // static Future<UserApp?> currentUser({bool localy = false}) async {
  //   User? user = _auth.currentUser;
  //   UserApp userApp;// = await getUserFromPref();
  //
  //   if (user == null || userApp == null) return null;
  //
  //   //read from local db if [localy = true]
  //   if (localy) return userApp;
  //
  //   //read from server db if [localy = false]
  //   userApp = await GeneralApi.getUserFromUid(user.uid);
  //
  //   return userApp;
  // }

  static Future logout()async{

    await _googleSignIn.signOut();
    await _auth.signOut();
    await removeUserFromPref();

  }

  static Future resetPassword(String email) async{
    await _auth.sendPasswordResetEmail(email: email);
  }

  // static Future<UserApp> getUserFromPref() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   String? jsonUser = prefs.getString('User_Pref');
  //
  //   if (jsonUser == null) {
  //     User firebaseUser =  FirebaseAuthUtil.getCurrentUser();
  //     if (firebaseUser == null) return null;
  //
  //     UserApp user = await FirebaseAuthUtil.checkIfUserExist(firebaseUser.uid);
  //     storeUserIntoPref(user);
  //
  //     return user;
  //   }
  //
  //   Map userMap = json.decode(jsonUser);
  //
  //   return UserApp.getUserFromSnapshot(userMap);
  // }

 static Future removeUserFromPref() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

   await prefs.remove('User_Pref');
  }



}
