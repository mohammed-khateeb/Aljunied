import 'city.dart';
import 'department.dart';

class CurrentUser {
  static String? userId;
  static String? userName;
  static String? email;
  static City? city;
  static String? token;
  static String? mobileNumber;
  static String? departmentId;

  static Department? department;
  static bool? isAdmin;
  static bool? isDepartmentBoss;

  static bool? isSuperAdmin;
}