import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Components/user_container.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Controller/admin_controller.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/waiting_widget.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {

  @override
  void initState() {
    context.read<AdminController>().getEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "employees"),
      body: Consumer<AdminController>(
          builder: (context, adminController, child) {
            return !adminController.waitingEmployees
                ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15),
              itemCount: adminController.employees!.length,
              itemBuilder: (_, index) {
                return UserContainer(employee: adminController.employees![index],);
              },
            )
                : const WaitingWidget();
          }),
    )
        :Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: CustomAppBar(
        titleColor: Colors.white,
        title: translate(context, "employees"),
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
        child: Consumer<AdminController>(
            builder: (context, adminController, child) {
          return !adminController.waitingEmployees
              ? ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.02),
            itemCount: adminController.employees!.length,
            itemBuilder: (_, index) {
              return UserContainer(employee: adminController.employees![index],);
            },
          )
              : const WaitingWidget();
        }),
      ),
    );
  }
}
