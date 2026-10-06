import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override String toString() => message;
}

class ApiService {
  final Uri baseUri;
  final http.Client client;
  ApiService(String baseUrl, {http.Client? client}) : baseUri = Uri.parse(baseUrl), client = client ?? http.Client();
  Future<dynamic> getJson(String path) async {
    final response = await client.get(baseUri.resolve(path), headers: {'Accept': 'application/json'});
    if (response.statusCode < 200 || response.statusCode >= 300) throw const ApiException('Unable to load SmartFlux data.');
    try { return jsonDecode(response.body); } catch (_) { throw const ApiException('The SmartFlux server returned invalid data.'); }
  }
  Future<dynamic> postJson(String path, Map<String, dynamic> body) async {
    final response = await client.post(baseUri.resolve(path), headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}, body: jsonEncode(body));
    if (response.statusCode < 200 || response.statusCode >= 300) throw const ApiException('The command could not be completed.');
    try { return jsonDecode(response.body); } catch (_) { throw const ApiException('The SmartFlux server returned invalid data.'); }
  }
}
