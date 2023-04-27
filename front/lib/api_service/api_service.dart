import 'dart:convert';
import 'dart:io';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // daily schedule
  Future<List<dynamic>> getDailySchedule() async {
    return await _httpRequest('GET', '$baseUrl/data/daily-schedule/');
  }

  Future<dynamic> postDailySchedule(Map<String, dynamic> scheduleData) async {
    return await _httpRequest('POST', '$baseUrl/data/daily-schedule/', scheduleData);
  }

  Future<dynamic> putDailySchedule(
      String date, Map<String, dynamic> scheduleData) async {
    return await _httpRequest(
        'PUT', '$baseUrl/data/daily-schedule/$date', scheduleData);
  }

  Future<dynamic> deleteDailySchedule(String date) async {
    return await _httpRequest('DELETE', '$baseUrl/data/daily-schedule/$date');
  }

  // food menu
  Future<List<dynamic>> getFoodMenu() async {
    return await _httpRequest('GET', '$baseUrl/data/food-menu/');
  }

  Future<List<Map<String, dynamic>>> getGames() async {
    return await _httpRequest('GET', '$baseUrl/data/games/');
  }

  Future<List<Map<String, dynamic>>> getSports() async {
    return await _httpRequest('GET', '$baseUrl/data/sports/');
  }

  Future<List<Map<String, dynamic>>> getLostAndFound() async {
    return await _httpRequest('GET', '$baseUrl/data/lost-and-found/');
  }

  Future<dynamic> postLostAndFound(Map<String, dynamic> lostAndFoundData) async {
    return await _httpRequest('POST', '$baseUrl/data/lost-and-found/', lostAndFoundData);
  }

  Future<dynamic> putLostAndFound(
      String id, Map<String, dynamic> lostAndFoundData) async {
    return await _httpRequest('PUT', '$baseUrl/data/lost-and-found/image/$id', lostAndFoundData);
  }

  // not added in server yet
  // Future<dynamic> deleteLostAndFound(String id) async {
  //   return await _httpRequest('DELETE', '$baseUrl/data/lost-and-found/$id');
  // }

  Future<dynamic> getLostAndFoundItemImage(String id) async {
    return await _httpRequest('GET', '$baseUrl/data/lost-and-found/image/$id');
  }

  Future<List<Map<String, dynamic>>> getSchoolStoreItems() async {
    return await _httpRequest('GET', '$baseUrl/data/school-store/');
  }

  Future<dynamic> postSchoolStoreItem(Map<String, dynamic> schoolStoreItemData) async {
    return await _httpRequest('POST', '$baseUrl/data/school-store/', schoolStoreItemData);
  }

  Future<dynamic> putSchoolStoreItem(
      String id, Map<String, dynamic> schoolStoreItemData) async {
    return await _httpRequest('PUT', '$baseUrl/data/school-store/$id', schoolStoreItemData);
  }

  Future<dynamic> getSchoolStoreItemImage(String id) async {
    return await _httpRequest('GET', '$baseUrl/data/school-store/image/$id');
  }

  Future<dynamic> deleteSchoolStoreItem(String id) async {
    return await _httpRequest('DELETE', '$baseUrl/data/school-store/$id');
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
      // request.headers.set('Origin', 'https://your-origin.com');

      // Set the 'Referer-Policy' header
      // request.headers.set('Referer-Policy', 'strict-origin-when-cross-origin');

      // Set any other necessary headers for authentication or API access
      request.headers.set('Client-data', 'your-session-token');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String responseBody = await response.transform(utf8.decoder).join();
        dynamic data = jsonDecode(responseBody);
        return data;
      } else {
        throw Exception('Error ${response.statusCode}: Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e: Failed to load data');
    }
  }
}
