import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:supervisor/services/storage_service.dart';
import 'package:get/get.dart';

enum Result { success, error }

String baseUrl = "192.168.0.123:8000";
String middle = "api";
String login = "/login";
String order = "/orders";
String model = "/models";
String recipe = "/recipes";
String item = "/items";
String unit = "/units";
String color = "/colors";
String razryad = "/razryads";
String itemType = "/itemtypes";

class HttpService {
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? param,
  }) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );
    Uri url = Uri.http(baseUrl, '$middle$endpoint', param);
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'data': jsonDecode(response.body),
          'status': Result.success,
        };
      } else {
        print("Error [GET]: ${response.body}");
        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
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
        print("Error [POST]: ${response.body}");

        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
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
        print("Error [PUT]: ${response.body}");
        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
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
        print("Error [PATCH]: ${response.body}");

        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
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
        print("Error [DELETE]: ${response.body}");

        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'status': Result.error,
      };
    }
  }

  // multipart/form-data upload image
  static Future<Map<String, dynamic>> upload(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
      }..addAllIf(StorageService.read("token") != null, {"Authorization": "Bearer ${StorageService.read("token")}"});

      // API endpoint
      final url = Uri.http(baseUrl, '$middle$endpoint');

      var request = http.MultipartRequest('post', url);

      request.headers.addAll(headers);

      request.fields.addAll(body.map((key, value) => MapEntry(key, value.toString())));
      request.files.add(await http.MultipartFile.fromPath('image', body['image']));

      inspect(await http.MultipartFile.fromPath('image', body['image']));

      var res = await request.send();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return {
          'data': jsonDecode(await res.stream.bytesToString()),
          'status': Result.success,
        };
      } else {
        print('Error: ${await res.stream.bytesToString()}');
        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'status': Result.error,
      };
    }
  }
}
