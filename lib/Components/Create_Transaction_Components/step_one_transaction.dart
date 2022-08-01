import 'package:aljunied/Widgets/custom_button.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:aljunied/Widgets/reusable_cache_network_image.dart';
import 'package:flutter/foundation.dart' as web;
import 'package:flutter/material.dart';

import '../../Constants/constants.dart';
import '../../Models/category.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_text_field.dart';


class StepOneTransaction extends StatelessWidget {
  final Function onSubmit;
  final int selectedIndex;
  final List<Category>? categories;
  final Function(int selected) onSelectType;
  final TextEditingController areaController;


  const StepOneTransaction({Key? key,required this.onSubmit, required this.selectedIndex, required this.onSelectType, required this.areaController, this.categories}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return
        ListView(
          physics: web.kIsWeb&&size.width>520?NeverScrollableScrollPhysics():null,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal:web.kIsWeb&&size.width>520?10: size.width*0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                translate(context, "selectArea"),
                style: TextStyle(
                    fontSize:web.kIsWeb&&size.width>520?16: size.height*0.02,
                    fontFamily: "ArabFontBold",
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height:web.kIsWeb&&size.width>520?10: size.height*0.01,),
              CustomTextField(
                controller: areaController,
                withValidation: true,
                dropList: const ["صخرة","عبين","عبلين"],
                readOnly: true,
              ),
              SizedBox(height:web.kIsWeb&&size.width>520?15: size.height*0.03,),
              Text(
                translate(context, "determineTheTypeOfTransaction"),
                style: TextStyle(
                    fontSize:web.kIsWeb&&size.width>520?16: size.height*0.02,
                    fontFamily: "ArabFontBold",
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: size.height*0.005,),
              Text(
                translate(context, "pleaseDetermineTheTypeOfTransaction"),
                style: TextStyle(
                    fontSize:web.kIsWeb&&size.width>520?14: size.height*0.018,
                    color: kSubTitleColor
                ),
              ),
              SizedBox(height:web.kIsWeb&&size.width>520?10: size.height*0.03,),
            ],
          ),
        ),

        if(categories!=null)
        SizedBox(
          height:web.kIsWeb&&size.width>520?250: size.height*0.35,

          child: GridView.builder(
            itemCount: categories!.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.only(start:web.kIsWeb&&size.width>520?10: size.width*0.03),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent:web.kIsWeb&&size.width>520?100: size.width*0.29
            ),
            itemBuilder: (_,index){
              return CustomInkwell(
                onTap: (){
                  onSelectType(index);
                },
                child: Column(
                  children: [
                    Container(
                      height:web.kIsWeb&&size.width>520?80: size.width*0.25,
                      width:web.kIsWeb&&size.width>520?80: size.width*0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.height*0.005),
                        border:selectedIndex==index? Border.all(
                          color: kPrimaryColor,width: 3
                        ):null,
                        color:Colors.grey[200],
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(size.height*0.02),
                        child: ReusableCachedNetworkImage(
                          height:web.kIsWeb&&size.width>520?80: size.width*0.25,
                          width:web.kIsWeb&&size.width>520?80: size.width*0.25,
                          imageUrl: categories![index].imageUrl,
                        ),
                      ),
                    ),
                    Text(
                      categories![index].nameAr!,
                      style: TextStyle(
                          fontSize:web.kIsWeb&&size.width>520?15: size.height*0.017
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal:web.kIsWeb&&size.width>520?10: size.width*0.05,
          ),
          child: CustomButton(
            label: translate(context, "continue"),
            onPress: (){
              onSubmit();
            },
          ),
        )
      ],
    );
  }
}
