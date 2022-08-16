import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/headline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../Components/custom_scaffold_web.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/custom_text_field.dart';

class AddEditSubTitleScreen extends StatefulWidget {
  final SubTitle? subTitle;
  final String? titleAppBar;

  const AddEditSubTitleScreen({Key? key, this.subTitle, this.titleAppBar}) : super(key: key);

  @override
  State<AddEditSubTitleScreen> createState() => _AddEditSubTitleScreenState();
}

class _AddEditSubTitleScreenState extends State<AddEditSubTitleScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  SubTitle subTitle = SubTitle();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if(widget.subTitle!=null) {
      subTitle = widget.subTitle!;
      titleController.text = widget.subTitle!.label!;
      desController.text = widget.subTitle!.des??"";
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: widget.titleAppBar,
      body:Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 10,),
            CustomTextField(
              controller: titleController,
              hintText: translate(context, "subSubTitle"),
              withValidation: true,
            ),
            SizedBox(height: size.height*0.02,),
            CustomTextField(
              minLines: 5,
              keyboardType: TextInputType.multiline,
              controller: desController,
              withValidation: true,
              hintText: translate(context, "details"),
            ),

            SizedBox(height: 20,),

            CustomButton(label: translate(context, "save"), onPress:()=> add(context)),
          ],
        ),
      ),
    )
        :Scaffold(
      appBar: CustomAppBar(
        title: widget.titleAppBar,
      ),
      body:  Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width*0.03
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height*0.02,),
                CustomTextField(
                  height: size.height*0.05,
                  borderRadius: size.height*0.01,
                  controller: titleController,
                  hintText: translate(context, "subSubTitle"),
                  withValidation: true,
                ),
                SizedBox(height: size.height*0.02,),
                CustomTextField(
                  height: size.height*0.05,
                  borderRadius: size.height*0.01,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  controller: desController,
                  withValidation: true,
                  hintText: translate(context, "details"),
                ),

                SizedBox(height: size.height*0.06,),

                CustomButton(label: translate(context, "save"), onPress:()=> add(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void add(BuildContext context) async{

    if(!_formKey.currentState!.validate()) {
      return;
    }


    else{
      FocusScope.of(context).unfocus();
      subTitle.label = titleController.text;
      subTitle.des = desController.text;
      Navigator.pop(context, subTitle);
    }

  }



}
