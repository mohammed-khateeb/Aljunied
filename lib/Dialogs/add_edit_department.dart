import 'package:aljunied/Models/department.dart';
import 'package:flutter/foundation.dart';
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
      actionsPadding: EdgeInsets.symmetric(horizontal: kIsWeb&&size.width>520?10:size.width*0.02),
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(kIsWeb&&size.width>520?0:30.0))),
      title: Text(translate(context, "addADepartment"),style: TextStyle(
          fontWeight: FontWeight.normal,fontSize:kIsWeb&&size.width>520?16: size.height * 0.018)),
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
        InkWell(onTap: () => add(context), child: Text(translate(context, "add"),style: TextStyle(
            fontWeight: FontWeight.normal,fontSize:kIsWeb&&size.width>520?16: size.height * 0.018)))
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