import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Components/transaction_container.dart';
import 'package:aljunied/Controller/transaction_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constants/constants.dart';
import '../../Utils/util.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/waiting_widget.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({Key? key}) : super(key: key);

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  @override
  void initState() {
    context.read<TransactionController>().getAllTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "transactions"),
      body: Consumer<TransactionController>(
          builder: (context, transactionController, child) {
            return !transactionController.waitingAllTransactions
                ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10),
              itemCount: transactionController.allTransactions!.length,
              itemBuilder: (_, index) {
                return TransactionContainer(transaction: transactionController.allTransactions![index]);
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
        title: translate(context, "transactions"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child:  Consumer<TransactionController>(
            builder: (context, transactionController, child) {
              return !transactionController.waitingAllTransactions
                  ? ListView.builder(

                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.02),
                itemCount: transactionController.allTransactions!.length,
                itemBuilder: (_, index) {
                  return TransactionContainer(transaction: transactionController.allTransactions![index]);
                },
              )
                  : const WaitingWidget();
            }),
      ),
    );
  }
}
