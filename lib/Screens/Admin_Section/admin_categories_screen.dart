import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../Controller/admin_controller.dart';
import '../../Dialogs/add_new_category.dart';
import '../../Models/category.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/reusable_cache_network_image.dart';
import '../../Widgets/waiting_widget.dart';
import 'edit_category_screen.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {



  @override
  void initState() {
    context.read<AdminController>().getAllCategories();
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
        title: translate(context, "transactionsTypes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addCategory(context: context);
        },
        child:  Icon(
          Icons.add,
          color: Colors.white,
          size: size.height*0.04,
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child: Consumer<AdminController>(
            builder: (context, adminController, child) {
              return !adminController.waitingCategories? ListView.builder(
                itemCount: adminController.categories!.length,
                padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
                itemBuilder: (_,index){
                  return Card(
                    elevation: 0.5,
                    child: ListTile(
                      onTap: (){
                        editCategory(context: context,category: adminController.categories![index]);
                      },
                      contentPadding: EdgeInsets.symmetric(
                          vertical: size.height*0.01,
                          horizontal: size.width*0.03
                      ),
                      leading: ReusableCachedNetworkImage(
                        imageUrl: adminController.categories![index].imageUrl,
                        height: size.height*0.05,
                        width: size.height*0.05,
                        borderRadius: BorderRadius.circular(5),
                        fit: BoxFit.contain,
                      ),
                      title: Text(
                        adminController.categories![index].nameAr!.toUpperCase(),
                        style: TextStyle(
                            fontSize: size.height*0.02
                        ),
                      ),
                      trailing: CustomInkwell(
                        onTap: ()=>removeCategory(adminController.categories![index].id!),
                        child: Icon(
                          FontAwesomeIcons.timesCircle,
                          color: Colors.red,
                          size: size.height*0.03,
                        ),
                      ),

                    ),
                  );
                },
              ):const WaitingWidget();
            }
        ),
      ),
    );
  }

  Future<void> addCategory({required BuildContext context}) async {

    Category specialty = Category();
    List<String>? categoriesStringAr;
    if(context.read<AdminController>().categories!=null&&context.read<AdminController>().categories!.isNotEmpty) {
      categoriesStringAr = context
          .read<AdminController>()
          .categories!
          .map((e) => e.nameAr!.replaceAll(" ", "").toLowerCase())
          .toList();
    }

    dynamic result = await showDialog(context: context,builder: (_) => AddNewCategoryDialog(categoriesName: categoriesStringAr,));





    if(result is String){



      specialty.imageUrl = result.split("**").first;

      specialty.nameAr = result.split("**").last;

      Utils.showWaitingProgressDialog();


      await context.read<AdminController>().addNewCategory(specialty);

      Utils.hideWaitingProgressDialog();


    }
  }

  Future<void> editCategory({required BuildContext context,required Category category}) async {

    dynamic result = await openNewPage(context, EditCategoryScreen(category: category));


    List categoriesStringAr = context.read<AdminController>().categories!
        .map((e) => e.nameAr!.replaceAll(" ", "").toLowerCase()).toList();

    categoriesStringAr.removeWhere((element) =>element == category.nameAr);


    if(result is Category){

      if(categoriesStringAr.contains(result.nameAr!.replaceAll(" ", "").toLowerCase())){
        Utils.showErrorAlertDialog(translate(context, "thisNameExistsPleaseChooseAnotherName"));
        return;
      }

      category.imageUrl = result.imageUrl;

      category.nameAr = result.nameAr;

      context.read<AdminController>().editCategory(category);




    }
  }

  removeCategory(String specialtyId){
    Utils.showSureAlertDialog(
        onSubmit: (){
          context.read<AdminController>().removeCategory(specialtyId);
        }
    );
  }


}

