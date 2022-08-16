import 'package:aljunied/Models/area.dart';
import 'package:aljunied/Models/headline.dart';
import 'package:aljunied/Models/investment.dart';
import 'package:aljunied/Models/transaction.dart';
import 'package:aljunied/Screens/Admin_Section/add_edit_bid_screen.dart';
import 'package:aljunied/Screens/Admin_Section/add_edit_headline_screen.dart';
import 'package:aljunied/Screens/Admin_Section/add_edit_subtitle_screen.dart';
import 'package:aljunied/Screens/Admin_Section/add_edit_terms_screen.dart';
import 'package:aljunied/Screens/Admin_Section/add_edit_title_screen.dart';
import 'package:aljunied/Screens/Admin_Section/all_transactions_screen.dart';
import 'package:aljunied/Screens/Admin_Section/complaint_details_screen.dart';
import 'package:aljunied/Screens/Admin_Section/departments_screen.dart';
import 'package:aljunied/Screens/Admin_Section/employee_details_screen.dart';
import 'package:aljunied/Screens/Admin_Section/employees_screen.dart';
import 'package:aljunied/Screens/Admin_Section/home_admin_screen.dart';
import 'package:aljunied/Screens/Admin_Section/investment_details_screen.dart';
import 'package:aljunied/Screens/Admin_Section/investments_screen.dart';
import 'package:aljunied/Screens/Admin_Section/news_screen.dart';
import 'package:aljunied/Screens/Admin_Section/services_screen.dart';
import 'package:aljunied/Screens/Admin_Section/tourist_areas_screen.dart';
import 'package:aljunied/Screens/Admin_Section/users_screen.dart';
import 'package:aljunied/Screens/about_web_screen.dart';
import 'package:aljunied/Screens/home_emloyee_screen.dart';
import 'package:aljunied/Screens/add_investment_screen.dart';
import 'package:aljunied/Screens/create_edit_transaction_screen.dart';
import 'package:aljunied/Screens/headline_title_details_screen.dart';
import 'package:aljunied/Screens/language_screen.dart';
import 'package:aljunied/Screens/make_complaint_screen.dart';
import 'package:aljunied/Screens/news_details_screen.dart';
import 'package:aljunied/Screens/notifications_screen.dart';
import 'package:aljunied/Screens/transaction_details_screen.dart';
import 'package:aljunied/Screens/transaction_tracking_details.dart';
import 'package:aljunied/Screens/verify_phone_number_screen.dart';
import 'package:aljunied/Screens/welcome_screen.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:flutter/material.dart';
import '../Models/bid.dart';
import '../Models/complaint.dart';
import '../Models/news.dart';
import '../Models/user_app.dart';
import '../Screens/Admin_Section/add_edit_area_screen.dart';
import '../Screens/Admin_Section/add_edit_news_screen.dart';
import '../Screens/Admin_Section/admin_categories_screen.dart';
import '../Screens/Admin_Section/bid_types_screen.dart';
import '../Screens/Admin_Section/bids_screen.dart';
import '../Screens/Admin_Section/complaint_types_screen.dart';
import '../Screens/Admin_Section/complaints_screen.dart';
import '../Screens/Admin_Section/headlines_screen.dart';
import '../Screens/Admin_Section/send_notification_screen.dart';
import '../Screens/home_screen.dart';
import '../Screens/login_screen.dart';
import '../Screens/signup_screen.dart';
import '../Screens/splash_screen.dart';
import '../Screens/terms_conditions_screen.dart';
import '../Screens/transactions_screen.dart';

class NavigatorUtils {

