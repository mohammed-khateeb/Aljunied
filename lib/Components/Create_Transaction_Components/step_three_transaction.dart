import 'package:aljunied/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as web;
import '../../Constants/constants.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_button.dart';

class StepThreeTransaction extends StatelessWidget {
  final Function onSubmit;
  final TextEditingController infoController;

  const StepThreeTransaction({Key? key, required this.onSubmit, required this.infoController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            translate(context, "anotherAdditionToTheTypeOf")+" "+"ترخيص ابنية",
            style: TextStyle(
                fontSize: web.kIsWeb&&size.width>520?16:size.height*0.02,
                fontFamily: "ArabFontBold",
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height:web.kIsWeb&&size.width>520?8: size.height*0.005,),
          Text(
            translate(context, "pleaseSelectAnyOtherAddOns"),
            style: TextStyle(
                fontSize:web.kIsWeb&&size.width>520?14: size.height*0.018,
                color: kSubTitleColor
            ),
          ),
          SizedBox(height:web.kIsWeb&&size.width>520?20: size.height*0.03,),
          CustomTextField(
            minLines: 5,
            controller: infoController,
            keyboardType: TextInputType.multiline,
            hintText: translate(context, "anotherAddition"),
          ),
          SizedBox(height:web.kIsWeb&&size.width>520?20: size.height*0.03,),

          CustomButton(
            label: translate(context, "continue"),
            onPress: (){
              onSubmit();
            },
          )
        ],
      ),
    );
  }
}
