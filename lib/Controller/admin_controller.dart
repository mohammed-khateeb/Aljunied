import 'package:aljunied/Models/bid.dart';
import 'package:aljunied/Models/complaint.dart';
import 'package:aljunied/Models/department.dart';
import 'package:aljunied/Models/member.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import '../Apis/admin_services.dart';
import '../Apis/notification_api.dart';
import '../Models/admin_info.dart';
import '../Models/category.dart';
import '../Models/city.dart';
import '../Models/notification.dart';
import '../Models/user_app.dart';

class AdminController with ChangeNotifier{

  bool waiting = true;
  bool waitingCategories = true;
  bool waitingMembers = true;

  bool waitingCities = true;
  bool waitingDepartment = true;
  bool waitingBidType = true;
  bool waitingComplaintType = true;

  BidType? selectedType;

  bool waitingAllUsers = true;
  bool waitingEmployees = true;

  bool waitingSearchUser = true;
  bool waitingAllNotifications = true;
  List<NotificationModel>? allNotification;
  List<UserApp>? allUser;
  List<UserApp>? employees;
  List<UserApp>? employeeToDepartmentBoss;
  List<UserApp>? departmentEmployee;
  bool waitingDepartmentEmployee = true;
  bool waitingDepartmentBossUsers = true;

  List<Department>? departments;
  List<BidType>? bidTypes;
  List<ComplaintType>? complaintTypes;
  List<Category>? categories;
  List<Member>? members;
  List<Member>? membersWithoutBoss;
  Member? boss;
  List<City>? cities;
  AdminInfo? adminInfo;



  Future getAdminInfo()async{
    AdminInfo adminInfo = await AdminApi.getAdminInfo();
    this.adminInfo  = adminInfo;
    waiting = false;
    notifyListeners();
  }

  appointmentAsAnEmployee({required String employeeId,Department? department,bool isBoss = false}){
    AdminApi.appointmentAsAnEmployee(employeeId: employeeId,department: department,isBoss: isBoss);
    if(!isBoss&&department!=null){
      allUser!.firstWhere((element) => element.id == employeeId).isDepartmentBoss = false;
    }
    try{
      allUser??=[];
      if(!isBoss){
        allUser!.firstWhere((element) => element.id == employeeId).isDepartmentBoss = false;
      }
      allUser!.firstWhere((element) => element.id == employeeId).department = department;
      allUser!.firstWhere((element) => element.id == employeeId).departmentId = department!.id;

      if(isBoss){
        allUser!.firstWhere((element) => element.id == employeeId).isDepartmentBoss = true;
      }
    }
    catch(_){}
    try{
      employees??=[];
      employees!.firstWhere((element) => element.id == employeeId).department = department;
      employees!.firstWhere((element) => element.id == employeeId).departmentId = department!.id;

      if(isBoss){
        employees!.firstWhere((element) => element.id == employeeId).isDepartmentBoss = true;
      }
      if(department ==null){
        employees!.removeWhere((element) => element.id == employeeId);
        if(isBoss){
          employees!.firstWhere((element) => element.id == employeeId).isDepartmentBoss = false;
        }
      }
    }
    catch(_){}

    notifyListeners();
  }

  appointmentAsAdmin({bool toAdmin = true,required String userId}){
    AdminApi.appointmentAsAdmin(toAdmin: toAdmin,userId: userId);
    try{
      allUser??=[];
      allUser!.firstWhere((element) => element.id == userId).isAdmin = toAdmin;
    }
    catch(_){}
    try{
      employees??=[];
      employees!.firstWhere((element) => element.id == userId).isAdmin = toAdmin;
    }
    catch(_){}

    notifyListeners();
  }

  selectBidType(BidType bidType){
   selectedType = bidType;
   notifyListeners();
  }





  waitSearch(){
    waitingSearchUser = true;
    notifyListeners();
  }


  Future getEmployees()async{
    employees = await AdminApi.getEmployees();
    waitingEmployees = false;
    notifyListeners();
  }

  Future getUsers()async{
    allUser = await AdminApi.getUsers();
    waitingAllUsers = false;
    notifyListeners();
  }

  Future getUserByDepartmentId(String departmentId)async{
    departmentEmployee = await AdminApi.getUsersByDepartmentId(departmentId);
    waitingDepartmentEmployee = false;
    notifyListeners();
  }

  Future getEmployeeToDepartmentBoss(String departmentId)async{
    employeeToDepartmentBoss = [];
    employeeToDepartmentBoss = await AdminApi.getDepartmentBossUsers();
    List<UserApp> withinDepartment = await AdminApi.getUsersByDepartmentId(departmentId);
    for(int i = 0;i<withinDepartment.length;i++){
      if(employeeToDepartmentBoss!.firstWhereOrNull((element) => element.id == withinDepartment[i].id)==null){
        employeeToDepartmentBoss!.add(withinDepartment[i]);
      }
    }
    waitingDepartmentBossUsers = false;

    notifyListeners();
  }

  Future getAllNotifications()async{
    allNotification = await AdminApi.getAllNotificationsForAdmin();
    waitingAllNotifications = false;
    notifyListeners();
  }


  addAdminNotification(NotificationModel notificationModel){
    allNotification??=[];
    allNotification!.add(notificationModel);
    notifyListeners();
  }




