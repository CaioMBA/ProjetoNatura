import 'dart:convert';

import '../Domain/ApiRequestModel.dart';
import '../Domain/ProductModels.dart';
import '../Infra/ApiConnections/ApiUrls.dart';
import 'CallApiService.dart';

Future<GetFutureProductModel?> GetFutureProductService(String Type) async {
  List<CustomHeaderModel> Headers = [
    CustomHeaderModel(header: "Type", value: Type)
  ];
  Map<String, String?> JsonData = {};

  var response = await apiRequest(ApiRequestModel(
      auth: AuthApiModel(type: null, authorization: null),
      headers: Headers,
      body: jsonEncode(JsonData),
      url: '${ApiUrls.StartUrl}${ApiUrls.GetFutureProduct}',
      typeRequest: 'GET'));

  if (response.statusCode == 500) {
    return GetFutureProductModel();
  }

  var jsonReponse = json.decode(response.body);

  GetFutureProductModel responseModel = GetFutureProductModel(
      ID: jsonReponse['productid'],
      Name: jsonReponse['name'] ?? 'Produto Sem nome!',
      Type: jsonReponse['type'].toString(),
      Value: double.parse(jsonReponse['value'].toString()),
      Photo: jsonReponse['photo'] ?? 'https://static.wixstatic.com/media/436cbf_44eaeaeaeb1d4e59b076c11667c57fab~mv2.png/v1/fill/w_1600,h_853,al_c,q_90/file.jpg',
      Date: DateTime.parse(jsonReponse['dateinsert'],));
  return responseModel;
}

Future<List<GetProductTypes?>> GetTypesList() async{
  var Response = await apiRequest(ApiRequestModel(
      auth: AuthApiModel(type: null, authorization: null),
      headers: [],
      body: null,
      url: '${ApiUrls.StartUrl}${ApiUrls.GetProductTypesList}',
      typeRequest: 'GET'));

  if (Response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(Response.body);

    List<GetProductTypes?> ResponseModel = jsonResponse
        .map((dynamic json) => GetProductTypes.fromJson(json))
        .toList();

    return ResponseModel;
  } else {
    throw Exception('Failed to load data');
  }
}









