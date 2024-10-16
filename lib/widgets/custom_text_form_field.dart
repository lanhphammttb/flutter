import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nttcs/core/app_export.dart';

extension TextFormFieldStyleHelper on CustomTextFormField {
  static OutlineInputBorder get outLineGray => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.h),
      borderSide: BorderSide(
        color: appTheme.grayBorder,
        width: 1,
      ));
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.alignment,
    this.width,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixContraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled,
    this.validator,
    this.textStyle,
  }) : super(key: key);

  final Alignment? alignment;
  final double? width;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixContraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: textFormFieldWidget(context))
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => SizedBox(
        width: width ?? double.maxFinite,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) {
            if (focusNode != null) {
              focusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          autofocus: autofocus!,
          style: textStyle ?? CustomTextStyles.titleSmallInter,
          obscureText: obscureText!,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
        ),
      );

  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.bodyMediumBlack900,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixContraints,
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsets.all(16.h),
        fillColor: fillColor ?? appTheme.white,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
                borderSide: BorderSide(color: appTheme.white, width: 1)),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
                borderSide: BorderSide(color: appTheme.white, width: 1)),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.h),
                borderSide: BorderSide(color: appTheme.blue900, width: 1)),
      );
}
