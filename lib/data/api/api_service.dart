
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/data/api/response/login_response.dart';
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
        throw Exception('Failed to register');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');

    }
  }

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      }
      else if(response.statusCode == 400) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      }
      else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');

    }
  }
}