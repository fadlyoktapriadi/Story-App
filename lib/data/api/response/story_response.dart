import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/data/api/response/story_detail_response.dart';

part 'story_response.g.dart';

@JsonSerializable()
class StoryResponse {
  final bool? error;
  final String? message;
  @JsonKey(name: "listStory")
  final List<Story>? listStory;

  StoryResponse({this.error, this.message, this.listStory});

  factory StoryResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryResponseToJson(this);
}
