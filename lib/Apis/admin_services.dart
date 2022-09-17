import 'package:aljunied/Models/bid.dart';
import 'package:aljunied/Models/department.dart';
import 'package:aljunied/Models/member.dart';
import 'package:aljunied/Models/terms_conditions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Constants/constants.dart';
import '../Models/about.dart';
import '../Models/admin_info.dart';
import '../Models/category.dart';
import '../Models/city.dart';
import '../Models/complaint.dart';
import '../Models/current_user.dart';
import '../Models/notification.dart';
import '../Models/user_app.dart';

class AdminApi{

  static FirebaseFirestore db = FirebaseFirestore.instance;


  static Future<List<UserApp>> getAllUsersForAdmin() async {
    List<UserApp> users = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.user)
        .where("isAdmin",isEqualTo: false)
        .orderBy('registerAt', descending: true)
        .get();

    users = snapshot.docs.map((e) => UserApp.fromJson(e.data() as Map<String, dynamic>)).toList() ;
    return users;
  }

  static void appointmentAsAnEmployee({required String employeeId,Department? department}){
    DocumentReference employeeDoc =
    db.collection(CollectionsKey.user).doc(employeeId);

    employeeDoc.update({
      "department":department?.toJson(),
    });
  }

  static void appointmentAsAdmin({required bool toAdmin,required String userId}){
    DocumentReference employeeDoc =
    db.collection(CollectionsKey.user).doc(userId);

    employeeDoc.update({
      "isAdmin":toAdmin,
    });
  }

  static Future<List<UserApp>> getEmployees() async {
    List<UserApp> users = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.user)
        .orderBy('registerAt', descending: true)
        .get();

    users = snapshot.docs.map((e) => UserApp.fromJson(e.data() as Map<String, dynamic>)).toList().where((element) => element.department !=null).toList();
    return users;
  }

  static Future<List<UserApp>> getUsers() async {
    List<UserApp> users = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.user)
        .orderBy('registerAt', descending: true)
        .get();

    users = snapshot.docs.map((e) => UserApp.fromJson(e.data() as Map<String, dynamic>)).toList().where((element) => element.department ==null).toList();
    return users;
  }

  static Future<List<NotificationModel>> getAllNotificationsForAdmin() async {
    List<NotificationModel> notifications = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.notification)
        .orderBy('createAt', descending: true)
        .get();

    notifications = snapshot.docs.map((e) => NotificationModel.fromJson(e.data() as Map<String, dynamic>)).toList() ;
    return notifications;
  }


  static saveAbout(String aboutEn,String aboutAr,String phone,String email) {
    DocumentReference aboutDoc =
    db.collection(CollectionsKey.about).doc(CollectionsKey.about);

    aboutDoc.update({
      "aboutEn": aboutEn,
      "aboutAr": aboutAr,
      "email": email,
      "phone": phone,
    });
  }

  static saveTermsConditions(String terms) {
    DocumentReference aboutDoc =
    db.collection(CollectionsKey.terms).doc(CollectionsKey.terms);

    aboutDoc.update({
      "terms": terms,
    });
  }

  static updateAllowNotificationsNumber(int notificationsNumber) {
    DocumentReference aboutDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    aboutDoc.update({
      "allowedNotificationNumber": notificationsNumber,
    });
  }

  static Future<About?> getAbout() async {
    About about;
    DocumentSnapshot aboutDoc =
    await db.collection(CollectionsKey.about).doc(CollectionsKey.about).get();
    try{
      about = About.fromJson(aboutDoc.data() as Map<String,dynamic>);
    }
    catch(_){
      return null;
    }

    return about;
  }

  static Future<TermsCondition?> getTermsCoditions() async {
    TermsCondition termsCondition;
    DocumentSnapshot termsConditionDoc =
    await db.collection(CollectionsKey.terms).doc(CollectionsKey.terms).get();
    try{
      termsCondition = TermsCondition.fromJson(termsConditionDoc.data() as Map<String,dynamic>);
    }
    catch(_){
      return null;
    }

    return termsCondition;
  }

  static Future<List<UserApp>> getNewUsersForAdmin() async {
    List<UserApp> users = [];

    QuerySnapshot snapshot = await db
        .collection(CollectionsKey.user)
        .orderBy("registerAt",descending: true)
        .limit(6)
        .get();

    users = snapshot.docs.map((e) => UserApp.fromJson(e.data() as Map<String, dynamic>)).toList();

    users.removeWhere((element) => element.id==CurrentUser.userId);

    return users;
  }


  static Future addNewCategory(
      {required Category category}) async {
    try {
      DocumentReference reference = db.collection(CollectionsKey.category).doc();

      category.id = reference.id;

      await reference.set(category.toJson());

    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future addNewMember(
      {required Member member}) async {
    try {
      DocumentReference reference = db.collection(CollectionsKey.member).doc();

      member.id = reference.id;

      await reference.set(member.toJson());

    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }


  static Future addNewCity(
      {required City city}) async {
    try {
      DocumentReference reference = db.collection(CollectionsKey.city).doc();

      city.id = reference.id;

      await reference.set(city.toJson());

    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }


  static void editCategory(
      Category category)  {
    DocumentReference categoryDoc =
    db.collection(CollectionsKey.category).doc(category.id);

    categoryDoc.update({
      "nameAr": category.nameAr,
      "imageUrl": category.imageUrl,
      "subcategories": category.subcategories!=null? category.subcategories!.map((v) => v.toJson()).toList():null
    });

    return ;
  }

  static void editCity(
      City city)  {
    DocumentReference categoryDoc =
    db.collection(CollectionsKey.city).doc(city.id);


    categoryDoc.update(city.toJson());

    return ;
  }


  static Future<List<UserApp>?> getLastTwoUsers()async{
    List<UserApp>? users  = [];
    QuerySnapshot snapshot = await db.collection(CollectionsKey.user)
        .where("blocked",isEqualTo: false)
        .orderBy("registerAt",descending: true).limit(2).get();

    users = snapshot.docs.map((e) => UserApp.fromJson(e.data() as Map<String, dynamic>)).toList();
    users.removeWhere((element) => element.id == CurrentUser.userId);

    return users;
  }



  static Future getAllCategories()async{
    List<Category>? categories  = [];
    QuerySnapshot snapshot = await db.collection(CollectionsKey.category).get();

    categories = snapshot.docs.map((e) => Category.fromJson(e.data() as Map<String, dynamic>)).toList();
    return categories;
  }

  static Future getAllMembers()async{
    List<Member>? members  = [];
    QuerySnapshot snapshot = await db.collection(CollectionsKey.member).get();

    members = snapshot.docs.map((e) => Member.fromJson(e.data() as Map<String, dynamic>)).toList();
    return members;
  }


  static Future getBoss()async{
    List<Member>? members  = [];
    QuerySnapshot snapshot = await db.collection(CollectionsKey.member).where("isBoss",isEqualTo: true).get();

    members = snapshot.docs.map((e) => Member.fromJson(e.data() as Map<String, dynamic>)).toList();
    return members.first;
  }

  static Future getMembersWithoutBoss()async{
    List<Member>? members  = [];
    QuerySnapshot snapshot = await db.collection(CollectionsKey.member).where("isBoss",isEqualTo: false).get();

    members = snapshot.docs.map((e) => Member.fromJson(e.data() as Map<String, dynamic>)).toList();
    return members;
  }

  static Future addNewDepartment(
      {required Department department}) async {
    try {
      DocumentReference reference = db.collection(CollectionsKey.department).doc();

      department.id = reference.id;

      await reference.set(department.toJson());

    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future getAllDepartments()async{
    List<Department>? departments  = [];
    QuerySnapshot snapshot = await db.collection(CollectionsKey.department).get();

    departments = snapshot.docs.map((e) => Department.fromJson(e.data() as Map<String, dynamic>)).toList();
    return departments;
  }

  static removeDepartment(String departmentId){
    DocumentReference doc = db.collection(CollectionsKey.department).doc(departmentId);
    doc.delete();
  }

  static void editDepartment(
      Department department)  {
    DocumentReference categoryDoc =
    db.collection(CollectionsKey.department).doc(department.id);

    categoryDoc.update({
      "name": department.name,
    });

    return ;
  }


  static Future addNewBidType(
      {required BidType type}) async {
    try {
      DocumentReference reference = db.collection(CollectionsKey.bidType).doc();

      type.id = reference.id;

      await reference.set(type.toJson());

    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future getAllBidTypes()async{
    List<BidType>? bidTypes  = [];
    QuerySnapshot snapshot = await db.collection(CollectionsKey.bidType).get();

    bidTypes = snapshot.docs.map((e) => BidType.fromJson(e.data() as Map<String, dynamic>)).toList();
    return bidTypes;
  }

  static removeBidType(String bidTypeId){
    DocumentReference doc = db.collection(CollectionsKey.bidType).doc(bidTypeId);
    doc.delete();
  }

  static void editBidType(
      BidType bidType)  {
    DocumentReference categoryDoc =
    db.collection(CollectionsKey.bidType).doc(bidType.id);

    categoryDoc.update({
      "name": bidType.name,
    });

    return ;
  }

  static Future addNewComplaintType(
      {required ComplaintType type}) async {
    try {
      DocumentReference reference = db.collection(CollectionsKey.complaintType).doc();

      type.id = reference.id;

      await reference.set(type.toJson());

    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future getAllComplaintTypes()async{
    List<ComplaintType>? complaintType  = [];
    QuerySnapshot snapshot = await db.collection(CollectionsKey.complaintType).get();

    complaintType = snapshot.docs.map((e) => ComplaintType.fromJson(e.data() as Map<String, dynamic>)).toList();
    return complaintType;
  }

  static removeComplaintType(String complaintTypeId){
    DocumentReference doc = db.collection(CollectionsKey.complaintType).doc(complaintTypeId);
    doc.delete();
  }

  static void editComplaintType(
      ComplaintType complaintType)  {
    DocumentReference doc =
    db.collection(CollectionsKey.complaintType).doc(complaintType.id);

    doc.update({
      "name": complaintType.name,
    });

    return ;
  }

  static Future<List<City>> getAllCities()async{
    List<City>? cities  = [];
    QuerySnapshot snapshot = await db.collection(CollectionsKey.city).get();

    cities = snapshot.docs.map((e) => City.fromJson(e.data() as Map<String, dynamic>)).toList();
    return cities;
  }

  static removeCategory(String categoryId){
    DocumentReference doc = db.collection(CollectionsKey.category).doc(categoryId);
    doc.delete();
  }

  static removeMember(String memberId){
    DocumentReference doc = db.collection(CollectionsKey.member).doc(memberId);
    doc.delete();
  }


  static removeCity(String cityId){
    DocumentReference doc = db.collection(CollectionsKey.city).doc(cityId);

    doc.delete();
  }

  static blockUser(String userId,{bool block = true}) async {

    DocumentReference doc = db.collection(CollectionsKey.user).doc(userId);

    doc.update({
      "blocked" : block
    });
  }



  static Future<AdminInfo?> updateAdminInfo(
      {required AdminInfo adminInfo}) async {
    try {
      DocumentReference rewardDoc = db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

      await rewardDoc.set(adminInfo.toJson());

      return adminInfo;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<AdminInfo> getAdminInfo() async {
    DocumentSnapshot documentSnapshot =
    await db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo).get();

    AdminInfo adminInfo = AdminInfo.fromJson(documentSnapshot.data() as Map<String,dynamic>);

    return adminInfo;

  }

  static increaseUsersNumber() {
    DocumentReference adminInfoDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    adminInfoDoc.update({
      "usersNumber": FieldValue.increment(1),
    });
  }

  static increaseShopsNumber() {
    DocumentReference adminInfoDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    adminInfoDoc.update({
      "shopsNumber": FieldValue.increment(1),
    });
  }

  static decreaseShopsNumber() {
    DocumentReference adminInfoDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    adminInfoDoc.update({
      "shopsNumber": FieldValue.increment(-1),
    });
  }
  static increaseNotificationsNumber() {
    DocumentReference adminInfoDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    adminInfoDoc.update({
      "notificationsNumber": FieldValue.increment(1),
    });
  }

  static decreaseNotificationsNumber() {
    DocumentReference adminInfoDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    adminInfoDoc.update({
      "notificationsNumber": FieldValue.increment(-1),
    });
  }

  static increaseOffersNumber() {
    DocumentReference adminInfoDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    adminInfoDoc.update({
      "offersNumber": FieldValue.increment(1),
    });
  }

  static increasePendingOffersNumber() {
    DocumentReference adminInfoDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    adminInfoDoc.update({
      "pendingOffersNumber": FieldValue.increment(1),
    });
  }

  static increasePendingNotificationsNumber() {
    DocumentReference adminInfoDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    adminInfoDoc.update({
      "pendingNotificationsNumber": FieldValue.increment(1),
    });
  }

  static decreaseOffersNumber() {
    DocumentReference adminInfoDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    adminInfoDoc.update({
      "offersNumber": FieldValue.increment(-1),
    });
  }


  static decreasePendingOffersNumber() {
    DocumentReference adminInfoDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    adminInfoDoc.update({
      "pendingOffersNumber": FieldValue.increment(-1),
    });
  }

  static decreasePendingNotificationsNumber() {
    DocumentReference adminInfoDoc =
    db.collection(CollectionsKey.adminInfo).doc(CollectionsKey.adminInfo);

    adminInfoDoc.update({
      "pendingNotificationsNumber": FieldValue.increment(-1),
    });
  }








}