import 'package:flutter/material.dart';

class TooltipShape extends ShapeBorder {
  TooltipShape();

  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.circular(12); // Rounded corners

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

    // Start drawing the shape, rounded corners
    path.moveTo(10, 0); // Start from the top-left
    path.quadraticBezierTo(0, 0, 0, 10); // Top-left rounded corner
    path.lineTo(0, rrect.height - 10); // Left side
    path.quadraticBezierTo(0, rrect.height, 10, rrect.height); // Bottom-left rounded corner
    path.lineTo(rrect.width - 10, rrect.height); // Bottom edge
    path.quadraticBezierTo(rrect.width, rrect.height, rrect.width, rrect.height - 10); // Bottom-right rounded corner
    path.lineTo(rrect.width, 10); // Right side
    path.quadraticBezierTo(rrect.width, 0, rrect.width - 10, 0); // Top-right rounded corner

    // Create the arrow (notch) in the top-right corner
    path.lineTo(rrect.width - 40, 0); // Start point of the notch
    path.lineTo(rrect.width - 30, -10); // Arrow tip pointing upward
    path.lineTo(rrect.width - 20, 0); // End of the notch

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // Custom paint logic (optional)
  }

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: _borderRadius * t,
      );
}
