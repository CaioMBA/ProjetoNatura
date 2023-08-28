class ApiRequestModel {
  final AuthApiModel auth;
  final List<CustomHeaderModel> headers;
  final String? typeRequest;
  final String? url;
  final String? body;

  ApiRequestModel(
      {required this.auth,
        required this.headers,
        this.typeRequest,
        this.url,
        this.body});
}

class AuthApiModel {
  final String? type;
  final String? authorization;

  AuthApiModel({this.type, this.authorization});
}

class CustomHeaderModel {
  final String? header;
  final String? value;

  CustomHeaderModel({this.header, this.value});
}