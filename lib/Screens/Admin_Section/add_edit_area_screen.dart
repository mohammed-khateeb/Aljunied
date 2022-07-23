import 'dart:io';

import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/area_controller.dart';
import 'package:aljunied/Controller/bid_controller.dart';
import 'package:aljunied/Models/area.dart';
import 'package:aljunied/Models/bid.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:aljunied/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Apis/general_api.dart';
import '../../Widgets/reusable_cache_network_image.dart';

class AddEditAreaScreen extends StatefulWidget {
  final Area? area;
  const AddEditAreaScreen({Key? key, this.area}) : super(key: key);

  @override
  State<AddEditAreaScreen> createState() => _AddEditAreaScreenState();
}

class _AddEditAreaScreenState extends State<AddEditAreaScreen> {
  TextEditingController areaTitleController = TextEditingController();
  TextEditingController areaDetailsController = TextEditingController();
  TextEditingController areaLocationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Area area = Area();

  final ImagePicker _picker = ImagePicker();
  File? picture;

  @override
  void initState() {
    if(widget.area!=null){
      setState(() {
        area = widget.area!;
        areaTitleController.text = widget.area!.name!;
        areaDetailsController.text = widget.area!.des!;
        areaLocationController.text = widget.area!.location!;


      });
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        title: translate(context, "add"),
        titleColor: Colors.white,
        arrowColor: Colors.white,
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
          child: Padding(
            padding:  EdgeInsets.symmetric(
                vertical: size.height*0.03,
                horizontal: size.width*0.05
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    labelText: translate(context, "areaName"),
                    controller: areaTitleController,
                    withValidation: true,
                  ),
                  SizedBox(height: size.height*0.02,),
                  CustomTextField(
                    labelText: translate(context, "location"),
                    hintText: translate(context, "locationLinkFromTheMap"),
                    controller: areaLocationController,
                    withValidation: true,
                  ),
                  SizedBox(height: size.height*0.02,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: size.height*0.005),
                        child: Text(
                          translate(context, "areaPicture"),
                          style: TextStyle(
                              fontSize: size.height*0.02,
                              color: Colors.grey[850]
                          ),
                        ),
                      ),
                      CustomInkwell(
                        onTap: (){
                          _showBottomSheet(context: context);
                        },
                        child: Card(
                          elevation: 7,
                          shadowColor: Colors.white,
                          child:picture!=null
                              ?Image.file(
                            picture!,
                            height: size.height*0.2,
                            width: size.width,
                          )
                              :widget.area!=null
                              ?ReusableCachedNetworkImage(
                            imageUrl: widget.area!.imageUrl,
                            height: size.height*0.2,
                            width: size.width,

                          )
                              : Image.asset(
                            "images/browse.png",
                            height: size.height*0.2,
                            width: size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: size.height*0.02,),

                  CustomTextField(
                    labelText: translate(context, "details"),
                    controller: areaDetailsController,
                    withValidation: true,

                  ),
                  SizedBox(height: size.height*0.04,),

                  CustomButton(
                    label:widget.area!=null?translate(context, "edit"): translate(context, "submit"),
                    onPress: ()=>submit(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  submit() async {
    if(!_formKey.currentState!.validate()){
      return;
    }
    if (picture == null&&widget.area==null) {
      Utils.showErrorAlertDialog(
          translate(context, "pleaseUploadAnImage"));
      return;
    }
    Utils.showWaitingProgressDialog();
    if(widget.area!=null&&picture!=null){
      await GeneralApi.deleteFileByUrl(url: widget.area!.imageUrl!);
    }
    if(picture!=null) {

      String url = await GeneralApi.saveOneImage(
          file: picture!, folderPath: 'Tourist-images');
      area.imageUrl = url;

    }
    area.des = areaDetailsController.text;
    area.name = areaTitleController.text;
    area.location = areaLocationController.text;

    widget.area!=null
        ?await context.read<AreaController>().updateArea(area)
        :await context.read<AreaController>().insertArea(area: area);

    Utils.hideWaitingProgressDialog();
    Navigator.pop(context);

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