  static void navigateToSplashScreen(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SplashScreen()));
  }

  static void navigateToLoginScreen(context) {
    openNewPage(context, const LoginScreen());
  }

  static void navigateToSignupScreen(context) {
    openNewPage(context, const SignupScreen());
  }

  static void navigateToHomeScreen(context) {
    openNewPage(context, const HomeScreen(),popPreviousPages: true);
  }

  static void navigateToTouristAreasScreen(context) {
    openNewPage(context, const TouristAreasScreen());
  }

  static void navigateToBidsTypesScreen(context,) {
    openNewPage(context, const BidsTypesScreen());
  }

  static void navigateToComplaintsTypesScreen(context,) {
    openNewPage(context, const ComplaintTypesScreen());
  }


  static void navigateToComplaintsScreen(context, {int kind = 3}) {
    openNewPage(context, ComplaintsScreen(kind: kind,));
  }

  static void navigateToServicesScreen(context) {
    openNewPage(context, const ServicesScreen());
  }


  static void navigateToComplaintDetailsScreen(context,Complaint complaint) {
    openNewPage(context, ComplaintDetailsScreen(complaint: complaint));
  }


  static void navigateToInvestmentDetailsScreen(context,Investment investment) {
    openNewPage(context, InvestmentDetailsScreen(investment: investment));
  }

  static void navigateToInvestmentsScreen(context,) {
    openNewPage(context, const InvestmentsScreen());
  }

  static void navigateToNewsDetailsScreen(context, { News? news,Bid? bid,Area? area}) {
    openNewPage(context, NewsDetailsScreen(news: news,bid: bid,area: area,),);
  }

  static void navigateToSendNotificationScreen(context,{String? referenceNumber}) {
    openNewPage(context, SendNotificationScreen(referenceNumber: referenceNumber,),);
  }

  static void navigateToTransactionTrackingDetails(context,TransactionModel transaction) {
    openNewPage(context, TransactionTrackingDetails(transaction: transaction,),);
  }


  static void navigateToNotificationsScreen(context) {
    openNewPage(context, const NotificationsScreen(),);
  }

  static void navigateToEmployeeScreen(context) {
    openNewPage(context, const EmployeeScreen(),);
  }

  static void navigateToUsersScreen(context) {
    openNewPage(context, const UsersScreen(),);
  }


  static void navigateToCreateEditATransactionScreen(context,
      {TransactionModel? transaction}) {
    openNewPage(context, CreateEditTransactionScreen(transaction: transaction,));
  }


  static void navigateToWelcomeScreen(context) {
    openNewPage(context, const WelcomeScreen(),popPreviousPages: true);
  }



  static void navigateToHeadlinesScreen(context) {
    openNewPage(context, const HeadlinesScreen());
  }
  static void navigateToHomeEmployeeScreen(context) {
    openNewPage(context, const HomeEmployeeScreen(),popPreviousPages: true);
  }

  static void navigateToHomeAdminScreen(context) {
    openNewPage(context, const HomeAdminScreen());
  }

  static Future navigateToAddEditHeadlineScreen(context,{Headline? headline,int? orderIndex})async {
    openNewPage(context, AddEditHeadlineScreen(headline: headline,orderIndex: orderIndex,));
  }

  static Future navigateToHeadlineTitleDetailsScreen(context,{Headline? headline,TitleLine? titleLine})async {
    openNewPage(context, HeadlineTitleDetailsScreen(headline: headline,titleLine: titleLine,));
  }




  static void navigateToAddEditBidScreen(context,{Bid? bid}) {
    openNewPage(context, AddEditBidScreen(bid: bid,));
  }

  static void navigateToAddEditAreaScreen(context,{Area? area}) {
    openNewPage(context, AddEditAreaScreen(area: area,));
  }

  static void navigateToBidsScreen(context) {
    openNewPage(context, const BidsScreen());
  }

  static void navigateToAddEditTermsScreen(context) {
    openNewPage(context, const AddEditTermsScreen());
  }


  static void navigateToTermsConditionsScreen(context) {
    openNewPage(context, const TermsConditionsScreen());
  }


  static void navigateToAddInvestmentScreen(context) {
    openNewPage(context, const AddInvestmentScreen());
  }

  static void navigateToMakeComplaintScreen(context,{ int kind = 3}) {
    openNewPage(context, MakeComplaintScreen(kind: kind,));
  }

  static void navigateToLanguageScreen(context) {
    openNewPage(context, const LanguageScreen());
  }

  static void navigateToAboutWebScreen(context) {
    openNewPage(context, const AboutWebScreen());
  }


  static void navigateToAdminCategoriesScreen(context) {
    openNewPage(context, const AdminCategoriesScreen());
  }


  static void navigateToAllTransactionsScreen(context) {
    openNewPage(context, const AllTransactionsScreen());
  }

  static void navigateToDepartmentsScreen(context) {
    openNewPage(context, const DepartmentsScreen());
  }

  static void navigateToEmployeeDetailsScreen(context, {required UserApp employee}) {
    openNewPage(context, EmployeeDetailsScreen(employee: employee,));
  }

  static void navigateToAddEditNewsScreen(context,{News? news}) {
    openNewPage(context, AddEditNewsScreen(news: news,));
  }

  static void navigateToNewsScreen(context) {
    openNewPage(context, const NewsScreen());
  }

  static void navigateToTransactionDetailsScreen(context) {
    openNewPage(context, const TransactionDetailsScreen());
  }
  static void navigateToTransactionsScreen(context,String searchKey) {
    openNewPage(context,  TransactionsScreen(searchKey: searchKey,));
  }


  static void navigateToVerifyPhoneNumberScreen(context,{String? phoneNumber,String? fullName,UserApp? userApp}){
    openNewPage(context, VerifyPhoneNumberScreen(phoneNumber: phoneNumber, fullName: fullName,userApp: userApp,));
  }

}