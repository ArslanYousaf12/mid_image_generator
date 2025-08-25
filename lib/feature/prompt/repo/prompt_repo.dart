import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PromptRepo {
  static Future<Uint8List?> generateImage(String prompt) async {
    try {
      // Get API configuration from environment variables
      String url = dotenv.env['API_BASE_URL'] ?? 'https://api.vyro.ai/v1/imagine/api/generations';
      String apiKey = dotenv.env['API_KEY'] ?? '';
      
      if (apiKey.isEmpty) {
        log('Error: API_KEY not found in environment variables');
        return null;
      }
      
      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $apiKey',
      };

      Map<String, dynamic> payload = {
        'prompt': prompt,
        'style_id': '122',
        'aspect_ratio': '1:1',
        'cfg': '5',
        'seed': '1',
        'high_res_results': '1',
      };

      FormData formData = FormData.fromMap(payload);

      Dio dio = Dio();
      dio.options = BaseOptions(
        headers: headers,
        responseType: ResponseType.bytes,
      );

      final response = await dio.post(url, data: formData);
      if (response.statusCode == 200) {
        log(response.data.runtimeType.toString());
        log(response.data.toString());
        Uint8List uint8List = Uint8List.fromList(response.data);
        return uint8List;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
//Generate a Disney image of a princess with a prince