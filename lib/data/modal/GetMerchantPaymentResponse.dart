class GetMerchantPaymentResponse {
  String? message;
  MerchantPayment? data;

  GetMerchantPaymentResponse({this.message, this.data});

  GetMerchantPaymentResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new MerchantPayment.fromJson(json['data']) : null;
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

class MerchantPayment {
  int? id;
  int? playerId;
  String? playerUniqueId;
  String? gameUniqueId;
  String? gameName;
  int? outletId;
  String? outletName;
  int? completeStatus;
  String? outletImage;
  String? completionDatetime;
  String? amountPaid;
  String? commission;
  int? isGameStarted;
  String? createdAt;
  String? updatedAt;

  MerchantPayment(
      {this.id,
        this.playerId,
        this.playerUniqueId,
        this.gameUniqueId,
        this.gameName,
        this.outletId,
        this.outletName,
        this.completeStatus,
        this.outletImage,
        this.completionDatetime,
        this.amountPaid,
        this.commission,
        this.isGameStarted,
        this.createdAt,
        this.updatedAt});

  MerchantPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['player_id'];
    playerUniqueId = json['player_unique_id'];
    gameUniqueId = json['game_unique_id'];
    gameName = json['game_name'];
    outletId = json['outlet_id'];
    outletName = json['outlet_name'];
    completeStatus = json['complete_status'];
    outletImage = json['outletImage'];
    completionDatetime = json['completion_datetime'];
    amountPaid = json['amountPaid'];
    commission = json['commission']?.toString();
    isGameStarted = json['is_game_started'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['player_id'] = this.playerId;
    data['player_unique_id'] = this.playerUniqueId;
    data['game_unique_id'] = this.gameUniqueId;
    data['game_name'] = this.gameName;
    data['outlet_id'] = this.outletId;
    data['outlet_name'] = this.outletName;
    data['complete_status'] = this.completeStatus;
    data['outletImage'] = this.outletImage;
    data['completion_datetime'] = this.completionDatetime;
    data['amountPaid'] = this.amountPaid;
    data['commission'] = this.commission;
    data['is_game_started'] = this.isGameStarted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
