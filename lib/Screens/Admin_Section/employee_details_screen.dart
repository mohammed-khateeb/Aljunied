import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Dialogs/departments.dart';
import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Models/department.dart';
import 'package:aljunied/Models/user_app.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controller/admin_controller.dart';
import '../../Controller/notification_controller.dart';
import '../../Models/notification.dart';
import '../../Push_notification/push_notification_serveice.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_app_bar.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final UserApp employee;
  const EmployeeDetailsScreen({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: employee.name,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 160,
                child: Column(
                  children: [
                    Image.asset(
                      "images/man.png",
                      height: 120,

                      fit: BoxFit.cover,
                    ),
                    if(employee.department!=null)
                      Text(
                        employee.department!.name??"",
                        style: TextStyle(

                            fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ),

              Container(
                width: size.width,
                margin: EdgeInsets.only(top: size.height*0.02),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height*0.075,),
                      Text(
                        translate(context, "employeeInformation"),
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "ArabFontBold",
                        ),
                      ),
                      SizedBox(height: 10,),

                      if(employee.mobileNumber!=null)
                        Card(
                          elevation: 6,
                          shadowColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(7),
                            child: Row(
                              children: [

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: size.width,),
                                      Text(
                                        employee.mobileNumber!.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        translate(context, "mobileNumber"),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Image.asset(
                                    "icons/call.png",
                                    height: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: 15,),
                      if(employee.email!=null)
                        Card(
                          elevation: 6,
                          shadowColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: size.width,),
                                      Text(
                                        employee.email!,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        translate(context, "email"),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                  child: Image.asset(
                                    "icons/email.png",
                                    height: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(employee.isDepartmentBoss!=true)
                          CustomButton(
                            label: translate(context, "appointedAsDepartmentHead"),
                            onPress: (){
                                showDepartmentsDialog(context,isBoss: true);
                            },
                          ),
                          SizedBox(height: size.height*0.01,),
                          CustomButton(
                            label:employee.department!=null?translate(context, "removeFromEmployees"): translate(context, "appointmentAsAnEmployee"),
                            onPress: (){
                              if(employee.department==null){
                                showDepartmentsDialog(context);
                              }
                              else{
                                Utils.showSureAlertDialog(
                                    onSubmit: (){
                                      context.read<AdminController>().appointmentAsAnEmployee(employeeId: employee.id!,department: null);
                                      Navigator.pop(context);
                                    }
                                );
                              }
                            },
                          ),
                          SizedBox(height: size.height*0.01,),
                          CustomButton(
                            label:employee.isAdmin!=true?translate(context, "setAsAdmin"): translate(context, "removeFromAdmins"),
                            onPress: (){
                              if(employee.isSuperAdmin==true){
                                Utils.showErrorAlertDialog(
                                    translate(context, "thisUserIsASuperAdminCanNotBeDeleted")
                                );
                              }
                              else {
                                Utils.showSureAlertDialog(
                                  onSubmit: (){
                                    if(employee.isAdmin!=true){
                                      PushNotificationServices.sendMessageToAnyUser(
                                        title:"الادارة",
                                        body: "تم تعيينك كمسؤول في التطبيق.\n الرجاء تسجيل الخروج والدخول من جديد.",
                                        to: employee.token!,
                                      );
                                    }
                                    context.read<AdminController>().appointmentAsAdmin(userId: employee.id!,toAdmin: employee.isAdmin!=true);

                                    Navigator.pop(context);
                                  }
                              );
                              }
                            },
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.only(
          //       left: size.width*0.03,
          //       right: size.width*0.03,
          //       top: size.height*0.18
          //   ),
          //   child: Card(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(size.height*0.02),
          //     ),
          //     elevation: 6,
          //     shadowColor: Colors.white,
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal:size.width*0.01,vertical: size.height*0.01),
          //       child: SizedBox(
          //         height: size.height*0.1,
          //         child: Row(
          //           children: [
          //             SizedBox(
          //               width: size.width*0.25,
          //               child: Column(
          //                 mainAxisSize: MainAxisSize.min,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   SizedBox(width: size.width,),
          //                   Text(
          //                     "2:40 Pm",
          //                     style: TextStyle(
          //                         fontSize: size.height*0.022,
          //                         fontWeight: FontWeight.w600
          //                     ),
          //                   ),
          //                   Text(
          //                     translate(context, "entryTime"),
          //                     style: TextStyle(
          //                         fontSize: size.height*0.015,
          //                         color: Colors.grey
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             VerticalDivider(),
          //             SizedBox(
          //               width: size.width*0.25,
          //               child: Column(
          //                 mainAxisSize: MainAxisSize.min,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   SizedBox(width: size.width,),
          //                   Text(
          //                     "2:40 Pm",
          //                     style: TextStyle(
          //                         fontSize: size.height*0.022,
          //                         fontWeight: FontWeight.w600
          //                     ),
          //                   ),
          //                   Text(
          //                     translate(context, "endTime"),
          //                     style: TextStyle(
          //                         fontSize: size.height*0.015,
          //                         color: Colors.grey
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             VerticalDivider(),
          //             Expanded(
          //               child: Column(
          //                 mainAxisSize: MainAxisSize.min,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   SizedBox(width: size.width,),
          //                   Text(
          //                     "عجلون",
          //                     style: TextStyle(
          //                         fontSize: size.height*0.022,
          //                         fontWeight: FontWeight.w600
          //                     ),
          //                     maxLines: 1,
          //                   ),
          //                   Text(
          //                     translate(context, "placeOfEntry"),
          //                     style: TextStyle(
          //                         fontSize: size.height*0.015,
          //                         color: Colors.grey
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

        ],
      ),
    )
        :Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:CurrentUser.isAdmin == true? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(employee.isDepartmentBoss!=true)
            CustomButton(
              label: translate(context, "appointedAsDepartmentHead"),
              onPress: (){
                showDepartmentsDialog(context,isBoss: true);
              },
            ),
          SizedBox(height: size.height*0.01,),
          CustomButton(
            label:employee.department!=null?translate(context, "removeFromEmployees"): translate(context, "appointmentAsAnEmployee"),
            onPress: (){
              if(employee.department==null){
                showDepartmentsDialog(context);
              }
              else{
                Utils.showSureAlertDialog(
                    onSubmit: (){
                      context.read<AdminController>().appointmentAsAnEmployee(employeeId: employee.id!,department: null);
                      Navigator.pop(context);
                    }
                );
              }
            },
          ),
          SizedBox(height: size.height*0.01,),
          
          CustomButton(
            label:employee.isAdmin!=true?translate(context, "setAsAdmin"): translate(context, "removeFromAdmins"),
            onPress: (){
              if(employee.isSuperAdmin==true){
                Utils.showErrorAlertDialog(
                  translate(context, "thisUserIsASuperAdminCanNotBeDeleted")
                );
              }
              else{
                Utils.showSureAlertDialog(
                    onSubmit: (){
                      if(employee.isAdmin!=true){
                        PushNotificationServices.sendMessageToAnyUser(
                          title:"الادارة",
                          body: "تم تعيينك كمسؤول في التطبيق.\n الرجاء تسجيل الخروج والدخول من جديد.",
                          to: employee.token!,
                        );
                      }
                      context.read<AdminController>().appointmentAsAdmin(userId: employee.id!,toAdmin: employee.isAdmin!=true);

                      Navigator.pop(context);
                    }
                );
              }
              
            },
          ),
        ],
      ):null,
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: employee.name,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: size.height*0.22,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height*0.15,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height*0.01
                        ),
                        child: Image.asset(
                          "images/man.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if(employee.department!=null)
                    Text(
                      employee.department!.name??"",
                      style: TextStyle(
                          height: size.height*0.001,

                          fontSize: size.height*0.018,
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: size.width,
                  margin: EdgeInsets.only(top: size.height*0.02),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width*0.05,
                        vertical: size.height*0.03
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height*0.075,),
                        Text(
                          translate(context, "employeeInformation"),
                          style: TextStyle(
                            fontSize: size.height*0.025,
                            fontFamily: "ArabFontBold",
                          ),
                        ),
                        SizedBox(height: size.height*0.015,),
                        if(employee.mobileNumber!=null)
                        Card(
                          elevation: 6,
                          shadowColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(size.height*0.01),
                            child: Row(
                              children: [

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: size.width,),
                                      Text(
                                        employee.mobileNumber!.toString(),
                                        style: TextStyle(
                                          fontSize: size.height*0.02,
                                        ),
                                      ),
                                      Text(
                                        translate(context, "mobileNumber"),
                                        style: TextStyle(
                                            fontSize: size.height*0.017,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                  child: Image.asset(
                                    "icons/call.png",
                                    height: size.height*0.025,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: size.height*0.02,),
                        if(employee.email!=null)
                        Card(
                          elevation: 6,
                          shadowColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(size.height*0.01),
                            child: Row(
                              children: [

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: size.width,),
                                      Text(
                                        employee.email!,
                                        style: TextStyle(
                                          fontSize: size.height*0.02,
                                        ),
                                      ),
                                      Text(
                                        translate(context, "email"),
                                        style: TextStyle(
                                            fontSize: size.height*0.017,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                                  child: Image.asset(
                                    "icons/email.png",
                                    height: size.height*0.025,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width*0.03,
                right: size.width*0.03,
                top: size.height*0.18
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.height*0.02),
              ),
              elevation: 6,
              shadowColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:size.width*0.01,vertical: size.height*0.01),
                child: SizedBox(
                  height: size.height*0.1,
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width*0.25,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: size.width,),
                            Text(
                              "2:40 Pm",
                              style: TextStyle(
                                  fontSize: size.height*0.022,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              translate(context, "entryTime"),
                              style: TextStyle(
                                  fontSize: size.height*0.015,
                                  color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(),
                      SizedBox(
                        width: size.width*0.25,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: size.width,),
                            Text(
                              "2:40 Pm",
                              style: TextStyle(
                                  fontSize: size.height*0.022,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              translate(context, "endTime"),
                              style: TextStyle(
                                  fontSize: size.height*0.015,
                                  color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: size.width,),
                            Text(
                              "عجلون",
                              style: TextStyle(
                                  fontSize: size.height*0.022,
                                  fontWeight: FontWeight.w600
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              translate(context, "placeOfEntry"),
                              style: TextStyle(
                                  fontSize: size.height*0.015,
                                  color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  showDepartmentsDialog(BuildContext context,{bool isBoss = false}) async {
    dynamic result = await showDialog(context: context,builder: (_) => DepartmentsDialog());

    if(result is Department){
      Utils.showSureAlertDialog(
        onSubmit: (){
          context.read<AdminController>().appointmentAsAnEmployee(employeeId: employee.id!,department: result,isBoss: isBoss);
          PushNotificationServices.sendMessageToAnyUser(
            title:"الادارة",
            body:isBoss?"تم تعيينك كرئيس قسم في "+result.name!+"\n"+"الرجاء تسجيل الخروج والدخول من جديد.":"تم تعيينك كموظف في "+result.name!+"\n"+"الرجاء تسجيل الخروج والدخول من جديد.",
            to: employee.token??"",
          );
          Navigator.pop(context);
        }
      );




    }
  }


}
