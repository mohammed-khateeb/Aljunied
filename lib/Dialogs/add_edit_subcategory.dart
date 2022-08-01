import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Models/category.dart';
import '../Utils/util.dart';
import '../Widgets/custom_inkwell.dart';
import '../Widgets/custom_text_field.dart';

class AddEditSubCategoryDialog extends StatefulWidget {
  final Subcategory? subcategory;
  const AddEditSubCategoryDialog({Key? key, this.subcategory}) : super(key: key);

  @override
  State<AddEditSubCategoryDialog> createState() => _AddEditSubCategoryDialogState();
}

class _AddEditSubCategoryDialogState extends State<AddEditSubCategoryDialog> {
  final TextEditingController nameArController = TextEditingController();
  final TextEditingController nameErController = TextEditingController();


  @override
  void initState() {
     if(widget.subcategory != null){
      nameArController.text = widget.subcategory!.nameAr!;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Text(translate(context, "addATransactionSubType"),style: TextStyle(
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
        FlatButton(onPressed: () => add(context), child: Text(translate(context, "add"),style: TextStyle(
            fontWeight: FontWeight.normal,fontSize:kIsWeb&&size.width>520?16: size.height * 0.018)))
      ],
    );
  }

  void add(BuildContext context) {

    if(nameArController.text.trim().isEmpty) {
      return;
    }
    else{
      Navigator.pop(context,
          nameArController.text);
    }

  }
}