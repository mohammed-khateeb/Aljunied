import 'package:aljunied/Utils/util.dart';
import 'package:flutter/material.dart';

class DownloadAppSection extends StatelessWidget {
  const DownloadAppSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 15
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 100,
          runSpacing: 15,
          children: [
            SizedBox(
              width: 450,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(translate(context, "downloadOurApp"),
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                      )
                  ),
                  Text("لوريم إيبسوم هو ببساطة نص شكلي يستخدم في صناعة الطباعة والتنضيد. كان هو النص الوهميالقياسيغير معروفة لوحًا من النوع وتدافعت عليه لعمل كتاب عينة. لقد صمد ليس فقط لخمسةقرون ، ولكن أيضًا القفزة في التنضيد الإلكترون",
                      style: TextStyle(
                          fontSize: 15,
                      )

                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Image.asset(
                        "images/google_play.png",
                        height: 35,
                      ),
                      SizedBox(width: 15,),
                      Image.asset(
                        "images/app_store.png",
                        height: 35,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Image.asset(
              "images/download_app.png",
              height: 420,

            )
          ],
        ),
      ),
    );
  }
}
