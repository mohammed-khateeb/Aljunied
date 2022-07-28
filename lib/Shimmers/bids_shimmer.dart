import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BidsShimmer extends StatelessWidget {
  const BidsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.grey[300]!,
      child: SizedBox(
        height:kIsWeb?270: size.height*0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width*0.05),
              height:kIsWeb?12: size.height*0.015,
              width: kIsWeb?70:size.width*0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.height*0.02),
                color: Colors.grey[200],

              ),
            ),
            SizedBox(height:kIsWeb?25: size.height*0.01,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width*0.05),
              height:kIsWeb?16: size.height*0.03,
              width: kIsWeb?70:size.width*0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.height*0.02),
                color: Colors.grey[200],

              ),
            ),
            SizedBox(height:kIsWeb?28: size.height*0.015,),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                  scrollDirection: Axis.horizontal,
                itemBuilder: (context,index) {
                  return Container(
                    margin: EdgeInsetsDirectional.only(end: size.width*0.02),
                    height:kIsWeb?203: size.height*0.2,
                    width:kIsWeb?250: size.width*0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.height*0.007),
                      color: Colors.grey[200],

                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
