import 'dart:io';
import 'dart:typed_data';

import 'package:aljunied/Apis/general_api.dart';
import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Controller/admin_controller.dart';
import 'package:aljunied/Models/complaint.dart';
import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Constants/constants.dart';
import '../Controller/complaint_controller.dart';
import '../Widgets/custom_text_field.dart';

class MakeComplaintScreen extends StatefulWidget {
  final int kind;
  const MakeComplaintScreen({Key? key, required this.kind}) : super(key: key);

  @override
  State<MakeComplaintScreen> createState() => _MakeComplaintScreenState();
}

class _MakeComplaintScreenState extends State<MakeComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  Complaint complaint = Complaint();

  final ImagePicker _picker = ImagePicker();
  File? picture;

  ///for web
  FilePickerResult? pickedFile;
  Uint8List? pictureBase64;



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
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title:widget.kind==1
          ?translate(context, "askTheMunicipality")
          : widget.kind==2
          ?translate(context, "suggestion")
          : widget.kind==3
          ?translate(context, "makeAComplaint")
          :widget.kind==4
          ?translate(context, "report")
          :widget.kind==5
          ?translate(context, "tribute")
          :widget.kind==6
          ?translate(context, "requestToPutAGarbageContainer")
          :widget.kind==7
          ?translate(context, "requestToPruneTreesOutsideTheHouse")
          :widget.kind==8
          ?translate(context, "lightingRequestInstallationOfACompleteArm")
          :translate(context, "requestForLightingMaintenanceBurntOutLamp"),
      subTitle:widget.kind==3? translate(context, "pleaseFillOutTheFollowingFormToFileAComplaint"):null,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
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
              padding: const EdgeInsets.symmetric(vertical: 10),
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
              padding: const EdgeInsets.symmetric(vertical: 10),
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
            if(widget.kind==3)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
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
            if(CurrentUser.userId!=null&&(widget.kind==3||widget.kind==4))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        translate(context, "uploadPhoto"),
                        style: TextStyle(
                            fontSize:16,
                            color: Colors.grey[850]
                        ),
                      ),
                    ),
                    CustomInkwell(
                      onTap: () async {
                        pickedFile = await FilePicker.platform.pickFiles();
                        if (pickedFile != null) {
                          try {
                            setState(() {
                              pictureBase64 = pickedFile!.files.first.bytes;
                            });
                          } catch (err) {
                            print(err);
                          }
                        } else {
                          print('No Image Selected');
                        }
                      },
                      child: DottedBorder(
                        strokeCap: StrokeCap.butt,
                        dashPattern: const [7],
                        color: Colors.grey,
                        child: SizedBox(
                          height: 140,
                          child:pictureBase64!=null?Image.memory(pictureBase64!,width: size.width,): Center(
                            child: Text(
                              translate(context, "uploadPhoto"),
                              style: TextStyle(
                                  fontSize: 17,
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
            widget.kind!=6&&widget.kind!=7&&widget.kind!=8&&widget.kind!=9?Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CustomTextField(
                labelText:widget.kind==1
                    ?translate(context, "theQuestion")
                    : widget.kind==2
                    ?translate(context, "suggestion")
                    : widget.kind==3
                    ?translate(context, "explanationOfTheComplaint")
                    :widget.kind==4
                    ?translate(context, "report")
                    :translate(context, "tribute"),
                controller: complaintDesController,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                withValidation: true,

              ),
            ):Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CustomTextField(
                labelText:translate(context, "locationLinkFromTheMap"),
                controller: complaintDesController,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                withValidation: true,

              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: translate(context, "send"),
              onPress: (){
                submit();
              },
            ),
            const SizedBox(height: 20,),

          ],
        ),
      ),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(

        titleColor: Colors.white,
        arrowColor: Colors.white,
        title:widget.kind==1
            ?translate(context, "askTheMunicipality")
            : widget.kind==2
            ?translate(context, "suggestion")
            : widget.kind==3
          ?translate(context, "makeAComplaint")
            :widget.kind==4
            ?translate(context, "report")
            :widget.kind==5
            ?translate(context, "tribute")
            :widget.kind==6
            ?translate(context, "requestToPutAGarbageContainer")
            :widget.kind==7
            ?translate(context, "requestToPruneTreesOutsideTheHouse")
              :widget.kind==8
          ?translate(context, "lightingRequestInstallationOfACompleteArm")
            :translate(context, "requestForLightingMaintenanceBurntOutLamp"),
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
                  if(widget.kind==3)
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
                  if(widget.kind==3)
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
                  if(CurrentUser.userId!=null&&(widget.kind==3||widget.kind==4))
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
                  widget.kind!=6&&widget.kind!=7&&widget.kind!=8&&widget.kind!=9?
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                    child: CustomTextField(
                      labelText:widget.kind==1
                          ?translate(context, "theQuestion")
                          : widget.kind==2
                          ?translate(context, "suggestion")
                          : widget.kind==3
                          ?translate(context, "explanationOfTheComplaint")
                          :widget.kind==4
                          ?translate(context, "report")
                          :translate(context, "tribute"),
                      controller: complaintDesController,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      withValidation: true,

                    ),
                  ):Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                    child: CustomTextField(
                      labelText:translate(context, "locationLinkFromTheMap"),
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
    complaint.kind = widget.kind;
    complaint.token = CurrentUser.token;
    Utils.showWaitingProgressDialog();
    if(picture!=null) {
      String url = await GeneralApi.saveOneImage(file: picture!, folderPath: "Complaint");
      complaint.imageUrl = url;

    }
    if(pictureBase64!=null) {
      String url = await GeneralApi.saveOneImage(pictureWeb: pictureBase64!, folderPath: "Complaint");
      complaint.imageUrl = url;

    }
    await context.read<ComplaintController>().insertComplaint(complaint: complaint);
    Utils.hideWaitingProgressDialog();
    Navigator.pop(context);
    Utils.showSuccessAlertDialog(
        widget.kind==3
            ?translate(context, "complaintWasSubmittedSuccessfullyItWillBeConsideredByTheAdministrator")
            :translate(context, "sendingSuccessfully"),
        bottom: !kIsWeb||MediaQuery.of(Utils.navKey.currentContext!).size.width<520
    );
  }

  _showBottomSheet({required BuildContext context}) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Column(
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
          );
        });
  }

}
