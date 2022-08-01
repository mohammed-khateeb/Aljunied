import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LabelWithDetails extends StatelessWidget {
  final String label;
  final String details;
  final double? horizontalPadding;
  final double? verticalPadding;

  const LabelWithDetails({Key? key, required this.label, required this.details, this.horizontalPadding, this.verticalPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding!=null?horizontalPadding!:kIsWeb&&size.width>520?15:size.width*0.03,
        vertical: verticalPadding!=null?verticalPadding!:kIsWeb&&size.width>520?10:size.height*0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: kIsWeb&&size.width>520?16:size.height*0.02,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(
              start:kIsWeb&&size.width>520?10: size.width*0.01
            ),
            child: Text(
              details,
              style: TextStyle(
                fontSize:kIsWeb&&size.width>520?13: size.height*0.017,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.start,

            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
