import 'package:flutter/material.dart';
import '../Models/city.dart';
import '../Utils/util.dart';
import '../Widgets/custom_text_field.dart';

class AddEditCityDialog extends StatefulWidget {
  final City? city;
  const AddEditCityDialog({Key? key, this.city}) : super(key: key);

  @override
  State<AddEditCityDialog> createState() => _AddEditCityDialogState();
}

class _AddEditCityDialogState extends State<AddEditCityDialog> {
  final TextEditingController nameArController = TextEditingController();
  final TextEditingController nameErController = TextEditingController();


  @override
  void initState() {
    if(widget.city != null){
      nameErController.text = widget.city!.nameEn!;
      nameArController.text = widget.city!.nameAr!;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Text(translate(context,"addCity")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: size.height*0.02,),
          CustomTextField(
            height: size.height*0.05,
            borderRadius: size.height*0.01,
            controller: nameErController,
            hintText: translate(context, "nameEn"),
          ),
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
        FlatButton(onPressed: () => add(context), child: Text(translate(context, "add")))
      ],
    );
  }

  void add(BuildContext context) {

    if(nameErController.text.trim().isEmpty||nameArController.text.trim().isEmpty) {
      return;
    }
    else{
      Navigator.pop(context,
          nameErController.text+"**"+nameArController.text);
    }

  }
}