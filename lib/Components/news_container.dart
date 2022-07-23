import 'package:aljunied/Models/news.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:flutter/material.dart';

import '../Widgets/custom_inkwell.dart';
import '../Widgets/reusable_cache_network_image.dart';

class NewsContainer extends StatelessWidget {
  final News news;
  const NewsContainer({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomInkwell(
      onTap: ()=>NavigatorUtils.navigateToNewsDetailsScreen(context, news: news),
      child: SizedBox(
        height: size.height*0.2,
        child: Stack(
          children: [
            ReusableCachedNetworkImage(
              height: size.height*0.2,
              width: size.width,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(5),
              imageUrl: news.imageUrl,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width*0.03,
                    vertical: size.height*0.005
                ),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                    )
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title!,
                      style: TextStyle(
                          fontSize: size.height*0.015,
                          color: Colors.white
                      ),
                    ),
                    Text(
                      Utils.getDateAndTimeString(news.createAt!.toDate()),
                      style: TextStyle(
                          fontSize: size.height*0.01,
                          color: Colors.grey[200]
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}