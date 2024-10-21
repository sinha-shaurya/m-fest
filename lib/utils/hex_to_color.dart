import 'package:aash_india/core/constants/theme.dart';
import 'package:flutter/material.dart';

Color hexToColor(String? hexColor) {
  if (hexColor == null) {
    return AppColors.primaryColor;
  }
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}
