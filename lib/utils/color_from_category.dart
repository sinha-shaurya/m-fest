import 'package:flutter/material.dart';

Color generateColorFromCategory(String category) {
  const List<Color> colorPalette = [
    Color(0xFFD32F2F),
    Color(0xFF424242),
    Color(0xFFAB47BC),
    Color(0xFFFFC107),
    Color(0xFF3F51B5),
    Color(0xFF009688),
    Color(0xFF8BC34A),
  ];
  int hash = category.hashCode;

  int index = hash.abs() % colorPalette.length;

  return colorPalette[index];
}
