import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiService {
  late final http.Client _client;

  ApiService() {
    _client = http.Client();
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);

      final response = await _client
          .get(uri, headers: ApiConfig.headers)
          .timeout(ApiConfig.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Keine Internetverbindung verfügbar');
    } on HttpException {
      throw ApiException('HTTP Fehler bei der Anfrage');
    } catch (e) {
      throw ApiException('Unerwarteter Fehler: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final uri = _buildUri(endpoint);

      final response = await _client
          .post(uri, headers: ApiConfig.headers, body: jsonEncode(data))
          .timeout(ApiConfig.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Keine Internetverbindung verfügbar');
    } on HttpException {
      throw ApiException('HTTP Fehler bei der Anfrage');
    } catch (e) {
      throw ApiException('Unerwarteter Fehler: $e');
    }
  }

  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final baseUri = Uri.parse('${ApiConfig.baseUrl}$endpoint');

    if (queryParams != null && queryParams.isNotEmpty) {
      return baseUri.replace(queryParameters: queryParams);
    }

    return baseUri;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = jsonDecode(response.body);

        // If the response is a List, wrap it in a data object for consistency
        if (decoded is List) {
          return {'data': decoded};
        }

        // If it's already a Map, return it as is
        return decoded as Map<String, dynamic>;
      } catch (e) {
        throw ApiException('Ungültige JSON-Antwort vom Server');
      }
    } else {
      switch (response.statusCode) {
        case 404:
          throw ApiException('Ressource nicht gefunden');
        case 500:
          throw ApiException('Server Fehler');
        case 503:
          throw ApiException('Service temporär nicht verfügbar');
        default:
          throw ApiException('API Fehler: ${response.statusCode}');
      }
    }
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
