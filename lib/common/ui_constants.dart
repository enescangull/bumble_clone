import 'package:flutter/material.dart';

/// UI bileşenleri için sabit değerler
class UIConstants {
  // Boyutlar
  static const double appBarHeight = 64.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;
  static const double largeIconSize = 32.0;

  // Kenar boşlukları
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  // Animasyon süreleri
  static const Duration animationDurationShort = Duration(milliseconds: 150);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // Yazı boyutları
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeExtraLarge = 18.0;
  static const double fontSizeHeading = 20.0;
  static const double fontSizeTitle = 24.0;

  // Kenar yuvarlaklıkları
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusExtraLarge = 24.0;

  // Gölge değerleri
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];
}
