import 'package:aljunied/Components/custom_scaffold_web.dart';
import 'package:aljunied/Components/news_container.dart';
import 'package:aljunied/Utils/navigator_utils.dart';
import 'package:aljunied/Utils/util.dart';
import 'package:aljunied/Widgets/custom_app_bar.dart';
import 'package:aljunied/Widgets/custom_inkwell.dart';
import 'package:flutter/foundation.dart';
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
    return kIsWeb&&size.width>520
        ?CustomScaffoldWeb(
      title: translate(context, "news"),
      buttonLabel: translate(context, "add"),
      onPressButton: ()=>NavigatorUtils.navigateToAddEditNewsScreen(context,orderIndex: context.read<NewsController>().news!.length+1),
      body: Consumer<NewsController>(builder: (context, newsController, child) {
        return !newsController.waiting
            ? ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10),
          itemCount: newsController.news!.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical:10
              ),
              child: Stack(
                children: [
                  NewsContainer(news: newsController.news![index],edit: true,),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    iconSize: 20,

                    onPressed: (){
                      Utils.showSureAlertDialog(
                          onSubmit: (){
                            newsController.deleteNews(newsController.news![index]);
                          }
                      );
                    },
                  )
                ],
              ),
            );
          },
        )
            : const WaitingWidget();
      }),
    )
        :Scaffold(

      backgroundColor: kPrimaryColor,

      appBar: CustomAppBar(
        titleColor: Colors.white,
        arrowColor: Colors.white,
        title: translate(context, "news"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add,color: Colors.white,),
        onPressed: () => NavigatorUtils.navigateToAddEditNewsScreen(context,orderIndex: context.read<NewsController>().news!.length+1),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: kIsWeb?10:0),
                      child: Stack(
                        children: [
                          NewsContainer(news: newsController.news![index],edit: true,),
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
                      ),
                    );
                  },
                )
              : const WaitingWidget();
        }),
      ),
    );
  }
}
