import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Components/user_container.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/admin_controller.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/waiting_widget.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    context.read<AdminController>().getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return kIsWeb && size.width > 520
        ? CustomScaffoldWeb(
            title: translate(context, "citizens"),
            body: Consumer<AdminController>(
                builder: (context, adminController, child) {
              return !adminController.waitingAllUsers
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      itemCount: adminController.allUser!.length,
                      itemBuilder: (_, index) {
                        return UserContainer(
                          employee: adminController.allUser![index],
                        );
                      },
                    )
                  : const WaitingWidget();
            }),
          )
        : Scaffold(
            backgroundColor: kPrimaryColor,
            appBar: CustomAppBar(
              titleColor: Colors.white,
              title: translate(context, "citizens"),
              arrowColor: Colors.white,
            ),
            body: Container(
              width: size.width,
              height: size.height,
              margin: EdgeInsets.only(top: size.height * 0.02),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(size.height * 0.03))),
              child: Consumer<AdminController>(
                  builder: (context, adminController, child) {
                return !adminController.waitingAllUsers
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                            vertical: size.height * 0.02),
                        itemCount: adminController.allUser!.length,
                        itemBuilder: (_, index) {
                          return UserContainer(
                            employee: adminController.allUser![index],
                          );
                        },
                      )
                    : const WaitingWidget();
              }),
            ),
          );
  }
}
