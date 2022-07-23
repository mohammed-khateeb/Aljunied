import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Models/department.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:aljunied/Widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';
import '../../Constants/constants.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_button.dart';

class StepFourTransaction extends StatefulWidget {
  final Function onSubmit;
  final Function onEndTransaction;
  final bool edit;
  final TextEditingController nameController;
  final TextEditingController currentStageController;
  final TextEditingController convertToController;
  final TextEditingController convertFromController;
  final String? convertToId;
  final int duration;
  final Function(int,bool) onChangeDuration;
  final Function(bool) onChangeHourOrDay;

  final List<Department>? departments;
  final Function(Department department)? onSelectConvertFrom;
  final Function(Department department)? onSelectConvertTo;

  bool isDay;

   StepFourTransaction({Key? key,this.edit = false, required this.onSubmit, required this.nameController, required this.currentStageController, required this.convertToController, required this.duration, required this.onChangeDuration, required this.isDay, required this.departments, this.onSelectConvertFrom, this.onSelectConvertTo, required this.convertFromController, required this.onEndTransaction, required this.onChangeHourOrDay, this.convertToId}) : super(key: key);

  @override
  State<StepFourTransaction> createState() => _StepFourTransactionState();
}

class _StepFourTransactionState extends State<StepFourTransaction> {
  late WeightSliderController _controller;
  List<Department> nextStage = [];

  @override
  void initState() {
    super.initState();
    if(widget.departments!=null&&CurrentUser.department!=null) {
      nextStage = [];
      nextStage.addAll(widget.departments!);
      nextStage.removeWhere((element) => element.id == CurrentUser.department!.id);

    }
    _controller = WeightSliderController(initialWeight: widget.duration.toDouble(), minWeight: 1, interval: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return widget.departments!=null?ListView(
      children: [

        Text(
          translate(context, "citizenInformation"),
          style: TextStyle(
              fontSize: size.height*0.02,
              fontFamily: "ArabFontBold",
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: size.height*0.005,),
        Text(
          translate(context, "pleaseSpecifyCitizenInformation"),
          style: TextStyle(
              fontSize: size.height*0.018,
              color: kSubTitleColor
          ),
        ),
        SizedBox(height: size.height*0.03,),
        CustomTextField(
          labelText: translate(context, "CitizenName"),
          controller: widget.nameController,
          withValidation: true,
          suffixIcon: Image.asset(
            "icons/profile.png",
            color: Colors.grey[700],
            height: size.height*0.001,
          ),
        ),
        SizedBox(height: size.height*0.03,),
        CustomTextField(
          labelText: translate(context, "currentStage"),
          controller: widget.currentStageController,
          withValidation: true,

        ),
        SizedBox(height: size.height*0.03,),
        if(CurrentUser.isAdmin == true)
        CustomTextField(
          labelText: translate(context, "convertFrom"),
          readOnly: true,
          controller: widget.convertFromController,
          withValidation: true,
          onSelectDepartment: (dep){
            setState(() {
              if(widget.departments!=null) {
                nextStage = [];
                nextStage.addAll(widget.departments!);
                nextStage.remove(dep);
                if(CurrentUser.department!=null) {
                  nextStage.removeWhere((element) => element.id == CurrentUser.department!.id);
                }
                widget.convertToController.clear();
              }
              if(widget.onSelectConvertFrom!=null) {
                widget.onSelectConvertFrom!(dep);
              }
            });
          },
          dropDepartment: widget.departments!,
        ),
        SizedBox(height: size.height*0.03,),
        CustomTextField(
          labelText: translate(context, "convertTo"),
          readOnly: true,
          controller: widget.convertToController,
          withValidation: true,
          dropDepartment: nextStage,
          onSelectDepartment: (dep){
            setState(() {
              if(widget.onSelectConvertTo!=null) {
                widget.onSelectConvertTo!(dep);
              }
            });
          },

        ),
        SizedBox(height: size.height*0.03,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomInkwell(
              onTap: (){
                widget.onChangeHourOrDay(false);
                setState(() {
                  widget.isDay = false;
                });
              },
              child: Container(
                height: size.height*0.045,
                width: size.width*0.25,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadiusDirectional.horizontal(
                    start: Radius.circular(5)
                  ),
                  color: !widget.isDay?kPrimaryColor:Colors.grey[200]
                ),
                child: Center(
                  child: Text(
                    translate(context, "hour"),
                    style: TextStyle(
                      fontSize: size.height*0.02,
                      color: !widget.isDay?Colors.white:Colors.grey[700]
                    ),
                  ),
                ),
              ),
            ),
            CustomInkwell(
              onTap: (){
                widget.onChangeHourOrDay(true);
                setState(() {
                  widget.isDay = true;
                });
              },
              child: Container(
                height: size.height*0.045,
                width: size.width*0.25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.horizontal(
                        end: Radius.circular(5)
                    ),
                    color: widget.isDay?kPrimaryColor:Colors.grey[200]
                ),
                child: Center(
                  child: Text(
                    translate(context, "day"),
                    style: TextStyle(
                        fontSize: size.height*0.02,
                        color: widget.isDay?Colors.white:Colors.grey[700]
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        Center(
          child: Text(
            "${widget.duration} ${widget.isDay?translate(context, "day"):translate(context, "hour")}",
            style: TextStyle(fontSize: size.height*0.035, fontWeight: FontWeight.w500),
          ),
        ),
        VerticalWeightSlider(
          controller: _controller,
          height: size.height*0.15,
          isVertical: false,
          decoration:  PointerDecoration(
            width: size.height*0.06,
            height: 3.0,
            largeColor: kPrimaryColor,
            mediumColor: kPrimaryColor,
            smallColor: kPrimaryColor,
            gap: size.height*0.02,
          ),
          onChanged: (double value) {
            widget.onChangeDuration(value.toInt(),widget.isDay);
          },
          indicator: Container(
            height: 3.0,
            width: size.height*0.1,
            alignment: Alignment.centerLeft,
            color: kPrimaryColor,
          ),
        ),
        Image.asset(
         "icons/polygon.png",
         height: size.height*0.02,
        ),
        SizedBox(height: size.height*0.03,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomButton(
                label: widget.edit?translate(context, "edit"):translate(context, "create"),
                onPress: (){
                  widget.onSubmit();
                },
              ),
            ),
            if(widget.edit&&CurrentUser.department!=null&&CurrentUser.department!.id == widget.convertToId)
            Row(
              children: [
                SizedBox(width: size.width*0.04,),
                CustomButton(
                  width: size.width*0.4,
                  borderWidth: 2.5,
                  borderColor: kPrimaryColor,
                  textColor: kPrimaryColor,
                  color: Colors.white,
                  label: translate(context, "endTheTransaction"),
                  onPress: (){
                    widget.onEndTransaction();
                  },
                ),
              ],
            )
          ],
        ),

      ],
    ):SizedBox();
  }
}
