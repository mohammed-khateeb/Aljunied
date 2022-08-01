import 'package:aljunied/Models/bid.dart';
import 'package:aljunied/Models/complaint.dart';
import 'package:aljunied/Models/department.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Utils/util.dart';
import '../Widgets/custom_text_field.dart';

class AddEditComplaintTypeDialog extends StatefulWidget {
  final ComplaintType? complaintType;
  final List<String>? typesStringAr;

  const AddEditComplaintTypeDialog({Key? key, this.complaintType, this.typesStringAr}) : super(key: key);

  @override
  State<AddEditComplaintTypeDialog> createState() => _AddEditComplaintTypeDialogState();
}

class _AddEditComplaintTypeDialogState extends State<AddEditComplaintTypeDialog> {
  final TextEditingController nameArController = TextEditingController();


  @override
  void initState() {
     if(widget.complaintType != null){
      nameArController.text = widget.complaintType!.name!;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Text(translate(context, "addAComplaintType"),style: TextStyle(
          fontWeight: FontWeight.normal,fontSize: kIsWeb&&size.width>520?16:size.height * 0.018)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: size.height*0.02,),

          CustomTextField(
            height: kIsWeb&&size.width>520?null:size.height*0.05,
            borderRadius: kIsWeb&&size.width>520?null:size.height*0.01,
            controller: nameArController,
            hintText: translate(context, "nameAr"),
          ),
          const SizedBox(height: 10,),

        ],
      ),
      actions: [
        FlatButton(onPressed: () => add(context), child: Text(translate(context, "add"),style: TextStyle(
            fontWeight: FontWeight.normal,fontSize:kIsWeb&&size.width>520?16: size.height * 0.018)))
      ],
    );
  }

  void add(BuildContext context) {

    if(nameArController.text.trim().isEmpty) {
      return;
    }
    if(widget.typesStringAr!=null&&widget.typesStringAr!.contains(nameArController.text.replaceAll(" ", "").toLowerCase())){
      Utils.showErrorAlertDialog(translate(context, "thisNameExistsPleaseChooseAnotherName"));
      return;
    }
    else{
      Navigator.pop(context,
          nameArController.text);
    }

  }
}