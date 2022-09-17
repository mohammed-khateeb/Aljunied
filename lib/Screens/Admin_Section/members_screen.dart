import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/member.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:flutter/foundation.dart' as web;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../Controller/admin_controller.dart';
import '../../Dialogs/add_new_category.dart';
import '../../Dialogs/add_new_member_dialog.dart';
import '../../Models/category.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/reusable_cache_network_image.dart';
import '../../Widgets/waiting_widget.dart';
import 'edit_category_screen.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {

  @override
  void initState() {
    context.read<AdminController>().getAllMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return web.kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      buttonLabel: translate(context, "add"),
      onPressButton: ()=>addMember(context: context),
      title: translate(context, "municipalityMembers"),
      body: Consumer<AdminController>(
          builder: (context, adminController, child) {
            return !adminController.waitingMembers? ListView.builder(
              itemCount: adminController.members!.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              itemBuilder: (_,index){
                return Card(
                  elevation: 0.5,
                  child: ListTile(

                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15
                    ),
                    leading: ReusableCachedNetworkImage(
                      imageUrl: adminController.members![index].imageUrl,
                      height: 40,
                      width: 40,
                      borderRadius: BorderRadius.circular(5),
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      adminController.members![index].name!.toUpperCase(),
                      style:  TextStyle(
                          fontSize: 16,
                        color: adminController.members![index].isBoss==true?Colors.red:null,
                        fontWeight: adminController.members![index].isBoss==true?FontWeight.bold:null,

                      ),
                    ),
                    trailing: CustomInkwell(
                      onTap: ()=>removeMember(adminController.members![index].id!),
                      child: const Icon(
                        FontAwesomeIcons.timesCircle,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),

                  ),
                );
              },
            ):const WaitingWidget();
          }
      ),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "municipalityMembers"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addMember(context: context);
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
              return !adminController.waitingMembers? ListView.builder(
                itemCount: adminController.members!.length,
                padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
                itemBuilder: (_,index){
                  return Card(
                    elevation: 0.5,
                    child: ListTile(

                      contentPadding: EdgeInsets.symmetric(
                          vertical: size.height*0.01,
                          horizontal: size.width*0.03
                      ),
                      leading: ReusableCachedNetworkImage(
                        imageUrl: adminController.members![index].imageUrl,
                        height: size.height*0.05,
                        width: size.height*0.05,
                        borderRadius: BorderRadius.circular(5),
                        fit: BoxFit.contain,
                      ),
                      title: Text(
                        adminController.members![index].name!.toUpperCase(),
                        style: TextStyle(
                          color: adminController.members![index].isBoss==true?Colors.red:null,
                            fontWeight: adminController.members![index].isBoss==true?FontWeight.bold:null,
                            fontSize: size.height*0.02
                        ),
                      ),
                      trailing: CustomInkwell(
                        onTap: ()=>removeMember(adminController.members![index].id!),
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

  Future<void> addMember({required BuildContext context}) async {

    Member member = Member();
    List<String>? membersString;
    if(context.read<AdminController>().members!=null&&context.read<AdminController>().members!.isNotEmpty) {
      membersString = context
          .read<AdminController>()
          .members!
          .map((e) => e.name!.replaceAll(" ", "").toLowerCase())
          .toList();
    }

    dynamic result = await showDialog(context: context,builder: (_) => AddNewMemberDialog(membersName: membersString,));





    if(result is String){



      member.imageUrl = result.split("**").first;

      member.name = result.split("**")[1];

      member.isBoss = result.split("**")[2]=="1";
      member.des = result.split("**").last;

      Utils.showWaitingProgressDialog();


      await context.read<AdminController>().addNewMember(member);

      Utils.hideWaitingProgressDialog();


    }
  }


  removeMember(String memberId){
    Utils.showSureAlertDialog(
        onSubmit: (){
          context.read<AdminController>().removeMember(memberId);
        }
    );
  }


}

