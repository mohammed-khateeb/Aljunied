import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Widgets/waiting_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Apis/admin_services.dart';
import '../Constants/constants.dart';
import '../Models/terms_conditions.dart';
import '../Utils/util.dart';
import '../Widgets/custom_app_bar.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  TermsCondition? terms;
  @override
  void initState() {
    getTerms();
    super.initState();
  }

  getTerms()async{
    terms = await AdminApi.getTermsCoditions();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "termsAndConditions"),
      body:terms!=null? Text(
        terms!.terms!,
        style: TextStyle(
          fontSize: 17,
        ),
      ):const WaitingWidget(),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "termsAndConditions"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child: terms!=null?SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(size.width*0.05),
            child: Text(
              terms!.terms!,
              style: TextStyle(
                fontSize: size.height*0.02,
              ),
            ),
          ),
        ):const WaitingWidget(),
      ),
    );
  }
}
