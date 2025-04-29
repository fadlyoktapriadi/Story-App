
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/data/api/response/register_response.dart';

class ApiService{
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<RegisterResponse> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return RegisterResponse.fromJson(jsonDecode(response.body));
      }
      else if(response.statusCode == 400) {
        return RegisterResponse.fromJson(jsonDecode(response.body));
      }
      else {
        debugPrint('Error: ${response.statusCode}');
        throw Exception('Failed to register');
      }
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      throw Exception('Failed to register: $e');

    }
  }
}