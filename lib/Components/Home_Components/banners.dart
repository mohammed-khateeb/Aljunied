import 'package:aljunied/Components/news_container.dart';
import 'package:aljunied/Controller/news_controller.dart';
import 'package:aljunied/Models/news.dart';
import 'package:aljunied/Shimmers/areas_shimmer.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/reusable_cache_network_image.dart';
import 'package:aljunied/Widgets/waiting_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constants/constants.dart';
import '../../Controller/admin_controller.dart';
import '../../Shimmers/banner_shimmer.dart';

class Banners extends StatelessWidget {
  final bool fromNewsScreen;
  const Banners({Key? key, this.fromNewsScreen = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<NewsController>(
        builder: (context, newsController, child) {
        return newsController.news!=null?newsController.news!.isNotEmpty? SizedBox(
          height:kIsWeb?fromNewsScreen?250:200: size.height*0.2,
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: kIsWeb&&!fromNewsScreen?size.width*0.05:0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(kIsWeb)
                Text(
                  translate(context, "latestNews"),
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "ArabFontBold",
                  ),
                ),

                Expanded(
                  child: Swiper(
                      autoplay: true,
                      viewportFraction:kIsWeb?fromNewsScreen?500/size.width:350/size.width: 0.95,
                      itemCount: newsController.news!.length,
                      itemBuilder: (BuildContext context,int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal:kIsWeb?15: size.width*0.025),
                        child: NewsContainer(news: newsController.news![index],),
                      );
                    },
                      pagination: SwiperPagination(
                      margin: EdgeInsets.zero,
                      builder: SwiperCustomPagination(builder: (context, config) {
                        return ConstrainedBox(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child:  DotSwiperPaginationBuilder(
                                color: Colors.grey[300],
                                activeColor: kPrimaryColor,
                                size: size.height*0.007,
                                activeSize: size.height*0.007)
                                .build(context, config),
                          ),
                          constraints:  BoxConstraints.expand(height: size.height*0.012),
                        );
                      })),

    ),
                ),
              ],
            ),
          ),
        ):const SizedBox():kIsWeb&&size.width>520?AreasShimmer():const BannerShimmer();
      }
    );
  }
}


