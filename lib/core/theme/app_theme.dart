import 'package:flutter/material.dart';
import 'package:journal_local_app/core/theme/app_palette.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.light().copyWith(
    primaryColor: AppPalette.gradient1,
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    colorScheme: ColorScheme.fromSeed(seedColor: AppPalette.appOrange),
    appBarTheme: const AppBarTheme(
      color: AppPalette.backgroundColor,
      iconTheme: IconThemeData(color: AppPalette.appOrange),
    ),
  
  );
}
