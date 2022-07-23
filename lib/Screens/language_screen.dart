import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/constants.dart';
import '../Localizations/app_language.dart';
import '../Utils/util.dart';
import '../Widgets/custom_app_bar.dart';

class LanguageScreen extends StatelessWidget {

  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: translate(context,"language"),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          translate(context,"changeLanguage"),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  appLanguage.changeLanguage(Locale("en"));
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Localizations.localeOf(context).languageCode ==
                                            "en"
                                            ? kPrimaryColor
                                            : Colors.white
                                    ),


                                    child:  Center(child:  Text(
                                        'English',
                                      style: TextStyle(
                                        color:Localizations.localeOf(context).languageCode ==
                                            "ar"?kPrimaryColor: Colors.white
                                      ),
                                    ),)

                                ),
                              )
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  appLanguage.changeLanguage(Locale("ar"));
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Localizations.localeOf(context).languageCode ==
                                            "ar"
                                            ? kPrimaryColor
                                            : Colors.white
                                    ),


                                    child: Center(child:  Text('العربي',style:  TextStyle(
                                        color: Localizations.localeOf(context).languageCode ==
                                            "ar"?Colors.white:kPrimaryColor
                                    ),),)

                                ),
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            )
        ),
      ),
    );
  }
}