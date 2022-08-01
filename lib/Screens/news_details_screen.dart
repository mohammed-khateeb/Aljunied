import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/area.dart';
import 'package:aljunied/Models/bid.dart';
import 'package:aljunied/Models/news.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:aljunied/Widgets/reusable_cache_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Components/Home_Components/banners.dart';
import '../Utils/util.dart';

class NewsDetailsScreen extends StatelessWidget {
  final News? news;
  final Bid? bid;
  final Area? area;


  const NewsDetailsScreen({Key? key, this.news, this.bid, this.area}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: kIsWeb&&size.width>520?null:CustomInkwell(
        onTap: ()=>Navigator.pop(context),
        child: Icon(
          Icons.arrow_back,
          size: size.height*0.025,
        ),
      ),
      bottomNavigationBar:news!=null&&!kIsWeb? Padding(
        padding: EdgeInsets.symmetric(
          vertical: size.height*0.025
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(news!.facebookLink!=null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.height*0.005),
              child: CustomInkwell(
                onTap: ()=>Utils.launchUrl(news!.facebookLink),
                child: Image.asset(
                  "icons/facebook.png",
                  height: size.height*0.045,
                ),
              ),
            ),
            if(news!.instagramLink!=null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height*0.005),
                child: CustomInkwell(
                  onTap: ()=>Utils.launchUrl(news!.instagramLink),
                  child: Image.asset(
                    "icons/instagram.png",
                    height: size.height*0.045,
                  ),
                ),
              ),
            if(news!.twitterLink!=null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height*0.005),
                child: CustomInkwell(
                  onTap: ()=>Utils.launchUrl(news!.twitterLink),
                  child: Image.asset(
                    "icons/twitter.png",
                    height: size.height*0.045,
                  ),
                ),
              ),
            if(news!.snapchatLink!=null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height*0.005),
                child: CustomInkwell(
                  onTap: ()=>Utils.launchUrl(news!.snapchatLink),
                  child: Image.asset(
                    "icons/snapchat.png",
                    height: size.height*0.045,
                  ),
                ),
              ),

          ],
        ),
      ):null,
      body: kIsWeb&&size.width>520?ListView(
        children: [

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:kIsWeb&&size.width>520? 150:0,
              vertical: kIsWeb?30:0
            ),
            child: ReusableCachedNetworkImage(
              height: kIsWeb?250:size.height*0.3,
              width: size.width,
              imageUrl:news!=null? news!.imageUrl:bid!=null?bid!.imageUrl:area!.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: 150
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: size.width,),

                Text(
                  news!=null? news!.title!:bid!=null?bid!.title!:area!.name!,
                  style: TextStyle(
                      fontSize:kIsWeb?20: size.height*0.021,
                      fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: size.height*0.01,),
                if(area!=null)
                CustomInkwell(
                  onTap: ()=>Utils.launchMapUrl(area!.location),
                  child: Text(
                    translate(context, "location"),
                    style: TextStyle(
                      fontSize:kIsWeb?17: size.height*0.021,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor
                    ),
                  ),
                ),
                if(area!=null)
                  SizedBox(height: size.height*0.01,),
                Text(
                  Utils.getDateAndTimeString((news!=null? news!.createAt!:bid!=null?bid!.createAt!:area!.createAt!
                  ).toDate()),
                  style: TextStyle(
                      fontSize:kIsWeb?10: size.height*0.013,
                      color: Colors.grey[600]
                  ),
                ),
                SizedBox(height: size.height*0.01,),

                Text(
                  news!=null? news!.details??"":bid!=null?bid!.details??"":area!.des??"",
                  style: TextStyle(
                      fontSize:kIsWeb?16: size.height*0.017,
                  ),
                ),
                if(news!=null)
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(news!.facebookLink!=null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: CustomInkwell(
                            onTap: ()=>Utils.launchUrl(news!.facebookLink),
                            child: Image.asset(
                              "icons/facebook.png",
                              height: 50,
                            ),
                          ),
                        ),
                      if(news!.instagramLink!=null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: CustomInkwell(
                            onTap: ()=>Utils.launchUrl(news!.instagramLink),
                            child: Image.asset(
                              "icons/instagram.png",
                              height: 50,
                            ),
                          ),
                        ),
                      if(news!.twitterLink!=null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: CustomInkwell(
                            onTap: ()=>Utils.launchUrl(news!.twitterLink),
                            child: Image.asset(
                              "icons/twitter.png",
                              height: 50,
                            ),
                          ),
                        ),
                      if(news!.snapchatLink!=null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: CustomInkwell(
                            onTap: ()=>Utils.launchUrl(news!.snapchatLink),
                            child: Image.asset(
                              "icons/snapchat.png",
                              height: 50,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if(news!=null)
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 40
                  ),
                  child: Banners(fromNewsScreen: true,),
                ),
              ],
            ),
          ),
        ],
      ):Column(
        children: [

          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:kIsWeb&&size.width>520? 150:0,
                vertical: kIsWeb?30:0
            ),
            child: ReusableCachedNetworkImage(
              height: kIsWeb?250:size.height*0.3,
              width: size.width,
              imageUrl:news!=null? news!.imageUrl:bid!=null?bid!.imageUrl:area!.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.symmetric(
                  horizontal: size.width*0.05
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: size.width,),

                  Text(
                    news!=null? news!.title!:bid!=null?bid!.title!:area!.name!,
                    style: TextStyle(
                      fontSize:kIsWeb?20: size.height*0.021,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: size.height*0.01,),
                  if(area!=null)
                    CustomInkwell(
                      onTap: ()=>Utils.launchMapUrl(area!.location),
                      child: Text(
                        translate(context, "location"),
                        style: TextStyle(
                            fontSize:kIsWeb?17: size.height*0.021,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  if(area!=null)
                    SizedBox(height: size.height*0.01,),
                  Text(
                    Utils.getDateAndTimeString((news!=null? news!.createAt!:bid!=null?bid!.createAt!:area!.createAt!
                    ).toDate()),
                    style: TextStyle(
                        fontSize:kIsWeb?10: size.height*0.013,
                        color: Colors.grey[600]
                    ),
                  ),
                  SizedBox(height: size.height*0.01,),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        news!=null? news!.details??"":bid!=null?bid!.details??"":area!.des??"",
                        style: TextStyle(
                          fontSize:kIsWeb?16: size.height*0.017,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
