
class PostalCodeResponse {
  String? message;
  AddressData? data;

  PostalCodeResponse({
    this.message,
    this.data,
  });

  factory PostalCodeResponse.fromJson(Map<String, dynamic> json) => PostalCodeResponse(
    message: json["message"],
    data: AddressData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,

  };
}

class AddressData {
  String? searchval;
  String? blkNo;
  String ?roadName;
  String ?building;
  String ?address;
  String? postal;
  String ?x;
  String ?y;
  String ?latitude;
  String ?longitude;

  AddressData({
    this.searchval,
    this.blkNo,
    this.roadName,
    this.building,
    this.address,
    this.postal,
    this.x,
    this.y,
    this.latitude,
    this.longitude,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
    searchval: json["SEARCHVAL"],
    blkNo: json["BLK_NO"],
    roadName: json["ROAD_NAME"],
    building: json["BUILDING"],
    address: json["ADDRESS"],
    postal: json["POSTAL"],
    x: json["X"],
    y: json["Y"],
    latitude: json["LATITUDE"],
    longitude: json["LONGITUDE"],
  );

  Map<String, dynamic> toJson() => {
    "SEARCHVAL": searchval,
    "BLK_NO": blkNo,
    "ROAD_NAME": roadName,
    "BUILDING": building,
    "ADDRESS": address,
    "POSTAL": postal,
    "X": x,
    "Y": y,
    "LATITUDE": latitude,
    "LONGITUDE": longitude,
  };
}
