import 'dart:io';
import 'dart:typed_data';

import 'package:aljunied/Apis/general_api.dart';
import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Widgets/reusable_cache_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' as web;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../Dialogs/add_edit_subcategory.dart';
import '../../Dialogs/add_new_category.dart';
import '../../Models/category.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/custom_text_field.dart';

class EditCategoryScreen extends StatefulWidget {
  final Category category;
  const EditCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final TextEditingController nameArController = TextEditingController();
  XFile? image;

  ///for web
  FilePickerResult? pickedFile;
  Uint8List? pictureBase64;


  final ImagePicker _picker = ImagePicker();


  @override
  void initState() {
      nameArController.text = widget.category.nameAr!;


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return web.kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      body: Column(
        children: [
          SizedBox(height: size.height*0.02,),
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
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(5),
                  image:pictureBase64!=null? DecorationImage(
                      image: MemoryImage(
                        pictureBase64!
                      ),
                      fit: BoxFit.cover
                  ):null
              ),
              child:pictureBase64!=null?
              SizedBox()
                  :widget.category.imageUrl!=null
                  ?ReusableCachedNetworkImage(
                imageUrl: widget.category.imageUrl,
                height: 200,
                width: 200,
                borderRadius: BorderRadius.circular(5),
                fit: BoxFit.contain,
              )
                  :Icon(Icons.image,size: 50,),
            ),
          ),
          SizedBox(height:20),
          CustomTextField(
            borderRadius: size.height*0.01,
            controller: nameArController,
            hintText: translate(context, "nameAr"),
          ),

          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate(context, "subTypesOfTransactions"),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600]
                ),
              ),
              CustomInkwell(
                onTap: ()=>addSubCategory(context: context),
                child: Icon(
                  Icons.add_circle,
                  color: kPrimaryColor,
                  size: 25,
                ),
              )
            ],
          ),
          if(widget.category.subcategories!=null)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.category.subcategories!.length,
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              itemBuilder: (_,index){
                return Card(
                  elevation: 0.5,
                  child: ListTile(
                    onTap: (){
                      editSubCategory(context: context,subcategory: widget.category.subcategories![index]);
                    },
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15
                    ),
                    leading: Text(
                      "${index+1} -",
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                    title: Text(
                      widget.category.subcategories![index].nameAr!.toUpperCase(),
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                    trailing: CustomInkwell(
                      onTap: (){
                        setState(() {
                          widget.category.subcategories!.remove(widget.category.subcategories![index]);
                        });
                      },
                      child: Icon(
                        FontAwesomeIcons.timesCircle,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),

                  ),
                );
              },
            ),
          SizedBox(height: 20),
          CustomButton(label: translate(context, "save"), onPress:()=> add(context)),
        ],
      ),
    )
        :Scaffold(
      appBar: CustomAppBar(),
      body:  Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width*0.03
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height*0.02,),
              CustomInkwell(
                onTap: (){
                  _picker.pickImage(source: ImageSource.gallery).then((value) {
                    if(value!=null){
                      setState(() {
                        image = value;
                      });
                    }
                  });
                },
                child: Container(
                  height: size.height*0.2,
                  width: size.height*0.2,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[700]!),
                      borderRadius: BorderRadius.circular(5),
                      image:image!=null? DecorationImage(
                          image: FileImage(
                            File(
                                image!.path
                            ),
                          ),
                          fit: BoxFit.cover
                      ):null
                  ),
                  child:image!=null?
                  SizedBox()
                      :widget.category.imageUrl!=null
                      ?ReusableCachedNetworkImage(
                    imageUrl: widget.category.imageUrl,
                    height: size.height*0.2,
                    width: size.height*0.2,
                    borderRadius: BorderRadius.circular(5),
                    fit: BoxFit.contain,
                  )
                      :Icon(Icons.image,size: size.height*0.03,),
                ),
              ),
              SizedBox(height: size.height*0.02,),
              CustomTextField(
                height: size.height*0.05,
                borderRadius: size.height*0.01,
                controller: nameArController,
                hintText: translate(context, "nameAr"),
              ),

              SizedBox(height: size.height*0.06,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate(context, "subTypesOfTransactions"),
                    style: TextStyle(
                      fontSize: size.height*0.022,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600]
                    ),
                  ),
                  CustomInkwell(
                    onTap: ()=>addSubCategory(context: context),
                    child: Icon(
                      Icons.add_circle,
                      color: kPrimaryColor,
                      size: size.height*0.03,
                    ),
                  )
                ],
              ),
              if(widget.category.subcategories!=null)
              SizedBox(
                height: size.height*0.3,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.category.subcategories!.length,
                  padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
                  itemBuilder: (_,index){
                    return Card(
                      elevation: 0.5,
                      child: ListTile(
                        onTap: (){
                          editSubCategory(context: context,subcategory: widget.category.subcategories![index]);
                        },
                        contentPadding: EdgeInsets.symmetric(
                            vertical: size.height*0.01,
                            horizontal: size.width*0.03
                        ),
                        leading: Text(
                          "${index+1} -",
                          style: TextStyle(
                              fontSize: size.height*0.02
                          ),
                        ),
                        title: Text(
                          widget.category.subcategories![index].nameAr!.toUpperCase(),
                          style: TextStyle(
                              fontSize: size.height*0.02
                          ),
                        ),
                        trailing: CustomInkwell(
                          onTap: (){
                            setState(() {
                              widget.category.subcategories!.remove(widget.category.subcategories![index]);
                            });
                          },
                          child: Icon(
                            FontAwesomeIcons.timesCircle,
                            color: Colors.red,
                            size: size.height*0.03,
                          ),
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
    );
  }

  void add(BuildContext context) async{

    if(nameArController.text.trim().isEmpty) {
      return;
    }


    else{
      Utils.showWaitingProgressDialog();
      if(image!=null) {
        if(widget.category.imageUrl!=null){
          await GeneralApi.deleteFileByUrl(url: widget.category.imageUrl!);
        }
        String url = await GeneralApi.saveOneImage(file: File(image!.path), folderPath: "Type of transaction");
        widget.category.imageUrl = url;

      }
      widget.category.nameAr = nameArController.text;
      Utils.hideWaitingProgressDialog();
      Navigator.pop(context,
          widget.category);
    }

  }
  Future<void> editSubCategory({required BuildContext context,required Subcategory subcategory}) async {


    dynamic result = await showDialog(context: context,builder: (_) => AddEditSubCategoryDialog(subcategory: subcategory,));


    List categoriesStringAr = widget.category.subcategories!
        .map((e) => e.nameAr!.replaceAll(" ", "").toLowerCase()).toList();

    categoriesStringAr.removeWhere((element) => element==subcategory.nameAr);

    if(result!=null&&result is String){



      if(categoriesStringAr.contains(result.split("**").last.replaceAll(" ", "").toLowerCase())){
        Utils.showErrorAlertDialog(translate(context, "thisNameExistsPleaseChooseAnotherName"));
        return;
      }

      setState(() {
        widget.category.subcategories??=[];
        widget.category.subcategories!.remove(subcategory);
      });


      subcategory.nameAr = result;

      subcategory.id =
      widget.category.subcategories!=null&&widget.category.subcategories!.isNotEmpty?widget.category.id!+"-"+
          "${int.parse(widget.category.subcategories!.last.id.toString().split("-").last)+1}".toString()
          :widget.category.id!+"-"+"0";


      setState(() {
        widget.category.subcategories??=[];
        widget.category.subcategories!.add(subcategory);
      });




    }
  }


  Future<void> addSubCategory({required BuildContext context}) async {

    Subcategory subcategory = Subcategory();

    dynamic result = await showDialog(context: context,builder: (_) => AddEditSubCategoryDialog());


    List? subcategoriesStringAr;

    if(widget.category.subcategories!=null&&widget.category.subcategories!.isNotEmpty) {

      subcategoriesStringAr = widget.category.subcategories!
          .map((e) => e.nameAr!.replaceAll(" ", "").toLowerCase())
          .toList();
    }

    if(result is String){



      if((subcategoriesStringAr!=null&&subcategoriesStringAr.contains(result.split("**").last.replaceAll(" ", "").toLowerCase()))){
        Utils.showErrorAlertDialog(translate(context, "thisNameExistsPleaseChooseAnotherName"));
        return;
      }



      subcategory.nameAr = result;

      subcategory.id =
          widget.category.subcategories!=null&&widget.category.subcategories!.isNotEmpty?widget.category.id!+"-"+
               "${int.parse(widget.category.subcategories!.last.id.toString().split("-").last)+1}".toString()
              :widget.category.id!+"-"+"0";

      setState(() {
        widget.category.subcategories ??= [];
        widget.category.subcategories!.add(subcategory);
      });


    }
  }

}
