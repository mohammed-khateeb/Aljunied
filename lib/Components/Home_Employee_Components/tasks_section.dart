import 'package:aljunied/Controller/transaction_controller.dart';
import 'package:aljunied/Models/current_user.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:aljunied/Widgets/waiting_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constants/constants.dart';
import '../../Utils/util.dart';
import '../task.dart';

class TasksSection extends StatelessWidget {
  const TasksSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<TransactionController>(
        builder: (context, transactionController, child) {
        return !transactionController.waitingTasks?Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: size.width,),
            if(CurrentUser.department!=null)
            RichText(
              text: TextSpan(
                text: translate(context, "tasks")+" ",
                style: TextStyle(
                  fontSize: size.height*0.02,
                  color: Colors.black,
                  fontFamily: "ArabFontBold",
                ),
                children: <TextSpan>[
                  TextSpan(text: "(${CurrentUser.department!.name!})",
                      style: TextStyle(
                          fontSize: size.height*0.013,
                        fontFamily: "ArabFont"
                      )),
                ],
              ),
            ),
            SizedBox(height: size.height*0.01,),
            Row(
              children: [
                CustomInkwell(
                  onTap: (){
                    transactionController.changeTaskType(0);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.03),
                    height: size.height*0.045,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.height*0.01),
                        color:context.watch<TransactionController>().taskType==0? kPrimaryColor:Colors.grey[200]
                    ),
                    child: Center(
                      child: Text(
                        translate(context, "all"),
                        style: TextStyle(
                          fontSize: size.height*0.017,
                          color:transactionController.taskType==0? Colors.white:Colors.grey[700],

                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width*0.02),
                CustomInkwell(
                  onTap: (){
                    transactionController.changeTaskType(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.03),
                    height: size.height*0.045,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.height*0.01),
                        color:transactionController.taskType==1? kPrimaryColor:Colors.grey[200]
                    ),
                    child: Center(
                      child: Text(
                        translate(context, "completedTasks"),
                        style: TextStyle(
                          fontSize: size.height*0.017,
                          color:transactionController.taskType==1? Colors.white:Colors.grey[700],

                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width*0.02),
                CustomInkwell(
                  onTap: (){
                    transactionController.changeTaskType(2);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.03),
                    height: size.height*0.045,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.height*0.01),
                        color:transactionController.taskType==2? kPrimaryColor:Colors.grey[200]
                    ),
                    child: Center(
                      child: Text(
                        translate(context, "unfinishedTasks"),
                        style: TextStyle(
                          fontSize: size.height*0.017,
                          color:transactionController.taskType==2? Colors.white:Colors.grey[700],

                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if((transactionController.taskType==0&&transactionController.todayTasks!.isNotEmpty)
                     ||(transactionController.taskType==1&&transactionController.todayCompletedTasks!.isNotEmpty)
                    ||(transactionController.taskType==2&&transactionController.todayUnFinishTasks!.isNotEmpty))
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height*0.01,
                  ),
                  child: Text(
                    translate(context, "today"),
                    style: TextStyle(
                        fontSize: size.height*0.02,
                        color: kSubTitleColor
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount:transactionController.taskType==0
                      ? transactionController.todayTasks!.length
                      :transactionController.taskType==1
                        ? transactionController.todayCompletedTasks!.length
                        : transactionController.todayUnFinishTasks!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_,index){
                    return TaskWidget(
                      transactionModel: transactionController.taskType==0
                          ? transactionController.todayTasks![index]
                          :transactionController.taskType==1
                          ? transactionController.todayCompletedTasks![index]
                          : transactionController.todayUnFinishTasks![index],);
                  },
                ),
                if((transactionController.taskType==0&&transactionController.allTasks!.isNotEmpty)
                    ||(transactionController.taskType==1&&transactionController.completedTasks!.isNotEmpty)
                    ||(transactionController.taskType==2&&transactionController.unFinishTasks!.isNotEmpty))
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height*0.02,
                  ),
                  child: Text(
                    translate(context, "othersDay"),
                    style: TextStyle(
                        fontSize: size.height*0.02,
                        color: kSubTitleColor
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount:transactionController.taskType==0
                      ? transactionController.allTasks!.length
                      :transactionController.taskType==1
                      ? transactionController.completedTasks!.length
                      : transactionController.unFinishTasks!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_,index){
                    return TaskWidget(
                      transactionModel: transactionController.taskType==0
                          ? transactionController.allTasks![index]
                          :transactionController.taskType==1
                          ? transactionController.completedTasks![index]
                          : transactionController.unFinishTasks![index],
                    );
                  },
                ),
              ],
            )
          ],
        ):const WaitingWidget();
      }
    );
  }
}

