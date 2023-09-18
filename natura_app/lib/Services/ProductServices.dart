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
      Date: DateTime.parse(jsonReponse['dateinsert'],));
  return responseModel;
}
