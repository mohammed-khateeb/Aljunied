import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/transaction.dart';
import 'package:aljunied/Models/user_app.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
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
        SizedBox(height:kIsWeb&&size.width>520?10: size.height*0.02,),

        CustomInkwell(
          onTap: (){

            context.read<TransactionController>().setTransactionDetails(transaction).then((value) {
              NavigatorUtils.navigateToTransactionDetailsScreen(context);
            });
          },
          child: Row(
            children: [
              Container(
                height:kIsWeb&&size.width>520?60: size.height*0.07,
                width:kIsWeb&&size.width>520?60: size.height*0.07,
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
              SizedBox(width:kIsWeb&&size.width>520?10: size.width*0.03,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.citizenName!,
                    style: TextStyle(
                      fontSize:kIsWeb&&size.width>520?16: size.height*0.02,
                    ),
                  ),
                    Text(
                      translate(context, "referenceNumber")+" : "+transaction.id!,
                      style: TextStyle(
                          fontSize:kIsWeb&&size.width>520?13: size.height*0.015,
                          color: kSubTitleColor
                      ),
                    ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size:kIsWeb&&size.width>520?20: size.height*0.03,
                color: kPrimaryColor,
              ),
              SizedBox(width:kIsWeb&&size.width>520?10: size.width*0.03,),


            ],
          ),
        ),
        SizedBox(height:kIsWeb&&size.width>520?10: size.height*0.02,),
        Divider(color: Colors.grey[800],endIndent: kIsWeb&&size.width>520?20:size.width*0.05,)
      ],
    );
  }
}
