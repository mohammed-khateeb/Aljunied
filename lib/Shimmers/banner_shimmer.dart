import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.grey[300]!,
      child: Container(
        height: size.height*0.2,
        width: size.width*0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.height*0.005),
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
