import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/user_app.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  final UserApp employee;
  const UserContainer({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height:kIsWeb&&size.width>520?10: size.height*0.02,),

        CustomInkwell(
          onTap: (){
            NavigatorUtils.navigateToEmployeeDetailsScreen(context,employee: employee);
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
                    employee.name!,
                    style: TextStyle(
                      fontSize:kIsWeb&&size.width>520?16: size.height*0.02,
                    ),
                  ),
                  if(employee.department!=null&&employee.department!.name!=null)
                  Row(
                    children: [
                      Text(
                        employee.department!.name!,
                        style: TextStyle(
                            fontSize:kIsWeb&&size.width>520?13: size.height*0.015,
                          color: kSubTitleColor
                        ),
                      ),
                      Text(
                          employee.isDepartmentBoss==true?" (${translate(context,"head")})":"",
                        style: TextStyle(
                            fontSize:kIsWeb&&size.width>520?13: size.height*0.015,
                            color: Colors.red,
                          fontWeight: FontWeight.bold
                      )
                      )
                    ],
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size:kIsWeb&&size.width>520?20: size.height*0.03,
                color: kPrimaryColor,
              ),
              SizedBox(width: size.width*0.03,),


            ],
          ),
        ),
        SizedBox(height:kIsWeb&&size.width>520?10: size.height*0.02,),
        Divider(color: Colors.grey[800],endIndent: kIsWeb&&size.width>520?20:size.width*0.05,)
      ],
    );
  }
}
