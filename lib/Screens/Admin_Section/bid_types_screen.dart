import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Dialogs/add_edit_bid_type.dart';
import 'package:aljunied/Dialogs/add_edit_department.dart';
import 'package:aljunied/Models/bid.dart';
import 'package:aljunied/Models/department.dart';
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

class BidsTypesScreen extends StatefulWidget {
  const BidsTypesScreen({Key? key}) : super(key: key);

  @override
  State<BidsTypesScreen> createState() => _BidsTypesScreenState();
}

class _BidsTypesScreenState extends State<BidsTypesScreen> {




  @override
  void initState() {
    context.read<AdminController>().getAllBidTypes();
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
        title: translate(context, "bidsTypes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addBidType(context: context);
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
              return !adminController.waitingBidType? ListView.builder(
                itemCount: adminController.bidTypes!.length,
                padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
                itemBuilder: (_,index){
                  return Card(
                    elevation: 0.5,
                    child: ListTile(
                      onTap: (){
                        editBidType(context: context,bidType: adminController.bidTypes![index]);
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
                        adminController.bidTypes![index].name!.toUpperCase(),
                        style: TextStyle(
                            fontSize: size.height*0.02
                        ),
                      ),
                      trailing: CustomInkwell(
                        onTap: ()=>removeBidType(adminController.bidTypes![index].id!),
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

  Future<void> addBidType({required BuildContext context}) async {

    BidType bidType = BidType();
    List<String>? typesStringAr;
    if(context.read<AdminController>().bidTypes!=null&&context.read<AdminController>().bidTypes!.isNotEmpty) {
      typesStringAr = context
          .read<AdminController>()
          .bidTypes!
          .map((e) => e.name!.replaceAll(" ", "").toLowerCase())
          .toList();
    }

    dynamic result = await showDialog(context: context,builder: (_) => AddEditBidTypeDialog(typesStringAr: typesStringAr,));





    if(result is String){



      bidType.name = result;


      Utils.showWaitingProgressDialog();


      await context.read<AdminController>().addNewBidType(bidType);

      Utils.hideWaitingProgressDialog();


    }
  }

  Future<void> editBidType({required BuildContext context,required BidType bidType}) async {



    List<String> typesStringAr = context.read<AdminController>().bidTypes!
        .map((e) => e.name!.replaceAll(" ", "").toLowerCase()).toList();

    typesStringAr.removeWhere((element) =>element == bidType.name);

    dynamic result = await showDialog(context: context,builder: (_) => AddEditBidTypeDialog(typesStringAr: typesStringAr,bidType: bidType,));

    if(result is String){


      bidType.name = result;

      context.read<AdminController>().editBidType(bidType);




    }
  }

  removeBidType(String bidTypeId){
    Utils.showSureAlertDialog(
        onSubmit: (){
          context.read<AdminController>().removeBidType(bidTypeId);
        }
    );
  }


}

