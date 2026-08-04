class RedeemableItemResponse {
  bool? status;
  List<RedeemableItemList>? data;

  RedeemableItemResponse({this.status, this.data});

  RedeemableItemResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <RedeemableItemList>[];
      json['data'].forEach((v) {
        data!.add(new RedeemableItemList.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RedeemableItemList {
  int? id;
  String? redeemableItemImage;
  String? itemNameEn;
  String? itemNameCh;
  String? amountPaid;
  String? stock;

  RedeemableItemList(
      {this.id,
        this.redeemableItemImage,
        this.itemNameEn,
        this.itemNameCh,
        this.amountPaid,
        this.stock});

  RedeemableItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    redeemableItemImage = json['redeemableItemImage'];
    itemNameEn = json['itemName_en'];
    itemNameCh = json['itemName_ch'];
    amountPaid = json['amountPaid'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['redeemableItemImage'] = this.redeemableItemImage;
    data['itemName_en'] = this.itemNameEn;
    data['itemName_ch'] = this.itemNameCh;
    data['amountPaid'] = this.amountPaid;
    data['stock'] = this.stock;
    return data;
  }
}

class RedeemableDetailsResponse {
  bool? status;
  RedeemableDetails? data;

  RedeemableDetailsResponse({this.status, this.data});

  RedeemableDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new RedeemableDetails.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class RedeemableDetails {
  int? id;
  String? redeemableItemImage;
  List<String>? itemImages;
  String? itemNameEn;
  String? itemNameCh;
  String? description;
  String? amountPaid;
  String? stock;

  RedeemableDetails(
      {this.id,
        this.redeemableItemImage,
        this.itemImages,
        this.itemNameEn,
        this.itemNameCh,
        this.description,
        this.amountPaid,
        this.stock});

  RedeemableDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    redeemableItemImage = json['redeemableItemImage'];
    itemImages = json['itemImages'].cast<String>();
    itemNameEn = json['itemName_en'];
    itemNameCh = json['itemName_ch'];
    description = json['description'];
    amountPaid = json['amountPaid'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['redeemableItemImage'] = this.redeemableItemImage;
    data['itemImages'] = this.itemImages;
    data['itemName_en'] = this.itemNameEn;
    data['itemName_ch'] = this.itemNameCh;
    data['description'] = this.description;
    data['amountPaid'] = this.amountPaid;
    data['stock'] = this.stock;
    return data;
  }
}

