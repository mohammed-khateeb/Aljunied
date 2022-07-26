import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AreasShimmer extends StatelessWidget {
  const AreasShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.grey[300]!,
      child: SizedBox(
        height:kIsWeb?250: size.height*0.15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width*0.05),
              height:kIsWeb?15: size.height*0.03,
              width:kIsWeb?100: size.width*0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.height*0.02),
                color: Colors.grey[200],

              ),
            ),
            SizedBox(height: size.height*0.015,),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                  scrollDirection: Axis.horizontal,
                itemBuilder: (context,index) {
                  return Container(
                    margin: EdgeInsetsDirectional.only(end: size.width*0.02),
                    width:kIsWeb?200: size.width*0.4,
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
