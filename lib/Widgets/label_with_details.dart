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
        horizontal: horizontalPadding??size.width*0.03,
        vertical: verticalPadding??size.height*0.01
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: size.height*0.02,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: size.width*0.01
            ),
            child: Text(
              details,
              style: TextStyle(
                fontSize: size.height*0.017,
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
