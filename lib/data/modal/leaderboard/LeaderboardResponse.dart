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

  LeaderboardList({this.id, this.gameUniqueId, this.gameName, this.gImage});

  LeaderboardList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameUniqueId = json['game_unique_id'];
    gameName = json['game_name'];
    gImage = json['g_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['game_unique_id'] = this.gameUniqueId;
    data['game_name'] = this.gameName;
    data['g_image'] = this.gImage;
    return data;
  }
}
