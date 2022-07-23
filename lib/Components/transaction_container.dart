import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/transaction.dart';
import 'package:aljunied/Models/user_app.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/transaction_controller.dart';

class TransactionContainer extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionContainer({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: size.height*0.02,),

        CustomInkwell(
          onTap: (){

            context.read<TransactionController>().setTransactionDetails(transaction).then((value) {
              NavigatorUtils.navigateToTransactionDetailsScreen(context);
            });
          },
          child: Row(
            children: [
              Container(
                height: size.height*0.07,
                width: size.height*0.07,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  image: DecorationImage(
                      image: AssetImage(
                        "images/man.png",
                      ),
                      fit: BoxFit.cover
                  ),
                ),
              ),
              SizedBox(width: size.width*0.03,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.citizenName!,
                    style: TextStyle(
                      fontSize: size.height*0.02,
                    ),
                  ),
                    Text(
                      translate(context, "referenceNumber")+" : "+transaction.id!,
                      style: TextStyle(
                          fontSize: size.height*0.015,
                          color: kSubTitleColor
                      ),
                    ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: size.height*0.03,
                color: kPrimaryColor,
              ),
              SizedBox(width: size.width*0.03,),


            ],
          ),
        ),
        SizedBox(height: size.height*0.02,),
        Divider(color: Colors.grey[800],endIndent: size.width*0.05,)
      ],
    );
  }
}
