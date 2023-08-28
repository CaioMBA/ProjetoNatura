import 'dart:async';
import 'package:http/http.dart' as http;
import '../Domain/ApiRequestModel.dart';

Future<http.Response> apiRequest(ApiRequestModel apiRequest) async {
  final http.Client httpClient = http.Client();
  final Map<String, String> headers = {};

  if (apiRequest.auth.authorization != null && apiRequest.auth.authorization!.isNotEmpty) {
    headers['Authorization'] = '${apiRequest.auth.type} ${apiRequest.auth.authorization}';
  }

  if (apiRequest.headers.isNotEmpty && apiRequest.headers[0].header != null && apiRequest.headers[0].header!.isNotEmpty) {
    for (var header in apiRequest.headers) {
      if (header.header != null && header.header!.isNotEmpty) {
        headers[header.header!] = header.value ?? '';
      }
    }
  }

  headers['Accept'] = 'application/json; charset=UTF-8';
  headers['Content-Type'] = 'application/json; charset=UTF-8';
  final http.Response response;

  switch (apiRequest.typeRequest) {
    case 'POST':
      response = await httpClient.post(Uri.parse(apiRequest.url ?? ''),
          body: apiRequest.body, headers: headers);
      break;
    case 'PUT':
      response = await httpClient.put(Uri.parse(apiRequest.url ?? ''),
          body: apiRequest.body, headers: headers);
      break;
    case 'GET':
      final requestGet = http.Request('GET', Uri.parse(apiRequest.url ?? ''));
      requestGet.body = apiRequest.body ?? '';
      requestGet.headers.addAll(headers);
      final streamedResponse = await httpClient.send(requestGet);
      response = await http.Response.fromStream(streamedResponse);
      break;
    case 'DELETE':
      final requestDelete = http.Request('DELETE', Uri.parse(apiRequest.url ?? ''));
      requestDelete.body = apiRequest.body ?? '';
      requestDelete.headers.addAll(headers);
      final streamedResponse = await httpClient.send(requestDelete);
      response = await http.Response.fromStream(streamedResponse);
      break;
    default:
      throw ArgumentError('Erro no switch Case de tipos de requisição!');
  }

  httpClient.close();

  return response;
}




