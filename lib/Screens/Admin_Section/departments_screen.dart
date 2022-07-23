import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Dialogs/add_edit_department.dart';
import 'package:aljunied/Models/department.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../Controller/admin_controller.dart';
import '../../Dialogs/add_new_category.dart';
import '../../Models/category.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/reusable_cache_network_image.dart';
import '../../Widgets/waiting_widget.dart';
import 'edit_category_screen.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({Key? key}) : super(key: key);

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {




  @override
  void initState() {
    context.read<AdminController>().getAllDepartments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "transactionsTypes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addDepartment(context: context);
        },
        child:  Icon(
          Icons.add,
          color: Colors.white,
          size: size.height*0.04,
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child: Consumer<AdminController>(
            builder: (context, adminController, child) {
              return !adminController.waitingDepartment? ListView.builder(
                itemCount: adminController.departments!.length,
                padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
                itemBuilder: (_,index){
                  return Card(
                    elevation: 0.5,
                    child: ListTile(
                      onTap: (){
                        editDepartment(context: context,department: adminController.departments![index]);
                      },
                      contentPadding: EdgeInsets.symmetric(
                          vertical: size.height*0.01,
                          horizontal: size.width*0.03
                      ),
                      leading: Text(
                        "${index+1} - ",
                        style: TextStyle(
                            fontSize: size.height*0.02
                        ),
                      ),
                      title: Text(
                        adminController.departments![index].name!.toUpperCase(),
                        style: TextStyle(
                            fontSize: size.height*0.02
                        ),
                      ),
                      trailing: CustomInkwell(
                        onTap: ()=>removeDepartment(adminController.departments![index].id!),
                        child: Icon(
                          FontAwesomeIcons.timesCircle,
                          color: Colors.red,
                          size: size.height*0.03,
                        ),
                      ),

                    ),
                  );
                },
              ):const WaitingWidget();
            }
        ),
      ),
    );
  }

  Future<void> addDepartment({required BuildContext context}) async {

    Department department = Department();
    List<String>? departmentsStringAr;
    if(context.read<AdminController>().departments!=null&&context.read<AdminController>().departments!.isNotEmpty) {
      departmentsStringAr = context
          .read<AdminController>()
          .departments!
          .map((e) => e.name!.replaceAll(" ", "").toLowerCase())
          .toList();
    }

    dynamic result = await showDialog(context: context,builder: (_) => AddEditDepartmentDialog(departmentsName: departmentsStringAr,));





    if(result is String){



      department.name = result;


      Utils.showWaitingProgressDialog();


      await context.read<AdminController>().addNewDepartment(department);

      Utils.hideWaitingProgressDialog();


    }
  }

  Future<void> editDepartment({required BuildContext context,required Department department}) async {



    List<String> departmentsStringAr = context.read<AdminController>().departments!
        .map((e) => e.name!.replaceAll(" ", "").toLowerCase()).toList();

    departmentsStringAr.removeWhere((element) =>element == department.name);

    dynamic result = await showDialog(context: context,builder: (_) => AddEditDepartmentDialog(departmentsName: departmentsStringAr,department: department,));

    if(result is String){


      department.name = result;

      context.read<AdminController>().editDepartment(department);




    }
  }

  removeDepartment(String departmentId){
    Utils.showSureAlertDialog(
        onSubmit: (){
          context.read<AdminController>().removeDepartment(departmentId);
        }
    );
  }


}

