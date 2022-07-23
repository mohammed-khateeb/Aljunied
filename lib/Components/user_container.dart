import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/user_app.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  final UserApp employee;
  const UserContainer({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: size.height*0.02,),

        CustomInkwell(
          onTap: (){
            NavigatorUtils.navigateToEmployeeDetailsScreen(context,employee: employee);
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
                    employee.name!,
                    style: TextStyle(
                      fontSize: size.height*0.02,
                    ),
                  ),
                  if(employee.department!=null)
                  Text(
                    employee.department!.name??"",
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
