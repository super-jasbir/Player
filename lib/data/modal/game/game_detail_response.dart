
class GetGameDetailResponse {
  String message;
  GameInfo gameInfo;
  List<OutletDetail> outletDetails;

  GetGameDetailResponse({
    required this.message,
    required this.gameInfo,
    required this.outletDetails,
  });

  factory GetGameDetailResponse.fromJson(Map<String, dynamic> json) => GetGameDetailResponse(
    message: json["message"],
    gameInfo: GameInfo.fromJson(json["gameInfo"]),
    outletDetails: List<OutletDetail>.from(json["outletDetails"].map((x) => OutletDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "gameInfo": gameInfo.toJson(),
    "outletDetails": List<dynamic>.from(outletDetails.map((x) => x.toJson())),
  };
}

class GetGameResetResponse {
  String? message;
  bool? success;

  GetGameResetResponse({
    this.message,
    this.success,
  });

  factory GetGameResetResponse.fromJson(Map<String, dynamic> json) => GetGameResetResponse(
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "success": success,
  };
}

class GameInfo {
  int? gameId;
  String? uniqueId;
  String? gameName;
  String? gamePoster;
  DateTime? gameStartDate;
  DateTime? gameEndDate;
  String? gameZone;
  String? outletType;
  String? prize;
  String? start_timer_count;
  String? end_timer_count;

  GameInfo({
    this.gameId,
    this.uniqueId,
    this.gameName,
    this.gamePoster,
    this.gameStartDate,
    this.gameEndDate,
    this.gameZone,
    this.outletType,
    this.prize,
    this.start_timer_count,
    this.end_timer_count,
  });

  factory GameInfo.fromJson(Map<String, dynamic> json) => GameInfo(
    gameId: json["gameID"],
    uniqueId: json["unique_id"],
    gameName: json["gameName"],
    gamePoster: json["gamePoster"],
    gameStartDate: DateTime.parse(json["gameStartDate"]),
    gameEndDate: DateTime.parse(json["gameEndDate"]),
    gameZone: json["gameZone"],
    outletType: json["outletType"],
    prize: json["prize"],
    start_timer_count: json["start_timer_count"],
    end_timer_count: json["end_timer_count"],
  );

  Map<String, dynamic> toJson() => {
    "gameID": gameId,
    "unique_id": uniqueId,
    "gameName": gameName,
    "gamePoster": gamePoster,
    "gameStartDate": "${gameStartDate?.year.toString().padLeft(4, '0')}-${gameStartDate?.month.toString().padLeft(2, '0')}-${gameStartDate?.day.toString().padLeft(2, '0')}",
    "gameEndDate": "${gameEndDate?.year.toString().padLeft(4, '0')}-${gameEndDate?.month.toString().padLeft(2, '0')}-${gameEndDate?.day.toString().padLeft(2, '0')}",
    "gameZone": gameZone,
    "outletType": outletType,
    "prize": prize,
    "start_timer_count": start_timer_count,
    "end_timer_count": end_timer_count,
  };
}

class OutletDetail {
  int outletId;
  String outletUniqueId;
  // List<Image> outletImages;
  String initalImage;
  String outletName;
  String outletContactNumber;
  String outletEmailAddress;
  String outletZone;
  String outletAddress;
  String lat;
  String long;
  String specializedIn;
  String minimumSpending;
  String startHours;
  String endHours;
  int? isGameStarted;

  OutletDetail({
    required this.outletId,
    required this.outletUniqueId,
    // required this.outletImages,
    required this.initalImage,
    required this.outletName,
    required this.outletContactNumber,
    required this.outletEmailAddress,
    required this.outletZone,
    required this.outletAddress,
    required this.lat,
    required this.long,
    required this.specializedIn,
    required this.startHours,
    required this.endHours,
    required this.minimumSpending,
     this.isGameStarted,
  });

  factory OutletDetail.fromJson(Map<String, dynamic> json) => OutletDetail(
    outletId: json["outletID"],
    outletUniqueId: json["outletUnique_id"],
    // outletImages: List<Image>.from(json["outletImages"].map((x) => imageValues.map[x]!)),
    initalImage: json["initalImage"],
    outletName: json["outletName"],
    outletContactNumber: json["outletContactNumber"],
    outletEmailAddress: json["outletEmailAddress"],
    outletZone: json["outletZone"],
    outletAddress: json["outletAddress"],
    lat: json["lat"],
    long: json["long"],
    specializedIn: json["specializedIN"],
    startHours: json["startHours"],
    endHours: json["endHours"],
    minimumSpending: json["minimumSpending"],
    isGameStarted: json["is_game_started"],
  );

  Map<String, dynamic> toJson() => {
    "outletID": outletId,
    "outletUnique_id": outletUniqueId,
    // "outletImages": List<dynamic>.from(outletImages.map((x) => imageValues.reverse[x])),
    "initalImage": imageValues.reverse[initalImage],
    "outletName": outletName,
    "outletContactNumber": outletContactNumber,
    "outletEmailAddress": outletEmailAddress,
    "outletZone": outletZone,
    "outletAddress": outletAddress,
    "lat": lat,
    "long": long,
    "specializedIN": specializedIn,
    "startHours": startHours,
    "endHours": endHours,
    "minimumSpending": minimumSpending,
    "is_game_started": isGameStarted,
  };
}

enum Image {
  RESTURANT1_JPG,
  RESTURANT2_JPG,
  RESTURANT3_JPG,
  RESTURANT4_JPG,
  RESTURANT5_JPG
}

final imageValues = EnumValues({
  "resturant1.jpg": Image.RESTURANT1_JPG,
  "resturant2.jpg": Image.RESTURANT2_JPG,
  "resturant3.jpg": Image.RESTURANT3_JPG,
  "resturant4.jpg": Image.RESTURANT4_JPG,
  "resturant5.jpg": Image.RESTURANT5_JPG
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
