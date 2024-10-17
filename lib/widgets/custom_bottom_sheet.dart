import 'package:flutter/material.dart';

class CustomBottomSheet {
  final Widget child;
  final double? height;
  final Color? backgroundColor;
  final bool? showDraggableIndicator;
  CustomBottomSheet({
    required this.child,
    this.height,
    this.backgroundColor,
    this.showDraggableIndicator,
  });

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: height ?? MediaQuery.of(context).size.height * 0.87,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          child: Column(
            children: [
              if(showDraggableIndicator ?? true) _buildDraggableIndicator(),
              Expanded(
                // Không nên dùng SingleChildScrollView ở đây
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggableIndicator() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
