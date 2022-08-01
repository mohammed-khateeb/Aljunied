import 'package:aljunied/Models/category.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as web;
import '../../Constants/constants.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_button.dart';

class StepTwoTransaction extends StatelessWidget {
  final Function(int selected) onSelectSubType;
  final Function onSubmit;
  final int selectedIndex;
  final Category? category;


  const StepTwoTransaction({Key? key, required this.onSubmit, required this.onSelectSubType, required this.selectedIndex, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return category!=null?Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          translate(context, "determineATypeOfTransaction")+" "+category!.nameAr!,
          style: TextStyle(
              fontSize:web.kIsWeb&&size.width>520?16: size.height*0.02,
              fontFamily: "ArabFontBold",
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height:web.kIsWeb&&size.width>520?10 :size.height*0.005,),
        Text(
          translate(context, "pleaseDetermineATypeOfTransaction")+" "+category!.nameAr!,
          style: TextStyle(
              fontSize:web.kIsWeb&&size.width>520?14: size.height*0.018,
              color: kSubTitleColor
          ),
        ),
        SizedBox(height:web.kIsWeb&&size.width>520?20: size.height*0.03,),
        Expanded(
          child:category!.subcategories!=null? GridView.builder(
            itemCount: category!.subcategories!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              mainAxisExtent:web.kIsWeb&&size.width>520?60: size.height*0.09
            ),
            itemBuilder: (_,index){
              return CustomInkwell(
                onTap: (){
                  onSelectSubType(index);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: size.height*0.01),
                  width:web.kIsWeb&&size.width>520?4300: size.width*0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.height*0.005),
                    color:selectedIndex == index ?kPrimaryColor:Colors.grey[200],
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal:web.kIsWeb&&size.width>520?10: size.width*0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category!.subcategories![index].nameAr!,
                          style: TextStyle(
                            fontSize:web.kIsWeb&&size.width>520?14: size.height*0.018,
                            color: selectedIndex == index?Colors.white:null
                          ),
                        ),
                        Icon(
                          selectedIndex == index?Icons.check_circle_rounded:Icons.radio_button_off,
                          color: selectedIndex == index?Colors.green:Colors.grey[400],
                          size:web.kIsWeb&&size.width>520?20: size.height*0.025,
                        )
                      ],
                    )
                  ),
                ),
              );
            },
          ):const SizedBox(),
        ),
        SizedBox(height:web.kIsWeb&&size.width>520?10: size.height*0.03,),

        CustomButton(
          label: translate(context, "continue"),
          onPress: (){
            onSubmit();
          },
        )
      ],
    ):const SizedBox();
  }
}
