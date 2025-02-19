import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:supervisor/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

enum Result { success, error }

String baseUrl = "176.124.208.61:2005";
// String baseUrl = "192.168.68.109:8000";
String middle = "api/supervisor";
String login = "/login";
String order = "/orders";
String model = "/models";
String recipe = "/recipes";
String showRecipe = "/getrecipes";
String item = "/items";
String material = "/materials";
String unit = "/units";
String color = "/colors";
String razryad = "/razryads";
String itemType = "/itemtypes";
String department = "/departments";
String user = "/users";
String userMaster = "/users/master";
String userSubMaster = "/users/submaster";
String warehouseUrl = "/warehouses";
String group = "/groups";
String contragent = "/contragents";
String importOrders = "/import-orders";
String orderStore = "/orderStore";

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
        print("Error [GET]: ${response.body}\nCode: ${response.statusCode}\nURL: $url");
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
    Map<String, dynamic> body, {
    bool isAuth = false,
  }) async {
    String token = StorageService.read("token") ?? "";

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }..addAllIf(
        token.isNotEmpty,
        {"Authorization": "Bearer $token"},
      );

    Uri url = Uri.http(baseUrl, '${isAuth ? "api" : middle}$endpoint');
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

  static Future<Map<String, dynamic>> uploadWithImages(
    String endpoint, {
    required Map<String, dynamic> body,
    String method = 'post',
  }) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        if (StorageService.read("token") != null) "Authorization": "Bearer ${StorageService.read("token")}",
      };

      // API endpoint
      final url = Uri.http(
        baseUrl,
        '$middle$endpoint',
        {'_method': method},
      );

      var request = http.MultipartRequest("post", url);

      request.headers.addAll(headers);

      if (body['images'] != null && body['images'].isNotEmpty) {
        for (var imagePath in body['images']) {
          if (imagePath.toString().contains("http")) {
            img.Image image = img.decodeImage((await http.get(Uri.parse(imagePath))).bodyBytes)!;

            //save image to file and upload

            var file = File("assets/images/models/${imagePath.split('/').last}")..writeAsBytesSync(img.encodePng(image));

            request.files.add(await http.MultipartFile.fromPath(
              'images[]',
              file.path,
              filename: imagePath.split('/').last,
            ));

            continue;
          }

          request.files.add(await http.MultipartFile.fromPath(
            'images[]',
            imagePath,
            filename: imagePath.split('/').last,
          ));
        }
      }

      request.fields.addAll({
        "data": jsonEncode(Map.from(body)..remove('images')),
      });

      var res = await request.send();

      final directory = Directory('assets/images/models');

      if (directory.existsSync()) {
        for (var file in directory.listSync()) {
          if (file is File) {
            file.deleteSync();
          }
        }
      }

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return {
          'data': jsonDecode(await res.stream.bytesToString()),
          'status': Result.success,
        };
      } else {
        log("Error: ${await res.stream.bytesToString()}");
        return {
          'status': Result.error,
        };
      }
    } catch (e) {
      log('Error: $e');
      return {
        'status': Result.error,
      };
    }
  }

  static Future<Map<String, dynamic>> uploadWithFile(
    String endpoint, {
    required Map<String, dynamic> body,
    String method = 'post',
  }) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        if (StorageService.read("token") != null) "Authorization": "Bearer ${StorageService.read("token")}",
      };

      // API endpoint
      final url = Uri.http(
        baseUrl,
        '$middle$endpoint',
        {'_method': method},
      );

      var request = http.MultipartRequest("post", url);

      request.headers.addAll(headers);

      if (body['path'] != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          body['path'],
        ));
      }

      var res = await request.send();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return {
          'data': jsonDecode(await res.stream.bytesToString()),
          'status': Result.success,
        };
      } else {
        log(await res.stream.bytesToString());
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
