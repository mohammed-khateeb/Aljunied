import 'dart:io';

import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/bid_controller.dart';
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
import '../../Controller/admin_controller.dart';
import '../../Widgets/reusable_cache_network_image.dart';

class AddEditBidScreen extends StatefulWidget {
  final Bid? bid;
  const AddEditBidScreen({Key? key, this.bid}) : super(key: key);

  @override
  State<AddEditBidScreen> createState() => _AddEditBidScreenState();
}

class _AddEditBidScreenState extends State<AddEditBidScreen> {
  TextEditingController bidTypeController = TextEditingController();
  TextEditingController bidStatusController = TextEditingController();
  TextEditingController bidTitleController = TextEditingController();
  TextEditingController bidDetailsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? bidTypeId;
  Bid bid = Bid();

  final ImagePicker _picker = ImagePicker();
  File? picture;

  @override
  void initState() {
    if(context.read<AdminController>().waitingBidType){
      context.read<AdminController>().getAllBidTypes();
    }
    if(widget.bid!=null){
      setState(() {
        bid = widget.bid!;
        bidTypeController.text = widget.bid!.type!;
        bidTitleController.text = widget.bid!.title!;
        bidStatusController.text = widget.bid!.forwarded==true
            ?translate(Utils.navKey.currentContext!, "submittedBids"):translate(Utils.navKey.currentContext!, "availableBids");
        bidDetailsController.text = widget.bid!.details??"";
        bidTypeId = widget.bid!.typeId!;
        bid.forwarded = widget.bid!.forwarded!;
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
        title: translate(context, "addBids"),
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
                    labelText: translate(context, "bidType"),
                    controller: bidTypeController,
                    dropBidsTypes: context.watch<AdminController>().bidTypes,
                    readOnly: true,
                    withValidation: true,
                    onSelectBidType: (type){
                      bidTypeId = type.id!;
                      bid.typeId = type.id!;
                    },

                  ),
                  SizedBox(height: size.height*0.02,),
                  CustomTextField(
                    labelText: translate(context, "bidTitle"),
                    controller: bidTitleController,
                    withValidation: true,
                    suffixIcon: Image.asset(
                      "icons/document.png",
                      color: Colors.grey[700],
                      height: size.height*0.001,
                    ),
                  ),
                  SizedBox(height: size.height*0.02,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: size.height*0.005),
                        child: Text(
                          translate(context, "bidPicture"),
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
                              :widget.bid!=null
                              ?ReusableCachedNetworkImage(
                            imageUrl: widget.bid!.imageUrl,
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
                    labelText: translate(context, "status"),
                    controller: bidStatusController,
                    dropList: [
                      translate(context,"availableBids"),
                      translate(context,"submittedBids")
                    ],
                    onChanged: (str){
                      if(str == translate(context, "availableBids")){
                        bid.forwarded = false;
                      }
                      else{
                        bid.forwarded = true;
                      }
                    },
                    readOnly: true,
                    withValidation: true,

                  ),
                  SizedBox(height: size.height*0.02,),

                  CustomTextField(
                    labelText: translate(context, "bidDetails"),
                    hintText: translate(context, "details"),
                    controller: bidDetailsController,
                    minLines: 5,
                    keyboardType: TextInputType.multiline,
                    withValidation: true,

                  ),
                  SizedBox(height: size.height*0.04,),
                  CustomButton(
                    label:widget.bid!=null?translate(context, "edit"): translate(context, "share"),
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
    if (picture == null&&widget.bid==null) {
      Utils.showErrorAlertDialog(
          translate(context, "pleaseUploadAnImage"));
      return;
    }
    Utils.showWaitingProgressDialog();
    if(widget.bid!=null&&picture!=null){
      await GeneralApi.deleteFileByUrl(url: widget.bid!.imageUrl!);
    }
    if(picture!=null) {

      String url = await GeneralApi.saveOneImage(
        file: picture!, folderPath: 'Bid-images');
    bid.imageUrl = url;

    }
    bid.details = bidDetailsController.text;
    bid.title = bidTitleController.text;
    bid.type = bidTypeController.text;

    widget.bid!=null
        ?await context.read<BidController>().updateBid(bid)
        :await context.read<BidController>().insertBid(bid: bid);

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
