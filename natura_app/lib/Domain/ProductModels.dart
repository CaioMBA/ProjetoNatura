class GetFutureProductModel {
  int? ID;
  String? Name;
  String? Type;
  DateTime? Date;
  double? Value;
  String? Photo;

  GetFutureProductModel({this.ID, this.Name, this.Type, this.Date, this.Value, this.Photo});
}

class GetProductTypes {
  int? producttypeid;
  String? type;

  GetProductTypes({this.producttypeid, this.type});

  GetProductTypes.fromJson(Map<String, dynamic> json) {
    producttypeid = json['producttypeid'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['producttypeid'] = producttypeid;
    data['type'] = type;
    return data;
  }

  Map<String, String?> toMap() {
    return {
      'producttypeid': producttypeid?.toString(),
      'type': type,
    };
  }
}