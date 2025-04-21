import 'package:flutter/material.dart';

enum StoryColor {

  yellowAccent("yellowAccent", Color(0xFF00FFF0));

  const StoryColor(this.name, this.color);

  final String name;
  final Color color;
}