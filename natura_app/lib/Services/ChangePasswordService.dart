import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:natura_app/Domain/DefaultApiResponseModel.dart';
import 'package:natura_app/Services/CallApiService.dart';
import 'package:natura_app/Domain/ApiRequestModel.dart';
import 'package:http/http.dart' as http;
import '../Infra/ApiConnections/ApiUrls.dart';

Future<DefaultApiResponseModel> ChangePassword(String LoginCredential,
    String? OldPassword, String? NewPassword, bool ForgotPassword) async {
  List<CustomHeaderModel> Headers = [
    CustomHeaderModel(header: "LoginCredential", value: LoginCredential),
    CustomHeaderModel(header: "OldPassword", value: OldPassword),
    CustomHeaderModel(header: "NewPassword", value: NewPassword),
    CustomHeaderModel(header: "ForgotPassword", value: ForgotPassword.toString()),
  ];
  var response = await apiRequest(ApiRequestModel(
      auth: AuthApiModel(type: null, authorization: null),
      headers: Headers,
      url: '${ApiUrls.StartUrl}${ApiUrls.ChangePassword}',
      typeRequest: 'POST'));

  var jsonReponse = json.decode(response.body);

  DefaultApiResponseModel responseModel = DefaultApiResponseModel(
      STATUS: jsonReponse['status'].toString(),
      MSG: jsonReponse['msg'].toString());

  return responseModel;
}
