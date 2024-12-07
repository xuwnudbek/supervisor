import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supervisor/services/storage_service.dart';
import 'package:get/get.dart';

enum Result { success, error }

String baseUrl = "192.168.0.100:8000";
String middle = "api";
String login = "/login";
String order = "/orders";
String model = "/models";

class HttpService {
  static Future<Map<String, dynamic>> get(String endpoint) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );
    Uri url = Uri.http(baseUrl, '$middle$endpoint');
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'data': jsonDecode(response.body),
          'status': Result.success,
        };
      } else {
        return {
          'data': jsonDecode(response.body),
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'data': e.toString(),
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );

    Uri url = Uri.http(baseUrl, '$middle$endpoint');
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'data': jsonDecode(response.body),
          'status': Result.success,
        };
      } else {
        return {
          'data': jsonDecode(response.body),
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'data': e.toString(),
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );

    Uri url = Uri.http(baseUrl, '$middle$endpoint');
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'data': jsonDecode(response.body),
          'status': Result.success,
        };
      } else {
        return {
          'data': jsonDecode(response.body),
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'data': e.toString(),
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> body) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );

    Uri url = Uri.http(baseUrl, '$middle$endpoint');
    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'data': jsonDecode(response.body),
          'status': Result.success,
        };
      } else {
        return {
          'data': jsonDecode(response.body),
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'data': e.toString(),
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );

    Uri url = Uri.http(baseUrl, '$middle$endpoint');
    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'data': jsonDecode(response.body),
          'status': Result.success,
        };
      } else {
        return {
          'data': jsonDecode(response.body),
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'data': e.toString(),
        'status': Result.error,
      };
    }
  }
}
