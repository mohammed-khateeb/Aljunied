import 'package:aljunied/Components/news_container.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constants/constants.dart';
import '../../Controller/news_controller.dart';
import '../../Widgets/waiting_widget.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      context.read<NewsController>().resetWaiting().then((value) {
        context.read<NewsController>().getNews();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      backgroundColor: kPrimaryColor,

      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "news"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          translate(context, "add"),
          style: TextStyle(
            fontSize: size.height*0.018,
            fontWeight: FontWeight.w600
          ),
        ),
        onPressed: () => NavigatorUtils.navigateToAddEditNewsScreen(context),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.only(top: size.height*0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(size.height*0.03))
        ),
        child: Consumer<NewsController>(builder: (context, newsController, child) {
          return !newsController.waiting
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.02),
                  itemCount: newsController.news!.length,
                  itemBuilder: (_, index) {
                    return CustomInkwell(
                      onTap: ()=>NavigatorUtils.navigateToAddEditNewsScreen(context,news: newsController.news![index]),
                        child: Stack(
                          children: [
                            NewsContainer(news: newsController.news![index]),
                            IconButton(
                              icon: Icon(
                                  Icons.delete,
                                color: Colors.red,
                              ),
                              iconSize: size.height*0.025,

                              onPressed: (){
                                Utils.showSureAlertDialog(
                                  onSubmit: (){
                                    newsController.deleteNews(newsController.news![index]);
                                  }
                                );
                              },
                            )
                          ],
                        ));
                  },
                )
              : const WaitingWidget();
        }),
      ),
    );
  }
}
