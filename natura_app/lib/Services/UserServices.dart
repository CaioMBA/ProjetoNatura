import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:natura_app/Domain/DefaultApiResponseModel.dart';
import 'package:natura_app/Services/CallApiService.dart';
import 'package:natura_app/Domain/ApiRequestModel.dart';
import 'package:http/http.dart' as http;
import '../Domain/StaticSchematics.dart';
import '../Domain/UserExtraInfoModel.dart';
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
      typeRequest: 'PUT'));

  var jsonReponse = json.decode(response.body);

  DefaultApiResponseModel responseModel = DefaultApiResponseModel(
      STATUS: jsonReponse['status'].toString(),
      MSG: jsonReponse['msg'].toString());

  return responseModel;
}

Future<DefaultApiResponseModel?> ChangeUserDetailsService(String Credential,
    String NewLogin, String NewMail, String? NewPhone) async {
  List<CustomHeaderModel> Headers = [];
  Map<String, String?> JsonData = {
    "p_CREDENCIAL": Credential,
    "p_LOGIN": NewLogin,
    "p_EMAIL": NewMail,
    "p_PHONE": NewPhone,
  };
  String? Body = jsonEncode(JsonData);

  var response = await apiRequest(ApiRequestModel(
      auth: AuthApiModel(type: null, authorization: null),
      headers: Headers,
      body: Body,
      url: '${ApiUrls.StartUrl}${ApiUrls.ChangeUserDetails}',
      typeRequest: 'PUT'));

  var jsonReponse = json.decode(response.body);


  DefaultApiResponseModel responseModel = DefaultApiResponseModel(
      STATUS: jsonReponse['status'].toString(),
      MSG: jsonReponse['msg'] ?? 'Erro na API de Alterar Detalhes de Usuario'
  );
  return responseModel;
}

GetExtraInfo(String? Credencial) async {
  List<CustomHeaderModel> Headers = [
    CustomHeaderModel(header: "Credencial", value: Credencial),
  ];

  var response = await apiRequest(ApiRequestModel(
      auth: AuthApiModel(type: null, authorization: null),
      headers: Headers,
      url: '${ApiUrls.StartUrl}${ApiUrls.GetUserInfo}',
      typeRequest: 'GET'));
  if (response.statusCode == 500){
    return;
  }
  var jsonReponse = json.decode(response.body);

  UserExtraInfoModel responseModel = UserExtraInfoModel(
      userid: jsonReponse['userid'],
      name: jsonReponse['name'].toString(),
      login: jsonReponse['login'].toString(),
      birthday: jsonReponse['birthday'].toString(),
      cpF_CNPJ: jsonReponse['cpF_CNPJ'].toString(),
      email: jsonReponse['email'].toString(),
      phone: jsonReponse['phone'].toString(),
      photo: jsonReponse['photo'] ?? 'https://static.wixstatic.com/media/436cbf_44eaeaeaeb1d4e59b076c11667c57fab~mv2.png/v1/fill/w_1600,h_853,al_c,q_90/file.jpg');

  GlobalStatics.UserName = responseModel.name;
  GlobalStatics.UserLogin = responseModel.login;
  GlobalStatics.UserBirthday = responseModel.birthday;
  GlobalStatics.UserUnique = responseModel.cpF_CNPJ;
  GlobalStatics.UserEmail = responseModel.email;
  GlobalStatics.UserPhone = responseModel.phone;
  GlobalStatics.UserPhoto = responseModel.photo;
}