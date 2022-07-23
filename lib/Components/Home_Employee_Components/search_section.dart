import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_text_field.dart';

class SearchSection extends StatefulWidget {

  const SearchSection({Key? key}) : super(key: key);

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: CustomTextField(
                  hintText: translate(context, "search"),
                  controller: controller,
                )),
            SizedBox(width: size.width*0.05,),
            CustomInkwell(
              onTap: (){
                FocusScope.of(context).unfocus();
                NavigatorUtils.navigateToTransactionsScreen(context, controller.text);
                controller.clear();
              },
              child: Container(
                height: size.height*0.054,
                width: size.width*0.12,
                padding: EdgeInsets.all(size.height*0.013),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: kPrimaryColor,
                ),
                child: Image.asset("icons/search.png"),
              ),
            ),
          ],
        ),
        Text(
          "  * "+translate(context, "searchForCitizensByReferenceNumberOrName"),
          style: TextStyle(
            fontSize: size.height*0.012,
            color: kPrimaryColor
          ),
        )
      ],
    );
  }
}
