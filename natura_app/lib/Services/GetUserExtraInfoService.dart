import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:natura_app/Domain/StaticSchematics.dart';
import '../Infra/ApiConnections/ApiUrls.dart';
import 'package:natura_app/Domain/ApiRequestModel.dart';
import 'package:natura_app/Services/CallApiService.dart';
import 'package:natura_app/Domain/UserExtraInfoModel.dart';

GetExtraInfo(String? Credencial) async {
  List<CustomHeaderModel> Headers = [
    CustomHeaderModel(header: "Credencial", value: Credencial),
  ];

  var response = await apiRequest(ApiRequestModel(
      auth: AuthApiModel(type: null, authorization: null),
      headers: Headers,
      url: '${ApiUrls.StartUrl}${ApiUrls.GetUserInfo}',
      typeRequest: 'GET'));

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
