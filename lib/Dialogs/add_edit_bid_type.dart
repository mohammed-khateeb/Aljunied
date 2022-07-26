import 'package:aljunied/Models/bid.dart';
import 'package:aljunied/Models/department.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Utils/util.dart';
import '../Widgets/custom_text_field.dart';

class AddEditBidTypeDialog extends StatefulWidget {
  final BidType? bidType;
  final List<String>? typesStringAr;

  const AddEditBidTypeDialog({Key? key, this.bidType, this.typesStringAr}) : super(key: key);

  @override
  State<AddEditBidTypeDialog> createState() => _AddEditBidTypeDialogState();
}

class _AddEditBidTypeDialogState extends State<AddEditBidTypeDialog> {
  final TextEditingController nameArController = TextEditingController();


  @override
  void initState() {
     if(widget.bidType != null){
      nameArController.text = widget.bidType!.name!;

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
      title: Text(translate(context, "addABidType"),style: TextStyle(
          fontWeight: FontWeight.normal,fontSize: kIsWeb&&size.width>520?16:size.height * 0.018)),
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