import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';


class ReusableCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final Widget? errorWidget;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final BoxFit fit;
  final bool allowFullScreen;

  const ReusableCachedNetworkImage(
      {Key? key,
        this.imageUrl,
        required this.height,
        required this.width,
        this.fit = BoxFit.contain,
        this.borderRadius = BorderRadius.zero,
        this.errorWidget, this.allowFullScreen = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        height: height,
        width: width,
        imageUrl: imageUrl??"",
        fit: fit,
        placeholder: (context, url) => Shimmer.fromColors(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: Theme.of(context).focusColor,
            ),
          ),
          baseColor: Theme.of(context).focusColor,
          highlightColor: Theme.of(context).focusColor.withOpacity(0.5),),
        errorWidget: (context, url, error) =>
        errorWidget ??
            Icon(
              FontAwesomeIcons.exclamation,
              size: height * 0.5,
            ),
      ),
    );
  }
}