class MySteryBoxDetailsResponse {
  bool? status;
  MySteryBoxDetails? data;

  MySteryBoxDetailsResponse({this.status, this.data});

  MySteryBoxDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new MySteryBoxDetails.fromJson(json['data']) : null;
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

class MySteryBoxDetails {
  int? id;
  String? mysteryBoxImage;
  String? mysteryBoxNameEn;
  String? mysteryBoxNameCh;
  String? gameName;
  int? numberOfMystery;
  String? amountpaid;
  String? description;

  MySteryBoxDetails(
      {this.id,
        this.mysteryBoxImage,
        this.mysteryBoxNameEn,
        this.mysteryBoxNameCh,
        this.gameName,
        this.numberOfMystery,
        this.amountpaid,
        this.description});

  MySteryBoxDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mysteryBoxImage = json['mysteryBoxImage'];
    mysteryBoxNameEn = json['mysteryBoxName_en'];
    mysteryBoxNameCh = json['mysteryBoxName_ch'];
    gameName = json['gameName'];
    numberOfMystery = json['numberOfMystery'];
    amountpaid = json['amountpaid'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mysteryBoxImage'] = this.mysteryBoxImage;
    data['mysteryBoxName_en'] = this.mysteryBoxNameEn;
    data['mysteryBoxName_ch'] = this.mysteryBoxNameCh;
    data['gameName'] = this.gameName;
    data['numberOfMystery'] = this.numberOfMystery;
    data['amountpaid'] = this.amountpaid;
    data['description'] = this.description;
    return data;
  }
}
