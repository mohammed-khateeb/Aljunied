import 'package:aljunied/Constants/constants.dart';
import 'package:aljunied/Models/bid.dart';
import 'package:aljunied/Models/complaint.dart';
import 'package:aljunied/Models/department.dart';
import 'package:aljunied/Utils/extension.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Models/city.dart';
import '../Utils/util.dart';
import 'custom_inkwell.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final Color? borderColor;
  final Widget? prefixIcon;
  final String? errorText;
  final String? helperText;
  final int? minLines;
  final Function? onTapHelperText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final TextStyle? hintStyle;
  final int? charLength;
  final TextEditingController? controller;

  final EdgeInsets? margin;

  final double? width;
  final double? height;
  final double? borderRadius;

  final String? hintText;
  final String? labelText;

  final Color? color;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Function? onTap;
  final Function? onComplete;
  final List<String>? dropList;
  final List<Department>? dropDepartment;
  final Function(Department department)? onSelectDepartment;

  final List<City>? dropCities;
  final Function(City city)? onSelectCity;
  final List<BidType>? dropBidsTypes;
  final Function(BidType bidType)? onSelectBidType;
  final List<ComplaintType>? dropComplaintsTypes;
  final Function(ComplaintType complaintType)? onSelectComplaintType;


  final FormFieldValidator<String>? validator;

  final bool? readOnly;
  final bool obscureText;
  final bool digitsOnly;

  final bool withValidation;

  const CustomTextField({
    Key? key,
    this.keyboardType,
    this.dropCities,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.margin,
    this.width,
    this.hintText,
    this.textAlign,
    this.textDirection,
    this.onTap,
    this.readOnly,
    this.obscureText = false,
    this.validator,
    this.errorText,
    this.charLength,
    this.onChanged,
    this.onComplete,
    this.borderRadius,
    this.height,
    this.helperText,
    this.onTapHelperText,
    this.color,
    this.minLines,
    this.hintStyle,
    this.digitsOnly = false,
    this.dropList,
    this.onSelectCity,
    this.labelText,
    this.withValidation = false, this.dropDepartment, this.onSelectDepartment, this.dropBidsTypes, this.onSelectBidType, this.dropComplaintsTypes, this.onSelectComplaintType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.005),
            child: Text(
              labelText!,
              style: TextStyle(
                  fontSize:kIsWeb?18: size.height * 0.02, color: Colors.grey[850]),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.001),
          child: Center(
            child: Stack(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: prefixIcon != null ? size.width * 0.02 : 0,
                    ),
                    prefixIcon ?? SizedBox(),
                    Expanded(
                      child: Stack(
                        children: [
                          TextFormField(
                            style: TextStyle(
                                fontSize:kIsWeb?15: size.height * 0.015),
                            minLines: minLines ?? 1,
                            autofocus: false,
                            onFieldSubmitted: (_) =>
                                context.nextEditableTextFocus(),
                            inputFormatters: digitsOnly
                                ? [
                                    LengthLimitingTextInputFormatter(charLength??15),
                                    FilteringTextInputFormatter.digitsOnly
                                  ]
                                : [],
                            onEditingComplete: () => onComplete,

                            onTap: () => onTap != null ? onTap!() : null,
                            keyboardType: keyboardType,
                            controller: controller,
                            readOnly:
                                dropList != null ? true : readOnly ?? false,
                            validator: withValidation
                                ? (str) {
                                    if (str!.isEmpty) {
                                      return translate(
                                          context, "pleaseEnterThisField");
                                    }
                                    return null;
                                  }
                                : validator,
                            obscureText: obscureText,
                            onChanged: onChanged,
                            textAlign: textAlign ?? TextAlign.start,
                            maxLines: keyboardType == TextInputType.multiline
                                ? null
                                : 1,
                            // textDirection: textDirection ?? TextDirection.ltr,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(

                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius:
                                    BorderRadius.circular(borderRadius ?? 8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                gapPadding: 8,
                                borderSide: const BorderSide(
                                  color: Color(0xfffa9501),
                                ),
                                borderRadius:
                                    BorderRadius.circular(borderRadius ?? 8.0),
                              ),
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              filled: true,
                              hintText: hintText,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: "",
                              suffixIcon: Padding(
                                padding: EdgeInsets.all(kIsWeb?8:size.height * 0.014),
                                child: suffixIcon,
                              ),
                              errorStyle:
                                  TextStyle(fontSize:kIsWeb?12: size.height * 0.011),
                              fillColor: color ?? Colors.grey[100],
                              errorText: errorText,
                              contentPadding: const EdgeInsets.only(
                                  left: 10.0, top: 0, bottom: 12, right: 8.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if ((dropCities != null && dropCities!.isNotEmpty))
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          dropdownWidth: width ?? size.width * 0.855,
                          buttonElevation: 0,
                          dropdownElevation: 1,
                          iconSize: size.height * 0.03,
                          icon: Padding(
                            padding: EdgeInsetsDirectional.only(
                                end: size.width * 0.015),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[800],
                            ),
                          ),
                          hint: Text(
                            '',
                            style: TextStyle(
                              fontSize: size.height * 0.02,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: dropCities!
                              .map((item) => DropdownMenuItem<City>(
                                    value: item,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Localizations.localeOf(context)
                                                      .languageCode ==
                                                  "en"
                                              ? item.nameEn!
                                              : item.nameAr!,
                                          style: TextStyle(
                                            fontSize: size.height * 0.018,
                                          ),
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          onChanged: (City? value) {
                            controller!.text =
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? value!.nameEn!
                                    : value!.nameAr!;
                            if (onSelectCity != null) {
                              onSelectCity!(value);
                            }
                          },
                          dropdownDecoration:
                              BoxDecoration(color: Colors.grey[200]),
                          dropdownMaxHeight: size.height * 0.3,
                          buttonHeight: height ?? size.height * 0.065,
                          buttonWidth: width ?? size.width * 0.9,
                          itemHeight: size.height * 0.06,
                        ),
                      ),
                    ),
                  ),
                if (( dropBidsTypes!= null && dropBidsTypes!.isNotEmpty))
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          dropdownWidth: width ?? size.width * 0.855,
                          buttonElevation: 0,
                          dropdownElevation: 1,
                          iconSize: size.height * 0.03,
                          icon: Padding(
                            padding: EdgeInsetsDirectional.only(
                                end: size.width * 0.015),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[800],
                            ),
                          ),
                          hint: Text(
                            '',
                            style: TextStyle(
                              fontSize: size.height * 0.02,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: dropBidsTypes!
                              .map((item) => DropdownMenuItem<BidType>(
                            value: item,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name!,
                                  style: TextStyle(
                                    fontSize: size.height * 0.018,
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          ))
                              .toList(),
                          onChanged: (BidType? value) {
                            controller!.text =
                            value!.name!;
                            if (onSelectBidType != null) {
                              onSelectBidType!(value);
                            }
                          },
                          dropdownDecoration:
                          BoxDecoration(color: Colors.grey[200]),
                          dropdownMaxHeight: size.height * 0.3,
                          buttonHeight: height ?? size.height * 0.065,
                          buttonWidth: width ?? size.width * 0.9,
                          itemHeight: size.height * 0.06,
                        ),
                      ),
                    ),
                  ),
                if (( dropComplaintsTypes!= null && dropComplaintsTypes!.isNotEmpty))
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          dropdownWidth: width ?? size.width * 0.855,
                          buttonElevation: 0,
                          dropdownElevation: 1,
                          iconSize: size.height * 0.03,
                          icon: Padding(
                            padding: EdgeInsetsDirectional.only(
                                end: size.width * 0.015),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[800],
                            ),
                          ),
                          hint: Text(
                            '',
                            style: TextStyle(
                              fontSize: size.height * 0.02,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: dropComplaintsTypes!
                              .map((item) => DropdownMenuItem<ComplaintType>(
                            value: item,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name!,
                                  style: TextStyle(
                                    fontSize: size.height * 0.018,
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          ))
                              .toList(),
                          onChanged: (ComplaintType? value) {
                            controller!.text =
                            value!.name!;
                            if (onSelectComplaintType != null) {
                              onSelectComplaintType!(value);
                            }
                          },
                          dropdownDecoration:
                          BoxDecoration(color: Colors.grey[200]),
                          dropdownMaxHeight: size.height * 0.3,
                          buttonHeight: height ?? size.height * 0.065,
                          buttonWidth: width ?? size.width * 0.9,
                          itemHeight: size.height * 0.06,
                        ),
                      ),
                    ),
                  ),
                if ((dropDepartment != null && dropDepartment!.isNotEmpty))
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          dropdownWidth: width ?? size.width * 0.855,
                          buttonElevation: 0,
                          dropdownElevation: 1,
                          iconSize: size.height * 0.03,
                          icon: Padding(
                            padding: EdgeInsetsDirectional.only(
                                end: size.width * 0.015),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[800],
                            ),
                          ),
                          hint: Text(
                            '',
                            style: TextStyle(
                              fontSize: size.height * 0.02,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: dropDepartment!
                              .map((item) => DropdownMenuItem<Department>(
                            value: item,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                   item.name!,
                                  style: TextStyle(
                                    fontSize: size.height * 0.018,
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          ))
                              .toList(),
                          onChanged: (Department? value) {
                            controller!.text = value!.name!;
                            if (onSelectDepartment != null) {
                              onSelectDepartment!(value);
                            }
                          },
                          dropdownDecoration:
                          BoxDecoration(color: Colors.grey[200]),
                          dropdownMaxHeight: size.height * 0.3,
                          buttonHeight: height ?? size.height * 0.065,
                          buttonWidth: width ?? size.width * 0.9,
                          itemHeight: size.height * 0.06,
                        ),
                      ),
                    ),
                  ),
                if ((dropList != null && dropList!.isNotEmpty))
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          dropdownWidth: width ?? size.width * 0.9,
                          buttonElevation: 0,
                          dropdownElevation: 1,
                          iconSize: size.height * 0.03,
                          icon: Padding(
                            padding: EdgeInsetsDirectional.only(
                                end: size.width * 0.015),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[600],
                            ),
                          ),
                          hint: Text(
                            '',
                            style: TextStyle(
                              fontSize: size.height * 0.02,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: dropList!
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: size.height * 0.018,
                                          ),
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            controller!.text = value.toString();
                            if(onChanged!=null) {
                              onChanged!(value.toString());
                            }
                          },
                          dropdownDecoration:
                              BoxDecoration(color: Colors.grey[200]),
                          dropdownMaxHeight: size.height * 0.3,
                          buttonHeight: height ?? size.height * 0.065,
                          buttonWidth: width ?? size.width * 0.9,
                          itemHeight: size.height * 0.06,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (helperText != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                      top: size.height * 0.01, end: size.width * 0.01),
                  child: CustomInkwell(
                    onTap: () =>
                        onTapHelperText != null ? onTapHelperText!() : null,
                    child: Text(
                      helperText!,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: size.height * 0.01,
                      ),

                    ),
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }
}
