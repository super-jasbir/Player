class LeaderboardDetailResponse {
  bool? status;
  int? limit;
  int? offset;
  int? totalPlayers;
  bool? hasMore;
  List<LeaderboardDetail>? data;

  LeaderboardDetailResponse(
      {this.status,
        this.limit,
        this.offset,
        this.totalPlayers,
        this.hasMore,
        this.data});

  LeaderboardDetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    limit = json['limit'];
    offset = json['offset'];
    totalPlayers = json['total_players'];
    hasMore = json['has_more'];
    if (json['data'] != null) {
      data = <LeaderboardDetail>[];
      json['data'].forEach((v) {
        data!.add(new LeaderboardDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    data['total_players'] = this.totalPlayers;
    data['has_more'] = this.hasMore;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaderboardDetail {
  int? rank;
  String? playerUniqueId;
  String? playerName;
  String? playerImage;
  int? stationsCompleted;
  String? startTime;
  String? endTime;
  String? totalTime;

  LeaderboardDetail(
      {this.rank,
        this.playerUniqueId,
        this.playerName,
        this.playerImage,
        this.stationsCompleted,
        this.startTime,
        this.endTime,
        this.totalTime});

  LeaderboardDetail.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    playerUniqueId = json['player_unique_id'];
    playerName = json['player_name'];
    playerImage = json['player_image'];
    stationsCompleted = json['stations_completed'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    totalTime = json['total_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['player_unique_id'] = this.playerUniqueId;
    data['player_name'] = this.playerName;
    data['player_image'] = this.playerImage;
    data['stations_completed'] = this.stationsCompleted;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['total_time'] = this.totalTime;
    return data;
  }
}
