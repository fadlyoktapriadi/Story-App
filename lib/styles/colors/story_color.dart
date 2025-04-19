import 'package:flutter/material.dart';

enum StoryColor {

  yellowAccent("yellowAccent", Color(0xFFE8F9FF)),;

  const StoryColor(this.name, this.color);

  final String name;
  final Color color;
}