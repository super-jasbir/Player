
class PlayerDetailsResponse {
  String? message;
  PlayerDetail? data;

  PlayerDetailsResponse({this.message, this.data});

  PlayerDetailsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new PlayerDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PlayerDetail {
  String? profilePic;
  String? nickName;
  String? nationality;
  String? gameID;
  String? playerUniqueId;
  String? outletUnique_id;

  PlayerDetail(
      {this.profilePic,
        this.nickName,
        this.nationality,
        this.gameID,
        this.playerUniqueId,
        this.outletUnique_id});

  PlayerDetail.fromJson(Map<String, dynamic> json) {
    profilePic = json['profilePic'];
    nickName = json['nickName'];
    nationality = json['nationality'];
    gameID = json['gameID'];
    playerUniqueId = json['player_unique_id'];
    outletUnique_id = json['outletUnique_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profilePic'] = this.profilePic;
    data['nickName'] = this.nickName;
    data['nationality'] = this.nationality;
    data['gameID'] = this.gameID;
    data['player_unique_id'] = this.playerUniqueId;
    data['outletUnique_id'] = this.outletUnique_id;
    return data;
  }
}
