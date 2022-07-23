import 'package:aljunied/Models/department.dart';
import 'package:flutter/material.dart';
import '../Utils/util.dart';
import '../Widgets/custom_text_field.dart';

class AddEditDepartmentDialog extends StatefulWidget {
  final Department? department;
  final List<String>? departmentsName;

  const AddEditDepartmentDialog({Key? key, this.department, this.departmentsName}) : super(key: key);

  @override
  State<AddEditDepartmentDialog> createState() => _AddEditDepartmentDialogState();
}

class _AddEditDepartmentDialogState extends State<AddEditDepartmentDialog> {
  final TextEditingController nameArController = TextEditingController();


  @override
  void initState() {
     if(widget.department != null){
      nameArController.text = widget.department!.name!;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Text(translate(context, "addADepartment"),style: TextStyle(
          fontWeight: FontWeight.normal,fontSize: size.height * 0.018)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: size.height*0.02,),

          CustomTextField(
            height: size.height*0.05,
            borderRadius: size.height*0.01,
            controller: nameArController,
            hintText: translate(context, "nameAr"),
          ),
          const SizedBox(height: 10,),

        ],
      ),
      actions: [
        FlatButton(onPressed: () => add(context), child: Text(translate(context, "add"),style: TextStyle(
            fontWeight: FontWeight.normal,fontSize: size.height * 0.018)))
      ],
    );
  }

  void add(BuildContext context) {

    if(nameArController.text.trim().isEmpty) {
      return;
    }
    if(widget.departmentsName!=null&&widget.departmentsName!.contains(nameArController.text.replaceAll(" ", "").toLowerCase())){
      Utils.showErrorAlertDialog(translate(context, "thisNameExistsPleaseChooseAnotherName"));
      return;
    }
    else{
      Navigator.pop(context,
          nameArController.text);
    }

  }
}