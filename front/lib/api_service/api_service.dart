/// api_service.dart
// ignore_for_file: depend_on_referenced_packages, import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/api_service/exceptions.dart';
import 'package:front/data/user_.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  final String baseUrl;
  String? token;

  ApiService({required this.baseUrl, this.token});

  Future<User_?> login(String userEmail, String password) async {
    try {
      Map<String, dynamic> responseBody = await _httpRequest('POST', '$baseUrl/auth/login', {
        'username': userEmail,
        'password': password,
      });
      if (responseBody['code'] != null && responseBody['code'] == 401) {
        throw const UnauthorizedException("Invalid username or password");
      }
      Map<String, dynamic> userData = responseBody['user_data'];
      return User_(
        id: userData['id'],
        name: "${userData['first_name'] as String} ${userData['last_name'] as String}",
        token: responseBody['token'],
        userType: UserType.admin,
        password: password,
        email: userData['email'],
      );
    } on UnauthorizedException {
      return null;
    }
  }

  Future<bool> checkAuth() async {
    dynamic responseBody = await _httpRequest('GET', '$baseUrl/auth/testToken', {'token': token ?? ''});  
    return responseBody.runtimeType == String;
  }

  void logout(Data? data) {
    Data.pageList = [
        ["DASHBOARD", Icons.dashboard], 
        ["DAILY SCHEDULE", Icons.schedule], 
        ["LOST AND FOUND", Icons.find_in_page], 
        ["FOOD MENU", Icons.fastfood], 
        ["HAWKS NEST", Icons.store], 
        ["SPORTS", Icons.sports]
    ];
    if (data != null) {
      data.user = null;
    }
  }

  // daily schedule
  Future<List<Map<String, dynamic>>> getDailySchedule() async {
    // dynamic result = await _httpRequest('GET', '$baseUrl/data/daily-schedule');
    // if (result is Map<String, dynamic>) {
    //   return [Map<String, dynamic>.from(result)];
    // }
    // return List<Map<String, dynamic>>.from(result);
    List<Map<String, String>> widgets = [
      {'url': 'www.naver.com', 'date': '2021-10-01'},
      {'url': 'www.google.com', 'date': '2021-10-02'},
      {'url': 'www.bing.com', 'date': '2021-10-03'},
    ];

    return widgets;
  }

  Future<dynamic> postDailySchedule(String date, String url) async {
    return await _httpRequest('POST', '$baseUrl/data/daily-schedule/', {date: url});
  }

  Future<dynamic> putDailySchedule(String date, Map<String, String> scheduleData) async {
    return await _httpRequest('PUT', '$baseUrl/data/daily-schedule/$date', scheduleData);
  }

  Future<dynamic> deleteDailySchedule(String date) async {
    return await _httpRequest('DELETE', '$baseUrl/data/daily-schedule/$date');
  }

  // food menu
  Future<List<Map<String, dynamic>>> getFoodMenu() async {
    dynamic data = await _httpRequest('GET', '$baseUrl/data/food-menu/');
    if (data['list'] == null) {
      return [Map<String, dynamic>.from(data)];
    }
    List<Map<String, String>> listOfMaps = List<Map<String, String>>.from(data['list']);
    return listOfMaps;
  }

  Future<List<Map<String, dynamic>>> getGames() async {
    dynamic data = await _httpRequest('GET', '$baseUrl/data/games/');
    List<Map<String, dynamic>> listOfMaps = List<Map<String, dynamic>>.from(data['list']);
    return listOfMaps;
  }

  Future<List<Map<String, dynamic>>> getSports() async {
    dynamic data = await _httpRequest('GET', '$baseUrl/data/sports/');
    List<Map<String, dynamic>> listOfMaps = List<Map<String, dynamic>>.from(data['list']);
    return listOfMaps;
  }

  Future<List<Map<String, dynamic>>> getLostAndFound() async {
    dynamic data = await _httpRequest('GET', '$baseUrl/data/lost-and-found/');
    List<Map<String, dynamic>> listOfMaps = List<Map<String, dynamic>>.from(data['items']);
    return listOfMaps;
  }

  Future<dynamic> postLostAndFound(Map<String, String> lostAndFoundData, File imageFile) async {
    return await _httpRequest('POST', '$baseUrl/data/lost-and-found/', lostAndFoundData, imageFile);
  }

  Future<dynamic> putLostAndFound(String id, Map<String, String> lostAndFoundData, File imageFile) async {
    return await _httpRequest('PUT', '$baseUrl/data/lost-and-found/$id', lostAndFoundData, imageFile);
  }

  Future<dynamic> deleteLostAndFound(String id) async {
    return await _httpRequest('DELETE', '$baseUrl/data/lost-and-found/$id');
  }

  Future<dynamic> getLostAndFoundItemImage(String id) async {
    return await _httpRequest('GET', '$baseUrl/data/lost-and-found/image/$id');
  }

  Future<List<Map<String, dynamic>>> getSchoolStoreItems() async {
    dynamic data = await _httpRequest('GET', '$baseUrl/data/school-store/');
    List<Map<String, dynamic>> listOfMaps = List<Map<String, dynamic>>.from(data['list']);
    return listOfMaps;
  }

  Future<dynamic> postSchoolStoreItem(Map<String, String> schoolStoreItemData, File imageFile) async {
    return await _httpRequest('POST', '$baseUrl/data/school-store/', schoolStoreItemData, imageFile);
  }

  Future<dynamic> putSchoolStoreItem(String id, Map<String, String> schoolStoreItemData, File imageFile) async {
    return await _httpRequest('PUT', '$baseUrl/data/school-store/$id', schoolStoreItemData, imageFile);
  }

  Future<dynamic> getSchoolStoreItemImage(String id) async {
    return await _httpRequest('GET', '$baseUrl/data/school-store/image/$id');
  }

  Future<dynamic> deleteSchoolStoreItem(String id) async {
    return await _httpRequest('DELETE', '$baseUrl/data/school-store/$id');
  }

  Future<dynamic> _httpRequest(String method, String url, [Map<String, String>? data, File? imageFile]) async {
    var request;
    if (method == 'PUT' || method == 'POST') {
      if (imageFile != null) {
        request = MultipartRequest(method, Uri.parse(url));
        data?.forEach((key, value) {
          request.fields[key] = value;
        });
        var multipartFile = await MultipartFile.fromPath(
        'image_file', imageFile.path,
        contentType: MediaType('image', 'jpeg'));
        request.files.add(multipartFile);
      } else {
        request = Request(method, Uri.parse(url));
        request.headers['Content-Type'] = 'application/json';
        request.body = jsonEncode(data);
      }
    } else {
      request = Request(method, Uri.parse(url));
    }
    
    if (token != null) {
      request.headers["Authorization"] = "Bearer $token";
    }

    // Set the 'Origin' header
    // request.headers.set('Origin', 'https://your-origin.com');

    // Set the 'Referer-Policy' header
    // request.headers.set('Referer-Policy', 'strict-origin-when-cross-origin');

    // Set any other necessary headers for authentication or API access
    // request.headers.set('Client-data', 'your-session-token');
    final streamedResponse = await request.send();
    Response response = await Response.fromStream(streamedResponse);
    if (response.statusCode == ResponseType.UNAUTHORIZED) {
      throw UnauthorizedException('Error ${response.statusCode}: Failed to load data');
    } else if (response.statusCode == ResponseType.BAD_REQUEST) {
      throw BadRequestException('Error ${response.statusCode}: Failed to load data');
    } else if (response.statusCode == ResponseType.NOT_FOUND) {
      throw NotFoundException('Error ${response.statusCode}: Failed to load data');
    } else if (response.statusCode == ResponseType.INTERNAL_SERVER_ERROR) {
      throw InternalServerErrorException('Error ${response.statusCode}: Failed to load data');
    } else if (response.statusCode == ResponseType.SERVICE_UNAVAILABLE) {
      throw ServiceUnavailableException('Error ${response.statusCode}: Failed to load data');
    } else if (response.statusCode == ResponseType.GATEWAY_TIMEOUT) {
      throw GatewayTimeoutException('Error ${response.statusCode}: Failed to load data');
    } 

    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic data;
      String responseBody = response.body;
      try {
        data = jsonDecode(responseBody);
      } on FormatException {
        // responseBody is not valid JSON but string
        return responseBody;
      }
      return data;
    } 
    throw UnknownResponseException('Error ${response.statusCode}: Failed to load data');
  }
}
