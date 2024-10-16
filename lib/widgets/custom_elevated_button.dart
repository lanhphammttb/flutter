import 'package:flutter/material.dart';
import '../core/app_export.dart';
import 'base_button.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton(
      {Key? key,
      this.decoration,
      this.leftIcon,
      this.rightIcon,
      this.backgroundColor,
      EdgeInsets? margin,
      VoidCallback? onPressed,
      ButtonStyle? buttonStyle,
      Alignment? alignment,
      TextStyle? buttonTextStyle,
      bool? isDisable,
      double? height,
      double? width,
      required String text})
      : super(text: text, onPressed: onPressed, buttonStyle: buttonStyle, isDisable: isDisable, buttonTextStyle: buttonTextStyle, height: height, width: width, alignment: alignment, margin: margin);

  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return alignment != null ? Align(alignment: alignment ?? Alignment.center, child: buildElevatedButtonWidget) : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
        height: height ?? 40.v,
        margin: margin ?? EdgeInsets.zero,
        decoration: decoration,
        width: width,
        child: ElevatedButton(
          style: buttonStyle ??
              ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? appTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8), // Thêm padding ngang
                elevation: 0, // Đặt độ cao của nút thành 0 để bỏ đổ bóng
              ),
          onPressed: isDisable ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? const SizedBox.shrink(),
              Text(
                ' $text ',
                style: buttonTextStyle ?? CustomTextStyles.textButton,
              ),
              rightIcon ?? const SizedBox.shrink()
            ],
          ),
        ),
      );
}
