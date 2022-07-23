import 'package:flutter/cupertino.dart';

class OutlineContainer extends StatelessWidget {
  final _GradientPainter _painter;
  final Widget _child;
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  OutlineContainer({
    required double strokeWidth,
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    required Gradient gradient,
    required Widget child,
  })
      : this._painter = _GradientPainter(
    strokeWidth: strokeWidth,
    gradient: gradient,
    topLeft: topLeft,
    bottomLeft: bottomLeft,
    bottomRight: bottomRight,
    topRight: topRight,),
        this._child = child;



  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _child,
          ],
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter({required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    required double strokeWidth,
    required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect = RRect.fromRectAndCorners(outerRect,
        topRight: Radius.circular(topRight),
        topLeft: Radius.circular(topLeft),
        bottomRight: Radius.circular(bottomRight),
        bottomLeft: Radius.circular(bottomLeft));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndCorners(innerRect,
        topRight: Radius.circular(topRight - strokeWidth),
        topLeft: Radius.circular(topLeft - strokeWidth),
        bottomRight: Radius.circular(bottomRight - strokeWidth),
        bottomLeft: Radius.circular(bottomLeft - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()
      ..addRRect(outerRRect);
    Path path2 = Path()
      ..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}