import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../Controller/admin_controller.dart';
import '../../Dialogs/add_edit_complaint_type.dart';
import '../../Models/complaint.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/waiting_widget.dart';

class ComplaintTypesScreen extends StatefulWidget {
  const ComplaintTypesScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintTypesScreen> createState() => _ComplaintTypesScreenState();
}

class _ComplaintTypesScreenState extends State<ComplaintTypesScreen> {




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
        title: translate(context, "complaintsTypes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addComplaintType(context: context);
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
              return !adminController.waitingComplaintType? ListView.builder(
                itemCount: adminController.complaintTypes!.length,
                padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
                itemBuilder: (_,index){
                  return Card(
                    elevation: 0.5,
                    child: ListTile(
                      onTap: (){
                        editComplaintType(context: context,complaintType: adminController.complaintTypes![index]);
                      },
                      contentPadding: EdgeInsets.symmetric(
                          vertical: size.height*0.01,
                          horizontal: size.width*0.03
                      ),
                      leading: Text(
                        "${index+1} - ",
                        style: TextStyle(
                            fontSize: size.height*0.02
                        ),
                      ),
                      title: Text(
                        adminController.complaintTypes![index].name!.toUpperCase(),
                        style: TextStyle(
                            fontSize: size.height*0.02
                        ),
                      ),
                      trailing: CustomInkwell(
                        onTap: ()=>removeComplaintType(adminController.complaintTypes![index].id!),
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

  Future<void> addComplaintType({required BuildContext context}) async {

    ComplaintType complaintType = ComplaintType();
    List<String>? complaintsStringAr;
    if(context.read<AdminController>().complaintTypes!=null&&context.read<AdminController>().complaintTypes!.isNotEmpty) {
      complaintsStringAr = context
          .read<AdminController>()
          .complaintTypes!
          .map((e) => e.name!.replaceAll(" ", "").toLowerCase())
          .toList();
    }

    dynamic result = await showDialog(context: context,builder: (_) => AddEditComplaintTypeDialog(typesStringAr: complaintsStringAr,));





    if(result is String){



      complaintType.name = result;


      Utils.showWaitingProgressDialog();


      await context.read<AdminController>().addNewComplaintType(complaintType);

      Utils.hideWaitingProgressDialog();


    }
  }

  Future<void> editComplaintType({required BuildContext context,required ComplaintType complaintType}) async {



    List<String> typesStringAr = context.read<AdminController>().complaintTypes!
        .map((e) => e.name!.replaceAll(" ", "").toLowerCase()).toList();

    typesStringAr.removeWhere((element) =>element == complaintType.name);

    dynamic result = await showDialog(context: context,builder: (_) => AddEditComplaintTypeDialog(typesStringAr: typesStringAr,complaintType: complaintType,));

    if(result is String){


      complaintType.name = result;

      context.read<AdminController>().editComplaintType(complaintType);




    }
  }

  removeComplaintType(String complaintTypeId){
    Utils.showSureAlertDialog(
        onSubmit: (){
          context.read<AdminController>().removeComplaintType(complaintTypeId);
        }
    );
  }


}

