import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:natura_app/Domain/DefaultApiResponseModel.dart';
import 'package:natura_app/Services/CallApiService.dart';
import 'package:natura_app/Domain/ApiRequestModel.dart';
import 'package:http/http.dart' as http;
import '../Infra/ApiConnections/ApiUrls.dart';

Future<DefaultApiResponseModel?> SignIn(String Username, String Password) async {
  List<CustomHeaderModel> Headers = [
    CustomHeaderModel(header: "LoginUser", value: Username),
    CustomHeaderModel(header: "Password", value: Password)
  ];

  var response = await apiRequest(ApiRequestModel(
      auth: AuthApiModel(type: null, authorization: null),
      headers: Headers,
      url: '${ApiUrls.StartUrl}${ApiUrls.ValidateAccount}',
      typeRequest: 'GET'));

  var jsonReponse = json.decode(response.body);


  DefaultApiResponseModel responseModel = DefaultApiResponseModel(
    STATUS: jsonReponse['status'].toString(),
    MSG: jsonReponse['msg'].toString()
  );

  return responseModel;
}

Future<DefaultApiResponseModel?> SignUp(
    String Name,
    String Username,
    String Password,
    String Email,
    String? Phone,
    String BirthDay,
    String CPF_CNPJ,
    String? PhotoLink
    ) async {
  List<CustomHeaderModel> Headers = [];

  Map<String, String?> JsonData = {
    "p_USERNAME": Name,
    "p_USERLOGIN": Username,
    "p_PASSWORD": Password,
    "p_CPF_CNPJ": CPF_CNPJ,
    "p_BIRTHDAY": '${DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").format(DateTime.parse(BirthDay))}Z',
    "p_EMAIL": Email,
    "p_PHONE": Phone,
    "p_TYPE": "USER",
    "P_PHOTO": PhotoLink
  };

  String? Body = jsonEncode(JsonData);

  var response = await apiRequest(ApiRequestModel(
      auth: AuthApiModel(type: null, authorization: null),
      headers: Headers,
      body: Body,
      url: '${ApiUrls.StartUrl}${ApiUrls.RegisterAccount}',//'https://10.0.2.2:7164/CadastrarUsuario',
      typeRequest: 'POST'));

  var jsonReponse = json.decode(response.body);


  DefaultApiResponseModel responseModel = DefaultApiResponseModel(
      STATUS: jsonReponse['status'].toString(),
      MSG: jsonReponse['msg'] ?? 'Erro na API de Cadastro de Usuário'
  );

  return responseModel;
}
