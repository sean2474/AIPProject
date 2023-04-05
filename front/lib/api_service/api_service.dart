import 'dart:convert';
import 'dart:io';

class ApiService {
  final String baseUrl = 'https://domain.com/data';

  // classes
  Future<List<dynamic>> getClasses() async {
    return await _httpRequest('GET', '$baseUrl/classes');
  }

  Future<dynamic> postClasses(Map<String, dynamic> classData) async {
    return await _httpRequest('POST', '$baseUrl/classes', classData);
  }

  Future<dynamic> putClasses(String id, Map<String, dynamic> classData) async {
    return await _httpRequest('PUT', '$baseUrl/classes/$id', classData);
  }

  Future<dynamic> deleteClass(String id) async {
    return await _httpRequest('DELETE', '$baseUrl/classes/$id');
  }

  // daily schedule
  Future<List<dynamic>> getDailySchedule() async {
    return await _httpRequest('GET', '$baseUrl/daily-schedule');
  }

  Future<dynamic> postDailySchedule(Map<String, dynamic> scheduleData) async {
    return await _httpRequest('POST', '$baseUrl/daily-schedule', scheduleData);
  }

  Future<dynamic> putDailySchedule(
      String id, Map<String, dynamic> scheduleData) async {
    return await _httpRequest(
        'PUT', '$baseUrl/daily-schedule/$id', scheduleData);
  }

  Future<dynamic> deleteDailySchedule(String id) async {
    return await _httpRequest('DELETE', '$baseUrl/daily-schedule/$id');
  }

  // duty administrator
  Future<dynamic> getDutyAdministrator() async {
    return await _httpRequest('GET', '$baseUrl/duty-administrator');
  }

  Future<dynamic> putDutyAdministrator(
      String id, Map<String, dynamic> dutyAdministratorData) async {
    return await _httpRequest(
        'PUT', '$baseUrl/duty-administrator/$id', dutyAdministratorData);
  }

  // emergencies
  Future<List<dynamic>> getEmergencies() async {
    return await _httpRequest('GET', '$baseUrl/emergencies');
  }

  Future<dynamic> postEmergencies(Map<String, dynamic> emergencyData) async {
    return await _httpRequest('POST', '$baseUrl/emergencies', emergencyData);
  }

  Future<dynamic> putEmergencies(
      String id, Map<String, dynamic> emergencyData) async {
    return await _httpRequest('PUT', '$baseUrl/emergencies/$id', emergencyData);
  }

  Future<dynamic> deleteEmergency(String id) async {
    return await _httpRequest('DELETE', '$baseUrl/emergencies/$id');
  }

  // food menu
  Future<List<dynamic>> getFoodMenu() async {
    return await _httpRequest('GET', '$baseUrl/food-menu');
  }

  // off-campus requests
  Future<List<dynamic>> getOffCampusRequests() async {
    return await _httpRequest('GET', '$baseUrl/off-campus-requests');
  }

  Future<dynamic> postOffCampusRequests(
      Map<String, dynamic> requestData) async {
    return await _httpRequest(
        'POST', '$baseUrl/off-campus-requests', requestData);
  }

  Future<dynamic> putOffCampusRequests(
      String id, Map<String, dynamic> requestData) async {
    return await _httpRequest(
        'PUT', '$baseUrl/off-campus-requests/$id', requestData);
  }

  Future<dynamic> deleteOffCampusRequests(String id) async {
    return await _httpRequest('DELETE', '$baseUrl/off-campus-requests/$id');
  }

  // notifications
  Future<List<dynamic>> getNotifications() async {
    return await _httpRequest('GET', '$baseUrl/notifications');
  }

  Future<dynamic> postNotifications(
      Map<String, dynamic> notificationData) async {
    return await _httpRequest(
        'POST', '$baseUrl/notifications', notificationData);
  }

  Future<dynamic> putNotifications(
      String id, Map<String, dynamic> notificationData) async {
    return await _httpRequest(
        'PUT', '$baseUrl/notifications/$id', notificationData);
  }

  Future<dynamic> deleteNotification(String id) async {
    return await _httpRequest('DELETE', '$baseUrl/notifications/$id');
  }

  Future<dynamic> _httpRequest(String method, String url,
      [Map<String, dynamic>? data]) async {
    try {
      HttpClient httpClient = HttpClient();
      HttpClientRequest request;

      switch (method) {
        case 'POST':
          request = await httpClient.postUrl(Uri.parse(url));
          request.headers.contentType = ContentType.json;
          request.write(json.encode(data));
          break;
        case 'PUT':
          request = await httpClient.putUrl(Uri.parse(url));
          request.headers.contentType = ContentType.json;
          request.write(json.encode(data));
          break;
        case 'DELETE':
          request = await httpClient.deleteUrl(Uri.parse(url));
          break;
        default: // GET
          request = await httpClient.getUrl(Uri.parse(url));
      }

      // Set the 'Origin' header
      request.headers.set('Origin', 'https://your-origin.com');

      // Set the 'Referer-Policy' header
      request.headers.set('Referer-Policy', 'strict-origin-when-cross-origin');

      // Set any other necessary headers for authentication or API access
      request.headers.set('Client-data', 'your-session-token');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String responseBody = await response.transform(utf8.decoder).join();
        dynamic data = jsonDecode(responseBody);
        return data;
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }
}
