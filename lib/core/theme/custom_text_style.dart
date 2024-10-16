import 'package:flutter/material.dart';
import 'package:nttcs/core/app_export.dart';

class CustomTextStyles {
  static get bodyLargeBlue700 => theme.textTheme.bodyLarge!.copyWith(
      color: appTheme.primary, fontWeight: FontWeight.w600, fontSize: 16);

  static get bodyMediumBlack900 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black,
        fontWeight: FontWeight.w600,
      );

  static get titleLargeBlack900 => theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.black,
    fontWeight: FontWeight.w600,
    fontSize: 16
  );

  static get bodyMediumSecondary => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray,
        fontWeight: FontWeight.w300,
      );

  static get titleLargeBlue800 => theme.textTheme.titleMedium!.copyWith(
      color: appTheme.primary, fontWeight: FontWeight.w600, fontSize: 16);

  static get titleMediumBlue800 => theme.textTheme.titleMedium!.copyWith(
      color: appTheme.primary, fontWeight: FontWeight.w600, fontSize: 14);

  static get titleSmallBlue800 => theme.textTheme.titleSmall!.copyWith(
      color: appTheme.primary, fontWeight: FontWeight.w300, fontSize: 12);

  static get titleSmallInter => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black,
      );

  static get titleOverview => theme.textTheme.titleSmall!.copyWith(
      color: appTheme.white, fontWeight: FontWeight.w600, fontSize: 16);

  static get countOverview =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.white, fontSize: 16);

  static get textButton =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.white, fontSize: 14);

  static get titleActive=> theme.textTheme.titleMedium!.copyWith(
      color: Colors.green, fontWeight: FontWeight.w600, fontSize: 16);

  static get titleOn=> theme.textTheme.titleMedium!.copyWith(
      color: appTheme.primary, fontWeight: FontWeight.w600, fontSize: 16);

  static get titleOff=> theme.textTheme.titleMedium!.copyWith(
      color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 16);
}
