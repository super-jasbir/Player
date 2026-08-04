
class GetGameListResponse {
  String message;
  List<GameData> data;

  GetGameListResponse({
    required this.message,
    required this.data,
  });

  factory GetGameListResponse.fromJson(Map<String, dynamic> json) => GetGameListResponse(
    message: json["message"],
    data: List<GameData>.from(json["data"].map((x) => GameData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GameData {
  int gameId;
  String gameUniqueId;
  String gameName;
  String gamePoster;
  String gameZone;
  int totalOutlet;
  String? gameEndDate;
  String? CompletedTime;
  String? prize;
  String? start_timer_count;
  String? end_timer_count;
  String? status;

  GameData({
    required this.gameId,
    required this.gameUniqueId,
    required this.gameName,
    required this.gamePoster,
    required this.gameZone,
     required this.totalOutlet,
     this.gameEndDate,
     this.CompletedTime,
     this.prize,
     this.start_timer_count,
     this.end_timer_count,
     this.status,
  });

  factory GameData.fromJson(Map<String, dynamic> json) => GameData(
    gameId: json["gameID"],
    gameUniqueId: json["gameUniqueID"],
    gameName: json["gameName"],
    gamePoster: json["gamePoster"],
    gameZone: json["gameZone"],
    totalOutlet: json["totalOutlet"],
    gameEndDate: json["gameEndDate"],
    CompletedTime: json["CompletedTime"],
    prize: json["winningPrize"],
    start_timer_count: json["start_timer_count"],
    end_timer_count: json["end_timer_count"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "gameID": gameId,
    "gameUniqueID": gameUniqueId,
    "gameName": gameName,
    "gamePoster": gamePoster,
    "gameZone": gameZone,
    "totalOutlet": totalOutlet,
    "CompletedTime": CompletedTime,
    "start_timer_count": start_timer_count,
    "end_timer_count": end_timer_count,
    "status": status,
  };
}
