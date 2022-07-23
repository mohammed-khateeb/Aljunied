import 'dart:io';

import 'package:aljunied/Apis/general_api.dart';
import 'package:aljunied/Controller/admin_controller.dart';
import 'package:aljunied/Models/complaint.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Constants/constants.dart';
import '../Controller/complaint_controller.dart';
import '../Widgets/custom_text_field.dart';

class MakeComplaintScreen extends StatefulWidget {
  const MakeComplaintScreen({Key? key}) : super(key: key);

  @override
  State<MakeComplaintScreen> createState() => _MakeComplaintScreenState();
}

class _MakeComplaintScreenState extends State<MakeComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  Complaint complaint = Complaint();

  final ImagePicker _picker = ImagePicker();
  File? picture;


  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController complaintDesController = TextEditingController();
  final TextEditingController complaintTypeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    context.read<AdminController>().getAllComplaintTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(

        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "makeAComplaint"),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height*0.04,),
                  Text(
                    translate(context, "pleaseFillOutTheFollowingFormToFileAComplaint"),
                    style: TextStyle(
                        fontSize: size.height*0.018,
                        color: kSubTitleColor
                    ),
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
                      validator: (str){
                        if(str!.isEmpty){
                          return translate(context, "pleaseEnterYourName");
                        }

                        return null;
                      },
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
                      validator: (str){
                        if(str!.isEmpty){
                          return translate(context, "pleaseEnterYourMobileNumber");
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                    child: CustomTextField(
                      labelText: translate(context, "theIDNumber"),
                      controller: idNumberController,
                      keyboardType: TextInputType.number,
                      digitsOnly: true,
                      charLength: 10,
                      validator: (str){
                        if(str!.isEmpty){
                          return translate(context, "pleaseEnterThisField");
                        }
                        else if(str.length!=10){
                          return translate(context, "pleaseEnterAValidNationalNumber");
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                    child: CustomTextField(
                      labelText: translate(context, "complaintType"),
                      controller: complaintTypeController,
                      readOnly: true,
                      dropComplaintsTypes: context.watch<AdminController>().complaintTypes,
                      onSelectComplaintType: (ct){
                        complaint.type = ct.name;
                        complaint.typeId = ct.id;
                      },
                      validator: (str){
                        if(str!.isEmpty){
                          return translate(context, "pleaseEnterYourMobileNumber");
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: size.height*0.005),
                          child: Text(
                            translate(context, "uploadPhoto"),
                            style: TextStyle(
                                fontSize: size.height*0.02,
                                color: Colors.grey[850]
                            ),
                          ),
                        ),
                        CustomInkwell(
                          onTap: ()=>_showBottomSheet(context: context),
                          child: DottedBorder(
                            strokeCap: StrokeCap.butt,
                            dashPattern: const [7],
                            color: Colors.grey,
                            child: SizedBox(
                              height: size.height*0.12,
                              child:picture!=null?Image.file(picture!,width: size.width,): Center(
                                child: Text(
                                  translate(context, "uploadPhotoOrFile"),
                                  style: TextStyle(
                                      fontSize: size.height*0.02,
                                      color: Colors.grey[850],
                                    decoration: TextDecoration.underline
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                    child: CustomTextField(
                      labelText: translate(context, "explanationOfTheComplaint"),
                      controller: complaintDesController,
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
    complaint.userName = nameController.text;
    complaint.citizenNumber = int.parse(idNumberController.text);
    complaint.details = complaintDesController.text;
    complaint.mobileNumber = mobileController.text;
    Utils.showWaitingProgressDialog();
    if(picture!=null) {
      String url = await GeneralApi.saveOneImage(file: picture!, folderPath: "Complaint");
      complaint.imageUrl = url;

    }
    await context.read<ComplaintController>().insertComplaint(complaint: complaint);
    Utils.hideWaitingProgressDialog();
    Navigator.pop(context);
    Utils.showSuccessAlertDialog(
        translate(context, "complaintWasSubmittedSuccessfullyItWillBeConsideredByTheAdministrator"),
        bottom: true
    );
  }

  _showBottomSheet({required BuildContext context}) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  onTap: () async {
                    final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      Navigator.pop(context);
                      setState(() {
                        picture = File(image.path);
                      });
                    }
                  },
                  title: Text(translate(context, "gallery")),
                  leading: const Icon(Icons.image),
                ),
                ListTile(
                  onTap: () async {
                    final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      Navigator.pop(context);
                      setState(() {
                        picture = File(image.path);
                      });
                    }
                  },
                  title: Text(translate(context, "camera")),
                  leading: const Icon(Icons.camera),
                )
              ],
            ),
          );
        });
  }

}
