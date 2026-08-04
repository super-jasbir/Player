class MySteryBoxResponse {
  bool? status;
  List<MySteryBoxList>? data;

  MySteryBoxResponse({this.status, this.data});

  MySteryBoxResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <MySteryBoxList>[];
      json['data'].forEach((v) {
        data!.add(new MySteryBoxList.fromJson(v));
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

class MySteryBoxList {
  int? id;
  String? mysteryBoxImage;
  String? mysteryBoxNameEn;
  String? mysteryBoxNameCh;
  String? gameName;
  String? amountpaid;

  MySteryBoxList(
      {this.id,
        this.mysteryBoxImage,
        this.mysteryBoxNameEn,
        this.mysteryBoxNameCh,
        this.gameName,
        this.amountpaid});

  MySteryBoxList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mysteryBoxImage = json['mysteryBoxImage'];
    mysteryBoxNameEn = json['mysteryBoxName_en'];
    mysteryBoxNameCh = json['mysteryBoxName_ch'];
    gameName = json['gameName'];
    amountpaid = json['amountpaid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mysteryBoxImage'] = this.mysteryBoxImage;
    data['mysteryBoxName_en'] = this.mysteryBoxNameEn;
    data['mysteryBoxName_ch'] = this.mysteryBoxNameCh;
    data['gameName'] = this.gameName;
    data['amountpaid'] = this.amountpaid;
    return data;
  }
}
