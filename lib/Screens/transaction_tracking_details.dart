import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Models/transaction.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Constants/constants.dart';
import '../Widgets/custom_app_bar.dart';

class TransactionTrackingDetails extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionTrackingDetails({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "tracking"),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          vertical: size.height*0.03,
        ),

        children: List<Widget>.generate(transaction.employees!.length, (i) =>
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: size.width*0.05),
              child: Column(
                children: [
                  if(i!=0)
                    Icon(
                      Icons.arrow_downward,
                      size: 35,
                    ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            transaction.departments![i],
                            style: const TextStyle(
                                fontSize: 15
                            ),
                          ),
                          Text(
                            transaction.employees![i],
                            style: const TextStyle(
                                fontSize: 15
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            )
        ),
      ),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "tracking"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(size.height*0.04)
          )
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
            vertical: size.height*0.03,
          ),

          children: List<Widget>.generate(transaction.employees!.length, (i) =>
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: size.width*0.05),
                child: Column(
                  children: [
                    if(i!=0)
                    Icon(
                      Icons.arrow_downward,
                      size: size.height*0.06,
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width*0.02,
                          vertical: size.height*0.01
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              transaction.departments![i],
                              style: TextStyle(
                                  fontSize: size.height*0.017
                              ),
                            ),
                            Text(
                              transaction.employees![i],
                              style: TextStyle(
                                  fontSize: size.height*0.017
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}