  deleteNotification(NotificationModel notificationModel) async {
    NotificationApi.deleteNotification(notificationModel);
    if(allNotification!=null)allNotification!.removeWhere((element) => element.id == notificationModel.id);
    notifyListeners();
  }





  Future getAllCategories()async{
    waitingCategories = true;
    categories = await AdminApi.getAllCategories();
    waitingCategories = false;
    notifyListeners();
  }

  Future getAllMembers()async{
    waitingMembers = true;
    members = await AdminApi.getAllMembers();
    waitingMembers = false;
    notifyListeners();
  }

  Future getMembersWithoutBoss()async{
    waitingMembers = true;
    membersWithoutBoss = await AdminApi.getMembersWithoutBoss();
    waitingMembers = false;
    notifyListeners();
  }
  Future getBoss()async{
    waitingMembers = true;
    boss = await AdminApi.getBoss();
    waitingMembers = false;
    notifyListeners();
  }

  Future getAllDepartments()async{
    waitingDepartment = true;
    departments = await AdminApi.getAllDepartments();
    waitingDepartment = false;
    notifyListeners();
  }


  Future getAllBidTypes()async{
    waitingBidType = true;
    bidTypes = await AdminApi.getAllBidTypes();
    if(bidTypes!=null&&bidTypes!.isNotEmpty) {
      selectedType = bidTypes!.first;
    }
    waitingBidType = false;
    notifyListeners();
  }

  Future getAllComplaintTypes()async{
    waitingComplaintType = true;
    complaintTypes = await AdminApi.getAllComplaintTypes();
    waitingComplaintType = false;
    notifyListeners();
  }


  Future getAllCities()async{
    waitingCities = true;
    cities = await AdminApi.getAllCities();
    waitingCities = false;
    notifyListeners();
  }

  resetCategory(){
    waitingCategories = true;
    categories = null;
    notifyListeners();
  }

  addNewCategory(Category category){
    AdminApi.addNewCategory(category: category);
    categories ??= [];
    categories!.add(category);
    notifyListeners();
  }

  addNewMember(Member member){
    AdminApi.addNewMember(member: member);
    members ??= [];
    members!.add(member);
    notifyListeners();
  }

  addNewDepartment(Department department){
    AdminApi.addNewDepartment(department: department);
    departments ??= [];
    departments!.add(department);
    notifyListeners();
  }

  addNewBidType(BidType bidType){
    AdminApi.addNewBidType(type: bidType);
    bidTypes ??= [];
    bidTypes!.add(bidType);
    notifyListeners();
  }

  addNewComplaintType(ComplaintType complaintType){
    AdminApi.addNewComplaintType(type: complaintType);
    complaintTypes ??= [];
    complaintTypes!.add(complaintType);
    notifyListeners();
  }

  addNewCity(City city){
    AdminApi.addNewCity(city: city);
    cities ??= [];
    cities!.insert(0,city);
    notifyListeners();
  }


  editCategory(Category category){
    AdminApi.editCategory(category);
    categories!.firstWhere((element) => element.id == category.id).imageUrl = category.imageUrl;
    categories!.firstWhere((element) => element.id == category.id).nameAr = category.nameAr;
    categories!.firstWhere((element) => element.id == category.id).subcategories = category.subcategories;
    notifyListeners();
  }

  editDepartment(Department department){
    AdminApi.editDepartment(department);
    departments!.firstWhere((element) => element.id == department.id).name = department.name;
    notifyListeners();
  }

  editBidType(BidType bidType){
    AdminApi.editBidType(bidType);
    bidTypes!.firstWhere((element) => element.id == bidType.id).name = bidType.name;
    notifyListeners();
  }

  editComplaintType(ComplaintType complaintType){
    AdminApi.editComplaintType(complaintType);
    complaintTypes!.firstWhere((element) => element.id == complaintType.id).name = complaintType.name;
    notifyListeners();
  }

  editCity(City city){
    AdminApi.editCity(city);
    cities!.firstWhere((element) => element.id == city.id).nameEn = city.nameEn;
    cities!.firstWhere((element) => element.id == city.id).nameAr = city.nameAr;
    notifyListeners();
  }

  removeCategory(String categoryId){
    AdminApi.removeCategory(categoryId);
    categories!.removeWhere((element) => element.id==categoryId);
    notifyListeners();
  }

  removeMember(String memberId){
    AdminApi.removeMember(memberId);
    members!.removeWhere((element) => element.id==memberId);
    notifyListeners();
  }


  removeDepartment(String departmentId){
    AdminApi.removeDepartment(departmentId);
    departments!.removeWhere((element) => element.id==departmentId);
    notifyListeners();
  }

  removeBidType(String bidTypeId){
    AdminApi.removeBidType(bidTypeId);
    bidTypes!.removeWhere((element) => element.id==bidTypeId);
    notifyListeners();
  }

  removeComplaintType(String complaintTypeId){
    AdminApi.removeComplaintType(complaintTypeId);
    complaintTypes!.removeWhere((element) => element.id==complaintTypeId);
    notifyListeners();
  }


  removeCity(String cityId){
    AdminApi.removeCity(cityId);
    cities!.removeWhere((element) => element.id==cityId);
    notifyListeners();
  }






}