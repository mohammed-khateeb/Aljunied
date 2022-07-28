import 'package:flutter/material.dart';

import '../Constants/constants.dart';

class BottomBarWeb extends StatelessWidget {
  const BottomBarWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: 40,
      color: kPrimaryColor,
      child: const Center(
        child: Text(
          "جميع الحقوق محفوظة © 2022 بلدية الجنيد",
          style: TextStyle(
              fontSize: 12,
              color: Colors.white
          ),
        ),
      ),
    );
  }
}
