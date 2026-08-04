
class GetMerchantListResponse {
  String message;
  List<MerchantData> data;

  GetMerchantListResponse({
    required this.message,
    required this.data,
  });

  factory GetMerchantListResponse.fromJson(Map<String, dynamic> json) => GetMerchantListResponse(
    message: json["message"],
    data: List<MerchantData>.from(json["data"].map((x) => MerchantData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class MerchantData {
  String merchantType;
  int id;
  String uniqueId;
  String? minimumSpending;
  List<String> outletImages;
  String initalImage;
  String ? personOnCharge;
  String outletName;
  String outletContactNumber;
  String outletEmailAddress;
  String outletZone;
  String outletAddress;
  String lat;
  String long;
  String? outletPassword;
  String specializedIn;
  String startHours;
  String endHours;
  String? description;
  String ? status;
  dynamic createdAt;
  dynamic updatedAt;

  MerchantData({
    required this.merchantType,
    required this.id,
    required this.uniqueId,
    required this.outletImages,
    required this.initalImage,
     this.personOnCharge,
    this.minimumSpending,
    required this.outletName,
    required this.outletContactNumber,
    required this.outletEmailAddress,
    required this.outletZone,
    required this.outletAddress,
    required this.lat,
    required this.long,
     this.outletPassword,
    required this.specializedIn,
    required this.startHours,
    required this.endHours,
     this.description,
     this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MerchantData.fromJson(Map<String, dynamic> json) => MerchantData(
    merchantType: json["merchant_type"],
    minimumSpending: json["minimumSpending"],
    id: json["id"],
    uniqueId: json["unique_id"],
    outletImages: List<String>.from(json["outletImages"].map((x) => x)),
    initalImage: json["initalImage"],
    personOnCharge: json["personOnCharge"],
    outletName: json["outletName"],
    outletContactNumber: json["outletContactNumber"],
    outletEmailAddress: json["outletEmailAddress"],
    outletZone: json["outletZone"],
    outletAddress: json["outletAddress"],
    lat: json["lat"],
    long: json["long"],
    outletPassword: json["outletPassword"],
    specializedIn: json["specializedIN"],
    startHours: json["startHours"],
    endHours: json["endHours"],
    description: json["description"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "merchant_type": merchantType,
    "id": id,
    "unique_id": uniqueId,
    "outletImages": outletImages,
    "initalImage": initalImage,
    "personOnCharge": personOnCharge,
    "outletName": outletName,
    "outletContactNumber": outletContactNumber,
    "outletEmailAddress": outletEmailAddress,
    "outletZone": outletZone,
    "outletAddress": outletAddress,
    "lat": lat,
    "long": long,
    "outletPassword": outletPassword,
    "specializedIN": specializedIn,
    "startHours": startHours,
    "endHours": endHours,
    "description": description,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
