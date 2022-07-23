import 'package:aljunied/Controller/admin_controller.dart';
import 'package:aljunied/Models/department.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:aljunied/Widgets/waiting_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Utils/util.dart';

class DepartmentsDialog extends StatefulWidget {

  const DepartmentsDialog({Key? key}) : super(key: key);

  @override
  State<DepartmentsDialog> createState() => _DepartmentsDialogState();
}

class _DepartmentsDialogState extends State<DepartmentsDialog> {

  @override
  void initState() {
    context.read<AdminController>().getAllDepartments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Text(translate(context, "departments"),style: TextStyle(
          fontWeight: FontWeight.normal,fontSize: size.height * 0.018)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          !context.watch<AdminController>().waitingDepartment?SizedBox(
              height: size.height*0.4,
            width: size.width,
            child: ListView.builder(
              itemCount: context.watch<AdminController>().departments!.length,
              itemBuilder: (_,index){
                return CustomInkwell(
                  onTap: (){
                    add(context,context.read<AdminController>().departments![index]);
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height*0.01,
                        horizontal: size.width*0.02
                      ),
                      child: Text(
                          context.watch<AdminController>().departments![index].name!,
                        style: TextStyle(
                          fontSize: size.height*0.018,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ):const WaitingWidget(),
        ],
      ),
    );
  }

  void add(BuildContext context,Department department) {

      Navigator.pop(context,
          department);

  }
}