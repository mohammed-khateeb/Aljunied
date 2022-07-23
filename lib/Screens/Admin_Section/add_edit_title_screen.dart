import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/headline.dart';
import 'package:flutter/material.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/custom_text_field.dart';
import 'add_edit_subtitle_screen.dart';

class AddEditTitleScreen extends StatefulWidget {
  final TitleLine? titleLine;
  final String? titleAppBar;

  const AddEditTitleScreen({Key? key, this.titleLine, this.titleAppBar}) : super(key: key);

  @override
  State<AddEditTitleScreen> createState() => _AddEditTitleScreenState();
}

class _AddEditTitleScreenState extends State<AddEditTitleScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  TitleLine titleLine = TitleLine(subTitles: []);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if(widget.titleLine!=null) {
      titleLine = widget.titleLine!;
      titleController.text = widget.titleLine!.label!;
      desController.text = widget.titleLine!.des??"";
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:  CustomAppBar(
        title: widget.titleAppBar,
      ),
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
                  controller: titleController,
                  hintText: translate(context, "subTitle"),
                  withValidation: true,
                ),
                SizedBox(height: size.height*0.02,),
                CustomTextField(
                  height: size.height*0.05,
                  borderRadius: size.height*0.01,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  controller: desController,
                  hintText: translate(context, "details"),
                  withValidation: titleLine.subTitles!.isEmpty,
                ),

                SizedBox(height: size.height*0.06,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       translate(context, "subSubTitles"),
                //       style: TextStyle(
                //           fontSize: size.height*0.022,
                //           fontWeight: FontWeight.w600,
                //           color: Colors.grey[600]
                //       ),
                //     ),
                //     CustomInkwell(
                //       onTap: (){
                //         FocusScope.of(context).unfocus();
                //         openNewPage(context, AddEditSubTitleScreen(titleAppBar: titleController.text,)).then((value) {
                //           if(value!=null && value is SubTitle) {
                //             setState(() {
                //               titleLine.subTitles!.add(value);
                //             });
                //           }
                //         });
                //       },
                //       child: Icon(
                //         Icons.add_circle,
                //         color: kPrimaryColor,
                //         size: size.height*0.03,
                //       ),
                //     )
                //   ],
                // ),

                  SizedBox(
                    height: size.height*0.4,
                    child: ListView.builder(
                      itemCount: titleLine.subTitles!.length,
                      padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
                      itemBuilder: (_,index){
                        return ListTile(
                          onTap: (){
                            FocusScope.of(context).unfocus();

                            openNewPage(context, AddEditSubTitleScreen(subTitle: titleLine.subTitles![index],titleAppBar: titleController.text)).then((value) {
                              if(value!=null&&value is SubTitle){
                                setState(() {
                                  titleLine.subTitles![index] = value;
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
                                      titleLine.subTitles!.remove(titleLine.subTitles![index]);
                                    });
                                  }
                              );

                            },
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                              size: size.height*0.02,
                            ),
                          ),
                          title: Text(
                            titleLine.subTitles![index].label!,
                            style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.w500),
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



    else{
      FocusScope.of(context).unfocus();
      titleLine.label = titleController.text;
      titleLine.des = desController.text;
      Navigator.pop(context, titleLine);
    }

  }



}
