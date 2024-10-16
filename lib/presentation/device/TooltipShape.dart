import 'package:flutter/material.dart';
import 'package:nttcs/core/app_export.dart';

class TooltipShape extends ShapeBorder {
  TooltipShape();

  final BorderSide _side = BorderSide(color: appTheme.primaryContainer, width: 1.0);
  final BorderRadiusGeometry _borderRadius = BorderRadius.circular(4); // Rounded corners

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );
    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);
    final Path path = Path();

    // Start drawing the shape with rounded corners
    path.moveTo(10, 0); // Start from the top-left
    path.quadraticBezierTo(0, 0, 0, 10); // Top-left rounded corner
    path.lineTo(0, rrect.height - 10); // Left side
    path.quadraticBezierTo(0, rrect.height, 10, rrect.height); // Bottom-left rounded corner
    path.lineTo(rrect.width - 10, rrect.height); // Bottom edge
    path.quadraticBezierTo(rrect.width, rrect.height, rrect.width, rrect.height - 10); // Bottom-right rounded corner
    path.lineTo(rrect.width, 10); // Right side
    path.quadraticBezierTo(rrect.width, 0, rrect.width - 10, 0); // Top-right rounded corner

    double arrowCenter = rrect.width / 2;
    path.lineTo(arrowCenter + 10, 0); // Arrow tip pointing upward
    path.lineTo(arrowCenter, -10); // Start point of the notch
    path.lineTo(arrowCenter - 10, 0); // Arrow tip pointing upward

    // Close the path by connecting back to the start of the notch
    path.lineTo(10, 0); // Connects back to the starting point to close the path

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint()
      ..color = _side.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _side.width;

    final Path path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint); // Draw the border with the specified color and width
  }

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: _borderRadius * t,
      );
}
