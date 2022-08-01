import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants/constants.dart';

class WaitingWidget extends StatelessWidget {
  const WaitingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SpinKitDualRing(
      color: kPrimaryColor,
      size: kIsWeb&&size.width>520?40:size.height*0.07,
      duration: const Duration(milliseconds: 900),
    );
  }
}