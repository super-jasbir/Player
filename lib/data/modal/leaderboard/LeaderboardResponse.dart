class LeaderboardResponse {
  String? message;
  List<LeaderboardList>? data;

  LeaderboardResponse({this.message, this.data});

  LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <LeaderboardList>[];
      json['data'].forEach((v) {
        data!.add(new LeaderboardList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaderboardList {
  int? id;
  String? gameUniqueId;
  String? gameName;
  String? gImage;

  // Extra fields used by the ContinueGame screen. Nullable so the existing
  // leaderboard usage is unaffected. NOTE: the JSON key names below are a
  // best guess — adjust them once the real participate-list response is known.
  String? gameEndDate;
  String? createdAt;
  String? startTimerCount;
  String? endTimerCount;
  String? extraTime;
  String? status;
  int? completeStatus;

  LeaderboardList({
    this.id,
    this.gameUniqueId,
    this.gameName,
    this.gImage,
    this.gameEndDate,
    this.createdAt,
    this.startTimerCount,
    this.endTimerCount,
    this.extraTime,
    this.status,
    this.completeStatus,
  });

  LeaderboardList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameUniqueId = json['game_unique_id'];
    gameName = json['game_name'];
    gImage = json['g_image'];
    gameEndDate = json['game_end_date']?.toString();
    createdAt = json['created_at']?.toString();
    startTimerCount = json['start_timer_count']?.toString();
    endTimerCount = json['end_timer_count']?.toString();
    extraTime = json['extra_time']?.toString();
    status = json['status']?.toString();
    completeStatus = json['complete_status'] is int
        ? json['complete_status']
        : int.tryParse(json['complete_status']?.toString() ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['game_unique_id'] = this.gameUniqueId;
    data['game_name'] = this.gameName;
    data['g_image'] = this.gImage;
    data['game_end_date'] = this.gameEndDate;
    data['created_at'] = this.createdAt;
    data['start_timer_count'] = this.startTimerCount;
    data['end_timer_count'] = this.endTimerCount;
    data['extra_time'] = this.extraTime;
    data['status'] = this.status;
    data['complete_status'] = this.completeStatus;
    return data;
  }
}
