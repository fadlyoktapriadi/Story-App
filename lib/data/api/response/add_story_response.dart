
import 'dart:convert';

AddStoryResponse addStoryResponseFromJson(String str) => AddStoryResponse.fromJson(json.decode(str));

String addStoryResponseToJson(AddStoryResponse data) => json.encode(data.toJson());

class AddStoryResponse {
  bool error;
  String message;

  AddStoryResponse({
    required this.error,
    required this.message,
  });

  factory AddStoryResponse.fromJson(Map<String, dynamic> json) => AddStoryResponse(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}
