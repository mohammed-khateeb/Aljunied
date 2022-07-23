import 'package:aljunied/Controller/investment_controller.dart';
import 'package:aljunied/Models/investment.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/constants.dart';
import '../Widgets/custom_text_field.dart';

class AddInvestmentScreen extends StatefulWidget {
  const AddInvestmentScreen({Key? key}) : super(key: key);

  @override
  State<AddInvestmentScreen> createState() => _AddInvestmentScreenState();
}

class _AddInvestmentScreenState extends State<AddInvestmentScreen> {
  final _formKey = GlobalKey<FormState>();
  Investment investment = Investment();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController ideaController = TextEditingController();
  final TextEditingController nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "invest"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width*0.05
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height*0.04,),
                  Text(
                    translate(context, "pleaseFillOutTheFollowingFormWithAnInvestmentIdea"),
                    style: TextStyle(
                      fontSize: size.height*0.018,
                      color: kSubTitleColor
                    ),
                  ),
                  SizedBox(height: size.height*0.02),

                  Image.asset(
                    "images/computer.png",
                    height: size.height*0.12,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                    child: CustomTextField(
                      labelText: translate(context, "name"),
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      suffixIcon: Image.asset(
                        "icons/profile.png",
                        color: Colors.grey[600],
                        height: size.height*0.001,
                      ),
                      
                      withValidation: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                    child: CustomTextField(
                      labelText: translate(context, "mobileNumber"),
                      controller: mobileController,
                      keyboardType: TextInputType.number,
                      suffixIcon: Image.asset(
                        "icons/call.png",
                        color: Colors.grey[600],
                        height: size.height*0.001,
                      ),
                      withValidation: true,

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                    child: CustomTextField(
                      labelText: translate(context, "email"),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: Image.asset(
                        "icons/email.png",
                        color: Colors.grey[600],

                        height: size.height*0.001,
                      ),
                      withValidation: true,

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                    child: CustomTextField(
                      labelText: translate(context, "ideaText"),
                      controller: ideaController,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      withValidation: true,

                    ),
                  ),
                  SizedBox(height: size.height*0.03,),
                  CustomButton(
                    label: translate(context, "send"),
                    onPress: (){
                      submit();
                    },
                  ),
                  SizedBox(height: size.height*0.03,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  submit()async{
    if(!_formKey.currentState!.validate())return;
    investment.userName = nameController.text;
    investment.email = emailController.text;
    investment.mobileNumber = mobileController.text;
    investment.des = ideaController.text;
    Utils.showWaitingProgressDialog();
    await context.read<InvestmentController>().insertInvestment(investment: investment);
    Utils.hideWaitingProgressDialog();
    Navigator.pop(context);
    Utils.showSuccessAlertDialog(
      translate(context, "theIdeaWasSubmittedSuccessfullyItWillBeConsideredByTheAdministrator"),
      bottom: true
    );
  }
}
