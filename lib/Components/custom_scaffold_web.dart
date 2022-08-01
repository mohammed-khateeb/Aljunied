import 'package:aljunied/Components/bottom_bar_web.dart';
import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'app_bar_web.dart';

class CustomScaffoldWeb extends StatelessWidget {
  final Widget body;
  final String? title;
  final String? subTitle;
  final bool showHeaderAndBottom;
  final String? buttonLabel;
  final Function? onPressButton;


  const CustomScaffoldWeb({Key? key, required this.body, this.title, this.subTitle, this.showHeaderAndBottom = true, this.buttonLabel, this.onPressButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    if(showHeaderAndBottom)
                    const SizedBox(height: 100,),
                    Container(
                      width: size.width,
                      height: size.height * 0.55,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/custom_scaffold.jpeg"),
                              fit: BoxFit.fill)),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[100],
                        child: Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: Image.asset(
                            "images/down_web_path.png",
                            height: size.height * 0.3,
                          ),
                        ),
                      ),
                    ),
                    if(showHeaderAndBottom)
                      const BottomBarWeb(),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(width: size.width,),
                  if(showHeaderAndBottom)
                    const AppBarWeb(),
                  Expanded(
                    child: SizedBox(
                      width: size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            if(title!=null)
                              Text(
                                title!,
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white
                                ),
                                textAlign: TextAlign.center,
                              ),
                            if(subTitle!=null)
                              Text(
                                subTitle!,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[200]
                                ),
                                textAlign: TextAlign.center,

                              ),

                            SizedBox(height: title==null&&subTitle==null?40:30,),
                            Container(
                              width: 450,
                                constraints: BoxConstraints(
                                  minHeight: 500
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10
                               ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 10,
                                      blurRadius: 10,
                                      offset: Offset(0, 5), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: body),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                ],
              ),
              if(buttonLabel!=null&&onPressButton!=null&&size.width>1000)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: 100,
                      bottom: 200
                    ),
                    child: CustomButton(
                      width: 200,
                      height: 70,
                      label: buttonLabel!,
                      onPress:()=> onPressButton!(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
