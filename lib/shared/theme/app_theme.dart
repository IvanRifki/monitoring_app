import 'package:flutter/material.dart';
import 'package:monitoring_app/shared/constants/app_colors.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    // Use ColorScheme for a more consistent and modern theming approach
    colorScheme: const ColorScheme.dark(
      primary: kAccentBlue, // Main interactive color
      secondary: kAccentBlue, // Overall background
      surface: kCardColor, // Card, Dialog, BottomSheet backgrounds
      onPrimary: kPrimaryTextColor, // Text/icons on primary color
      onSecondary: kPrimaryTextColor, // Text/icons on background color
      onSurface: kPrimaryTextColor, // Text/icons on surface color
      error: kAccentRed, // Color for error messages/widgets
      onError: kPrimaryTextColor, // Text/icons on error color
    ),
    scaffoldBackgroundColor: kBackgroundColor,
    // Define text styles based on the default dark theme for consistency
    textTheme: ThemeData.dark()
        .textTheme
        .copyWith(
          bodyMedium: const TextStyle(color: kPrimaryTextColor),
          titleLarge: const TextStyle(
              color: kPrimaryTextColor, fontWeight: FontWeight.bold),
          titleMedium: const TextStyle(
              color: kPrimaryTextColor, fontWeight: FontWeight.w600),
          bodySmall: const TextStyle(color: kSecondaryTextColor),
        )
        .apply(
          fontFamily: 'Poppins',
        ),
    cardTheme: CardThemeData(
      color: kCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: kAccentBlue, width: 3),
        insets: EdgeInsets.symmetric(horizontal: 40.0),
      ),
      labelColor: kPrimaryTextColor,
      unselectedLabelColor: kSecondaryTextColor,
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'Poppins',
      ),
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kBackgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
