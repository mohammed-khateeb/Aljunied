import 'dart:io';
import 'dart:typed_data';
import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/news_controller.dart';
import 'package:aljunied/Models/news.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:aljunied/Widgets/custom_text_field.dart';
import 'package:aljunied/Widgets/reusable_cache_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Apis/general_api.dart';

class AddEditNewsScreen extends StatefulWidget {
  final News? news;
  final int? orderIndex;

  const AddEditNewsScreen({Key? key, this.news, this.orderIndex}) : super(key: key);

  @override
  State<AddEditNewsScreen> createState() => _AddEditNewsScreenState();
}

class _AddEditNewsScreenState extends State<AddEditNewsScreen> {

  int? orderIndex;

  TextEditingController newsTitleController = TextEditingController();
  TextEditingController newsDetailsController = TextEditingController();
  TextEditingController facebookUrlController = TextEditingController();
  TextEditingController twitterUrlController = TextEditingController();
  TextEditingController instagramUrlController = TextEditingController();
  TextEditingController snapchatUrlController = TextEditingController();
  TextEditingController orderController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ///for web
  FilePickerResult? pickedFile;
  Uint8List? pictureBase64;

  News news = News();

  final ImagePicker _picker = ImagePicker();
  File? picture;

  @override
  void initState() {
    if(widget.news!=null){
      setState(() {
        news = widget.news!;
        newsTitleController.text = widget.news!.title!;
        newsDetailsController.text = widget.news!.details!;
        facebookUrlController.text = widget.news!.facebookLink?? "";
        twitterUrlController.text = widget.news!.twitterLink??"";
        snapchatUrlController.text = widget.news!.snapchatLink??"";
        instagramUrlController.text = widget.news!.instagramLink??"";
        orderIndex = widget.news!.orderIndex;
        orderController.text = widget.news!.orderIndex.toString();



      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "addNews"),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              labelText: translate(context, "newsTitle"),
              controller: newsTitleController,
              suffixIcon: Image.asset(
                "icons/document.png",
                color: Colors.grey[700],
                height: size.height*0.001,
              ),
              withValidation: true,

            ),
            SizedBox(height: size.height*0.02,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 7),
                  child: Text(
                    translate(context, "newsPicture"),
                    style: TextStyle(
                        fontSize: 16,
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
                  child: Card(
                    elevation: 7,
                    shadowColor: Colors.white,
                    child:pictureBase64!=null?Image.memory(pictureBase64!,height:120,width: size.width,)
                        :widget.news!=null
                        ?ReusableCachedNetworkImage(
                      imageUrl: widget.news!.imageUrl,
                      height: 120,
                      width: size.width,

                    )
                        : Image.asset(
                      "images/browse.png",
                      height: 120,
                      width: size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: size.height*0.02,),


            CustomTextField(
              labelText: translate(context, "theTextOfTheNews"),
              hintText: translate(context, "theTextOfTheNews"),
              controller: newsDetailsController,
              minLines: 5,
              keyboardType: TextInputType.multiline,
              withValidation: true,

            ),
            SizedBox(height: size.height*0.02,),
            if(widget.news!=null&&widget.orderIndex!=null)
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
            SizedBox(height: size.height*0.02,),
            CustomTextField(
              labelText: translate(context, "facebookLink"),
              controller: facebookUrlController,
              suffixIcon: Image.asset(
                "icons/facebook.png",
                height: size.height*0.001,
              ),

            ),
            SizedBox(height: size.height*0.02,),
            CustomTextField(
              labelText: translate(context, "snapchatLink"),
              controller: snapchatUrlController,
              suffixIcon: Image.asset(
                "icons/snapchat.png",
                height: size.height*0.001,
              ),

            ),
            SizedBox(height: size.height*0.02,),
            CustomTextField(
              labelText: translate(context, "twitterLink"),
              controller: twitterUrlController,
              suffixIcon: Image.asset(
                "icons/twitter.png",
                height: size.height*0.001,
              ),

            ),
            SizedBox(height: size.height*0.02,),
            CustomTextField(
              labelText: translate(context, "instagramLink"),
              controller: instagramUrlController,
              suffixIcon: Image.asset(
                "icons/instagram.png",
                height: size.height*0.001,
              ),

            ),
            SizedBox(height: size.height*0.04,),

            CustomButton(
              label:widget.news!=null?translate(context, "edit"): translate(context, "add"),
              onPress: ()=>submit(),
            )
          ],
        ),
      ),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        title: translate(context, "addNews"),
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
                    labelText: translate(context, "newsTitle"),
                    controller: newsTitleController,
                    suffixIcon: Image.asset(
                      "icons/document.png",
                      color: Colors.grey[700],
                      height: size.height*0.001,
                    ),
                    withValidation: true,

                  ),
                  SizedBox(height: size.height*0.02,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: size.height*0.005),
                        child: Text(
                          translate(context, "newsPicture"),
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
                              :widget.news!=null
                              ?ReusableCachedNetworkImage(
                            imageUrl: widget.news!.imageUrl,
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
                    labelText: translate(context, "theTextOfTheNews"),
                    hintText: translate(context, "theTextOfTheNews"),
                    controller: newsDetailsController,
                    minLines: 5,
                    keyboardType: TextInputType.multiline,
                    withValidation: true,

                  ),
                  SizedBox(height: size.height*0.02,),
                  if(widget.news!=null&&widget.orderIndex!=null)
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
                  SizedBox(height: size.height*0.02,),
                  CustomTextField(
                    labelText: translate(context, "facebookLink"),
                    controller: facebookUrlController,
                    suffixIcon: Image.asset(
                      "icons/facebook.png",
                      height: size.height*0.001,
                    ),

                  ),
                  SizedBox(height: size.height*0.02,),
                  CustomTextField(
                    labelText: translate(context, "snapchatLink"),
                    controller: snapchatUrlController,
                    suffixIcon: Image.asset(
                      "icons/snapchat.png",
                      height: size.height*0.001,
                    ),

                  ),
                  SizedBox(height: size.height*0.02,),
                  CustomTextField(
                    labelText: translate(context, "twitterLink"),
                    controller: twitterUrlController,
                    suffixIcon: Image.asset(
                      "icons/twitter.png",
                      height: size.height*0.001,
                    ),

                  ),
                  SizedBox(height: size.height*0.02,),
                  CustomTextField(
                    labelText: translate(context, "instagramLink"),
                    controller: instagramUrlController,
                    suffixIcon: Image.asset(
                      "icons/instagram.png",
                      height: size.height*0.001,
                    ),

                  ),
                  SizedBox(height: size.height*0.04,),

                  CustomButton(
                    label:widget.news!=null?translate(context, "edit"): translate(context, "add"),
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
    if (picture == null&&widget.news==null&&!kIsWeb) {
      Utils.showErrorAlertDialog(
          translate(context, "pleaseUploadAnImage"));
      return;
    }

    if (pictureBase64 == null&&kIsWeb) {
      Utils.showErrorAlertDialog(
          translate(context, "pleaseUploadAnImage"));
      return;
    }

    Utils.showWaitingProgressDialog();

    if(widget.news!=null&&picture!=null&&!kIsWeb||(widget.news!=null&&pictureBase64!=null&&kIsWeb)){
      await GeneralApi.deleteFileByUrl(url: widget.news!.imageUrl!);
    }
    if(picture!=null) {
      String url = await GeneralApi.saveOneImage(
        file: picture!, folderPath: 'News-images');
      news.imageUrl = url;

    }

    if(pictureBase64!=null) {
      String url = await GeneralApi.saveOneImage(pictureWeb: pictureBase64!, folderPath: "News-images");
      news.imageUrl = url;

    }
    news.details = newsDetailsController.text;
    news.title = newsTitleController.text;
    news.facebookLink =facebookUrlController.text.isNotEmpty? facebookUrlController.text:null;
    news.instagramLink =instagramUrlController.text.isNotEmpty? instagramUrlController.text:null;
    news.twitterLink =twitterUrlController.text.isNotEmpty? twitterUrlController.text:null;
    news.snapchatLink =snapchatUrlController.text.isNotEmpty? snapchatUrlController.text:null;
    if(widget.news==null) {
      news.orderIndex = widget.orderIndex;
    }
    else if(orderIndex!=null&&orderIndex!=widget.news!.orderIndex){
      context.read<NewsController>().changeOrderIndex(
          orderIndex!,widget.news!.orderIndex!
      );
    }
    widget.news!=null
        ?await context.read<NewsController>().updateNews(news)
        :await context.read<NewsController>().insertNews(news: news);

    Utils.hideWaitingProgressDialog();
    Navigator.pop(context);

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
