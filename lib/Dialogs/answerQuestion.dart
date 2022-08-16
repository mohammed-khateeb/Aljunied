import 'package:aljunied/Models/bid.dart';
import 'package:aljunied/Models/department.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Utils/util.dart';
import '../Widgets/custom_text_field.dart';

class AnswerQuestionDialog extends StatefulWidget {
  const AnswerQuestionDialog({Key? key}) : super(key: key);

  @override
  State<AnswerQuestionDialog> createState() => _AnswerQuestionDialogState();
}

class _AnswerQuestionDialogState extends State<AnswerQuestionDialog> {
  final TextEditingController answerController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      actionsPadding: EdgeInsets.symmetric(horizontal: kIsWeb&&size.width>520?10:size.width*0.02),
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(kIsWeb&&size.width>520?0:30.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: size.height*0.02,),

          CustomTextField(
            minLines: 5,
            keyboardType: TextInputType.multiline,
            borderRadius: size.height*0.01,
            controller: answerController,
            hintText: translate(context, "answer"),
          ),
          const SizedBox(height: 10,),

        ],
      ),
      actions: [
        InkWell(onTap: () => add(context), child: Text(translate(context, "send"),style: TextStyle(
            fontWeight: FontWeight.normal,fontSize:kIsWeb&&size.width>520?16: size.height * 0.018)))
      ],
    );
  }

  void add(BuildContext context) {

    if(answerController.text.trim().isEmpty) {
      return;
    }

    else{
      Navigator.pop(context,
          answerController.text);
    }

  }
}