import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Constants/constants.dart';
import '../Controller/admin_controller.dart';
import '../Controller/user_controller.dart';
import '../Models/city.dart';
import '../Models/current_user.dart';
import '../Models/user_app.dart';
import '../Utils/navigator_utils.dart';
import '../Utils/util.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_inkwell.dart';
import '../Widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserApp? userApp;
  City? city;



  @override
  void initState() {
    context.read<AdminController>().getAllCities();

    userApp = context.read<UserController>().userApp!;
    city =userApp != null ? userApp!.city:null;
    nameController.text = userApp != null ? userApp!.name ?? "" : "";
    mobileController.text = userApp != null ? userApp!.mobileNumber ?? "" : "";
    emailController.text = userApp != null ? userApp!.email ?? "" : "";
    cityController.text = userApp != null
        ?Localizations.localeOf(Utils.navKey.currentContext!).languageCode=="en"? userApp!.city!.nameEn ?? "":userApp!.city!.nameAr ?? "" : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Center(
              child: Padding(
                padding: EdgeInsets.only(top: size.height*0.05),
                child: Text(
                  translate(context, "settings").toUpperCase(),
                  style: TextStyle(
                      fontSize: size.height*0.025,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold
                  ),
                ),
              )),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: size.width*0.03),
            child: CustomInkwell(
              onTap: () {
                Utils.showSureAlertDialog(
                    onSubmit: () {
                      context.read<UserController>().logout();
                      NavigatorUtils.navigateToSplashScreen(context);
                    }
                );
              },
              child: Icon(
                Icons.logout,
                size: MediaQuery
                    .of(context)
                    .size
                    .height * 0.03,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                Text(
                  translate(context, "edit_personal_info"),
                  style: TextStyle(
                      fontSize: size.height * 0.015,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  height: size.height * 0.04,
                ),
                CustomTextField(
                  hintText: translate(context, "fullName"),
                  controller: nameController,
                  validator: (str) {
                    if (str!.isEmpty) {
                      return translate(context, "pleaseEnterYourName");
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTextField(
                  hintText: translate(context, "mobileNumber"),
                  controller: mobileController,
                  keyboardType: TextInputType.number,
                  digitsOnly: true,
                  validator: (str) {
                    if (str!.isEmpty) {
                      return translate(context, "pleaseEnterYourMobileNumber");
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTextField(
                  hintText: translate(context, "email"),
                  controller: emailController,
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                CustomTextField(
                  hintText: translate(context, "city"),
                  controller: cityController,
                  readOnly: true,
                  onSelectCity: (v){
                    setState(() {
                      city = v;
                    });
                  },
                  dropCities: context.watch<AdminController>().cities,
                  validator: (str){
                    if(str!.isEmpty){
                      return translate(context, "pleaseEnterYourCity");
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),


                SizedBox(
                  height: size.height * 0.03,
                ),

                Center(
                  child: CustomButton(
                    label: translate(context, "submit"),
                    onPress: submit,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  submit() async {
    if (!_formKey.currentState!.validate() || userApp == null) {
      return;
    } else {
      Utils.showWaitingProgressDialog();

      userApp!.name = nameController.text;
      userApp!.mobileNumber = mobileController.text;
      userApp!.city = city;

      Future.delayed(Duration(milliseconds: 300)).then((value) {
        context.read<UserController>().updateProfile(userApp: userApp!);
        Utils.hideWaitingProgressDialog();

        Utils.showSuccessAlertDialog(translate(
            context, "yourPersonalInformationHasBeenUpdatedSuccessfully"));
      });
    }
  }
}
