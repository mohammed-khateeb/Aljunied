import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/investment_controller.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/waiting_widget.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({Key? key}) : super(key: key);

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  @override
  void initState() {

    context.read<InvestmentController>().getInvestments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "investments"),
      body: Consumer<InvestmentController>(
          builder: (context, investmentController, child) {
            return !investmentController.waiting
                ? ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10),
              itemCount: investmentController.investments!.length,
              itemBuilder: (_, index) {
                return ListTile(
                  onTap: ()=>NavigatorUtils.navigateToInvestmentDetailsScreen(context, investmentController.investments![index]),
                  title: Text(
                    investmentController.investments![index].userName!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    Utils.getDateAndTimeString(
                        investmentController.investments![index].createAt!.toDate()
                    ),
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600]
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    iconSize: 25,

                    onPressed: (){
                      Utils.showSureAlertDialog(
                          onSubmit: (){
                            investmentController.deleteInvestment(investmentController.investments![index]);
                          }
                      );
                    },
                  ),
                );
              },
            )
                : const WaitingWidget();
          }),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "investments"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child:  Consumer<InvestmentController>(
            builder: (context, investmentController, child) {
          return !investmentController.waiting
              ? ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.02),
            itemCount: investmentController.investments!.length,
            itemBuilder: (_, index) {
              return ListTile(
                onTap: ()=>NavigatorUtils.navigateToInvestmentDetailsScreen(context, investmentController.investments![index]),
                title: Text(
                    investmentController.investments![index].userName!,
                  style: TextStyle(
                      fontSize: size.height*0.018,
                  ),
                ),
                subtitle: Text(
                  Utils.getDateAndTimeString(
                      investmentController.investments![index].createAt!.toDate()
                  ),
                  style: TextStyle(
                    fontSize: size.height*0.012,
                    color: Colors.grey[600]
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  iconSize: size.height*0.025,

                  onPressed: (){
                    Utils.showSureAlertDialog(
                        onSubmit: (){
                          investmentController.deleteInvestment(investmentController.investments![index]);
                        }
                    );
                  },
                ),
              );
            },
          )
              : const WaitingWidget();
        }),
      ),
    );
  }
}
