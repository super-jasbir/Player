class SplashBannerResponse {
  bool? status;
  List<SplashBannerList>? data;

  SplashBannerResponse({this.status, this.data});

  SplashBannerResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SplashBannerList>[];
      json['data'].forEach((v) {
        data!.add(new SplashBannerList.fromJson(v));
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

class SplashBannerList {
  int? id;
  String? postedON;
  String? bannerImg;
  String? bannerNameEn;
  String? bannerNameCh;
  String? startDate;
  String? endDate;
  String? gameName;

  SplashBannerList(
      {this.id,
        this.postedON,
        this.bannerImg,
        this.bannerNameEn,
        this.bannerNameCh,
        this.startDate,
        this.endDate,
        this.gameName});

  SplashBannerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postedON = json['postedON'];
    bannerImg = json['bannerImg'];
    bannerNameEn = json['bannerName_en'];
    bannerNameCh = json['bannerName_ch'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    gameName = json['gameName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['postedON'] = this.postedON;
    data['bannerImg'] = this.bannerImg;
    data['bannerName_en'] = this.bannerNameEn;
    data['bannerName_ch'] = this.bannerNameCh;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['gameName'] = this.gameName;
    return data;
  }
}
