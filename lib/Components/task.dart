import 'package:aljunied/Controller/transaction_controller.dart';
import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Models/transaction.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskWidget extends StatelessWidget {
  final TransactionModel transactionModel;

  const TaskWidget({Key? key, required this.transactionModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomInkwell(
      onTap: () {
        context
            .read<TransactionController>()
            .setTransactionDetails(transactionModel)
            .then((value) {
          NavigatorUtils.navigateToTransactionDetailsScreen(context);
        });
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:kIsWeb?15: size.width * 0.03, vertical:kIsWeb?10: size.height * 0.01),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width,
                    ),
                    Text(
                      translate(context, "transaction") +
                          " " +
                          transactionModel.citizenName!,
                      style: TextStyle(
                          fontSize:kIsWeb?15: size.height * 0.02,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                        transactionModel.convertTo=="انتهاء المعاملة"?"انتهت المعاملة":translate(context, "transaction") +
                          " " +
                          transactionModel.convertTo! +
                          " " +
                          transactionModel.currentStage!,
                      style: TextStyle(
                          fontSize:kIsWeb?12: size.height * 0.012, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(
                (CurrentUser.department != null &&
                            transactionModel.convertFromId ==
                                CurrentUser.department!.id) ||
                        transactionModel.completed == true
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_ios,
                size:kIsWeb?15: size.height * 0.025,
                color: (CurrentUser.department != null &&
                            transactionModel.convertFromId ==
                                CurrentUser.department!.id) ||
                        transactionModel.completed == true
                    ? Colors.green
                    : null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
