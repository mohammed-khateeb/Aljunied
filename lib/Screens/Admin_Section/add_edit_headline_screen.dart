import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/headline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Controller/headline_controller.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/custom_text_field.dart';
import 'add_edit_title_screen.dart';

class AddEditHeadlineScreen extends StatefulWidget {
  final Headline? headline;
  final int? orderIndex;
  const AddEditHeadlineScreen({Key? key, this.headline, this.orderIndex}) : super(key: key);

  @override
  State<AddEditHeadlineScreen> createState() => _AddEditHeadlineScreenState();
}

class _AddEditHeadlineScreenState extends State<AddEditHeadlineScreen> {
  final TextEditingController titleArController = TextEditingController();
  final TextEditingController titleEnController = TextEditingController();
  final TextEditingController orderController = TextEditingController();

  final TextEditingController desController = TextEditingController();
  Headline headline = Headline(titles: []);
  final _formKey = GlobalKey<FormState>();
  int? orderIndex;
  @override
  void initState() {
    if(widget.headline!=null) {
      headline = widget.headline!;
      titleEnController.text = widget.headline!.labelEn??"";
      titleArController.text = widget.headline!.labelAr!;
      desController.text = widget.headline!.des??"";
      orderIndex = widget.headline!.orderIndex;
      orderController.text = widget.headline!.orderIndex.toString();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 10),
            CustomTextField(
              borderRadius: 10,
              controller: titleArController,
              hintText: translate(context, "mainTitle")+" ${translate(context, "inArabic")}",
              withValidation: true,

            ),
            SizedBox(height: 10,),
            CustomTextField(
              borderRadius: 10,
              controller: titleEnController,
              hintText: translate(context, "mainTitle")+" ${translate(context, "inEnglish")}",

            ),
            SizedBox(height: 10,),
            CustomTextField(
              borderRadius: 10,
              minLines: 5,
              keyboardType: TextInputType.multiline,
              controller: desController,
              withValidation: headline.titles!.isEmpty,
              hintText: translate(context, "details"),
              helperText: translate(context, "thereIsNoNeedForDetailsIfTheMainTitleContainsSubheadings"),
            ),
            SizedBox(height: 10,),
            if(widget.headline!=null&&widget.orderIndex!=null)
              CustomTextField(
                borderRadius: 10,
                controller: orderController,
                readOnly: true,
                onChanged: (str){
                  orderIndex = int.tryParse(str);
                },
                dropList: List<String>.generate(widget.orderIndex!-1, (i) => "${i + 1}"),
                hintText: translate(context, "order"),
              ),

            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "subTitles"),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600]
                  ),
                ),
                CustomInkwell(
                  onTap: (){
                    FocusScope.of(context).unfocus();

                    openNewPage(context, AddEditTitleScreen(titleAppBar: titleArController.text,)).then((value) {
                      if(value!=null&&value is TitleLine) {
                        setState(() {
                          headline.titles!.add(value);
                        });
                      }
                    });
                  },
                  child: Icon(
                    Icons.add_circle,
                    color: kPrimaryColor,
                    size: 30,
                  ),
                )
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: headline.titles!.length,
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              itemBuilder: (_,index){
                return Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ListTile(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      openNewPage(context, AddEditTitleScreen(titleLine: headline.titles![index],titleAppBar: titleArController.text)).then((value) {
                        if(value!=null&&value is TitleLine){
                          setState(() {
                            headline.titles![index] = value;
                          });
                        }
                      });
                    },
                    trailing: Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 20,
                    ),
                    leading: CustomInkwell(
                      onTap: (){
                        Utils.showSureAlertDialog(
                            onSubmit: (){
                              setState(() {
                                headline.titles!.remove(headline.titles![index]);
                              });
                            }
                        );

                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 10),
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      Localizations.localeOf(context).languageCode=="ar"?headline.titles![index].labelAr!:headline.titles![index].labelEn??headline.titles![index].labelAr!,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),

                  ),
                );
              },
            ),
            SizedBox(height: 25,),
            CustomButton(label: translate(context, "save"), onPress:()=> add(context)),
          ],
        ),
      ),
    )
        :Scaffold(
      appBar: const CustomAppBar(),
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
                  controller: titleArController,
                  hintText: translate(context, "mainTitle")+" ${translate(context, "inArabic")}",
                  withValidation: true,

                ),
                SizedBox(height: size.height*0.02,),
                CustomTextField(
                  height: size.height*0.05,
                  borderRadius: size.height*0.01,
                  controller: titleEnController,
                  hintText: translate(context, "mainTitle")+" ${translate(context, "inEnglish")}",

                ),
                SizedBox(height: size.height*0.02,),
                CustomTextField(
                  height: size.height*0.05,
                  borderRadius: size.height*0.01,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  controller: desController,
                  withValidation: headline.titles!.isEmpty,
                  hintText: translate(context, "details"),
                  helperText: translate(context, "thereIsNoNeedForDetailsIfTheMainTitleContainsSubheadings"),
                ),
                SizedBox(height: size.height*0.02,),
                if(widget.headline!=null&&widget.orderIndex!=null)
                CustomTextField(
                  height: size.height*0.05,
                  borderRadius: size.height*0.01,
                  controller: orderController,
                  readOnly: true,
                  onChanged: (str){
                    orderIndex = int.tryParse(str);
                  },
                  dropList: List<String>.generate(widget.orderIndex!-1, (i) => "${i + 1}"),
                  hintText: translate(context, "order"),
                ),

                SizedBox(height: size.height*0.06,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translate(context, "subTitles"),
                      style: TextStyle(
                          fontSize: size.height*0.022,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600]
                      ),
                    ),
                    CustomInkwell(
                      onTap: (){
                        FocusScope.of(context).unfocus();

                        openNewPage(context, AddEditTitleScreen(titleAppBar: titleArController.text,)).then((value) {
                          if(value!=null&&value is TitleLine) {
                            setState(() {
                            headline.titles!.add(value);
                          });
                          }
                        });
                      },
                      child: Icon(
                        Icons.add_circle,
                        color: kPrimaryColor,
                        size: size.height*0.03,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height*0.3,
                  child: ListView.builder(
                    itemCount: headline.titles!.length,
                    padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
                    itemBuilder: (_,index){
                      return Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ListTile(
                          onTap: (){
                            FocusScope.of(context).unfocus();
                            openNewPage(context, AddEditTitleScreen(titleLine: headline.titles![index],titleAppBar: titleArController.text)).then((value) {
                              if(value!=null&&value is TitleLine){
                                setState(() {
                                  headline.titles![index] = value;
                                });
                              }
                            });
                          },
                          trailing: Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: size.height*0.02,
                          ),
                          leading: CustomInkwell(
                            onTap: (){
                              Utils.showSureAlertDialog(
                                  onSubmit: (){
                                    setState(() {
                                      headline.titles!.remove(headline.titles![index]);
                                    });
                                  }
                              );

                            },
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(end: size.width*0.01),
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                                size: size.height*0.02,
                              ),
                            ),
                          ),
                          title: Text(
                            Localizations.localeOf(context).languageCode=="ar"?headline.titles![index].labelAr!:headline.titles![index].labelEn??headline.titles![index].labelAr!,
                            style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.w500),
                          ),

                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: size.height*0.05,),
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
     FocusScope.of(context).unfocus();
     headline.labelAr = titleArController.text;
     headline.labelEn = titleEnController.text.isNotEmpty?titleEnController.text:null;
     headline.des = desController.text;
     if(widget.headline==null) {
       headline.orderIndex = widget.orderIndex;
     }
     else if(orderIndex!=null&&orderIndex!=widget.headline!.orderIndex){
       context.read<HeadlineController>().changeOrderIndex(
         orderIndex!,widget.headline!.orderIndex!
       );
     }
     Utils.showWaitingProgressDialog();
     widget.headline==null
        ?await context.read<HeadlineController>().insertHeadline(headline: headline)
        :await context.read<HeadlineController>().updateHeadline(headline);
     Utils.hideWaitingProgressDialog();
     Navigator.pop(context,);

  }



}
