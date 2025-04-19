
import 'package:flutter/material.dart';
import 'package:story_app/styles/colors/story_color.dart';
import 'package:story_app/styles/typography/story_text_style.dart';

class StoryTheme {

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: myTextTheme.displayLarge,
      displayMedium: myTextTheme.displayMedium,
      displaySmall: myTextTheme.displaySmall,
      headlineLarge: myTextTheme.headlineLarge,
      headlineMedium: myTextTheme.headlineMedium,
      headlineSmall: myTextTheme.headlineSmall,
      titleLarge: myTextTheme.titleLarge,
      titleMedium: myTextTheme.titleMedium,
      titleSmall: myTextTheme.titleSmall,
      labelLarge: myTextTheme.labelLarge,
      labelMedium: myTextTheme.labelMedium,
      labelSmall: myTextTheme.labelSmall,
      bodyLarge: myTextTheme.bodyLarge,
      bodyMedium: myTextTheme.bodyMedium,
      bodySmall: myTextTheme.bodySmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: StoryColor.yellowAccent.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: StoryColor.yellowAccent.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }


}