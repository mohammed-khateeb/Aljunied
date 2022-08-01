import 'dart:io';
import 'dart:typed_data';
import 'package:aljunied/Apis/general_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Models/category.dart';
import '../Utils/util.dart';
import '../Widgets/custom_inkwell.dart';
import '../Widgets/custom_text_field.dart';

class AddNewCategoryDialog extends StatefulWidget {
  final List<String>? categoriesName;
  const AddNewCategoryDialog({Key? key, this.categoriesName}) : super(key: key);

  @override
  State<AddNewCategoryDialog> createState() => _AddNewCategoryDialogState();
}

class _AddNewCategoryDialogState extends State<AddNewCategoryDialog> {
  final TextEditingController nameArController = TextEditingController();
  XFile? image;

  final ImagePicker _picker = ImagePicker();
  ///for web
  FilePickerResult? pickedFile;
  Uint8List? pictureBase64;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Text(translate(context,"addATransactionType"),style: TextStyle(
        fontWeight: FontWeight.normal,fontSize:kIsWeb&&size.width>520?16: size.height * 0.018),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomInkwell(
            onTap: () async {
              if(kIsWeb){
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
              }
              else{
                _picker.pickImage(source: ImageSource.gallery).then((value) {
                  if(value!=null){
                    setState(() {
                      image = value;
                    });
                  }
                });
              }

            },
            child: Container(
              height:kIsWeb&&size.width>520?80: size.height*0.12,
              width:kIsWeb&&size.width>520?80: size.height*0.12,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]!),
                  shape: kIsWeb&&size.width>520?BoxShape.rectangle:BoxShape.circle,
                  image:kIsWeb&&pictureBase64!=null?
                  DecorationImage(image: MemoryImage(pictureBase64!)):image!=null? DecorationImage(
                      image: FileImage(
                        File(
                            image!.path
                        ),
                      ),
                      fit: BoxFit.contain
                  ):null
              ),
              child:image!=null||pictureBase64!=null?
              SizedBox()
                  :Icon(Icons.image,size:kIsWeb&&size.width>520?40: size.height*0.03,),
            ),
          ),
          SizedBox(height: size.height*0.02,),

          CustomTextField(
            height: size.height*0.05,
            borderRadius: size.height*0.01,
            controller: nameArController,
            hintText: translate(context, "nameAr"),
          ),
          const SizedBox(height: 10,),

        ],
      ),
      actions: [
        FlatButton(onPressed: () => add(context), child: Text(translate(context, "add"),style: TextStyle(
            fontWeight: FontWeight.normal,fontSize:kIsWeb&&size.width>520?14: size.height * 0.018),))
      ],
    );
  }

  Future<void> add(BuildContext context) async {
    if(image==null&&!kIsWeb){
      Utils.showErrorAlertDialog(translate(context, "pleaseUploadAnImage"));
      return;
    }
    if(pictureBase64==null&&kIsWeb){
      Utils.showErrorAlertDialog(translate(context, "pleaseUploadAnImage"));
      return;
    }
    if(nameArController.text.trim().isEmpty) {
      return;
    }
    if((widget.categoriesName!=null&&widget.categoriesName!.contains(nameArController.text.replaceAll(" ", "").toLowerCase()))){
      Utils.showErrorAlertDialog(translate(context, "thisNameExistsPleaseChooseAnotherName"));
      return;
    }
      Utils.showWaitingProgressDialog();
    String url;
    if(kIsWeb){
      url = await GeneralApi.saveOneImage(pictureWeb: pictureBase64!, folderPath: "Type of transaction");

    }
    else{
      url = await GeneralApi.saveOneImage(file: File(image!.path), folderPath: "Type of transaction");

    }
      Utils.hideWaitingProgressDialog();
      Navigator.pop(context,
          url+"**"+nameArController.text);


  }
}