import 'package:aljunied/Apis/admin_services.dart';
import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Models/terms_conditions.dart';
import 'package:aljunied/Widgets/waiting_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_text_field.dart';

class AddEditTermsScreen extends StatefulWidget {
  const AddEditTermsScreen({Key? key}) : super(key: key);

  @override
  State<AddEditTermsScreen> createState() => _AddEditTermsScreenState();
}

class _AddEditTermsScreenState extends State<AddEditTermsScreen> {
  final TextEditingController termsController = TextEditingController();
  TermsCondition? terms;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    getTerms();
    super.initState();
  }

  getTerms()async{
    terms = await AdminApi.getTermsCoditions();
    setState(() {
      if(terms!=null) {
        termsController.text = terms!.terms!;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
        title: translate(context, "termsAndConditions"),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 10,),
            CustomTextField(
              keyboardType: TextInputType.multiline,
              controller: termsController,
              labelText: translate(context, "termsAndConditions"),
              withValidation: true,
              minLines: 35,
            ),

            SizedBox(height: 20,),

            CustomButton(label: translate(context, "save"), onPress:()=> add(context)),
          ],
        ),
      ),
    )
        : Scaffold(
      appBar: CustomAppBar(title: translate(context, "termsAndConditions"),),
      body:  Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width*0.03
        ),
        child: terms!=null?SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height*0.02,),
                CustomTextField(
                  height: size.height*0.05,
                  keyboardType: TextInputType.multiline,
                  borderRadius: size.height*0.01,
                  controller: termsController,
                  labelText: translate(context, "termsAndConditions"),
                  withValidation: true,
                  minLines: 35,
                ),

                SizedBox(height: size.height*0.06,),

                CustomButton(label: translate(context, "save"), onPress:()=> add(context)),
              ],
            ),
          ),
        ):const WaitingWidget(),
      ),
    );
  }

  void add(BuildContext context) async{

    if(!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    terms!.terms = termsController.text;
    Utils.showWaitingProgressDialog();
    await AdminApi.saveTermsConditions(termsController.text);
    Utils.hideWaitingProgressDialog();
    Navigator.pop(context,);

  }



}
