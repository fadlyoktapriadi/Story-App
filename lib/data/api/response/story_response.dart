// To parse this JSON data, do
//
//     final storyResponse = storyResponseFromJson(jsonString);

import 'dart:convert';

import 'package:story_app/data/api/response/story_detail_response.dart';

StoryResponse storyResponseFromJson(String str) => StoryResponse.fromJson(json.decode(str));

String storyResponseToJson(StoryResponse data) => json.encode(data.toJson());

class StoryResponse {
  bool error;
  String message;
  List<Story> listStory;

  StoryResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryResponse.fromJson(Map<String, dynamic> json) => StoryResponse(
    error: json["error"],
    message: json["message"],
    listStory: List<Story>.from(json["listStory"].map((x) => Story.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
  };
}