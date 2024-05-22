import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// theme data for light theme
final ThemeData lightThemeData = ThemeData(
  primaryColor: lightThemePrimaryColor,
  dividerColor: lightThemePrimaryColor,
  dividerTheme: const DividerThemeData(thickness: 0),
  dialogBackgroundColor: Colors.white,
  tabBarTheme: const TabBarTheme(
    labelColor: lightThemePrimaryColor,
    indicatorColor: lightThemePrimaryColor,
    splashFactory: NoSplash.splashFactory,
    indicatorSize: TabBarIndicatorSize.tab,
    tabAlignment: TabAlignment.start,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  popupMenuTheme: const PopupMenuThemeData(
    surfaceTintColor: Colors.transparent,
    position: PopupMenuPosition.under,
    color: Colors.white,
  ),
  visualDensity: VisualDensity.defaultDensityForPlatform(TargetPlatform.iOS),
  scaffoldBackgroundColor: lightThemeBackgroundColor,
  splashFactory: NoSplash.splashFactory,
  fontFamily: GoogleFonts.manrope().fontFamily,
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: lightThemePrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      disabledBackgroundColor: kDarkColor.shade400,
      disabledForegroundColor: kDarkColor.shade300,
      foregroundColor: Colors.white,
      maximumSize: const Size(double.infinity, 60),
      minimumSize: const Size(60, 48),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      maximumSize: const Size(double.infinity, 60),
      minimumSize: const Size(double.infinity, 48),
      foregroundColor: lightThemePrimaryColor,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      maximumSize: const Size(double.infinity, 60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide(color: kDarkColor.shade500),
      foregroundColor: kDarkColor.shade800,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: FilledButton.styleFrom(
      elevation: 0,
      minimumSize: const Size(20, 20),
      backgroundColor: lightThemeBackgroundColor,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: kDarkColor.shade700,
    surfaceTintColor: Colors.white,
    titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: kDarkColor.shade700),
    shape: RoundedRectangleBorder(
      side: BorderSide(color: kDarkColor.shade500.withOpacity(0.25)),
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Color(0XFF6E7781)),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Color(0xFFF6F8FA)),
  iconTheme: const IconThemeData(color: Color(0xFF6E7781)),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: kDarkColor.shade500, fontSize: 14, fontWeight: FontWeight.w400),
    floatingLabelStyle: TextStyle(fontWeight: FontWeight.w500, color: kDarkColor.shade500),
    labelStyle: TextStyle(fontWeight: FontWeight.w500, color: kDarkColor.shade500),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: lightThemePrimaryColor, width: 0.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 0.5, color: Color(0xFFD0D7DE)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 0.5, color: Color(0xFFD0D7DE)),
    ),
  ),
);
