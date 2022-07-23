import 'package:aljunied/Components/user_container.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/admin_controller.dart';
import 'package:aljunied/Controller/transaction_controller.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/waiting_widget.dart';
import '../Components/transaction_container.dart';

class TransactionsScreen extends StatefulWidget {
  final String searchKey;
  const TransactionsScreen({Key? key, required this.searchKey}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {

  @override
  void initState() {

    context.read<TransactionController>().getSearchTransactions(widget.searchKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        title: translate(context, "searchResults"),
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
        child: Consumer<TransactionController>(builder: (context, transactionsController, child) {
          return !transactionsController.waitingSearchTransactions
              ? ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.02),
            itemCount: transactionsController.searchTransactions!.length,
            itemBuilder: (_, index) {
              return TransactionContainer(transaction: transactionsController.searchTransactions![index],);
            },
          )
              : const WaitingWidget();
        }),
      ),
    );
  }
}
